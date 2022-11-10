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

class GanttTimelineHighlightModel {
  const GanttTimelineHighlightModel({
    this.visible = false,
    this.startDate,
    this.endDate,
    this.left = 0,
    this.width = 0,
  });

  final bool visible;
  final DateTime? startDate;
  final DateTime? endDate;
  final double left;
  final double width;

  GanttTimelineHighlightModel copyWith({
    bool? visible,
    DateTime? startDate,
    DateTime? endDate,
    double? left,
    double? width,
  }) {
    return GanttTimelineHighlightModel(
      visible: visible ?? this.visible,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      left: left ?? this.left,
      width: width ?? this.width,
    );
  }
}
