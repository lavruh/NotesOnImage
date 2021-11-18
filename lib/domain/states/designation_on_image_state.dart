import 'dart:io';
import 'dart:ui' as ui;
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_on_image/domain/entities/designation.dart';
import 'package:notes_on_image/ui/screens/draw_on_image_screen.dart';

enum DesignationMode { dimension, note }

class DesignationOnImageState extends GetxController {
  final objects = <Designation>[].obs();
  Offset? p1;
  Offset? p2;
  String text = '';
  DesignationMode? mode;
  ui.Image? image;
  Paint lineStyle = Paint()
    ..color = Colors.redAccent
    ..strokeWidth = 8.0;
  late Size image_size;
  String path = '';

  loadImage(File f) async {
    final data = await f.readAsBytes();
    image = await decodeImageFromList(data);
    path = f.path;
    image_size = Size(image!.width.toDouble(), image!.height.toDouble());
    update();
  }

  undo() {
    objects.removeLast();
    update();
  }

  saveImage() async {
    if (image != null) {
      final rec = ui.PictureRecorder();
      final canvas = Canvas(rec);
      final painter = ImagePainter();
      painter.paint(canvas, image_size);
      final picture = rec.endRecording();
      final im = await picture.toImage(image!.width, image!.height);
      final outFile = File("${path}_${generateFileName()}");
      final byteData = await im.toByteData(format: ui.ImageByteFormat.png);
      outFile.writeAsBytes(byteData!.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
      Get.snackbar("Saved at:", outFile.path, colorText: Colors.green);
      update();
    }
  }

  String generateFileName() {
    return "${DateFormat("ms").format(DateTime.now())}.jpg";
  }

  setText(String val) {
    text = val;
  }

  double get lineWeight => lineStyle.strokeWidth;

  setLineWeight(double val) {
    lineStyle.strokeWidth = val;
  }

  Color get lineColor => lineStyle.color;

  setLineColor(Color val) {
    lineStyle.color = val;
  }

  tapHandler(Offset pos) {
    if (mode == DesignationMode.dimension) {
      addDimension(pos);
    }
    if (mode == DesignationMode.note) {
      addNote(pos);
    }
    update();
  }

  addDimension(Offset val) {
    if (p1 == null) {
      p1 = val;
    } else {
      p2 ??= val;
    }
    if (p1 != null && p2 != null) {
      objects.add(Dimension(
        text: text,
        start: p1!,
        end: p2!,
        lineStyle: lineStyle,
      ));
      p1 = null;
      p2 = null;
      mode = null;
    }
  }

  addNote(Offset val) {
    if (p1 == null) {
      p1 = val;
    } else {
      p2 ??= val;
    }
    if (p1 != null && p2 != null) {
      objects.add(Note(
        text: text,
        pointer: p1!,
        note: p2!,
        lineStyle: lineStyle,
      ));
      p1 = null;
      p2 = null;
      mode = null;
    }
  }

  @override
  void onInit() {
    objects.clear();
    super.onInit();
  }
}
