import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/timeline_highlight.dart';

final ganttTimelineHighlightProvider = StateNotifierProvider<
    GanttTimelineHighlightNotifier, GanttTimelineHighlightModel?>(
  (ref) => GanttTimelineHighlightNotifier(),
);

class GanttTimelineHighlightNotifier
    extends StateNotifier<GanttTimelineHighlightModel?> {
  GanttTimelineHighlightNotifier() : super(null);

  bool get isHighlight => state != null ? true : false;

  void setState(GanttTimelineHighlightModel? value) {
    state = value;
  }

  void setValue(
      {DateTime? startDate, DateTime? endDate, double? left, double? width}) {
    state = state?.copyWith(
        startDate: startDate, endDate: endDate, left: left, width: width);
  }
}
