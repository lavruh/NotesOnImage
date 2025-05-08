import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:notes_on_image/domain/entities/dimension.dart';
import 'package:notes_on_image/domain/entities/note.dart';
import 'package:notes_on_image/domain/entities/point.dart';
import 'package:notes_on_image/domain/entities/point_empty.dart';
import 'package:notes_on_image/domain/entities/text_block.dart';
import 'package:notes_on_image/utils/color_extensions.dart';

abstract class Designation {
  final int _id;
  String text = '';
  late Paint paint;
  Map<String, Point> points = {};
  final bool drawTextFrame;

  Designation({
    int? id,
    this.text = '',
    Paint? lineStyle,
    Point? start,
    Point? end,
    this.drawTextFrame = false,
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

  double get textOffset => -50 - log(lineWeight) * 10 - lineWeight;

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
    TextSpan ts = TextSpan(text: "\u2007$text\u2007", style: getTextStyle());
    TextPainter tp = TextPainter(
      text: ts,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    return tp;
  }

  TextStyle getTextStyle() {
    final shadedColor = paint.color.generateBackgroundColor();
    final color = drawTextFrame ? shadedColor : paint.color;
    final bg = drawTextFrame ? paint.color : null;
    return TextStyle(
      color: color,
      backgroundColor: bg,
      height: 1.5,
      leadingDistribution: TextLeadingDistribution.even,
      fontSize: lineWeight * 2 + 30,
    );
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
    bool? drawTextFrame,
    double? lineWeight,
    Color? color,
  });

  resetHighlight() {
    for (final p in points.values) {
      points[p.name] = p.copyWith(isHighlighted: false);
    }
  }

  @override
  String toString() {
    return "$runtimeType [$id] \n text: $text \n start: $start \n end: $end \n";
  }

  Map<String, dynamic> toMap() {
    return {
      'runtimeType': runtimeType.toString(),
      'id': _id,
      'text': text,
      'color': paint.color.toHexString(),
      'strokeWidth': paint.strokeWidth,
      'points': points.values.map((poi) => poi.toMap()).toList(),
      'drawTextFrame': drawTextFrame,
    };
  }

  factory Designation.fromMap(Map<String, dynamic> map) {
    final type = map['runtimeType'];
    if (type == null) {
      throw Exception("Designation.fromMap: runtimeType is null");
    }

    final pointsMap = map['points'];
    if (pointsMap == null) {
      throw Exception("Designation.fromMap: pointsMap is null");
    }
    final Map<String, Point> poi = {};
    for (final p in pointsMap) {
      poi[p['name']] = Point.fromMap(p);
    }
    if (poi['start'] == null || poi['end'] == null) {
      throw Exception("Designation.fromMap: start or end is null");
    }
    final String c = map['color'];

    if (type == "Note") {
      return Note.empty().copyWith(
        id: map['id'],
        text: map['text'],
        start: poi['start'],
        end: poi['end'],
        lineWeight: map['strokeWidth'],
        color: c.toColor(),
        drawTextFrame: map['drawTextFrame'],
      );
    }
    if (type == "Dimension") {
      return Dimension.empty().copyWith(
        id: map['id'],
        text: map['text'],
        start: poi['start'],
        end: poi['end'],
        lineWeight: map['strokeWidth'],
        color: c.toColor(),
        drawTextFrame: map['drawTextFrame'],
      );
    }
    if (type == "TextBlock") {
      return TextBlock.empty().copyWith(
        id: map['id'],
        text: map['text'],
        start: poi['start'],
        end: poi['end'],
        lineWeight: map['strokeWidth'],
        color: c.toColor(),
        drawTextFrame: map['drawTextFrame'],
      );
    }
    throw Exception("Designation.fromMap: Unknown type: $type");
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Designation &&
          runtimeType == other.runtimeType &&
          _id == other._id &&
          text == other.text;

  @override
  int get hashCode => _id.hashCode ^ text.hashCode ^ points.hashCode;
}
