import 'package:material_ui/material_ui.dart';
import 'package:notes_on_image/domain/entities/dimension.dart';
import 'package:notes_on_image/domain/entities/note.dart';
import 'package:notes_on_image/domain/states/designation_on_image_state.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';

class ActionButtonMenuWidget extends StatelessWidget {
  const ActionButtonMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final state = DesignationOnImageScope.of(context, listen: false);
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
          onPressed: () => state.initAddDesignation(context, Note.empty()),
        ),
        SpeedDialChild(
          child: const Icon(Icons.open_in_full),
          label: "Dimension",
          onPressed: () => state.initAddDesignation(context, Dimension.empty()),
        ),
      ],
      child: const Icon(Icons.menu),
    );
  }
}
