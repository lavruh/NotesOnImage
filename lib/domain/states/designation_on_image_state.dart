import 'dart:io';
import 'dart:ui' as ui;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as image_util;
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import 'package:notes_on_image/domain/entities/designation.dart';
import 'package:notes_on_image/ui/screens/draw_on_image_screen.dart';
import 'package:permission_handler/permission_handler.dart';

enum DesignationMode { dimension, note }

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
  late Size imageSize;
  String _sourcePath = '';
  String _fileName = '';
  String _fileExtension = '';

  set sourcePath(String p) {
    final delim = p.lastIndexOf('/');
    _sourcePath = p.substring(0, delim);
    final n = p.substring(delim + 1);
    _fileName = n.substring(0, n.length - 4);
    _fileExtension = n.substring(n.length - 4);
  }

  String get sourcePath => path.join(_sourcePath, "$_fileName$_fileExtension");
  String get pathBase => _sourcePath;
  String get fileName => _fileName;
  String get fileExt => _fileExtension;
  DesignationMode? get mode => _mode;

  set mode(DesignationMode? m) {
    _mode = m;
    isDrawing = true;
  }

  loadImage(File f) async {
    final data = await f.readAsBytes();
    image = await decodeImageFromList(data);
    sourcePath = f.path;
    imageSize = Size(image!.width.toDouble(), image!.height.toDouble());
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
      painter.paint(canvas, imageSize);
      final picture = rec.endRecording();
      final im = await picture.toImage(image!.width, image!.height);
      final outFile = File(path.join(
          _sourcePath, "${_fileName}_${generateNamePrefix()}$fileExt"));
      final byteData = await im.toByteData(format: ui.ImageByteFormat.rawRgba);
      image_util.Image img = image_util.Image.fromBytes(
          image!.width,
          image!.height,
          byteData!.buffer
              .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
      outFile.writeAsBytes(image_util.encodeJpg(img));
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
      mode = null;
    }
  }

  @override
  void onInit() async {
    if (await isPermissionsGranted() == false) {
      throw Exception("No permissions to open file");
    }
    objects.clear();
    super.onInit();
  }

  Future<bool> isPermissionsGranted() async {
    bool fl = true;
    int v = await getAndroidVersion() ?? 5;
    if (v >= 12) {
      // Request of this permission on old devices leads to crash
      if (fl && await Permission.manageExternalStorage.status.isDenied) {
        fl = await Permission.manageExternalStorage.request().isGranted;
      }
    } else {
      if (fl && await Permission.storage.status.isDenied) {
        fl = await Permission.storage.request().isGranted;
      }
    }

    return fl;
  }

  Future<int?> getAndroidVersion() async {
    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      final androidVersion = androidInfo.version.release ?? '5';
      return int.parse(androidVersion.split('.')[0]);
    }
    return null;
  }
}
