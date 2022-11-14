import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'controllers/milestone_controller.dart';

class GanttMilestone extends StatefulWidget {
  const GanttMilestone({
    super.key,
    required this.controller,
    this.title = '',
  });

  final String title;
  final GanttMilestoneController controller;

  @override
  State<StatefulWidget> createState() => _GanttMilestoneState();
}

class _GanttMilestoneState extends State<GanttMilestone> {
  @override
  void initState() {
    super.initState();
  }

  void onDragStart(DragStartDetails details) {
    widget.controller.dragStart(details.globalPosition.dx);
  }

  void onDragUpdate(DragUpdateDetails details) {
    setState(() => widget.controller.dragUpdate(details.globalPosition.dx));
  }

  void onDragEnd(DragEndDetails details) {
    setState(() => widget.controller.dragEnd());
  }

  Widget buildBorder({double size = 0, double radius = 0, Widget? child}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue.shade100, width: 2),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    var containerWidth =
        math.sqrt(math.pow(widget.controller.width, 2) / 2) * 2;
    var halfWidth = widget.controller.width / 2;
    return Stack(
      children: [
        Positioned(
          left: widget.controller.left,
          child: GestureDetector(
            onHorizontalDragStart: onDragStart,
            onHorizontalDragUpdate: onDragUpdate,
            onHorizontalDragEnd: onDragEnd,
            child: SizedBox(
              width: containerWidth,
              height: containerWidth,
              child: Center(
                child: Transform.rotate(
                  angle: math.pi / 4,
                  child: buildBorder(
                    size: widget.controller.width,
                    radius: 4,
                    child: Center(
                      child: buildBorder(
                        size: halfWidth,
                        radius: halfWidth,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
