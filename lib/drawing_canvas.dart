import 'package:flutter/material.dart';

class DrawingCanvas extends StatefulWidget {
  final void Function(List<Offset>) onStrokeUpdate;

  const DrawingCanvas({super.key, required this.onStrokeUpdate});

  @override
  State<DrawingCanvas> createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  final List<Offset> _points = [];

  bool _isStylusInput(PointerEvent event) {
    // Basic palm rejection logic: large touch area = palm
    if (event is PointerDownEvent || event is PointerMoveEvent) {
      final area = event.radiusMajor * event.radiusMinor;
      return area < 1000;
    }
    return false;
  }

void _handlePointer(PointerEvent event) {
  if (!_isStylusInput(event)) {
    print("Rejected touch (likely palm): ${event.kind}");
    return;
  }

  print("Accepted touch at: ${event.localPosition}");

  setState(() {
    if (event is PointerMoveEvent || event is PointerDownEvent) {
      _points.add(event.localPosition);
      widget.onStrokeUpdate(List.from(_points));
    } else if (event is PointerUpEvent) {
      _points.add(Offset.zero); // break line
    }
  });
}

  @override
  Widget build(BuildContext context) {
    return Listener(
 onPointerDown: _handlePointer,
 onPointerMove: _handlePointer,
 onPointerUp: _handlePointer,
 child: Container(
 color: Colors.white,
 child: CustomPaint(
 painter: _DrawingPainter(_points),
 size: Size.infinite,
 ),
      ),
    );
  }
}

class _DrawingPainter extends CustomPainter {
  final List<Offset> points;

  _DrawingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] == Offset.zero || points[i + 1] == Offset.zero) continue;
      canvas.drawLine(points[i], points[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(_DrawingPainter oldDelegate) => true;
}
