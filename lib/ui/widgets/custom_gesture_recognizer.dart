import 'package:flutter/gestures.dart';

class CustomPanGestureRecognizer extends OneSequenceGestureRecognizer {
  final bool Function(Offset) onPanDown;
  final Function(DragUpdateDetails)? onPanUpdate;
  final Function(PointerEvent)? onPanEnd;

  CustomPanGestureRecognizer({
    required this.onPanDown,
    required this.onPanUpdate,
    this.onPanEnd,
  });

  @override
  void addPointer(PointerEvent event) {
    if (onPanDown(event.localPosition)) {
      startTrackingPointer(event.pointer, event.transform);
      resolve(GestureDisposition.accepted);
    } else {
      stopTrackingPointer(event.pointer);
    }
  }

  @override
  void handleEvent(PointerEvent event) {
    if (event is PointerMoveEvent) {
      if (onPanUpdate != null) {
        onPanUpdate!(DragUpdateDetails(
            globalPosition: event.position,
            delta: event.delta,
            localPosition: event.localPosition));
      }
    }
    if (event is PointerUpEvent) {
      if (onPanEnd != null) {
        onPanEnd!(event);
      }
      stopTrackingPointer(event.pointer);
    }
  }

  @override
  String get debugDescription => 'customPan';

  @override
  void didStopTrackingLastPointer(int pointer) {}
}
