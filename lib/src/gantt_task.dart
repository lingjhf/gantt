import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'models/left_width.dart';
import 'models/timeline_highlight.dart';
import 'providers/timeline_highlight_provider.dart';
import 'providers/timeline_provider.dart';
import 'utils/gantt.dart';
import 'widgets/gantt_task.dart';

class GanttTask extends ConsumerStatefulWidget {
  GanttTask({
    super.key,
    String? id,
    DateTime? startDate,
    DateTime? endDate,
    this.title = '',
    this.progress = 0,
  })  : id = id ?? const Uuid().v1(),
        startDate = startDate ?? DateTime.now(),
        endDate = endDate ?? DateTime.now();

  //id
  final String id;

  //开始日期
  final DateTime startDate;

  //结束日期
  final DateTime endDate;

  final String title;

  //进度(0-100%)
  final int progress;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GanttTaskState();
}

class _GanttTaskState extends ConsumerState<GanttTask> {
  //时间轴高亮通知
  //需要通过状态通知时间轴的高亮日期，位置
  late GanttTimelineHighlightNotifier timelineHighlightNotifier;

  late GanttTimelineNotifier timelineNotifier;

  //任务开始日期
  late DateTime startDate;

  //任务结束日期
  late DateTime endDate;

  //任务进度
  int progress = 0;

  //任务左边位置
  double taskLeft = 0;

  //任务宽度
  double taskWidth = 0;

  //单位天宽度
  double dayWidth = 0;

  var dates = <DateTime>[];

  bool isFocus = false;

  @override
  void initState() {
    startDate = widget.startDate;
    endDate = widget.endDate;
    progress = widget.progress;
    timelineNotifier = ref.read(ganttTimelineProvider.notifier);
    timelineHighlightNotifier =
        ref.read(ganttTimelineHighlightProvider.notifier);

    super.initState();
  }

  //初始化位置和宽度
  void updateLeftWidth() {
    dayWidth =
        ref.watch(ganttTimelineProvider.select((value) => value.unit.dayWidth));
    dates = ref.watch(ganttTimelineProvider.select((value) => value.dates));
    var startIndex = dates.indexOf(startDate);
    startIndex = startIndex < 0 ? 0 : startIndex;
    taskLeft = dayWidth * startIndex;
    taskWidth = (endDate.difference(startDate).inDays + 1) * dayWidth;
  }

  //获取向左调整大小的位置和宽度
  LeftWidth getAlignResizeLeftData(double left, double width) {
    var leftWidthSum = left + width;
    if (width < dayWidth) {
      return LeftWidth(left: leftWidthSum - dayWidth, width: dayWidth);
    }
    var tempLeft = getAlignLeft(left, dayWidth);
    return LeftWidth(
      left: tempLeft,
      width: leftWidthSum - tempLeft,
    );
  }

  double getAlignResizeRightWidth(double left, double width) {
    if (width < dayWidth) {
      return dayWidth;
    }
    var leftWidthSum = left + width;
    var endIndex = (leftWidthSum / dayWidth).round();
    return dayWidth * endIndex - left;
  }

  //启用时间轴高亮
  void enableTimelineHighlight() {
    timelineHighlightNotifier.setState(
      GanttTimelineHighlightModel(
        startDate: startDate,
        endDate: endDate,
        left: taskLeft,
        width: taskWidth,
      ),
    );
  }

  //关闭时间轴高亮
  void disableTimelineHighlight() {
    timelineHighlightNotifier.setState(null);
  }

  //dragEnd对齐时间轴
  void dragEndAlignTimeline(double left) {
    setState(() {
      taskLeft = getAlignLeft(left, dayWidth);
    });
  }

  //向左边调整大小后，任务的位置和宽度需要对齐时间轴
  void resizeLeftEndAlignTimeline(double left, double width) {
    var leftWidth = getAlignResizeLeftData(left, width);
    setState(() {
      taskLeft = leftWidth.left;
      taskWidth = leftWidth.width;
    });
  }

  //向右边调整大小后，任务宽度需要对齐时间轴
  void resizeRightEndAlignTimeline(double left, double width) {
    setState(() {
      taskWidth = getAlignResizeRightWidth(left, width);
    });
  }

  //是否需要向前添加一天
  bool needAddDayForward(double left) {
    if (timelineNotifier.needAddDayForward(left)) {
      timelineHighlightNotifier.setValue(left: taskLeft);
      return true;
    }
    return false;
  }

  //初始化时间轴高亮
  void onDragStart(double left, double width) {
    enableTimelineHighlight();
  }

  void onDrag(double left, double width) {
    if (needAddDayForward(left)) {
      return;
    }
    if (timelineNotifier.needAddDayBack(left, width)) {
      return;
    }

    timelineNotifier.scrollJumpToLeft(left);
    timelineNotifier.scrollJumpToRight(left, width);

    var startIndex = getStartIndex(left, dayWidth);

    var endIndex = getEndIndex(left, width, dayWidth);

    startDate = dates[startIndex];
    endDate = dates[endIndex - 1];

    timelineHighlightNotifier.setValue(
      startDate: startDate,
      endDate: endDate,
      left: getIndexkLeft(startIndex, dayWidth),
    );
  }

  void onDragEnd(double left, double width) {
    if (!isFocus) {
      disableTimelineHighlight();
    }
    dragEndAlignTimeline(left);
  }

  void onResizeLeftStart(double left, double width) {
    enableTimelineHighlight();
  }

  void onResizeLeft(double left, double width) {
    if (needAddDayForward(left)) return;
    timelineNotifier.scrollJumpToLeft(left);
    if (width > dayWidth) {
      var startIndex = getStartIndex(left, dayWidth);
      startDate = dates[startIndex];
    }
    var leftWidth = getAlignResizeLeftData(left, width);
    timelineHighlightNotifier.setValue(
      startDate: startDate,
      left: leftWidth.left,
      width: leftWidth.width,
    );
  }

  void onResizeLeftEnd(double left, double width) {
    resizeLeftEndAlignTimeline(left, width);
  }

  void onResizeRightStart(double left, double width) {
    enableTimelineHighlight();
  }

  void onResizeRight(double left, double width) {
    if (timelineNotifier.needAddDayBack(left, width)) return;
    timelineNotifier.scrollJumpToRight(left, width);
    if (width > dayWidth) {
      var endIndex = getEndIndex(left, width, dayWidth);
      endDate = dates[endIndex - 1];
    }
    timelineHighlightNotifier.setValue(
      endDate: endDate,
      width: getAlignResizeRightWidth(left, width),
    );
  }

  void onResizeRightEnd(double left, double width) {
    resizeRightEndAlignTimeline(left, width);
  }

  void onFocusIn() {
    isFocus = true;
    enableTimelineHighlight();
  }

  void onFocusOut() {
    isFocus = false;
    disableTimelineHighlight();
  }

  void onProgressChange(int value) {
    progress = value;
  }

  @override
  Widget build(BuildContext context) {
    updateLeftWidth();
    return GanttTaskWidget(
      title: widget.title,
      left: taskLeft,
      width: taskWidth,
      progress: progress,
      onDragStart: onDragStart,
      onDrag: onDrag,
      onDragEnd: onDragEnd,
      onResizeLeftStart: onResizeLeftStart,
      onResizeLeft: onResizeLeft,
      onResizeLeftEnd: onResizeLeftEnd,
      onResizeRightStart: onResizeRightStart,
      onResizeRight: onResizeRight,
      onResizeRightEnd: onResizeRightEnd,
      onProgressChange: onProgressChange,
      onFocusIn: onFocusIn,
      onFocusOut: onFocusOut,
    );
  }
}
