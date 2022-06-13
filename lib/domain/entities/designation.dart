import 'dart:math';

import 'package:flutter/material.dart';

abstract class Designation {
  final int _id;
  String text = '';
  late Paint paint;
  double scale = 2;
  Offset start;
  Offset end;
  Offset textPosition = const Offset(0, 0);

  Designation({
    int? id,
    this.text = '',
    Paint? lineStyle,
    this.start = const Offset(0, 0),
    this.end = const Offset(0, 0),
  }) : _id = id ?? DateTime.now().millisecondsSinceEpoch {
    if (lineStyle != null) {
      paint = Paint()
        ..strokeWidth = lineStyle.strokeWidth
        ..color = lineStyle.color;
    } else {
      paint = Paint()
        ..color = Colors.lightGreenAccent
        ..strokeWidth = 8.0;
    }
    scale = 0.14 * paint.strokeWidth;
  }

  int get id => _id;
  double get lineWeight => paint.strokeWidth;
  set lineWeight(double val) => paint.strokeWidth = val;
  Color get lineColor => paint.color;
  set lineColor(Color val) => paint.color = val;

  updateOffsets({Offset? p1, Offset? p2}) {
    if (p1 != null) start = p1;
    if (p2 != null) end = p2;
  }

  draw(Canvas canvas);

  int isTouched(Offset point) {
    final path = Path();
    path.addOval(Rect.fromCircle(center: start, radius: 75));
    path.close();
    if (path.contains(point)) {
      return 1;
    }
    final path2 = Path();
    path2.addOval(Rect.fromCircle(center: end, radius: 75));
    path2.close();
    if (path2.contains(point)) {
      return 2;
    }
    final pathText = Path();
    pathText.addOval(Rect.fromCircle(center: textPosition, radius: 75));
    pathText.close();
    if (pathText.contains(point)) {
      return 3;
    }
    return 0;
  }

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
