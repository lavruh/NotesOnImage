import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:notes_on_image/domain/states/designation_on_image_state.dart';

// TODO load pre size settings
class TextStyleDialog extends StatefulWidget {
  const TextStyleDialog({Key? key}) : super(key: key);

  @override
  State<TextStyleDialog> createState() => _TextStyleDialogState();
}

class _TextStyleDialogState extends State<TextStyleDialog> {
  TextEditingController txtController = TextEditingController();
  List<DropdownMenuItem<int>> availableSizes = List.generate(
      10,
      (index) => DropdownMenuItem(
            child: Text(((index + 1) * 2).toString()),
            value: (index + 1) * 2,
          ));

  final _state = Get.find<DesignationOnImageState>();

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
                  controller: txtController,
                  decoration: InputDecoration(
                      labelText: "Discription:",
                      suffixIcon: IconButton(
                          onPressed: () {
                            _state.setText(txtController.text);
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                          icon: const Icon(Icons.check))),
                ),
                Text(
                  "Line weight:",
                  style: Theme.of(context).textTheme.headline5,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton(
                    items: availableSizes,
                    value: _state.lineWeight,
                    onChanged: (num? val) {
                      setState(() {
                        final size = val?.toDouble() ?? 7;
                        _state.setLineWeight(size);
                      });
                    },
                  ),
                ),
                Text(
                  "Line Color:",
                  style: Theme.of(context).textTheme.headline5,
                ),
                SizedBox(
                  height: 200,
                  child: MaterialPicker(
                    pickerColor: _state.lineColor,
                    onColorChanged: _state.setLineColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
