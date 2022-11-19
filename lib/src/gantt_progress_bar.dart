import 'package:flutter/material.dart';

class GanttProgressBar extends StatelessWidget {
  const GanttProgressBar({
    super.key,
    this.width = 0,
    this.progressWidth = 0,
    Color? backgroundColor,
    this.progressColor,
    this.progressGradient = const LinearGradient(
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
      colors: [Color(0xff6505B4), Color(0xffCD1D9C)],
    ),
  }) : backgroundColor = backgroundColor ?? const Color(0xff282c34);

  final double width;
  final double progressWidth;
  final Color backgroundColor;
  final Color? progressColor;
  final Gradient? progressGradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: progressWidth,
            decoration: BoxDecoration(
              color: progressColor,
              gradient: progressColor == null ? progressGradient : null,
            ),
          )
        ],
      ),
    );
  }
}
