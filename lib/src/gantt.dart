import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'enums.dart';
import 'gantt_background.dart';
import 'gantt_list.dart';
import 'gantt_timeline.dart';
import 'providers/timeline_provider.dart';

class Gantt extends StatelessWidget {
  const Gantt({
    super.key,
    required this.startDate,
    required this.endDate,
    this.unit = GanttDateUnit.day,
    this.scrollController,
    this.children = const [],
  });

  final DateTime startDate;
  final DateTime endDate;
  final GanttDateUnit unit;
  final ScrollController? scrollController;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    var scrollController = this.scrollController ?? ScrollController();
    return ProviderScope(child: LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          child: Scrollbar(
            thumbVisibility: true,
            controller: scrollController,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: scrollController,
              child: GanttContainer(
                startDate: startDate,
                endDate: endDate,
                unit: unit,
                viewWidth: constraints.maxWidth,
                scrollController: scrollController,
                children: children,
              ),
            ),
          ),
        );
      },
    ));
  }
}

// ignore: must_be_immutable
class GanttContainer extends ConsumerWidget {
  GanttContainer({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.unit,
    required this.viewWidth,
    required this.scrollController,
    this.children = const [],
  });

  final DateTime startDate;
  final DateTime endDate;
  final GanttDateUnit unit;
  final double viewWidth;
  final ScrollController scrollController;

  final List<Widget> children;

  GanttTimelineNotifier? timelineNotifier;

  void initProviders(WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      timelineNotifier = ref.read(ganttTimelineProvider.notifier)!
        ..init(
          startDate: startDate,
          endDate: endDate,
          scrollController: scrollController,
          unit: unit,
          viewWidth: viewWidth,
        )
        ..setViewDates();
      watchScrolling(timelineNotifier!);
    });
  }

  watchScrolling(GanttTimelineNotifier notifier) {
    scrollController.addListener(() {
      notifier.setViewDates();
    });
  }

  //构造时间轴
  Widget _buildTimeline() {
    Widget timeline;
    switch (unit) {
      case GanttDateUnit.day:
        timeline = const GanttDayTimeline();
        break;
      case GanttDateUnit.week:
        timeline = const GanttWeekTimeline();
        break;
      case GanttDateUnit.month:
        timeline = const GanttMonthTimeline();
        break;
      case GanttDateUnit.quarter:
        timeline = const GanttQuarterTimeline();
        break;
      case GanttDateUnit.halfYear:
        timeline = const GanttHalfYearTimeline();
        break;
      case GanttDateUnit.year:
        timeline = const GanttYearTimeline();
        break;
    }

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
          child: timeline,
        ),
      ),
    );
  }

  //构建甘特图体
  Widget _buildBody() {
    return Expanded(
      child: Stack(
        children: [
          const GanttBackground(),
          GanttList(children: children),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    initProviders(ref);
    return Consumer(
      builder: (context, ref, child) {
        var totalWidth = ref
            .watch(ganttTimelineProvider.select((value) => value.totalWidth));
        return SizedBox(
          width: totalWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTimeline(),
              _buildBody(),
            ],
          ),
        );
      },
    );
  }
}
