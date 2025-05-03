import 'dart:math';

import 'package:flutter/material.dart';
import 'package:notes_on_image/domain/entities/designation.dart';

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
          start: const Offset(0, 0),
          end: const Offset(0, 0),
        );

  @override
  draw(Canvas canvas) {
    super.draw(canvas);
    canvas.drawLine(start, end, paint);
    double fi = getDirection(start, end);
    textPosition = start + (end - start) / 2;
    drawArrow(canvas: canvas, p1: start, p2: end, arrowAng: -45, fi: fi);
    drawArrow(canvas: canvas, p1: end, p2: start, arrowAng: 45, fi: fi);
    canvas.save();
    canvas.translate(start.dx, start.dy);
    canvas.rotate(fi + pi);
    TextPainter tp = drawText();
    tp.paint(
        canvas,
        Offset(
          vectorLen(p1: start, p2: end) / 2 - tp.width / 2,
          -100,
        ));
    canvas.translate(-start.dx, -start.dy);
    canvas.restore();
  }

  @override
  Designation copyWith({
    int? id,
    String? text,
    Offset? start,
    Offset? end,
    Paint? lineStyle,
    int? highLightedPoint,
  }) {
    return Dimension(
      text: text ?? this.text,
      start: start ?? this.start,
      end: end ?? this.end,
      lineStyle: lineStyle,
    );
  }
}
