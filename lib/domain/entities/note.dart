import 'dart:math';

import 'package:flutter/material.dart';
import 'package:notes_on_image/domain/entities/designation.dart';
import 'package:notes_on_image/domain/entities/point.dart';
import 'package:notes_on_image/domain/entities/point_arrow.dart';
import 'package:notes_on_image/domain/entities/point_empty.dart';
import 'package:notes_on_image/utils/math_utils.dart';

class Note extends Designation {
  late Offset lineEnd;
  Note({
    super.id,
    required super.start,
    required super.end,
    required super.text,
    super.lineStyle,
    super.drawTextFrame,
  });

  Note.empty()
      : super(
          text: '',
          start: PointArrow(name: "start", position: Offset(0, 0)),
          end: PointEmpty(name: "end", position: Offset(0, 0)),
        );

  @override
  draw(Canvas canvas) {
    double direction = getDirection(start, end);
    for (final poi in points.values) {
      poi.draw(canvas, paint, direction, lineWeight);
    }
    final tp = drawText();
    final textCenter = (direction >= 0) & (direction < pi)
        ? end - Offset(tp.width / 2, (tp.height - textOffset) / 2)
        : end - Offset(tp.width / 2, (tp.height + textOffset) / 2);
    textPosition = textCenter + Offset(tp.width / 2, tp.height / 2);
    lineEnd = rotatePoint(
      origin: textCenter,
      point: textCenter + Offset(-(tp.width + 5 / 2), 0),
      a: direction + pi,
    );

    tp.paint(
      canvas,
      textCenter,
    );
    canvas.drawLine(start, end, paint);
  }

  @override
  Designation copyWith({
    int? id,
    String? text,
    Point? start,
    Point? end,
    Paint? lineStyle,
    int? highLightedPoint,
    bool? drawTextFrame,
    double? lineWeight,
    Color? color,
  }) {
    Paint style = lineStyle ?? paint;
    style.color = color ?? style.color;
    style.strokeWidth = lineWeight ?? style.strokeWidth;
    return Note(
      id: id ?? this.id,
      start: start ?? startPoint,
      end: end ?? endPoint,
      text: text ?? this.text,
      lineStyle: style,
      drawTextFrame: drawTextFrame ?? this.drawTextFrame,
    );
  }
}
