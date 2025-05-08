import 'dart:ui';

import 'package:notes_on_image/domain/entities/point_arrow.dart';
import 'package:notes_on_image/domain/entities/point_empty.dart';

abstract class Point {
  final String name;
  final Offset position;
  final double intersectionRadius;
  final bool isHighlighted;

  Point(
      {required this.name, required this.position, this.isHighlighted = false})
      : intersectionRadius = 40.0;

  bool isTouched(Offset point) {
    final path = Path();
    path.addOval(Rect.fromCircle(center: position, radius: intersectionRadius));
    path.close();
    if (path.contains(point)) {
      return true;
    }
    return false;
  }

  Point copyWith({
    Offset? position,
    String? name,
    bool? isHighlighted,
    double? intersectionRadius,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Point &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          position == other.position;

  @override
  int get hashCode => name.hashCode ^ position.hashCode;

  highLight(Canvas canvas, Paint paint) {
    final color = paint.color;
    final p = Paint()..color = color.withAlpha(75);
    final path = Path();
    path.addOval(Rect.fromCircle(center: position, radius: intersectionRadius));
    path.close();
    canvas.drawPath(path, p);
  }

  draw(Canvas canvas, Paint paint, double symbolDirection, double scale) {
    if (isHighlighted) highLight(canvas, paint);
  }

  Map<String, dynamic> toMap() {
    return {
      'runtimeType': runtimeType.toString(),
      'name': name,
      'position': {'dx': position.dx, 'dy': position.dy},
      'intersectionRadius': intersectionRadius,
    };
  }

  factory Point.fromMap(Map map) {
    final type = map['runtimeType'];
    if (type == null) throw Exception("Point fromMap: runtimeType is null");

    final pos = map['position'] as Map<String, dynamic>;
    final x = double.parse(pos['dx'].toString());
    final y = double.parse(pos['dy'].toString());

    if (type == "PointArrow") {
      return PointArrow(
        name: map['name'],
        position: Offset(x, y),
      ).copyWith(intersectionRadius: map['intersectionRadius'] as double);
    }
    if (type == "PointEmpty") {
      return PointEmpty(
        name: map['name'],
        position: Offset(x, y),
      ).copyWith(intersectionRadius: map['intersectionRadius'] as double);
    }
    throw Exception("Point.fromMap: Unknown type: $type");
  }
}
