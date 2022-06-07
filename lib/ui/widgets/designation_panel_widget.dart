import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_on_image/domain/states/designation_on_image_state.dart';
import 'package:notes_on_image/ui/widgets/text_style_dialog.dart';

class DesignationsPanelWidget extends StatelessWidget {
  final _state = Get.find<DesignationOnImageState>();

  DesignationsPanelWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: MediaQuery.of(context).size.width,
      child: Card(
        color: Colors.grey,
        child: Wrap(
          alignment: WrapAlignment.spaceAround,
          runAlignment: WrapAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                  _state.saveImage();
                },
                icon: const Icon(Icons.save)),
            IconButton(
                onPressed: () {
                  _state.undo();
                },
                icon: const Icon(Icons.undo)),
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) => const TextStyleDialog());
                  _state.mode = DesignationMode.note;
                },
                icon: const Icon(Icons.arrow_right_alt)),
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) => const TextStyleDialog());
                  _state.mode = DesignationMode.dimension;
                },
                icon: const Icon(Icons.open_in_full)),
          ],
        ),
      ),
    );
  }
}
