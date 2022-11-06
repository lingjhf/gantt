import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../enums.dart';
import '../models/timeline.dart';
import '../utils/datetime.dart';
import '../utils/timeline_handler.dart';

final ganttTimelineProvider =
    StateNotifierProvider<GanttTimelineNotifier, GanttTimelineModel>(
  (ref) => GanttTimelineNotifier(),
);

class GanttTimelineNotifier extends StateNotifier<GanttTimelineModel> {
  GanttTimelineNotifier() : super(const GanttTimelineModel());

  late TimelineHandler timelineHandler;
  late ScrollController scrollController;

  double viewWidth = 0;

  double get totalWidth => state.totalWidth;

  double get scrollOffset => scrollController.offset;

  double get viewWidthOffset => scrollOffset + viewWidth;

  void init({
    required DateTime startDate,
    required DateTime endDate,
    required ScrollController scrollController,
    GanttDateUnit unit = GanttDateUnit.day,
    double viewWidth = 0,
  }) {
    this.scrollController = scrollController;
    this.viewWidth = viewWidth;
    state = state.copyWith(dates: getDates(startDate, endDate), unit: unit);
    switch (unit) {
      case GanttDateUnit.day:
        timelineHandler = DayHandler();
        break;
      case GanttDateUnit.week:
        timelineHandler = WeekHandler();
        break;
      case GanttDateUnit.month:
        timelineHandler = MonthHandler();
        break;
      case GanttDateUnit.quarter:
        timelineHandler = QuarterHandler();
        break;
      case GanttDateUnit.halfYear:
        timelineHandler = HalfYearHandler();
        break;
      case GanttDateUnit.year:
        timelineHandler = YearHandler();
        break;
    }
  }

  void setViewDates() {
    final List<GanttTimelineItemModel> firstItems = [];
    final List<GanttTimelineItemModel> secondItems = [];
    double offset = scrollController.hasClients ? scrollOffset : 0;
    int startIndex = (offset / state.unit.dayWidth).floor();
    int endIndex = startIndex + (viewWidth / state.unit.dayWidth).ceil();
    if (endIndex > state.dates.length - 1) {
      endIndex = state.dates.length - 1;
    }
    timelineHandler.update(
      state.dates,
      startIndex,
      endIndex,
      firstItems: firstItems,
      secondItems: secondItems,
      scrollOffset: offset,
    );
    state = state.copyWith(
      firstItems: firstItems,
      secondItems: secondItems,
    );
  }

  void scrollJumpTo(double offset) {
    scrollController.jumpTo(offset);
  }

  //当任务超出可视范围的左侧，向左滚动
  void scrollJumpToLeft(double left) {
    if (left < scrollOffset) {
      scrollJumpTo(left);
    }
  }

  //当任务超出可视范围的右侧，向右滚动
  void scrollJumpToRight(double left, double width) {
    if (left + width > viewWidthOffset) {
      var offset = scrollOffset + (left + width - viewWidthOffset);
      scrollJumpTo(offset);
    }
  }

  //时间轴向前加一天
  void addDayForward() {
    var dates = [
      state.dates.first.subtract(const Duration(days: 1)),
      ...state.dates
    ];
    state = state.copyWith(dates: dates);
  }

  //时间轴向后加一天
  void addDayBack() {
    var dates = [
      ...state.dates,
      state.dates.last.add(const Duration(days: 1)),
    ];
    state = state.copyWith(dates: dates);
  }

  bool needAddDayForward(double left) {
    if (left < 0) {
      addDayForward();
      setViewDates();
      return true;
    }
    return false;
  }

  bool needAddDayBack(double left, double width) {
    if (left + width > totalWidth) {
      addDayBack();
      setViewDates();
      return true;
    }
    return false;
  }
}
