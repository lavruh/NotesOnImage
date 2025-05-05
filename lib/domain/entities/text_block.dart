import 'dart:ui';

import 'package:notes_on_image/domain/entities/designation.dart';
import 'package:notes_on_image/domain/entities/point.dart';
import 'package:notes_on_image/domain/entities/point_empty.dart';
import 'package:notes_on_image/utils/color_extensions.dart';

class TextBlock extends Designation {
  TextBlock({
    super.id,
    required super.start,
    required super.end,
    required super.text,
    super.lineStyle,
    super.drawTextFrame,
  });

  TextBlock.empty()
      : super(
          text: '',
          start: PointEmpty(name: "start", position: Offset(0, 0)),
          end: PointEmpty(name: "end", position: Offset(0, 0)),
          drawTextFrame: true,
        );

  @override
  Designation copyWith({
    int? id,
    String? text,
    Point? start,
    Point? end,
    Paint? lineStyle,
    int? highLightedPoint,
    bool? drawTextFrame,
    double? lineWeight,
    Color? color,
  }) {
    Paint style = lineStyle ?? paint;
    style.color = color ?? style.color;
    style.strokeWidth = lineWeight ?? style.strokeWidth;
    return TextBlock(
      id: id ?? this.id,
      start: start ?? startPoint,
      end: end ?? endPoint,
      text: text ?? this.text,
      lineStyle: style,
      drawTextFrame: drawTextFrame ?? this.drawTextFrame,
    );
  }

  @override
  draw(Canvas canvas) {
    textPosition = start + Offset(50, 50);

    final shadedColor = paint.color.generateBackgroundColor();
    final color = drawTextFrame ? shadedColor : paint.color;
    if (drawTextFrame) canvas.drawRect(Rect.fromPoints(start, end), paint);

    for (final poi in points.values) {
      poi.draw(canvas, paint, 0, lineWeight);
    }

    final style = ParagraphStyle(textAlign: TextAlign.start);
    final pBuilder = ParagraphBuilder(style);
    final textStyle = TextStyle(
      color: color,
      height: 1.5,
      leadingDistribution: TextLeadingDistribution.even,
      fontSize: lineWeight * 2 + 30,
    );
    pBuilder.pushStyle(textStyle);
    pBuilder.addText(text);
    final paragraph = pBuilder.build();
    paragraph.layout(ParagraphConstraints(width: end.dx - start.dx));
    canvas.drawParagraph(paragraph, textPosition);
  }

  @override
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
        if (p.name == startPoint.name) {
          return (Offset val) {
            final dist = end - start;
            points["start"] = p.copyWith(position: val, isHighlighted: true);
            points["end"] =
                endPoint.copyWith(position: val + dist, isHighlighted: false);
          };
        }
        return (Offset val) {
          return points[p.name] =
              p.copyWith(position: val, isHighlighted: true);
        };
      }
    }
    return null;
  }
}
