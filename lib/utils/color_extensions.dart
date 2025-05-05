import 'package:flutter/material.dart';

extension ColorToneExtension on Color {
  Color generateBackgroundColor({double amount = 0.4}) {
    final hsl = HSLColor.fromColor(this);
    final bool isLight = hsl.lightness > 0.5;

    final double newLightness =
        (isLight ? hsl.lightness - amount : hsl.lightness + amount)
            .clamp(0.0, 1.0);

    return hsl.withLightness(newLightness).toColor();
  }
}
