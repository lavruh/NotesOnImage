import 'dart:math';

import 'package:flutter/material.dart';

class Designation {
  String text = 'tttt';

  Designation({required this.text});

  draw(Canvas canvas) {}

  TextPainter drawText() {
    TextSpan ts = TextSpan(text: text, style: TextStyle(color: Colors.black));
    TextPainter tp = TextPainter(
      text: ts,
      textAlign: TextAlign.start,
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    return tp;
  }

  drawArrow({
    required Canvas canvas,
    required Offset p1,
    required Offset p2,
    required int arrowAng,
  }) {
    Offset p = changeOrigin(newOrigin: p2, point: p1);
    double fi = atan2(p.dy, p.dx);
    canvas.drawLine(
      p1,
      rotatePoint(
          origin: p1, point: Offset(p1.dx + arrowAng, p1.dy - 5), a: fi),
      Paint(),
    );
    canvas.drawLine(
      p1,
      rotatePoint(
          origin: p1, point: Offset(p1.dx + arrowAng, p1.dy + 5), a: fi),
      Paint(),
    );
  }

  Offset changeOrigin({
    required Offset newOrigin,
    required Offset point,
  }) {
    return Offset(point.dx - newOrigin.dx, point.dy - newOrigin.dy);
  }

  Offset rotatePoint({
    required Offset origin,
    required Offset point,
    required double a,
  }) {
    return Offset(
      origin.dx +
          (point.dx - origin.dx) * cos(a) -
          (point.dy - origin.dy) * sin(a),
      origin.dy +
          (point.dx - origin.dx) * sin(a) +
          (point.dy - origin.dy) * cos(a),
    );
  }
}

class Dimension extends Designation {
  Offset end;
  Offset start;

  Dimension({
    required String text,
    required this.start,
    required this.end,
  }) : super(text: text);

  @override
  draw(Canvas canvas) {
    canvas.drawLine(start, end, Paint());
    drawArrow(canvas: canvas, p1: start, p2: end, arrowAng: -15);
    drawArrow(canvas: canvas, p1: end, p2: start, arrowAng: -15);
  }
}

class Note extends Designation {
  Offset pointer;
  Offset note;

  Note({
    required this.pointer,
    required this.note,
    required String text,
  }) : super(text: text);

  @override
  draw(Canvas canvas) {
    canvas.drawLine(pointer, note, Paint());
    drawArrow(canvas: canvas, p1: pointer, p2: note, arrowAng: -15);
    drawText().paint(canvas, note);
  }
}
