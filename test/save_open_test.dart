import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notes_on_image/domain/entities/designation.dart';
import 'package:notes_on_image/domain/entities/dimension.dart';
import 'package:notes_on_image/domain/entities/note.dart';
import 'package:notes_on_image/domain/entities/point_arrow.dart';
import 'package:notes_on_image/domain/entities/text_block.dart';

main() {

  test("create and read json string", () async {
    final note = Note.empty().copyWith(text: "Note 1", drawTextFrame: true);
    final dimension = Dimension.empty().copyWith(
        text: "Dimension 1",
        end: PointArrow(name: "end", position: Offset(5, 5)));
    final textBlock =
        TextBlock.empty().copyWith(text: "Text Block 1", color: Colors.red);
    final objects = [note, dimension, textBlock];

    final map = objects.map((e) => e.toMap()).toList();
    final json = jsonEncode(map);

    expect(json, contains(note.text));
    expect(json, contains(dimension.text));
    expect(json, contains(dimension.endPoint.name));
    expect(json, contains(textBlock.text));
    expect(json, contains(textBlock.paint.color.toHexString()));

    final list = jsonDecode(json) as List;
    final newState = list.map((e) => Designation.fromMap(e)).toList();

    expect(newState, contains(note));
    expect(newState, contains(dimension));
    expect(newState, contains(textBlock));
  });
}
