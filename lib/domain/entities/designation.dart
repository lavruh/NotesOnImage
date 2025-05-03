import 'package:flutter/material.dart';
import 'package:notes_on_image/domain/entities/point.dart';
import 'package:notes_on_image/domain/entities/point_empty.dart';

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
    Point? start,
    Point? end,
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
        PointEmpty(name: 'textPosition', position: Offset(0, 0));
    points['start'] = start?.copyWith(name: "start") ??
        PointEmpty(name: 'start', position: Offset(0, 0));
    points['end'] = end?.copyWith(name: "end") ??
        PointEmpty(name: 'end', position: Offset(0, 0));
  }

  int get id => _id;
  double get lineWeight => paint.strokeWidth;
  set lineWeight(double val) => paint.strokeWidth = val;
  Color get lineColor => paint.color;
  set lineColor(Color val) => paint.color = val;

  Point get startPoint => points['start']!;
  set startPoint(Point val) => points['start'] = val;
  Offset get start => startPoint.position;
  set start(Offset val) => startPoint = startPoint.copyWith(position: val);

  Point get endPoint => points['end']!;
  set endPoint(Point val) => points['end'] = val;
  Offset get end => endPoint.position;
  set end(Offset val) => endPoint = endPoint.copyWith(position: val);

  Point get textPositionPoint => points['textPosition']!;
  set textPositionPoint(Point val) => points['textPosition'] = val;
  Offset get textPosition => textPositionPoint.position;
  set textPosition(Offset val) => textPositionPoint =
      textPositionPoint.copyWith(name: "textPosition", position: val);

  updateOffsets({Offset? p1, Offset? p2}) {
    if (p1 != null) start = p1;
    if (p2 != null) end = p2;
  }

  draw(Canvas canvas);

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
          return points[p.name] =
              p.copyWith(position: val, isHighlighted: true);
        };
      }
    }
    return null;
  }

  Designation copyWith({
    int? id,
    String? text,
    Point? start,
    Point? end,
    Paint? lineStyle,
    int? highLightedPoint,
  });

  resetHighlight() {
    for (final p in points.values) {
      points[p.name] = p.copyWith(isHighlighted: false);
    }
  }
}
