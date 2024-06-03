import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:notes_on_image/domain/entities/designation.dart';

class TextStyleDialog extends StatefulWidget {
  const TextStyleDialog({super.key, required this.item});
  final Designation item;
  @override
  State<TextStyleDialog> createState() => _TextStyleDialogState();
}

class _TextStyleDialogState extends State<TextStyleDialog> {
  List<DropdownMenuItem<int>> availableSizes = List.generate(
      10,
      (index) => DropdownMenuItem(
            value: (index + 1) * 2,
            child: Text(((index + 1) * 2).toString()),
          ));

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(),
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Wrap(
              spacing: 5.0,
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                TextField(
                  controller: TextEditingController(text: widget.item.text),
                  onChanged: _textChanged,
                  decoration: InputDecoration(
                      labelText: "Description:",
                      suffixIcon: IconButton(
                          onPressed: _confirm, icon: const Icon(Icons.check))),
                ),
                Text(
                  "Line weight:",
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton(
                    items: availableSizes,
                    value: widget.item.lineWeight,
                    onChanged: _lineWeightChanged,
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: MaterialPicker(
                    pickerColor: widget.item.lineColor,
                    onColorChanged: _colorChanged,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _textChanged(String val) {
    widget.item.text = val;
  }

  void _lineWeightChanged(num? value) {
    widget.item.lineWeight = value?.toDouble() ?? 7;
    setState(() {});
  }

  void _colorChanged(Color value) {
    widget.item.lineColor = value;
  }

  void _confirm() {
    Navigator.of(context, rootNavigator: true).pop<Designation>(widget.item);
  }
}
