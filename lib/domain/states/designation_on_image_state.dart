import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:archive/archive.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as image_util;
import 'package:get/get.dart';
import 'package:notes_on_image/ui/widgets/confirm_dialog.dart';
import 'package:notes_on_image/ui/widgets/text_style_dialog.dart';
import 'package:notes_on_image/utils/converter.dart';
import 'package:path/path.dart' as path;
import 'package:notes_on_image/domain/entities/designation.dart';
import 'package:notes_on_image/ui/screens/draw_on_image_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class DesignationOnImageState extends GetxController {
  Map<int, Designation> objects = {};
  List<int> objectsSequence = [];
  bool isNewObj = false;
  bool isBusy = false;
  bool isPressed = false;
  Designation? objToEdit;
  Offset cursorPosition = Offset(0, 0);

  Function(Offset)? objUpdateCallback;

  ui.Image? image;
  late Size imageSize;
  String workDir = "";
  String originalName = "";

  bool isChanged() {
    if (objectsSequence.isNotEmpty) {
      return true;
    }
    return false;
  }

  _loadImage(File f) async {
    final data = await f.readAsBytes();
    image = await decodeImageFromList(data);
    imageSize = Size(image!.width.toDouble(), image!.height.toDouble());
    isBusy = false;
    update();
  }

  Future<File> saveImage({String? outputFilePath}) async {
    isBusy = true;
    update();
    if (image == null) throw Exception("Image is null");
    final rec = ui.PictureRecorder();
    final canvas = Canvas(rec);
    final painter = ImagePainter();
    painter.paint(canvas, imageSize);
    final picture = rec.endRecording();
    final im = await picture.toImage(image!.width, image!.height);
    final name = path.basenameWithoutExtension(originalName);
    final outFile = File(outputFilePath ??
        path.join(workDir, "${name}_${generateNamePrefix()}.jpg"));
    final byteData = await im.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (byteData == null) {
      throw Exception("Cannot encode image to byte data");
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
    return outFile;
  }

  saveZip({String? outputFilePath}) async {
    final originalImage = image;
    if (originalImage == null) return;
    final imgBytes = await imageToUint8List(originalImage);

    final data = objects.values.map((field) => field.toMap()).toList();
    final designationsJsonString = jsonEncode(data);

    final name = path.basenameWithoutExtension(originalName);
    final zipFilePath = outputFilePath ?? path.join(workDir, "$name.zip");

    final archive = Archive()
      ..addFile(ArchiveFile("$name.jpg", imgBytes.length, imgBytes))
      ..addFile(ArchiveFile('designationsJsonString.json',
          designationsJsonString.length, utf8.encode(designationsJsonString)));

    final zipFile = File(zipFilePath);
    final buffer = ZipEncoder().encode(archive);
    await zipFile.writeAsBytes(buffer);
  }

  void open(File file) async {
    if (!file.existsSync()) return;
    final extension = path.extension(file.path);

    if (extension != '.zip' && extension != '.jpg') return;
    isBusy = true;
    update();
    objects.clear();
    objectsSequence.clear();
    workDir = path.dirname(file.path);
    originalName = path.basenameWithoutExtension(file.path);

    if (extension == '.zip') await _openZip(file);
    if (extension == '.jpg') await _loadImage(file);

    isBusy = false;
    update();
  }

  _openZip(File file) async {
    final archiveBytes = await file.readAsBytes();
    final archive = ZipDecoder().decodeBytes(archiveBytes);

    ArchiveFile? source;
    ArchiveFile? json;

    for (final file in archive) {
      if (file.name == 'designationsJsonString.json') {
        json = file;
      } else if (path.extension(file.name) == '.jpg') {
        source = file;
      }
    }
    if (source == null || json == null) {
      throw Exception("Wrong zip file format: \n source $source\n json $json");
    }

    final data = source.content;
    image = await decodeImageFromList(data);
    imageSize = Size(image!.width.toDouble(), image!.height.toDouble());

    final fieldsJsonString = utf8.decode(json.content as List<int>);
    final dataMap = jsonDecode(fieldsJsonString);
    for (final m in dataMap) {
      final d = Designation.fromMap(m);
      objects[d.id] = d;
    }
  }

  hasToSaveDialog({
    required Function onConfirmCallback,
    Function? onCancelCallback,
    Function? onNoCallback,
  }) async {
    if (isChanged()) {
      final haveToSave = await Get.dialog(
        const ConfirmDialog(title: 'Do you like to save changes?'),
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
    final i = await Get.dialog<Designation>(TextStyleDialog(
      item: item,
    ));
    if (i != null) {
      isNewObj = true;
      objToEdit = i;
    }
  }

  panDown(Offset pos) {
    isPressed = true;
    final item = objToEdit;
    if (isNewObj && item != null) {
      item.start = pos;
      item.end = pos;
      objUpdateCallback = ((val) {
        objToEdit?.updateOffsets(p2: val);
      });
    } else {
      Timer(Duration(milliseconds: 500), () {
        initUpdateDesignationAtPosition(pos);
      });
    }
    update();
  }

  updateObjectInState(Designation obj) {
    final id = obj.id;
    obj.resetHighlight();
    objects[id] = obj;
    objectsSequence.removeWhere((objId) => objId == id);
    objectsSequence.add(id);
    update();
  }

  updatePoint(Offset pos) {
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
      objToEdit = null;
    }
    update();
  }

  initUpdateDesignationAtPosition(Offset position) {
    final cp = cursorPosition;
    if (isSamePosition(position, cp)) {
      for (Designation o in objects.values) {
        final callback = o.getUpdateCallBackIfTouchedAndHighlightIt(
            position, () => updateDesignationStyle(o));
        if (callback != null) {
          update();
          objToEdit = o;
          objUpdateCallback = callback;
          break;
        }
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

  void finishDrawing() {
    final item = objToEdit;
    if (item != null) updateObjectInState(item);
    isNewObj = false;
    objUpdateCallback = null;
    objToEdit = null;
    isPressed = false;
    update();
  }

  void updateCursorPosition(Offset position) {
    cursorPosition = position;
  }

  bool isSamePosition(Offset p1, Offset p2) {
    final path = Path();
    path.addOval(Rect.fromCircle(center: p1, radius: 75));
    path.close();
    if (path.contains(p2)) return true;
    return false;
  }

  bool isObjTouched(Offset point) {
    for (Designation o in objects.values) {
      if (o.isTouched(point)) return true;
    }
    return false;
  }

  void openPath(String path) {
    if (path.isEmpty) return;
    final file = File(path);
    open(file);
  }

  void deleteDesignation({required int id}) {
    if (!objects.containsKey(id)) return;
    objToEdit = null;
    objUpdateCallback = null;
    isNewObj = false;
    objects.remove(id);
    objectsSequence.remove(id);
    update();
  }

  void setImage(Uint8List data) async {
    image = await decodeImageFromList(data);
    imageSize = Size(image!.width.toDouble(), image!.height.toDouble());
    update();
  }
}
