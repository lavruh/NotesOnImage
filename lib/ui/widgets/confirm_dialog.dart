import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(title),
      actions: [
        ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes')),
        ElevatedButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No')),
      ],
    );
  }
}
