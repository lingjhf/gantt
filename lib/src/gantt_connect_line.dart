import 'package:flutter/material.dart';

class GanttConnectLine extends StatelessWidget {
  const GanttConnectLine({
    super.key,
    required this.startOffset,
    required this.endOffset,
  });

  final Offset startOffset;

  final Offset endOffset;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: CustomPaint(
        painter: GanttConnectLinePainter(
          startOffset: startOffset,
          endOffset: endOffset,
        ),
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
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
