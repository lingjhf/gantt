import 'package:uuid/uuid.dart';

abstract class GanttSubjectController {
  GanttSubjectController({String? id}) : id = id ?? const Uuid().v1();
  final String id;
}
