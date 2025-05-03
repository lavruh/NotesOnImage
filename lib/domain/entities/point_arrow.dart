import 'dart:ui';

import 'package:notes_on_image/domain/entities/point.dart';
import 'package:notes_on_image/utils/math_utils.dart';

class PointArrow extends Point {
  PointArrow(
      {required super.name, required super.position, super.isHighlighted});

  drawArrow({
    required Canvas canvas,
    required Paint paint,
    required double direction,
  }) {
    final arrowAng = -45;
    canvas.drawLine(
      position,
      rotatePoint(
          origin: position,
          point: Offset(position.dx + arrowAng, position.dy - (arrowAng) / 3),
          a: direction),
      paint,
    );
    canvas.drawLine(
      position,
      rotatePoint(
          origin: position,
          point: Offset(position.dx + arrowAng, position.dy + (arrowAng) / 3),
          a: direction),
      paint,
    );
  }

  @override
  draw(Canvas canvas, Paint paint, double symbolDirection) {
    super.draw(canvas, paint, symbolDirection);
    drawArrow(
        canvas: canvas,
        paint: paint,
        direction: symbolDirection);
  }

  @override
  Point copyWith({
    Offset? position,
    String? name,
    bool? isHighlighted,
    double? intersectionRadius,
  }) =>
      PointArrow(
          name: name ?? this.name,
          position: position ?? this.position,
          isHighlighted: isHighlighted ?? this.isHighlighted);
}
