import 'package:uuid/uuid.dart';
import 'gantt_controller.dart';
import 'timeline_controller.dart';

abstract class GanttSubjectController {
  GanttSubjectController({
    String? id,
    required this.ganttController,
    required this.timelineController,
  }) : id = id ?? const Uuid().v1();
  final String id;

  double left = 0;

  double width = 0;

  GanttController ganttController;

  GanttTimelineController timelineController;

  double get dayWidth => timelineController.unit.dayWidth;

  double get scrollOffset => timelineController.scrollController.offset;

  void scrollJumpTo(double value) {
    timelineController.scrollController.jumpTo(value);
  }

  //显示时间轴高亮日期
  void visibleTimelineHighlight() {
    timelineController.updateHighlight(visible: true);
  }

  //隐藏时间轴高亮日期
  void invisibleTimelineHighlight() {
    timelineController.updateHighlight(visible: false);
  }

  double getSubjectLeft(DateTime date) {
    var startIndex = timelineController.dates.indexOf(date);
    startIndex = startIndex < 0 ? 0 : startIndex;
    return startIndex * dayWidth;
  }

  bool leftOverflowTimeline(DateTime date) {
    if (left < 0) {
      timelineController.addForwardDay();
      left = getSubjectLeft(date);
      timelineController.updateHighlight(left: left);
      return true;
    }
    return false;
  }

  bool rightOverflowTimeline(DateTime date) {
    if (left + width > timelineController.totalWidth) {
      timelineController.addBackDay();
      left = getSubjectLeft(date);
      return true;
    }
    return false;
  }

  void leftOverflowViewWidth() {
    if (left < timelineController.scrollController.offset) {
      timelineController.scrollController.jumpTo(left);
    }
  }

  void rightOverflowViewWidth() {
    var scrollOffset = timelineController.scrollController.offset;
    var leftWidthSum = left + width;
    var offsetWidthSum = scrollOffset + timelineController.viewWidth;
    if (leftWidthSum > offsetWidthSum) {
      timelineController.scrollController
          .jumpTo(scrollOffset + (leftWidthSum - offsetWidthSum));
    }
  }
}
