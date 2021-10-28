import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_on_image/domain/states/designation_on_image_state.dart';

class TextStyleDialog extends StatefulWidget {
  TextStyleDialog({Key? key}) : super(key: key);

  @override
  State<TextStyleDialog> createState() => _TextStyleDialogState();
}

class _TextStyleDialogState extends State<TextStyleDialog> {
  TextEditingController txtController = TextEditingController();

  final _state = Get.find<DesignationOnImageState>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(),
      backgroundColor: Colors.transparent,
      child: Card(
        elevation: 5,
        child: Wrap(
          children: [
            Text(
              "Discription",
              style: Theme.of(context).textTheme.headline5,
            ),
            TextField(
              controller: txtController,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () {
                        _state.setText(txtController.text);
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      icon: const Icon(Icons.check))),
            ),
          ],
        ),
      ),
    );
    ;
  }
}
