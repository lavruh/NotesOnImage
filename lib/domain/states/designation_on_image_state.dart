import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_on_image/domain/entities/designation.dart';

enum DesignationMode { dimension, note }

class DesignationOnImageState extends GetxController {
  final objects = <Designation>[].obs();
  Offset? p1;
  Offset? p2;
  DesignationMode? mode;

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
        text: "text",
        start: p1!,
        end: p2!,
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
        text: "text",
        pointer: p1!,
        note: p2!,
      ));
      p1 = null;
      p2 = null;
      mode = null;
    }
  }
}
