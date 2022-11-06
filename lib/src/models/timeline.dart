import '../enums.dart';

class GanttTimelineItemModel {
  GanttTimelineItemModel({
    required this.date,
    this.left = 0,
    this.width = 0,
  });
  DateTime date;
  double left;
  double width;

  GanttTimelineItemModel copyWith({
    DateTime? date,
    double? left,
    double? width,
  }) {
    return GanttTimelineItemModel(
      date: date ?? this.date,
      left: left ?? this.left,
      width: width ?? this.width,
    );
  }
}

class GanttTimelineModel {
  const GanttTimelineModel({
    this.unit = GanttDateUnit.day,
    this.dates = const [],
    this.startIndex = 0,
    this.endIndex = 0,
    this.firstItems = const [],
    this.secondItems = const [],
  });

  final GanttDateUnit unit;
  final List<DateTime> dates;
  final int startIndex;
  final int endIndex;
  final List<GanttTimelineItemModel> firstItems;
  final List<GanttTimelineItemModel> secondItems;

  double get totalWidth => dates.length * unit.dayWidth;

  GanttTimelineModel copyWith({
    GanttDateUnit? unit,
    List<DateTime>? dates,
    int? startIndex,
    int? endIndex,
    List<GanttTimelineItemModel>? firstItems,
    List<GanttTimelineItemModel>? secondItems,
  }) {
    return GanttTimelineModel(
      unit: unit ?? this.unit,
      dates: dates ?? this.dates,
      startIndex: startIndex ?? this.startIndex,
      endIndex: endIndex ?? this.endIndex,
      firstItems: firstItems ?? this.firstItems,
      secondItems: secondItems ?? this.secondItems,
    );
  }
}
