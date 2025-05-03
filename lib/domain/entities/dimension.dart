import 'dart:math';

import 'package:flutter/material.dart';
import 'package:notes_on_image/domain/entities/designation.dart';
import 'package:notes_on_image/domain/entities/point.dart';
import 'package:notes_on_image/domain/entities/point_arrow.dart';
import 'package:notes_on_image/utils/math_utils.dart';

class Dimension extends Designation {
  Dimension({
    required super.text,
    required super.start,
    required super.end,
    super.lineStyle,
  });

  Dimension.empty()
      : super(
          text: '',
          start: PointArrow(name: "start", position: Offset(0, 0)),
          end: PointArrow(name: "end", position: Offset(0, 0)),
        );

  @override
  draw(Canvas canvas) {
    canvas.drawLine(start, end, paint);
    double direction = getDirection(start, end);
    textPosition = start + (end - start) / 2;
    for (final poi in points.values) {
      double d = direction;
      if (poi.name == "end") d = direction + pi;
      poi.draw(canvas, paint, d, lineWeight);
    }
    canvas.save();
    canvas.translate(start.dx, start.dy);
    canvas.rotate(direction + pi);
    TextPainter tp = drawText();
    tp.paint(canvas,
        Offset(vectorLen(p1: start, p2: end) / 2 - tp.width / 2, textOffset));
    canvas.translate(-start.dx, -start.dy);
    canvas.restore();
  }

  @override
  Designation copyWith({
    int? id,
    String? text,
    Point? start,
    Point? end,
    Paint? lineStyle,
    int? highLightedPoint,
  }) {
    return Dimension(
      text: text ?? this.text,
      start: start ?? startPoint,
      end: end ?? endPoint,
      lineStyle: lineStyle,
    );
  }
}
