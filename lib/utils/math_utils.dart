import 'dart:math';
import 'dart:ui';

double getDirection(Offset p1, Offset p2) {
  Offset p = changeOrigin(newOrigin: p2, point: p1);
  return atan2(p.dy, p.dx);
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