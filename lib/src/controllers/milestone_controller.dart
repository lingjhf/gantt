import '../mixins/drag_resize.dart';
import '../utils/gantt.dart';
import 'subject_controller.dart';

class GanttMilestoneController extends GanttSubjectController
    with DragResizeMixin {
  GanttMilestoneController({
    required super.ganttController,
    required super.timelineController,
    required super.connectContainerController,
    DateTime? date,
    this.finished = false,
  }) : date = date ?? DateTime.now() {
    left = getSubjectLeft(this.date);
  }

  @override
  double get width => 20;

  DateTime date;

  bool finished;

  //显示时间轴高亮日期
  @override
  void visibleTimelineHighlight() {
    timelineController.updateHighlight(
      visible: true,
      width: width,
      left: left,
      startDate: date,
      endDate: date,
    );
  }

  @override
  bool rightOverflowTimeline(DateTime date) {
    if (left + dayWidth > timelineController.totalWidth) {
      timelineController.addBackDay();
      left = getSubjectLeft(date);
      return true;
    }
    return false;
  }

  //注册时间轴高亮
  @override
  void dragStart(double dx) {
    super.dragStart(dx);
    if (id != ganttController.currentSubject?.id) {
      focused = true;
      ganttController.setCurrentSubject(this);
    }
    visibleTimelineHighlight();
  }

  @override
  void dragUpdate(double dx) {
    super.dragUpdate(dx);
    if (leftOverflowTimeline(date)) {
      return;
    }
    if (rightOverflowTimeline(date)) {
      return;
    }
    if (deltaX == 0) return;
    if (deltaX < 0) {
      leftOverflowViewWidth();
    } else {
      rightOverflowViewWidth();
    }
    var startIndex = getStartIndex(left, dayWidth);

    date = timelineController.dates[startIndex];

    timelineController.updateHighlight(
      left: startIndex * dayWidth,
      width: width,
      startDate: date,
      endDate: date,
    );
  }

  void dragEnd() {
    if (!focused) {
      invisibleTimelineHighlight();
    }
    left = timelineController.highlight.left;
  }
}
