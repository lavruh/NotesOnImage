import 'dart:io';
import 'dart:ui' as ui;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as image_util;
import 'package:get/get.dart';
import 'package:notes_on_image/ui/widgets/save_confirm_dialog.dart';
import 'package:notes_on_image/ui/widgets/text_style_dialog.dart';
import 'package:path/path.dart' as path;
import 'package:notes_on_image/domain/entities/designation.dart';
import 'package:notes_on_image/ui/screens/draw_on_image_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

enum DesignationMode { dimension, note }

class DesignationOnImageState extends GetxController {
  Map<int, Designation> objects = {};
  List<int> objectsSequence = [];
  bool isDrawing = false;
  bool isBusy = false;
  Designation? _tmpItem;

  Function(Offset)? objUpdateCallback;

  ui.Image? image;
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

  bool isChanged() {
    if (objectsSequence.isNotEmpty) {
      return true;
    }
    return false;
  }

  loadImage(File f) async {
    isBusy = true;
    update();
    objects.clear();
    objectsSequence.clear();
    final data = await f.readAsBytes();
    image = await decodeImageFromList(data);
    sourcePath = f.path;
    imageSize = Size(image!.width.toDouble(), image!.height.toDouble());
    isBusy = false;
    update();
  }

  Future<String?> saveImage() async {
    isBusy = true;
    update();
    if (image != null) {
      final rec = ui.PictureRecorder();
      final canvas = Canvas(rec);
      final painter = ImagePainter();
      painter.paint(canvas, imageSize);
      final picture = rec.endRecording();
      final im = await picture.toImage(image!.width, image!.height);
      final outFile =
          File(path.join(_sourcePath, "${_fileName}_${generateNamePrefix()}$_fileExtension"));
      final byteData =
          await im.toByteData(format: ui.ImageByteFormat.rawRgba);
      if (byteData == null) {
        return null;
      }
      final outputImage = image_util.Image.fromBytes(
        width: image!.width,
        height: image!.height,
        bytes: byteData.buffer,
        order: image_util.ChannelOrder.rgba,
      );
      await outFile.writeAsBytes(image_util.encodeJpg(outputImage));
      isBusy = false;
      update();
      objects.clear();
      objectsSequence.clear();
      return outFile.path;
    }
    return null;
  }

  hasToSavePromt({
    required Function onConfirmCallback,
    Function? onCancelCallback,
    Function? onNoCallback,
  }) async {
    if (isChanged()) {
      final haveToSave = await Get.dialog(
        const SaveConfirmDialog(),
        transitionDuration: const Duration(milliseconds: 0),
      );
      if (haveToSave == true) {
        onConfirmCallback();
        return;
      }
      if (haveToSave == false) {
        if (onNoCallback != null) onNoCallback();
        return;
      }
      if (onCancelCallback != null) onCancelCallback();
    } else {
      if (onNoCallback != null) onNoCallback();
    }
  }

  shareImage() async {
    final output = await saveImage();
    if (output != null) {
      await Share.shareXFiles([XFile(output)]);
      File(output).delete();
    }
  }

  String generateNamePrefix() {
    return DateFormat("msS").format(DateTime.now());
  }

  undo() {
    if (objectsSequence.isNotEmpty) {
      final id = objectsSequence.removeLast();
      objects.remove(id);
      update();
    }
  }

  initAddDesignation(Designation item) async {
    _tmpItem = await Get.dialog<Designation>(TextStyleDialog(
      item: item,
    ));
    if (_tmpItem != null) {
      isDrawing = true;
    }
  }

  tapHandler(Offset pos) {
    if (isDrawing && _tmpItem != null) {
      final Designation designation = _tmpItem!;
      designation.start = pos;
      designation.end = pos;
      objects.putIfAbsent(designation.id, (() => designation));
      objectsSequence.add(designation.id);
      objUpdateCallback = ((val) {
        objects[designation.id]!.updateOffsets(p2: val);
      });
      _tmpItem = null;
      update();
    }
  }

  updatePoint(Offset pos) {
    isDrawing = false;
    if (objUpdateCallback != null) {
      objUpdateCallback!(pos);
    }
    update();
  }

  updateDesignationStyle(Designation item) async {
    final updatedItem = await Get.dialog<Designation>(TextStyleDialog(
      item: item,
    ));
    if (updatedItem != null && objects.containsKey(updatedItem.id)) {
      objects[updatedItem.id] = updatedItem;
      update();
    }
  }

  initUpdateDesignitionAtPosition(Offset position) {
    for (Designation o in objects.values) {
      final pointIndex = o.isTouched(position);
      if (pointIndex == 1) {
        objUpdateCallback = (val) {
          objects[o.id]!.updateOffsets(p1: val);
        };
        isDrawing = true;
        break;
      }
      if (pointIndex == 2) {
        objUpdateCallback = (val) {
          objects[o.id]!.updateOffsets(p2: val);
        };
        isDrawing = true;
        break;
      }
      if (pointIndex == 3) {
        updateDesignationStyle(o);
        break;
      }
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
    if (Platform.isLinux) {
      return true;
    }
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
      final androidVersion = androidInfo.version.release;
      return int.parse(androidVersion.split('.')[0]);
    }
    return null;
  }
}
