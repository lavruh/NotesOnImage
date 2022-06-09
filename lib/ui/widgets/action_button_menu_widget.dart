import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_on_image/domain/entities/dimension.dart';
import 'package:notes_on_image/domain/entities/note.dart';
import 'package:notes_on_image/domain/states/designation_on_image_state.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';

class ActionButtonMenuWidget extends StatelessWidget {
  const ActionButtonMenuWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = Get.find<DesignationOnImageState>();
    return SpeedDial(
      speedDialChildren: [
        SpeedDialChild(
          child: const Icon(Icons.undo),
          label: "Undo",
          onPressed: () => state.undo(),
        ),
        SpeedDialChild(
          child: const Icon(Icons.text_rotation_angledown_rounded),
          label: "Note",
          onPressed: () => state.initAddDesignation(Note.empty()),
        ),
        SpeedDialChild(
          child: const Icon(Icons.open_in_full),
          label: "Dimension",
          onPressed: () => state.initAddDesignation(Dimension.empty()),
        ),
      ],
      child: const Icon(Icons.menu),
    );
  }
}
