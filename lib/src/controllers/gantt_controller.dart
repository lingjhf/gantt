import 'package:gantt/src/controllers/subject_controller.dart';
import 'package:gantt/src/mixins/event_bus.dart';

class GanttController with EventBusMixin {
  bool subjectFocused = false;

  GanttSubjectController? _currentSubject;

  setCurrentSubject(GanttSubjectController? value) {
    var oldId = _currentSubject?.id;
    _currentSubject = value;
    emit('onCurrentSubjectChange', oldId);
  }

  GanttSubjectController? get currentSubject => _currentSubject;
}
