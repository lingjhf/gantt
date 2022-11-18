import 'package:flutter/material.dart';

import 'controllers/connect_controller.dart';
import 'gantt_connect_line.dart';

class GanttConnectLineContainer extends StatefulWidget {
  const GanttConnectLineContainer({
    super.key,
    required this.controller,
  });

  final GanttConnectContainerController controller;

  @override
  State<StatefulWidget> createState() => _GanttConnectLineContainerState();
}

class _GanttConnectLineContainerState extends State<GanttConnectLineContainer> {
  @override
  void initState() {
    widget.controller.on('addConnectLine', (p0) => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: widget.controller.key,
      children: [
        for (final item in widget.controller.connectLines)
          GanttConnectLine(controller: item),
      ],
    );
  }
}
