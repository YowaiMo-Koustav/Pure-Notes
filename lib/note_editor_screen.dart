import 'package:flutter/material.dart';
import 'drawing_canvas.dart';

class NoteEditorScreen extends StatelessWidget {
  const NoteEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  backgroundColor: Colors.black,
  appBar: AppBar(title: const Text("New Note")),
  body: SafeArea(
    child: DrawingCanvas(
      onStrokeUpdate: (points) {
        print("Touch points: ${points.length}");
      },
    ),
  ),
    );
  }
}