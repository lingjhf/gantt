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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: widget.controller.left,
          child: Transform.rotate(
            angle: math.pi / 4,
            child: Container(
              width: 20,
              height: 20,
              color: Colors.green,
            ),
          ),
        ),
      ],
    );
  }
}
