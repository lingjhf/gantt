import 'package:flutter/material.dart';

class GanttProgressBar extends StatelessWidget {
  const GanttProgressBar({
    super.key,
    this.width = 0,
    this.progressWidth = 0,
    this.backgroundColor = const Color(0xFFBBDEFB),
    this.progressColor = Colors.blue,
  });

  final double width;
  final double progressWidth;
  final Color backgroundColor;
  final Color progressColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(color: backgroundColor),
      child: Row(
        children: [Container(width: progressWidth, color: progressColor)],
      ),
    );
  }
}
