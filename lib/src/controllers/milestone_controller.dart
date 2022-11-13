import '../mixins/drag_resize.dart';
import 'gantt_controller.dart';
import 'subject_controller.dart';
import 'timeline_controller.dart';

class GanttMilestoneController extends GanttSubjectController
    with DragResizeMixin {
  GanttMilestoneController({
    required this.ganttController,
    required this.timelineController,
    this.date,
    this.finished = false,
  });

  GanttController ganttController;

  GanttTimelineController timelineController;

  DateTime? date;

  bool finished;
}
