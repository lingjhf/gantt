import 'package:flutter/material.dart';

import 'controllers/connect_line_controller.dart';

class GanttConnectLine extends StatefulWidget {
  const GanttConnectLine({
    super.key,
    required this.controller,
  });

  final GanttConnectLineController controller;
  @override
  State<StatefulWidget> createState() => GanttConnectLineState();
}

class GanttConnectLineState extends State<GanttConnectLine> {
  @override
  void initState() {
    widget.controller.on('update', (p0) => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: GanttConnectLinePainter(
        startOffset: widget.controller.startOffset,
        endOffset: widget.controller.endOffset,
      ),
    );
  }
}

class GanttConnectLinePainter extends CustomPainter {
  const GanttConnectLinePainter({
    required this.startOffset,
    required this.endOffset,
  });

  final Offset startOffset;

  final Offset endOffset;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.blue;
    final path = Path();
    final double centerX = startOffset.dx + (endOffset.dx - startOffset.dx) / 2;
    final double centerY = startOffset.dy + (endOffset.dy - startOffset.dy) / 2;
    path.moveTo(startOffset.dx, startOffset.dy);
    path.quadraticBezierTo(
      centerX,
      startOffset.dy,
      centerX,
      centerY,
    );
    path.quadraticBezierTo(
      centerX,
      endOffset.dy,
      endOffset.dx,
      endOffset.dy,
    );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
