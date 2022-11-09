import 'package:gantt/src/models/subject.dart';

class GanttTaskData extends GanttSubjectData {
  const GanttTaskData({
    this.startDate,
    this.endDate,
    this.progress = 0
  });
  final DateTime? startDate;
  final DateTime? endDate;
  final int progress;
}
