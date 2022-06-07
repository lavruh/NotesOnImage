import 'dart:io';
import 'dart:ui' as ui;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as Im;
import 'package:get/get.dart';

import 'package:notes_on_image/domain/entities/designation.dart';
import 'package:notes_on_image/ui/screens/draw_on_image_screen.dart';
import 'package:permission_handler/permission_handler.dart';

enum DesignationMode { dimension, note }

// TODO bigger sizes arrows, text

class DesignationOnImageState extends GetxController {
  final objects = <Designation>[].obs();
  bool isDrawing = false;
  Offset? p1;
  Offset? p2;
  String text = '';
  DesignationMode? _mode;
  ui.Image? image;
  Paint lineStyle = Paint()
    ..color = Colors.lightGreenAccent
    ..strokeWidth = 8.0;
  late Size image_size;
  String _path = '';
  String _fileName = '';
  String _fileExtension = '';

  set path(String p) {
    final delim = p.lastIndexOf('/');
    _path = p.substring(0, delim);
    final n = p.substring(delim + 1);
    _fileName = n.substring(0, n.length - 4);
    _fileExtension = n.substring(n.length - 4);
  }

  String get path => "$_path/$_fileName$_fileExtension";
  String get pathBase => _path;
  String get fileName => _fileName;
  String get fileExt => _fileExtension;
  DesignationMode? get mode => _mode;

  set mode(DesignationMode? m) {
    _mode = m;
    isDrawing = true;
  }

  loadImage(File f) async {
    if (await Permission.storage.status.isDenied) {
      Permission.storage.request();
      update();
    }
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
    if (await Permission.manageExternalStorage.status.isDenied) {
      Permission.manageExternalStorage.request();
    }
    if (image != null) {
      final rec = ui.PictureRecorder();
      final canvas = Canvas(rec);
      final painter = ImagePainter();
      painter.paint(canvas, image_size);
      final picture = rec.endRecording();
      final im = await picture.toImage(image!.width, image!.height);
      final outFile =
          File("$_path/${_fileName}_${generateNamePrefix()}$fileExt");
      final byteData = await im.toByteData(format: ui.ImageByteFormat.rawRgba);
      Im.Image img = Im.Image.fromBytes(
          image!.width,
          image!.height,
          byteData!.buffer
              .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
      outFile.writeAsBytes(Im.encodeJpg(img));
      Get.snackbar("Saved at:", outFile.path, colorText: Colors.green);
      update();
    }
  }

  String generateNamePrefix() {
    return DateFormat("msS").format(DateTime.now());
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
    p1 = pos;
    p2 = pos;
    addDesignation();
    update();
  }

  releaseHandler(Offset pos) {
    p2 = pos;
    isDrawing = false;
    if (objects.isNotEmpty) {
      objects.last.updateOffsets(p2: pos);
    }
    update();
  }

  addDesignation() {
    if (mode == DesignationMode.dimension) {
      addDimension();
    }
    if (mode == DesignationMode.note) {
      addNote();
    }
    update();
  }

  addDimension() {
    if (p1 != null && p2 != null) {
      objects.add(Dimension(
        text: text,
        start: p1!,
        end: p2!,
        lineStyle: lineStyle,
      ));
      mode = null;
    }
  }

  addNote() {
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
