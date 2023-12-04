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
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = Get.put<DesignationOnImageState>(DesignationOnImageState());
    if (Platform.isLinux) {
      state.loadImage(File("/home/lavruh/20230802_012556.jpg"));
    } else if (Platform.isAndroid) {
      state.loadImage(File("/storage/emulated/0/DCIM/test.jpg"));
    }
    return GetMaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Screen1());
  }
}

class Screen1 extends StatelessWidget {
  const Screen1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('data'),
      ),
      body: Center(
        child: IconButton(
            onPressed: () {
              Navigator.push(context,
                  PageRouteBuilder(pageBuilder: (context, _, __) {
                return const Screen2();
              }));
            },
            icon: const Icon(Icons.screen_lock_landscape)),
      ),
      extendBodyBehindAppBar: true,
    );
  }
}

class Screen2 extends StatelessWidget {
  const Screen2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const NotesOnImageScreen(),
    );
  }
}
