import 'package:flutter/material.dart';
import 'package:gantt/src/controllers/timeline_conroller.dart';
import 'package:gantt/src/models/timeline.dart';

class GanttBackground extends StatefulWidget {
  const GanttBackground({super.key, required this.controller});
  final GanttTimelineController controller;
  @override
  State<StatefulWidget> createState() => _GanttBackgroundState();
}

class _GanttBackgroundState extends State<GanttBackground> {
  List<Widget> buildWeekHighlight(
      List<GanttTimelineItemModel> timelineItems, double dayWidth) {
    var children = <Widget>[];
    double width = 0;

    for (int i = 0; i < timelineItems.length; i++) {
      var item = timelineItems[i];

      if (item.date.weekday == DateTime.saturday) {
        width += dayWidth;
        if (i + 1 == timelineItems.length) {
          children.add(
            Positioned(
              left: item.left,
              top: 0,
              bottom: 0,
              child: Container(
                width: width,
                color: Colors.grey.shade200,
              ),
            ),
          );
        }
      } else if (item.date.weekday == DateTime.sunday) {
        width += dayWidth;
        children.add(
          Positioned(
            left: width > dayWidth ? timelineItems[i - 1].left : item.left,
            top: 0,
            bottom: 0,
            child: Container(
              width: width,
              color: Colors.grey.shade200,
            ),
          ),
        );
        width = 0;
      }
    }

    return children;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: buildWeekHighlight(
        widget.controller.mainItems,
        widget.controller.unit.dayWidth,
      ),
    );
  }
}
