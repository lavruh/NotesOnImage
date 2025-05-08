import 'dart:io';

// import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_on_image/domain/states/designation_on_image_state.dart';
import 'package:notes_on_image/ui/screens/draw_on_image_screen.dart';

void main() {
  // debugPrintGestureArenaDiagnostics = true;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put<DesignationOnImageState>(DesignationOnImageState());

    return GetMaterialApp(
        title: 'Notes on image',
        theme: ThemeData(primarySwatch: Colors.grey),
        home: const Screen1());
  }
}

class Screen1 extends StatelessWidget {
  const Screen1({super.key});

  @override
  Widget build(BuildContext context) {
    String initText = "/home/lavruh/tmp/dataonimage/PS Main Engine.jpg";
    if (Platform.isAndroid) {
      initText = "/storage/emulated/0/test.jpg";
    }
    final textController = TextEditingController(text: initText);
    return Scaffold(
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: TextField(
          controller: textController,
          decoration: InputDecoration(
            labelText: "File path",
            suffix: IconButton(
                onPressed: () => openFile(context, textController.text),
                icon: const Icon(Icons.screen_lock_landscape)),
          ),
        ),
      )),
      extendBodyBehindAppBar: true,
    );
  }

  openFile(BuildContext context, String path) {
    final file = File(path);
    if (!file.existsSync()) return;

    final state = Get.find<DesignationOnImageState>();
    state.open(file);
    Navigator.push(context, PageRouteBuilder(pageBuilder: (context, _, __) {
      return const NotesOnImageScreen();
    }));
  }
}
