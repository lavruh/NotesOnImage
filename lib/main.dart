import 'dart:io';

import 'package:material_ui/material_ui.dart';
import 'package:notes_on_image/domain/states/designation_on_image_state.dart';
import 'package:notes_on_image/ui/screens/draw_on_image_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final DesignationOnImageState _state = DesignationOnImageState();

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DesignationOnImageScope(
      notifier: _state,
      child: MaterialApp(
        title: 'Notes on image',
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey)),
        localizationsDelegates: const [
          DefaultMaterialLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
        ],
        home: const Screen1(),
      ),
    );
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

  void openFile(BuildContext context, String path) {
    final file = File(path);
    if (!file.existsSync()) return;

    final state = DesignationOnImageScope.of(context, listen: false);
    state.open(file);
    Navigator.push(context, PageRouteBuilder(pageBuilder: (context, _, __) {
      return const NotesOnImageScreen();
    }));
  }
}
