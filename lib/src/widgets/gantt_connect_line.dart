import 'package:flutter/material.dart';

class GanttConnectLine extends StatelessWidget {
  const GanttConnectLine({
    super.key,
    required this.firstOffset,
    required this.secondOffset,
  });

  final Offset firstOffset;

  final Offset secondOffset;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: CustomPaint(
        painter: GanttConnectLinePainter(
          firstOffset: firstOffset,
          secondOffset: secondOffset,
        ),
      ),
    );
  }
}

class GanttConnectLinePainter extends CustomPainter {
  const GanttConnectLinePainter({
    required this.firstOffset,
    required this.secondOffset,
  });

  final Offset firstOffset;

  final Offset secondOffset;

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
