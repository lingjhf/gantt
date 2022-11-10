import 'package:gantt/src/controllers/subject_controller.dart';
import 'package:gantt/src/mixins/event_bus.dart';

class GanttController with EventBusMixin {
  bool subjectFocused = false;

  GanttSubjectController? _currentSubject;

  setCurrentSubject(GanttSubjectController? value) {
    _currentSubject = value;
    emit('onCurrentSubjectChange');
  }

  GanttSubjectController? get currentSubject => _currentSubject;
}
