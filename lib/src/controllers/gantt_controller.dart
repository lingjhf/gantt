import '../mixins/event_bus.dart';
import 'subject_controller.dart';

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
