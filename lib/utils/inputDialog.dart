import 'package:material_ui/material_ui.dart';

class InputDialog extends StatelessWidget {
  const InputDialog({super.key, required this.title, this.initialValue});
  final String title;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: initialValue ?? '');
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
            icon: const Icon(Icons.check))
      ],
    );
  }
}
