import 'package:flutter/material.dart';
import 'package:gantt/src/controllers/timeline_conroller.dart';
import 'package:gantt/src/models/timeline.dart';
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
    widget.controller.on("onChange", (arg) {
      setState(() {});
    });
    super.initState();
  }

  Widget buildHeaderItems(Widget Function(GanttTimelineItemModel) builder) {
    return Stack(
      children: [
        for (var item in widget.controller.headerItems)
          Positioned(
            left: item.left,
            top: 0,
            bottom: 0,
            child: Container(
              width: item.width,
              alignment: Alignment.centerLeft,
              child: builder(item),
            ),
          )
      ],
    );
  }

  Widget buildMainItems(Widget Function(GanttTimelineItemModel) builder) {
    return Stack(
      children: [
        for (var item in widget.controller.mainItems)
          Positioned(
            left: item.left,
            top: 0,
            bottom: 0,
            child: SizedBox(
              width: item.width,
              child: Stack(children: [
                builder(item),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: 8,
                    width: 1,
                    color: Colors.grey.shade100,
                  ),
                )
              ]),
            ),
          ),
        GanttTimelineHighlight(controller: widget.controller)
      ],
    );
  }

  Widget buildDay() {
    return Column(
      children: [
        Expanded(
          child: buildHeaderItems(
            (item) =>
                Text('${item.date.monthAbbreviation()} ${item.date.year}'),
          ),
        ),
        Expanded(
          child: buildMainItems(
            (item) => Center(
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
          ),
        ),
      ],
    );
  }

  Widget buildWeek() {
    return Column(
      children: [
        Expanded(
          child: buildHeaderItems(
            (item) =>
                Text('${item.date.monthAbbreviation()} ${item.date.year}'),
          ),
        ),
        Expanded(
          child: buildMainItems(
            (item) => Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  item.date.weekdayAbbreviation().substring(0, 1),
                ),
                const SizedBox(width: 4),
                Text('${item.date.day}'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildMonth() {
    return Column(
      children: [
        Expanded(child: buildHeaderItems((item) => Text('${item.date.year}'))),
        Expanded(
          child: buildMainItems(
            (item) => SingleChildScrollView(
              child: Visibility(
                visible: item.date.day == 1,
                child: Text('${item.date.month}月'),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildQuater() {
    return Column(
      children: [
        Expanded(child: buildHeaderItems((item) => Text('${item.date.year}'))),
        Expanded(
          child: buildMainItems(
            (item) => SingleChildScrollView(
              child: Visibility(
                visible: (item.date.month == DateTime.january ||
                        item.date.month == DateTime.april ||
                        item.date.month == DateTime.july ||
                        item.date.month == DateTime.october) &&
                    item.date.day == 1,
                child: Text('${item.date.month}月'),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildHalfYear() {
    return Column(
      children: [
        Expanded(child: buildHeaderItems((item) => Text('${item.date.year}'))),
        Expanded(
          child: buildMainItems(
            (item) => SingleChildScrollView(
              child: Visibility(
                visible: (item.date.month == DateTime.january ||
                        item.date.month == DateTime.july) &&
                    item.date.day == 1,
                child: Text('${item.date.month}月'),
              ),
            ),
          ),
        ),
      ],
    );
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
