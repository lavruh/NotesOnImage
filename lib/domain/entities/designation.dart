import 'dart:math';

import 'package:flutter/material.dart';
import 'package:notes_on_image/domain/entities/point.dart';

abstract class Designation {
  final int _id;
  String text = '';
  late Paint paint;
  double scale = 2;
  Map<String, Point> points = {};
  final intersectionRadius = 75.0;

  Designation({
    int? id,
    this.text = '',
    Paint? lineStyle,
    Offset? start,
    Offset? end,
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
    points['textPosition'] =
        Point(name: 'textPosition', position: Offset(0, 0));
    points['start'] = Point(name: 'start', position: start ?? Offset(0, 0));
    points['end'] = Point(name: 'end', position: end ?? Offset(0, 0));
  }

  int get id => _id;
  double get lineWeight => paint.strokeWidth;
  set lineWeight(double val) => paint.strokeWidth = val;
  Color get lineColor => paint.color;
  set lineColor(Color val) => paint.color = val;

  Point get startPoint => points['start']!;
  set startPoint(Point val) => points['start'] = val;
  Offset get start => startPoint.position;
  set start(Offset val) => startPoint = Point(name: "start", position: val);

  Point get endPoint => points['end']!;
  set endPoint(Point val) => points['end'] = val;
  Offset get end => endPoint.position;
  set end(Offset val) => endPoint = Point(name: "end", position: val);

  Point get textPositionPoint => points['textPosition']!;
  set textPositionPoint(Point val) => points['textPosition'] = val;
  Offset get textPosition => textPositionPoint.position;
  set textPosition(Offset val) =>
      textPositionPoint = Point(name: "textPosition", position: val);

  updateOffsets({Offset? p1, Offset? p2}) {
    if (p1 != null) start = p1;
    if (p2 != null) end = p2;
  }

  draw(Canvas canvas) {
    for (final p in points.values) {
      p.draw(canvas, paint);
    }
  }

  bool isTouched(Offset point) {
    for (final p in points.values) {
      final flag = p.isTouched(point);
      if (flag) return true;
    }
    return false;
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

  Function(Offset)? getUpdateCallBackIfTouchedAndHighlightIt(
    Offset point,
    Function openEditor,
  ) {
    for (final p in points.values) {
      if (p.isTouched(point)) {
        if (p.name == textPositionPoint.name) {
          openEditor();
          return (p) {};
        }

        points[p.name] = p.copyWith(isHighlighted: true);
        return (Offset val) {
          return points[p.name] = p.copyWith(position: val, isHighlighted: true);
        };
      }
    }
    return null;
  }

  Designation copyWith({
    int? id,
    String? text,
    Offset? start,
    Offset? end,
    Paint? lineStyle,
    int? highLightedPoint,
  });

  resetHighlight() {
    for (final p in points.values) {
      points[p.name] = p.copyWith(isHighlighted: false);
    }
  }
}
