import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_on_image/domain/states/designation_on_image_state.dart';
import 'package:notes_on_image/ui/screens/draw_on_image_screen.dart';

void main() {
  debugPrintGestureArenaDiagnostics = true;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = Get.put<DesignationOnImageState>(DesignationOnImageState());
    if (Platform.isLinux) {
      state.loadImage(File("/home/lavruh/Screenshot_20200409_212221.jpg"));
    } else if (Platform.isAndroid) {
      state.loadImage(File("/storage/emulated/0/DCIM/test.jpg"));
    }
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NotesOnImageScreen(),
    );
  }
}
