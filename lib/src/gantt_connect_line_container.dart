

import 'package:flutter/material.dart';

import 'controllers/connect_controller.dart';

class GanttConnectLineContainer extends StatefulWidget {
  const GanttConnectLineContainer({
    super.key,
    required this.controller,
  });

  final GanttConnectLineController controller;

  @override
  State<StatefulWidget> createState() => _GanttConnectLineContainerState();
}

class _GanttConnectLineContainerState extends State<GanttConnectLineContainer> {
  @override
  Widget build(BuildContext context) {
    return Stack();
  }
}
