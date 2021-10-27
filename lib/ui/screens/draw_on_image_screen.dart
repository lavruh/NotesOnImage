import 'dart:math';

import 'package:flutter/material.dart';
import 'package:notes_on_image/domain/entities/designation.dart';
import 'package:get/get.dart';
import 'package:notes_on_image/domain/states/designation_on_image_state.dart';
import 'package:notes_on_image/ui/widgets/designation_panel_widget.dart';

class NotesOnImageScreen extends StatelessWidget {
  NotesOnImageScreen({Key? key}) : super(key: key);

  final _state = Get.find<DesignationOnImageState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<DesignationOnImageState>(builder: (_) {
        return GestureDetector(
          onTapDown: (TapDownDetails details) {
            _state.tapHandler(details.globalPosition);
          },
          child: CustomPaint(
            painter: MyPainter(_state.objects),
            child: Container(),
          ),
        );
      }),
      bottomNavigationBar: DesignationsPanelWidget(),
    );
  }
}

class MyPainter extends CustomPainter {
  MyPainter(this.objects);

  List<Designation> objects = [];

  @override
  void paint(Canvas canvas, Size size) {
    for (Designation o in objects) {
      o.draw(canvas);
    }
  }

  @override
  bool shouldRepaint(MyPainter oldDelegate) {
    return true;
  }
}
