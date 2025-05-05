import 'package:flutter/material.dart';

class FloatingPanelWidget extends StatefulWidget {
  const FloatingPanelWidget({
    super.key,
    required this.children,
    this.initPosition,
    this.moveToPosition,
  });
  final List<Widget> children;
  final Offset? initPosition;
  final Function(Offset)? moveToPosition;

  @override
  State<FloatingPanelWidget> createState() => _FloatingPanelWidgetState();
}

class _FloatingPanelWidgetState extends State<FloatingPanelWidget> {
  double x = 0;
  double y = 0;
  final _keyChild = GlobalKey();
  Size childSize = Size.zero;

  @override
  void initState() {
    final pos = widget.initPosition;
    if (pos != null) {
      x = pos.dx;
      y = pos.dy;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      childSize = _keyChild.currentContext?.size ?? Size.zero;
      if (childSize != Size.zero) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final child = Card(
      color: Colors.white54,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              width: 5,
              height: 25,
              color: Colors.grey,
            ),
          ),
          ...widget.children
        ],
      ),
    );

    return Positioned(
      top: y,
      left: x - childSize.width / 2,
      child: Draggable(
        key: _keyChild,
        onDragEnd: repositionWidget,
        feedback: child,
        child: child,
      ),
    );
  }

  void repositionWidget(details) {
    final pos = details.offset;
    x = pos.dx + childSize.width / 2;
    y = pos.dy;
    setState(() {});
  }
}
