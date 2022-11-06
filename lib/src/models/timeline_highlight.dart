class GanttTimelineHighlightModel {
  const GanttTimelineHighlightModel({
    required this.startDate,
    required this.endDate,
    this.left = 0,
    this.width = 0,
  });

  final DateTime startDate;
  final DateTime endDate;
  final double left;
  final double width;

  GanttTimelineHighlightModel copyWith({
    DateTime? startDate,
    DateTime? endDate,
    double? left,
    double? width,
  }) {
    return GanttTimelineHighlightModel(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      left: left ?? this.left,
      width: width ?? this.width,
    );
  }
}
