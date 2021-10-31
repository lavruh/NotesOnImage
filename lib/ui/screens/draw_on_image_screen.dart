import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:notes_on_image/domain/entities/designation.dart';
import 'package:get/get.dart';
import 'package:notes_on_image/domain/states/designation_on_image_state.dart';
import 'package:notes_on_image/ui/widgets/designation_panel_widget.dart';

class NotesOnImageScreen extends StatelessWidget {
  NotesOnImageScreen({Key? key}) : super(key: key);

  final _state = Get.find<DesignationOnImageState>();

  @override
  Widget build(BuildContext context) {
    _state.loadImage(File("/home/lavruh/Screenshot_20200409_212221.jpg"));
    return Scaffold(
      body: GetBuilder<DesignationOnImageState>(builder: (_) {
        return GestureDetector(
          onTapDown: (TapDownDetails details) {
            _state.tapHandler(details.globalPosition);
          },
          child: CustomPaint(
            painter: ImagePainter(),
            child: Container(),
          ),
        );
      }),
      bottomNavigationBar: DesignationsPanelWidget(),
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
    _state.image_size = size;
  }

  @override
  bool shouldRepaint(ImagePainter oldDelegate) {
    return true;
  }
}
