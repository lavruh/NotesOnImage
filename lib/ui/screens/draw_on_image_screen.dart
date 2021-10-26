import 'dart:math';

import 'package:flutter/material.dart';
import 'package:notes_on_image/domain/entities/designation.dart';

enum DesignationMode { dimension, note }

class NotesOnImageScreen extends StatefulWidget {
  NotesOnImageScreen({Key? key}) : super(key: key);

  @override
  State<NotesOnImageScreen> createState() => _NotesOnImageScreenState();
}

class _NotesOnImageScreenState extends State<NotesOnImageScreen> {
  Offset? p1;
  Offset? p2;
  DesignationMode? mode;
  List<Designation> objects = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTapDown: (TapDownDetails details) {
          if (mode == DesignationMode.dimension) {
            addDimension(details.globalPosition);
          }
          if (mode == DesignationMode.note) {
            addNote(details.globalPosition);
          }
          setState(() {});
        },
        child: CustomPaint(
          painter: MyPainter(objects),
          child: Container(),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 75,
        width: MediaQuery.of(context).size.width,
        child: Card(
          color: Colors.grey,
          child: Wrap(
            alignment: WrapAlignment.spaceAround,
            runAlignment: WrapAlignment.center,
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.save)),
              IconButton(
                  onPressed: () {
                    mode = DesignationMode.note;
                  },
                  icon: const Icon(Icons.arrow_right_alt)),
              IconButton(
                  onPressed: () {
                    mode = DesignationMode.dimension;
                  },
                  icon: const Icon(Icons.open_in_full)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.rtt)),
            ],
          ),
        ),
      ),
    );
  }

  addDimension(Offset val) {
    if (p1 == null) {
      p1 = val;
    } else {
      p2 ??= val;
    }
    if (p1 != null && p2 != null) {
      objects.add(Dimension(
        text: "text",
        start: p1!,
        end: p2!,
      ));
      p1 = null;
      p2 = null;
      mode = null;
    }
  }

  addNote(Offset val) {
    if (p1 == null) {
      p1 = val;
    } else {
      p2 ??= val;
    }
    if (p1 != null && p2 != null) {
      objects.add(Note(
        text: "text",
        pointer: p1!,
        note: p2!,
      ));
      p1 = null;
      p2 = null;
      mode = null;
    }
  }
}

class MyPainter extends CustomPainter {
  MyPainter(this.objects);

  List<Designation> objects = [];

  @override
  void paint(Canvas canvas, Size size) {
    for (Designation o in objects) {
      o.draw(canvas);
    }
  }

  @override
  bool shouldRepaint(MyPainter oldDelegate) {
    return true;
  }
}
