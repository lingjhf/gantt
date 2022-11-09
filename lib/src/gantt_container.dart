import 'package:flutter/material.dart';
import 'package:gantt/src/controllers/task_controller.dart';
import 'package:gantt/src/controllers/timeline_conroller.dart';
import 'package:gantt/src/gantt_task.dart';
import 'package:gantt/src/models/milestone.dart';
import 'package:gantt/src/models/subject.dart';
import 'package:gantt/src/models/task.dart';

import 'enums.dart';
import 'gantt_background.dart';
import 'gantt_list.dart';
import 'gantt_timeline.dart';

class GanttContainer extends StatefulWidget {
  const GanttContainer({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.unit,
    required this.viewWidth,
    required this.scrollController,
    this.data = const [],
  });

  final DateTime startDate;
  final DateTime endDate;
  final GanttDateUnit unit;
  final double viewWidth;
  final ScrollController scrollController;
  final List<GanttSubjectData> data;

  @override
  State<StatefulWidget> createState() => _GanttContainerState();
}

class _GanttContainerState extends State<GanttContainer> {
  late GanttTimelineController ganttTimelineController;

  @override
  void initState() {
    ganttTimelineController = GanttTimelineController(
      scrollController: widget.scrollController,
      startDate: widget.startDate,
      endDate: widget.endDate,
      unit: widget.unit,
      viewWidth: widget.viewWidth,
    );

    ganttTimelineController.on('onChange', () {
      setState(() {});
    });

    super.initState();
  }

  List<Widget> buildSubject(List<GanttSubjectData> data) {
    final List<Widget> children = [];
    for (var item in data) {
      if (item is GanttTaskData) {
        children.add(
          GanttTask(
            title: item.title,
            controller: GanttTaskController(
              timelineController: ganttTimelineController,
              scrollController: widget.scrollController,
              startDate: item.startDate,
              endDate: item.endDate,
              progress: item.progress,
            ),
          ),
        );
      } else if (item is GanttMilestoneData) {}
    }
    return children;
  }

  //构造时间轴
  Widget buildTimeline() {
    return Material(
      elevation: 2,
      child: Container(
        color: Colors.white,
        height: 36,
        child: DefaultTextStyle(
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          child: GanttTimeline(controller: ganttTimelineController),
        ),
      ),
    );
  }

  //构建甘特图体
  Widget buildBody() {
    return Expanded(
      child: Stack(
        children: [
          GanttBackground(controller: ganttTimelineController),
          GanttList(children: buildSubject(widget.data)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ganttTimelineController.totalWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTimeline(),
          buildBody(),
        ],
      ),
    );
  }
}
