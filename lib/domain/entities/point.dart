import 'dart:ui';

class Point {
  final String name;
  final Offset position;
  final double intersectionRadius;
  final bool isHighlighted;

  Point({required this.name, required this.position})
      : intersectionRadius = 75.0,
        isHighlighted = false;
  Point._(
      {required this.name,
      required this.position,
      required this.isHighlighted,
      required this.intersectionRadius});

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
  }) =>
      Point._(
          name: name ?? this.name,
          position: position ?? this.position,
          isHighlighted: isHighlighted ?? this.isHighlighted,
          intersectionRadius: intersectionRadius ?? this.intersectionRadius);

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

  draw(Canvas canvas, Paint paint) {
    if (isHighlighted) highLight(canvas, paint);
  }
}
