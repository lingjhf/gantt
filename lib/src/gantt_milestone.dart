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
    // TODO: implement build
    throw UnimplementedError();
  }
}
