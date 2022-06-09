import 'dart:math';

import 'package:flutter/material.dart';
import 'package:notes_on_image/domain/entities/designation.dart';

class Note extends Designation {
  late Offset lineEnd;
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

  Note.empty()
      : super(
          text: '',
          start: const Offset(0, 0),
          end: const Offset(0, 0),
        );

  @override
  draw(Canvas canvas) {
    final fi = getDirection(start, end);
    final tp = drawText();
    final textCenter = (fi >= 0) & (fi < pi)
        ? end - Offset(tp.width / 2, (tp.height + 100) / 2)
        : end - Offset(tp.width / 2, (tp.height - 100) / 2);
    textPosition = textCenter + Offset(tp.width / 2, tp.height / 2);
    lineEnd = rotatePoint(
      origin: textCenter,
      point: textCenter + Offset(-(tp.width + 5 / 2), 0),
      a: fi + pi,
    );

    tp.paint(
      canvas,
      textCenter,
    );
    canvas.drawLine(start, end, paint);
    drawArrow(canvas: canvas, p1: start, p2: end, arrowAng: -45, fi: fi);
  }
}
