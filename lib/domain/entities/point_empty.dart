import 'dart:ui';

import 'package:notes_on_image/domain/entities/point.dart';

class PointEmpty extends Point {
  PointEmpty(
      {required super.name, required super.position, super.isHighlighted});

  @override
  Point copyWith({
    Offset? position,
    String? name,
    bool? isHighlighted,
    double? intersectionRadius,
  }) =>
      PointEmpty(
          name: name ?? this.name,
          position: position ?? this.position,
          isHighlighted: isHighlighted ?? this.isHighlighted);
}
