import 'dart:math';

import 'package:flutter/material.dart';

abstract class Designation {
  String text;

  Designation({
    required this.text,
  });

  draw(Canvas canvas) {}
}

class Dimension implements Designation {
  Offset end;
  Offset start;

  @override
  String text;

  Dimension({
    required this.text,
    required this.start,
    required this.end,
  });

  @override
  draw(Canvas canvas) {
    canvas.drawLine(start, end, Paint());
    Offset p = changeOrigin(
      newOrigin: end,
      point: start,
    );
    double fi = atan2(p.dy, p.dx);
    canvas.drawLine(
      start,
      rotatePoint(
          origin: start, point: Offset(start.dx - 15, start.dy - 5), a: fi),
      Paint(),
    );
    canvas.drawLine(
      start,
      rotatePoint(
          origin: start, point: Offset(start.dx - 15, start.dy + 5), a: fi),
      Paint(),
    );
    canvas.drawLine(
      end,
      rotatePoint(origin: end, point: Offset(end.dx + 15, end.dy - 5), a: fi),
      Paint(),
    );
    canvas.drawLine(
      end,
      rotatePoint(origin: end, point: Offset(end.dx + 15, end.dy + 5), a: fi),
      Paint(),
    );
  }
}

class Note implements Designation {
  Offset pointer;
  Offset note;

  @override
  String text;

  Note({
    required this.pointer,
    required this.note,
    required this.text,
  });

  @override
  draw(Canvas canvas) {
    canvas.drawLine(pointer, note, Paint());
    Offset p = changeOrigin(
      newOrigin: note,
      point: pointer,
    );
    double fi = atan2(p.dy, p.dx);
    canvas.drawLine(
      pointer,
      rotatePoint(
          origin: pointer,
          point: Offset(pointer.dx - 15, pointer.dy - 5),
          a: fi),
      Paint(),
    );
    canvas.drawLine(
      pointer,
      rotatePoint(
          origin: pointer,
          point: Offset(pointer.dx - 15, pointer.dy + 5),
          a: fi),
      Paint(),
    );
  }
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
