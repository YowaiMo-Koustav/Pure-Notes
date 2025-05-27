import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:developer';
import 'note_editor_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // Consider renaming MyApp to OwlTakesApp if it's not being used elsewhere.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Owl Takes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NoteEditorScreen(),
    );
  }
}

class HandwritingCanvas extends StatefulWidget {
  // Changed the name to DrawingCanvas
  const HandwritingCanvas({super.key});

  @override
  State<HandwritingCanvas> createState() => _HandwritingCanvasState();
}

class _HandwritingCanvasState extends State<HandwritingCanvas> {
  List<List<Offset>> strokes = [];
  List<Offset> currentStroke = [];

  void _handleTouch(PointerEvent event) {
    setState(() {
      // Ensure we only process stylus input for drawing
      if (event.kind == PointerDeviceKind.stylus) {
        currentStroke.add(Offset(event.position.dx, event.position.dy));
      }
    });
  }

  void _handleTouchEnd(PointerEvent event) {
    setState(() {
      if (event.kind == PointerDeviceKind.stylus && currentStroke.isNotEmpty) {
        strokes.add(List.from(currentStroke)); // Add a copy of the current stroke
        currentStroke.clear(); // Start a new stroke
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerMove: (event) {
        log("Pointer Move");
        _handleTouch(event);
      },
      onPointerUp: (event) {
        log("Pointer Up");
        _handleTouchEnd(event);
      },
      onPointerCancel: (event) {
        log("Pointer Cancel");
        _handleTouchEnd(event);
      },
      child: CustomPaint(
        painter: HandwritingPainter(strokes: strokes, currentStroke: currentStroke),
        size: Size.infinite,
      ),
    );
  }
}

// Removed the TouchData class as it's no longer needed for the drawing logic.

class HandwritingPainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final List<Offset> currentStroke;

  HandwritingPainter({required this.strokes, required this.currentStroke});

  @override
  void paint(Canvas canvas, Size size) {
    log("Repainting"); // Added log for debugging
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.0;

    // Draw each stroke
    for (final stroke in strokes) {
      for (int i = 0; i < stroke.length - 1; i++) {
        canvas.drawLine(stroke[i], stroke[i + 1], paint);
      }
    }

    // Draw the current stroke
    for (int i = 0; i < currentStroke.length - 1; i++) {
      canvas.drawLine(currentStroke[i], currentStroke[i + 1], paint);
        }
  }

  @override
  bool shouldRepaint(HandwritingPainter oldDelegate) {
    // Repaint if the strokes or the current stroke have changed
    return oldDelegate.strokes != strokes || oldDelegate.currentStroke != currentStroke;
  }
}
