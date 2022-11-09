// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:uuid/uuid.dart';

// import 'models/timeline_highlight.dart';
// import 'providers/timeline_highlight_provider.dart';
// import 'providers/timeline_provider.dart';
// import 'utils/gantt.dart';
// import 'widgets/gantt_milestone.dart';

// class GanttMilestone extends ConsumerStatefulWidget {
//   GanttMilestone({
//     super.key,
//     String? id,
//     required this.date,
//   }) : id = id ?? const Uuid().v1();

//   final String id;
//   final DateTime date;

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _GanttMilestone();
// }

// class _GanttMilestone extends ConsumerState<GanttMilestone> {
//   final double milestoneSize = 16;

//   late GanttTimelineHighlightNotifier timelineHighlightNotifier;

//   late GanttTimelineNotifier timelineNotifier;

//   late DateTime date;

//   double milestoneLeft = 0;

//   //单位天宽度
//   double dayWidth = 0;

//   var dates = <DateTime>[];

//   bool isFocus = false;

//   @override
//   void initState() {
//     date = widget.date;
//     timelineNotifier = ref.read(ganttTimelineProvider.notifier);
//     timelineHighlightNotifier =
//         ref.read(ganttTimelineHighlightProvider.notifier);
//     super.initState();
//   }

//   void updateMilestoneLeft() {
//     dayWidth =
//         ref.watch(ganttTimelineProvider.select((value) => value.unit.dayWidth));
//     dates = ref.watch(ganttTimelineProvider.select((value) => value.dates));
//     var startIndex = dates.indexOf(date);
//     startIndex = startIndex < 0 ? 0 : startIndex;
//     milestoneLeft = dayWidth * startIndex;
//   }

//   //启用时间轴高亮
//   void enableTimelineHighlight() {
//     timelineHighlightNotifier.setState(
//       GanttTimelineHighlightModel(
//         startDate: date,
//         endDate: date,
//         left: milestoneLeft,
//         width: dayWidth,
//       ),
//     );
//   }

//   //关闭时间轴高亮
//   void disableTimelineHighlight() {
//     timelineHighlightNotifier.setState(null);
//   }

//   //dragEnd对齐时间轴
//   void dragEndAlignTimeline(double left) {
//     setState(() {
//       milestoneLeft = getAlignLeft(left, dayWidth);
//     });
//   }

//   //是否需要向前添加一天
//   bool needAddDayForward(double left) {
//     if (timelineNotifier.needAddDayForward(left)) {
//       timelineHighlightNotifier.setValue(left: milestoneLeft);
//       return true;
//     }
//     return false;
//   }

//   void onDragStart(double left) {
//     enableTimelineHighlight();
//   }

//   void onDrag(double left) {
//     if (needAddDayForward(left)) {
//       return;
//     }
//     if (timelineNotifier.needAddDayBack(left, dayWidth)) {
//       return;
//     }
//     timelineNotifier.scrollJumpToLeft(left);
//     timelineNotifier.scrollJumpToRight(left, dayWidth);

//     var startIndex = getStartIndex(left, dayWidth);
//     date = dates[startIndex];
//     timelineHighlightNotifier.setValue(
//       startDate: date,
//       endDate: date,
//       left: getIndexkLeft(startIndex, dayWidth),
//     );
//   }

//   void onDragEnd(double left) {
//     if (!isFocus) {
//       disableTimelineHighlight();
//     }
//     dragEndAlignTimeline(left);
//   }

//   void onFocusIn() {
//     isFocus = true;
//     enableTimelineHighlight();
//   }

//   void onFocusOut() {
//     isFocus = false;
//     disableTimelineHighlight();
//   }

//   @override
//   Widget build(BuildContext context) {
//     updateMilestoneLeft();
//     return GanttMilestoneWidget(
//       left: milestoneLeft,
//       onDragStart: onDragStart,
//       onDrag: onDrag,
//       onDragEnd: onDragEnd,
//       onFocusIn: onFocusIn,
//       onFocusOut: onFocusOut,
//     );
//   }
// }
