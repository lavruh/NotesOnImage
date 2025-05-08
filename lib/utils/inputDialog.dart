import 'package:flutter/material.dart';

class InputDialog extends StatelessWidget {
  const InputDialog({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title),
          TextField(controller: controller),
        ],
      ),
      actions: [
        IconButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            icon: Icon(Icons.check))
      ],
    );
  }
}
