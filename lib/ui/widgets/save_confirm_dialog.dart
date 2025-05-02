import 'package:flutter/material.dart';

class SaveConfirmDialog extends StatelessWidget {
  const SaveConfirmDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: const Text('Do you like to save changes?'),
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
