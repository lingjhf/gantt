import 'package:flutter/material.dart';

class GanttConnectPoint extends StatefulWidget {
  const GanttConnectPoint({
    super.key,
    required this.size,
    this.onTap,
  });

  final double? size;

  final ValueChanged<bool>? onTap;

  @override
  State<StatefulWidget> createState() => _GanttConnectPointState();
}

class _GanttConnectPointState extends State<GanttConnectPoint> {
  bool active = false;

  void onTap() {
    active = !active;
    widget.onTap?.call(active);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Align(
        alignment: Alignment.centerRight,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 2),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
