import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:notes_on_image/domain/entities/designation.dart';
import 'package:notes_on_image/domain/entities/text_block.dart';
import 'package:notes_on_image/domain/states/designation_on_image_state.dart';
import 'package:notes_on_image/ui/widgets/confirm_dialog.dart';

class TextStyleDialog extends StatefulWidget {
  const TextStyleDialog({super.key, required this.item});
  final Designation item;
  @override
  State<TextStyleDialog> createState() => _TextStyleDialogState();
}

class _TextStyleDialogState extends State<TextStyleDialog> {
  late Designation item;
  final nameController = TextEditingController();

  @override
  initState() {
    super.initState();
    item = widget.item;
    nameController.text = item.text;
  }

  List<DropdownMenuItem<int>> availableSizes = List.generate(
      10,
      (index) => DropdownMenuItem(
            value: (index + 1) * 2,
            child: Text(((index + 1) * 2).toString()),
          ));

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isSmallScreen = w < 600;
    return Dialog(
      shape: const RoundedRectangleBorder(),
      backgroundColor: Colors.transparent,
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxHeight: 600, maxWidth: isSmallScreen ? w * 0.9 : 550),
        child: Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ListTile(title: Text("Text:")),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isSmallScreen ? w * 0.5 : 400,
                  ),
                  child: TextFormField(
                    controller: nameController,
                    maxLines: item is TextBlock ? 3 : 1,
                  ),
                ),
                ListTile(
                  title: Text(
                    "Line weight:",
                  ),
                  trailing: DropdownButton(
                    items: availableSizes,
                    value: item.lineWeight,
                    onChanged: _lineWeightChanged,
                  ),
                ),
                SwitchListTile(
                    title: Text("Text frame:"),
                    value: item.drawTextFrame,
                    onChanged: _setTextFrame),
                ListTile(title: Text("Color")),
                Flexible(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 300, maxWidth: 200),
                    child: MaterialPicker(
                      portraitOnly: true,
                      pickerColor: item.lineColor,
                      onColorChanged: _colorChanged,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _delete,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.orange.shade200, // sets the background color
                      ),
                      child: const Text("DELETE"),
                    ),
                    IconButton(
                        onPressed: _confirm, icon: const Icon(Icons.check)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _lineWeightChanged(num? value) => setState(() {
        final d = value?.toDouble() ?? 7;
        item = item.copyWith(lineWeight: d);
      });

  void _colorChanged(Color value) => setState(() {
        item = item.copyWith(color: value);
      });

  void _setTextFrame(bool? val) => setState(() {
        item = item.copyWith(drawTextFrame: val);
      });

  void _confirm() {
    final result = item.copyWith(text: nameController.text);
    Navigator.of(context, rootNavigator: true).pop<Designation>(result);
  }

  void _delete() async {
    final confirmation =
        await Get.dialog<bool>(ConfirmDialog(title: "Delete item?"));
    if (confirmation != null && confirmation) {
      Get.find<DesignationOnImageState>().deleteDesignation(id: item.id);
      Get.back();
    }
  }
}
