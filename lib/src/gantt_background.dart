import 'package:flutter/material.dart';

import 'controllers/timeline_controller.dart';

class GanttBackground extends StatefulWidget {
  const GanttBackground({super.key, required this.controller});
  final GanttTimelineController controller;
  @override
  State<StatefulWidget> createState() => _GanttBackgroundState();
}

class _GanttBackgroundState extends State<GanttBackground> {
  @override
  void initState() {
    widget.controller.on('onChange', (arg) => setState(() {}));
    super.initState();
  }

  Widget buildHighlight(double left, double width) {
    return Positioned(
      left: left,
      top: 0,
      bottom: 0,
      child: Container(
        width: width,
        color: const Color.fromARGB(21, 158, 158, 158),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];
    double width = 0;
    var dayWidth = widget.controller.unit.dayWidth;

    for (int i = widget.controller.startIndex;
        i <= widget.controller.endIndex;
        i++) {
      var item = widget.controller.dates[i];

      if (item.weekday == DateTime.saturday) {
        width += dayWidth;
        if (i == widget.controller.endIndex) {
          children.add(buildHighlight(i * dayWidth, width));
        }
      } else if (item.weekday == DateTime.sunday) {
        width += dayWidth;
        children.add(
          buildHighlight(
            width > dayWidth ? (i - 1) * dayWidth : i * dayWidth,
            width,
          ),
        );
        width = 0;
      }
    }
    return Stack(
      children: children,
    );
  }
}
