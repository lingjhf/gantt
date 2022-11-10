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
