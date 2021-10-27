import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui show Image;

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
    // _state.loadImage(File("/home/lavruh/Screenshot_20200409_212221.jpg"));
    return Scaffold(
      body: GetBuilder<DesignationOnImageState>(builder: (_) {
        return GestureDetector(
          onTapDown: (TapDownDetails details) {
            _state.tapHandler(details.globalPosition);
          },
          child: CustomPaint(
            painter: MyPainter(_state.objects, _state.image),
            child: Container(),
          ),
        );
      }),
      bottomNavigationBar: DesignationsPanelWidget(),
    );
  }
}

class MyPainter extends CustomPainter {
  MyPainter(this.objects, [this.img]);
  ui.Image? img;
  List<Designation> objects = [];

  @override
  void paint(Canvas canvas, Size size) {
    if (img != null) {
      canvas.drawImage((img as ui.Image), Offset(0, 0), Paint());
    }
    for (Designation o in objects) {
      o.draw(canvas);
    }
  }

  @override
  bool shouldRepaint(MyPainter oldDelegate) {
    return true;
  }
}
