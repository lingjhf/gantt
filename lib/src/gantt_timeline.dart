import 'package:flutter/material.dart';
import 'package:gantt/src/controllers/timeline_conroller.dart';
import 'utils/datetime.dart';
import 'enums.dart';
import 'gantt_timeline_highlight.dart';

class GanttTimeline extends StatefulWidget {
  const GanttTimeline({super.key, required this.controller});

  final GanttTimelineController controller;

  @override
  State<StatefulWidget> createState() => _GanttTimelineState();
}

class _GanttTimelineState extends State<GanttTimeline> {
  @override
  void initState() {
    widget.controller.on("onChange", () {
      setState(() {});
    });
    super.initState();
  }

  Widget buildDay() {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              for (var item in widget.controller.headerItems)
                Positioned(
                  left: item.left,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: item.width,
                    alignment: Alignment.centerLeft,
                    child: Text(
                        '${item.date.monthAbbreviation()} ${item.date.year}'),
                  ),
                )
            ],
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              for (var item in widget.controller.mainItems)
                Positioned(
                  left: item.left,
                  top: 0,
                  bottom: 0,
                  child: SizedBox(
                    width: item.width,
                    child: Stack(children: [
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              item.date.weekdayAbbreviation().substring(0, 1),
                            ),
                            const SizedBox(width: 4),
                            Text('${item.date.day}'),
                          ],
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          height: 8,
                          width: 0.5,
                          color: Colors.grey,
                        ),
                      )
                    ]),
                  ),
                ),
              GanttTimelineHighlight(controller: widget.controller)
            ],
          ),
        ),
      ],
    );
  }

  Widget buildWeek() {
    return Column();
  }

  Widget buildMonth() {
    return Column();
  }

  Widget buildQuater() {
    return Column();
  }

  Widget buildHalfYear() {
    return Column();
  }

  Widget buildYear() {
    return Column();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.controller.unit) {
      case GanttDateUnit.day:
        return buildDay();
      case GanttDateUnit.week:
        return buildWeek();
      case GanttDateUnit.month:
        return buildMonth();
      case GanttDateUnit.quarter:
        return buildQuater();
      case GanttDateUnit.halfYear:
        return buildHalfYear();
      case GanttDateUnit.year:
        return buildYear();
    }
  }
}
