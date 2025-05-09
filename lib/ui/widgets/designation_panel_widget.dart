import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_on_image/domain/entities/dimension.dart';
import 'package:notes_on_image/domain/entities/note.dart';
import 'package:notes_on_image/domain/entities/text_block.dart';
import 'package:notes_on_image/domain/states/designation_on_image_state.dart';
import 'package:notes_on_image/ui/screens/corp_image_screen.dart';
import 'package:notes_on_image/ui/widgets/floating_panel_widget.dart';
import 'package:notes_on_image/utils/converter.dart';
import 'package:notes_on_image/utils/inputDialog.dart';
import 'package:path/path.dart' as p;

class DesignationsPanelWidget extends StatelessWidget {
  const DesignationsPanelWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DesignationOnImageState>(builder: (state) {
      return FloatingPanelWidget(
        initPosition: Offset(
          MediaQuery.of(context).size.width * 0.5,
          MediaQuery.of(context).size.height * 0.9,
        ),
        children: [
          IconButton(
              tooltip: "Open",
              onPressed: () async {
                final path = await Get.dialog<String>(
                    InputDialog(title: "Open file path"));
                if (path == null) return;
                state.openPath(path);
              },
              icon: const Icon(Icons.folder_open)),
          IconButton(
              tooltip: "Save",
              onPressed: () async {
                final name = await Get.dialog<String>(InputDialog(
                    title:
                        "File name with extension (Will be saved in ${state.workDir})"));
                if (name == null) return;
                final path = p.join(state.workDir, name);
                state.saveZip(outputFilePath: path);
              },
              icon: const Icon(Icons.save)),
          IconButton(
              tooltip: "Export",
              onPressed: () async {
                final name = await Get.dialog<String>(InputDialog(
                    title:
                        "File name with extension (Will be saved in ${state.workDir})"));
                if (name == null) return;
                final path = p.join(state.workDir, name);
                state.saveImage(outputFilePath: path);
              },
              icon: const Icon(Icons.save_alt)),
          IconButton(
              tooltip: "Undo",
              onPressed: () {
                state.undo();
              },
              icon: const Icon(Icons.undo)),
          IconButton(
              tooltip: "Crop image",
              onPressed: () async {
                final img = state.image;
                if (img == null) return;
                final bytes = await imageToUint8List(img);
                final result = await Get.to<Uint8List>(() => CorpImageScreen(
                    image: Image.memory(bytes), title: "Crop image"));
                if (result != null) {
                  state.setImage(result);
                }
              },
              icon: const Icon(Icons.crop_rotate)),
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
          IconButton(
              tooltip: "Text Block",
              onPressed: () {
                state.initAddDesignation(TextBlock.empty());
              },
              icon: const Icon(Icons.text_fields)),
        ],
      );
    });
  }
}
