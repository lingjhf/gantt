import 'subject.dart';

class GanttMilestoneData extends GanttSubjectData {
  const GanttMilestoneData({this.date, this.finished = false});
  final DateTime? date;
  final bool finished;
}
