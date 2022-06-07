import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:notes_on_image/domain/entities/designation.dart';
import 'package:get/get.dart';
import 'package:notes_on_image/domain/states/designation_on_image_state.dart';
import 'package:notes_on_image/ui/widgets/custom_gesture_recognizer.dart';
import 'package:notes_on_image/ui/widgets/designation_panel_widget.dart';
import 'package:zoom_widget/zoom_widget.dart';

class NotesOnImageScreen extends StatelessWidget {
  const NotesOnImageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<DesignationOnImageState>(builder: (_) {
        return Stack(alignment: AlignmentDirectional.bottomCenter, children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: _.image != null
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
                                _.releaseHandler(details.localPosition);
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
                : Container(),
          ),
          DesignationsPanelWidget(),
        ]);
      }),
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
    for (Designation o in _state.objects) {
      o.draw(canvas);
    }
    _state.imageSize = size;
  }

  @override
  bool shouldRepaint(ImagePainter oldDelegate) {
    return true;
  }
}
