import 'package:gantt/src/controllers/subject_controller.dart';
import 'package:gantt/src/mixins/event_bus.dart';

class GanttController with EventBusMixin {
  bool subjectFocused = false;

  GanttSubjectController? currentSubject;
}
