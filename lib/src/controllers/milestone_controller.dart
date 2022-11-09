import 'subject_controller.dart';
import '../mixins/drag_resize.dart';

class GanttMilestoneController extends GanttSubjectController
    with DragResizeMixin {
  GanttMilestoneController({required super.id});
}
