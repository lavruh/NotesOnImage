import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:notes_on_image/domain/entities/designation.dart';
import 'package:get/get.dart';
import 'package:notes_on_image/domain/states/designation_on_image_state.dart';
import 'package:notes_on_image/ui/widgets/action_button_menu_widget.dart';
import 'package:notes_on_image/ui/widgets/custom_gesture_recognizer.dart';
import 'package:notes_on_image/ui/widgets/designation_panel_widget.dart';
import 'package:zoom_widget/zoom_widget.dart';

class NotesOnImageScreen extends StatelessWidget {
  const NotesOnImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (fl, result) async {
        final state = Get.find<DesignationOnImageState>();
        bool leavePage = true;
        await state.hasToSavePromt(
            onConfirmCallback: () async {
              leavePage = false;
              await state.saveImage();
              Get.back();
            },
            onCancelCallback: () => leavePage = false);
        if (leavePage) {
          Get.back();
        }
      },
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Scaffold(
            body: GetBuilder<DesignationOnImageState>(builder: (state) {
              Widget child = const Center(child: CircularProgressIndicator());

              if (state.image != null && state.isBusy == false) {
                final imagePainter = CustomPaint(
                  painter: ImagePainter(),
                  child: Container(),
                );

                Widget eventHandler = RawGestureDetector(
                  gestures: <Type, GestureRecognizerFactory>{
                    CustomPanGestureRecognizer:
                        GestureRecognizerFactoryWithHandlers<
                            CustomPanGestureRecognizer>(
                      () => CustomPanGestureRecognizer(
                        onPanDown: (Offset details) {
                          state.panDown(details);
                          return true;
                        },
                        onPanUpdate: (details) =>
                            state.updatePoint(details.localPosition),
                        onPanEnd: (details) => state.finishDrawing(),
                      ),
                      (CustomPanGestureRecognizer instance) {},
                    ),
                  },
                  child: imagePainter,
                );

                child = Zoom(
                  initTotalZoomOut: true,
                  maxZoomHeight: state.image!.height.toDouble(),
                  maxZoomWidth: state.image!.width.toDouble(),
                  child: eventHandler,
                );
              }

              return SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: child,
              );
            }),
            floatingActionButton: const ActionButtonMenuWidget(),
          ),
          DesignationsPanelWidget(),
        ],
      ),
    );
  }
}

class ImagePainter extends CustomPainter {
  final _state = Get.find<DesignationOnImageState>();

  @override
  void paint(Canvas canvas, Size size) {
    ui.Image? img = _state.image;
    if (img != null) {
      canvas.drawImage(img, const Offset(0, 0), Paint());
    }
    for (Designation o in _state.objects.values) {
      o.draw(canvas);
    }
    _state.objToEdit?.draw(canvas);
    _state.imageSize = size;
  }

  @override
  bool shouldRepaint(ImagePainter oldDelegate) {
    return true;
  }

  @override
  bool? hitTest(Offset position) {
    _state.updateCursorPosition(position);
    return _state.isPressed || _state.isNewObj || _state.isObjTouched(position);
  }
}
