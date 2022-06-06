import 'dart:math';

import 'package:flutter/material.dart';

class Designation {
  String text = '';
  late final Paint paint;
  double scale = 2;

  Designation({required this.text, Paint? lineStyle}) {
    if (lineStyle != null) {
      paint = Paint()
        ..strokeWidth = lineStyle.strokeWidth
        ..color = lineStyle.color;

      scale = 0.14 * paint.strokeWidth;
    } else {
      paint = Paint();
    }
  }

  updateOffsets({Offset? p1, Offset? p2}) {}

  draw(Canvas canvas) {}

  TextPainter drawText() {
    TextSpan ts = TextSpan(
        text: text,
        style: TextStyle(
          color: paint.color,
          fontSize: paint.strokeWidth + 60,
        ));
    TextPainter tp = TextPainter(
      text: ts,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    return tp;
  }

  double getDirection(Offset p1, Offset p2) {
    Offset p = changeOrigin(newOrigin: p2, point: p1);
    return atan2(p.dy, p.dx);
  }

  drawArrow({
    required Canvas canvas,
    required Offset p1,
    required Offset p2,
    required int arrowAng,
    required double fi,
  }) {
    canvas.drawLine(
      p1,
      rotatePoint(
          origin: p1,
          point:
              Offset(p1.dx + arrowAng * scale, p1.dy - (arrowAng * scale) / 3),
          a: fi),
      paint,
    );
    canvas.drawLine(
      p1,
      rotatePoint(
          origin: p1,
          point:
              Offset(p1.dx + arrowAng * scale, p1.dy + (arrowAng * scale) / 3),
          a: fi),
      paint,
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

  double vectorLen({required Offset p1, required Offset p2}) {
    return sqrt(pow(p1.dx - p2.dx, 2) + pow(p1.dy - p2.dy, 2));
  }

  Offset midPoint({required Offset p1, required Offset p2}) {
    return Offset(p1.dx - p2.dx, p1.dy - p2.dy);
  }
}

class Dimension extends Designation {
  Offset end;
  Offset start;

  Dimension({
    required String text,
    required this.start,
    required this.end,
    Paint? lineStyle,
  }) : super(text: text, lineStyle: lineStyle);

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

  @override
  updateOffsets({Offset? p1, Offset? p2}) {
    if (p1 != null) start = p1;
    if (p2 != null) end = p2;
  }
}

class Note extends Designation {
  Offset pointer;
  Offset note;

  Note({
    required this.pointer,
    required this.note,
    required String text,
    Paint? lineStyle,
  }) : super(
          text: text,
          lineStyle: lineStyle,
        );

  @override
  draw(Canvas canvas) {
    double fi = getDirection(pointer, note);
    canvas.drawLine(pointer, note, paint);
    drawArrow(canvas: canvas, p1: pointer, p2: note, arrowAng: -45, fi: fi);

    Offset textOffset = Offset(note.dx + 30, note.dy + 30);
    drawText().paint(
        canvas,
        rotatePoint(
          origin: note,
          point: (fi >= 0) & (fi < pi / 2)
              ? Offset(note.dx, note.dy + 30)
              : Offset(note.dx, note.dy),
          a: fi + pi,
        ));
  }

  @override
  updateOffsets({Offset? p1, Offset? p2}) {
    if (p1 != null) pointer = p1;
    if (p2 != null) note = p2;
  }
}
