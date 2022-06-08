import 'dart:math';

import 'package:flutter/material.dart';
import 'package:notes_on_image/domain/entities/designation.dart';

class Dimension extends Designation {
  Dimension({
    required String text,
    required Offset start,
    required Offset end,
    Paint? lineStyle,
  }) : super(
          text: text,
          lineStyle: lineStyle,
          start: start,
          end: end,
        );

  @override
  draw(Canvas canvas) {
    canvas.drawLine(start, end, paint);
    double fi = getDirection(start, end);
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
    canvas.restore();
  }
}
