import 'package:flutter/material.dart';
import 'package:gantt/src/controllers/gantt_controller.dart';
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
  late GanttController ganttController;

  late GanttTimelineController ganttTimelineController;

  List<Widget> subjects = [];

  double get timelineHeight => widget.unit == GanttDateUnit.year ? 36 / 2 : 36;

  @override
  void initState() {
    ganttController = GanttController();

    ganttTimelineController = GanttTimelineController(
      scrollController: widget.scrollController,
      startDate: widget.startDate,
      endDate: widget.endDate,
      unit: widget.unit,
      viewWidth: widget.viewWidth,
    );

    ganttTimelineController.on('onChange', (arg) {
      setState(() {});
    });

    initSujects();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant GanttContainer oldWidget) {
    if (ganttTimelineController.viewWidth != widget.viewWidth) {
      ganttTimelineController.viewWidth = widget.viewWidth;
      ganttTimelineController.updateTimeline();
    }
    ganttTimelineController.scrollController = widget.scrollController;
    super.didUpdateWidget(oldWidget);
  }

  void initSujects() {
    final List<Widget> children = [];
    for (var item in widget.data) {
      if (item is GanttTaskData) {
        children.add(
          GanttTask(
            title: item.title,
            controller: GanttTaskController(
              ganttController: ganttController,
              timelineController: ganttTimelineController,
              startDate: item.startDate,
              endDate: item.endDate,
              progress: item.progress,
            ),
          ),
        );
      } else if (item is GanttMilestoneData) {}
    }
    subjects = children;
  }

  void onTapBody() {
    ganttController.setCurrentSubject(null);
  }

  //构造时间轴
  Widget buildTimeline() {
    return Container(
      height: timelineHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: DefaultTextStyle(
        style: const TextStyle(
          fontSize: 12,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        child: GanttTimeline(controller: ganttTimelineController),
      ),
    );
  }

  //构建甘特图体
  Widget buildBody() {
    return Expanded(
      child: Stack(
        children: [
          GanttBackground(controller: ganttTimelineController),
          GestureDetector(
            onTap: onTapBody,
            child: GanttList(children: subjects),
          ),
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
