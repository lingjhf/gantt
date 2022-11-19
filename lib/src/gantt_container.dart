import 'package:flutter/material.dart';

import 'controllers/connect_controller.dart';
import 'controllers/gantt_controller.dart';
import 'controllers/milestone_controller.dart';
import 'controllers/task_controller.dart';
import 'controllers/timeline_controller.dart';
import 'enums.dart';
import 'gantt_weekend_highlight.dart';
import 'gantt_connect_line_container.dart';
import 'gantt_list.dart';
import 'gantt_milestone.dart';
import 'gantt_task.dart';
import 'gantt_timeline.dart';
import 'models/milestone.dart';
import 'models/subject.dart';
import 'models/task.dart';

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

  final Color headerColor = const Color(0xFF141517);

  final Color bodyColor = const Color(0xFF141517);

  final Color weekendHighlight = const Color(0xff282c34);

  @override
  State<StatefulWidget> createState() => _GanttContainerState();
}

class _GanttContainerState extends State<GanttContainer> {
  late GanttController ganttController;

  late GanttTimelineController ganttTimelineController;

  late GanttConnectContainerController ganttConnectContainerController;

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

    ganttConnectContainerController = GanttConnectContainerController();

    ganttTimelineController.on('onAddBackDay', (arg) => setState(() {}));
    ganttTimelineController.on('onAddForwardDay', (arg) => setState(() {}));

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
              connectContainerController: ganttConnectContainerController,
              startDate: item.startDate,
              endDate: item.endDate,
              progress: item.progress,
            ),
          ),
        );
      } else if (item is GanttMilestoneData) {
        children.add(
          GanttMilestone(
            title: item.title,
            controller: GanttMilestoneController(
              ganttController: ganttController,
              timelineController: ganttTimelineController,
              connectContainerController: ganttConnectContainerController,
              date: item.date,
              finished: item.finished,
            ),
          ),
        );
      }
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
      color: widget.headerColor,
      child: DefaultTextStyle(
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        child: GanttTimeline(controller: ganttTimelineController),
      ),
    );
  }

  //构建甘特图体
  Widget buildBody() {
    return Expanded(
      child: DecoratedBox(
        decoration: BoxDecoration(color: widget.bodyColor),
        child: Stack(
          children: [
            GanttWeekendHighlight(
              controller: ganttTimelineController,
              color: widget.weekendHighlight.withOpacity(0.1),
            ),
            GanttConnectLineContainer(
                controller: ganttConnectContainerController),
            GestureDetector(
              onTap: onTapBody,
              child: GanttList(children: subjects),
            ),
          ],
        ),
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
