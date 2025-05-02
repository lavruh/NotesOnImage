import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_on_image/domain/entities/dimension.dart';
import 'package:notes_on_image/domain/entities/note.dart';
import 'package:notes_on_image/domain/states/designation_on_image_state.dart';

class DesignationsPanelWidget extends StatelessWidget {
  const DesignationsPanelWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DesignationOnImageState>(builder: (state) {
      return Card(
        color: Colors.white24,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                tooltip: "Undo",
                onPressed: () {
                  state.undo();
                },
                icon: const Icon(Icons.undo)),
            IconButton(
                tooltip: "Note",
                onPressed: () {
                  state.initAddDesignation(Note.empty());
                },
                icon: const Icon(Icons.arrow_right_alt)),
            IconButton(
                tooltip: "Dimension",
                onPressed: () {
                  state.initAddDesignation(Dimension.empty());
                },
                icon: const Icon(Icons.open_in_full)),
          ],
        ),
      );
    });
  }
}
