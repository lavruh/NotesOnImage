import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_on_image/domain/entities/dimension.dart';
import 'package:notes_on_image/domain/entities/note.dart';
import 'package:notes_on_image/domain/states/designation_on_image_state.dart';

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
                  _state.initAddDesignation(Note.empty());
                },
                icon: const Icon(Icons.arrow_right_alt)),
            IconButton(
                onPressed: () {
                  _state.initAddDesignation(Dimension.empty());
                },
                icon: const Icon(Icons.open_in_full)),
          ],
        ),
      ),
    );
  }
}
