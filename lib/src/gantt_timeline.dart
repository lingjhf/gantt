import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'gantt_timeline_highlight.dart';
import 'models/timeline.dart';
import 'providers/timeline_provider.dart';
import 'utils/datetime.dart';

class GanttDayTimeline extends ConsumerWidget {
  const GanttDayTimeline({super.key});

  Widget _buildFirstItem(GanttTimelineItemModel item) {
    return Positioned(
      left: item.left,
      top: 0,
      bottom: 0,
      child: Container(
        width: item.width,
        alignment: Alignment.centerLeft,
        child: Text('${item.date.monthAbbreviation()} ${item.date.year}'),
      ),
    );
  }

  Widget _buildSecondItem(GanttTimelineItemModel item) {
    return Positioned(
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
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.watch(ganttTimelineProvider);
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              for (var item in provider.firstItems) _buildFirstItem(item)
            ],
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              for (var item in provider.secondItems) _buildSecondItem(item),
              const GanttTimelineHighlight()
            ],
          ),
        ),
      ],
    );
  }
}

class GanttWeekTimeline extends ConsumerWidget {
  const GanttWeekTimeline({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container();
  }
}

class GanttMonthTimeline extends ConsumerWidget {
  const GanttMonthTimeline({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column();
  }
}

class GanttQuarterTimeline extends ConsumerWidget {
  const GanttQuarterTimeline({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column();
  }
}

class GanttHalfYearTimeline extends ConsumerWidget {
  const GanttHalfYearTimeline({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column();
  }
}

class GanttYearTimeline extends ConsumerWidget {
  const GanttYearTimeline({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column();
  }
}
