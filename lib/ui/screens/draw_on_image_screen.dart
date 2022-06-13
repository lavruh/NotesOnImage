import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:notes_on_image/domain/entities/designation.dart';
import 'package:get/get.dart';
import 'package:notes_on_image/domain/states/designation_on_image_state.dart';
import 'package:notes_on_image/ui/widgets/action_button_menu_widget.dart';
import 'package:notes_on_image/ui/widgets/custom_gesture_recognizer.dart';
import 'package:notes_on_image/ui/widgets/save_confirm_dialog.dart';
import 'package:zoom_widget/zoom_widget.dart';

class NotesOnImageScreen extends StatelessWidget {
  const NotesOnImageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final state = Get.find<DesignationOnImageState>();
        if (state.isChanged()) {
          final haveToSave = await Get.dialog(
            const SaveConfirmDialog(),
            transitionDuration: const Duration(milliseconds: 0),
          );
          if (haveToSave) {
            _saveAndPop();
            return false;
          }
        }
        state.image = null;
        return true;
      },
      child: Scaffold(
        body: GetBuilder<DesignationOnImageState>(builder: (_) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: _.image != null && _.isBusy == false
                ? Zoom(
                    initZoom: 0,
                    maxZoomHeight: _.image!.height.toDouble(),
                    maxZoomWidth: _.image!.width.toDouble(),
                    child: RawGestureDetector(
                        gestures: <Type, GestureRecognizerFactory>{
                          CustomPanGestureRecognizer:
                              GestureRecognizerFactoryWithHandlers<
                                  CustomPanGestureRecognizer>(
                            () => CustomPanGestureRecognizer(
                              onPanDown: (Offset details) {
                                _.tapHandler(details);
                                return _.isDrawing;
                              },
                              onPanUpdate: (details) {
                                _.updatePoint(details.localPosition);
                              },
                            ),
                            (CustomPanGestureRecognizer instance) {},
                          ),
                        },
                        child: CustomPaint(
                          painter: ImagePainter(),
                          child: Container(),
                        )),
                  )
                : const Center(child: CircularProgressIndicator()),
          );
        }),
        floatingActionButton: const ActionButtonMenuWidget(),
      ),
    );
  }

  _saveAndPop() async {
    final state = Get.find<DesignationOnImageState>();
    await state.saveImage();
    Get.back();
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
    _state.imageSize = size;
  }

  @override
  bool shouldRepaint(ImagePainter oldDelegate) {
    return true;
  }

  @override
  bool? hitTest(Offset position) {
    _state.initUpdateDesignitionAtPosition(position);
    return _state.isDrawing;
  }
}
