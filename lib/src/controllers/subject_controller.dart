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
}
