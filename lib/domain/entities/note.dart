import 'dart:math';

import 'package:flutter/material.dart';
import 'package:notes_on_image/domain/entities/designation.dart';

class Note extends Designation {
  Note({
    required Offset start,
    required Offset end,
    required String text,
    Paint? lineStyle,
  }) : super(
          text: text,
          lineStyle: lineStyle,
          start: start,
          end: end,
        );

  @override
  draw(Canvas canvas) {
    double fi = getDirection(start, end);
    canvas.drawLine(start, end, paint);
    drawArrow(canvas: canvas, p1: start, p2: end, arrowAng: -45, fi: fi);

    drawText().paint(
        canvas,
        rotatePoint(
          origin: end,
          point: (fi >= 0) & (fi < pi / 2)
              ? Offset(end.dx, end.dy + 30)
              : Offset(end.dx, end.dy),
          a: fi + pi,
        ));
  }
}
