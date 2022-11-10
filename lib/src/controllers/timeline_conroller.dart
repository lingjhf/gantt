import 'package:flutter/cupertino.dart';
import 'package:gantt/src/mixins/event_bus.dart';
import 'package:gantt/src/models/timeline.dart';

import '../enums.dart';

class GanttTimelineController with EventBusMixin {
  GanttTimelineController({
    required this.startDate,
    required this.endDate,
    required this.scrollController,
    this.unit = GanttDateUnit.day,
    this.viewWidth = 0,
  }) {
    initDates();
    setTotalWidth();
    updateTimeline();
    onScrollListener();
  }
  final ScrollController scrollController;
  DateTime startDate;
  DateTime endDate;
  GanttDateUnit unit;
  double viewWidth;
  double totalWidth = 0;

  List<DateTime> dates = [];

  List<GanttTimelineItemModel> headerItems = [];
  List<GanttTimelineItemModel> mainItems = [];

  GanttTimelineHighlightModel highlight = const GanttTimelineHighlightModel();

  TimelineHandler timelineHandler = DayHandler();

  void initDates() {
    for (var current = startDate;
        current.isBefore(endDate);
        current = current.add(const Duration(days: 1))) {
      dates.add(current);
    }
  }

  void updateHighlight({
    bool? visible,
    DateTime? startDate,
    DateTime? endDate,
    double? left,
    double? width,
  }) {
    highlight = highlight.copyWith(
      visible: visible,
      startDate: startDate,
      endDate: endDate,
      left: left,
      width: width,
    );

    emit('onHighlightChange');
  }

  void updateTimeline() {
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
    headerItems.clear();
    mainItems.clear();
    double offset = scrollController.offset;
    int startIndex = (offset / unit.dayWidth).floor();
    int endIndex = ((offset + viewWidth) / unit.dayWidth).ceil();
    if (endIndex > dates.length - 1) {
      endIndex = dates.length - 1;
    }
    timelineHandler.update(
      dates,
      startIndex,
      endIndex,
      firstItems: headerItems,
      secondItems: mainItems,
      scrollOffset: offset,
    );
    emit('onChange');
  }

  void setTotalWidth() {
    totalWidth = dates.length * unit.dayWidth;
  }

  void onScrollListener() {
    scrollController.addListener(() {
      updateTimeline();
    });
  }

  void addBackDay() {
    endDate = endDate.add(const Duration(days: 1));
    dates.add(endDate);
    setTotalWidth();
    updateTimeline();
  }

  void addForwardDay() {
    startDate = startDate.subtract(const Duration(days: 1));
    dates.insert(0, startDate);
    setTotalWidth();
    updateTimeline();
  }
}

abstract class TimelineHandler {
  void update(
    List<DateTime> dates,
    int startIndex,
    int endIndex, {
    List<GanttTimelineItemModel> firstItems = const [],
    List<GanttTimelineItemModel> secondItems = const [],
    double scrollOffset = 0,
  });
}

class DayHandler extends TimelineHandler {
  final double dayWidth = GanttDateUnit.day.dayWidth;

  @override
  void update(
    List<DateTime> dates,
    int startIndex,
    int endIndex, {
    List<GanttTimelineItemModel> firstItems = const [],
    List<GanttTimelineItemModel> secondItems = const [],
    double scrollOffset = 0,
  }) {
    var offset = startIndex * dayWidth;
    var dayMap = <String, GanttTimelineItemModel>{};
    var monthMap = <String, GanttTimelineItemModel>{};
    for (int i = startIndex; i <= endIndex; i++) {
      var date = dates[i];
      dayMap['${date.year}_${date.month}_${date.day}'] =
          GanttTimelineItemModel(width: dayWidth, left: offset, date: date);
      offset += dayWidth;
      //因为索引从0开始，所以要加1才等于item长度
      monthMap['${date.year}_${date.month}'] =
          GanttTimelineItemModel(width: (i + 1) * dayWidth, date: date);
    }
    offset = scrollOffset;
    monthMap.forEach((key, value) {
      value.width = value.width - offset;
      value.left = offset;
      offset += value.width;
    });
    firstItems.addAll(monthMap.values);
    secondItems.addAll(dayMap.values);
  }
}

class WeekHandler extends TimelineHandler {
  final double dayWidth = GanttDateUnit.week.dayWidth;

  @override
  void update(
    List<DateTime> dates,
    int startIndex,
    int endIndex, {
    List<GanttTimelineItemModel> firstItems = const [],
    List<GanttTimelineItemModel> secondItems = const [],
    double scrollOffset = 0,
  }) {
    var key = 0;
    var weekMap = <String, GanttTimelineItemModel>{};
    for (int i = startIndex; i <= endIndex; i++) {
      var date = dates[i];
      if (date.weekday == DateTime.monday) {
        key++;
      }
      var weekValue = weekMap['$key'];
      if (weekValue == null) {
        weekMap['$key'] = GanttTimelineItemModel(width: dayWidth, date: date);
      } else {
        weekValue.width += dayWidth;
      }
    }
  }
}

class MonthHandler extends TimelineHandler {
  final double dayWidth = GanttDateUnit.month.dayWidth;

  @override
  void update(
    List<DateTime> dates,
    int startIndex,
    int endIndex, {
    List<GanttTimelineItemModel> firstItems = const [],
    List<GanttTimelineItemModel> secondItems = const [],
    double scrollOffset = 0,
  }) {
    var monthMap = <String, GanttTimelineItemModel>{};
    for (int i = startIndex; i <= endIndex; i++) {
      var date = dates[i];
      var key = '${date.year}_${date.month}';
      var monthValue = monthMap[key];
      if (monthValue == null) {
        monthMap[key] = GanttTimelineItemModel(width: dayWidth, date: date);
      } else {
        monthValue.width += dayWidth;
      }
    }
  }
}

class QuarterHandler extends TimelineHandler {
  final double dayWidth = GanttDateUnit.quarter.dayWidth;

  @override
  void update(
    List<DateTime> dates,
    int startIndex,
    int endIndex, {
    List<GanttTimelineItemModel> firstItems = const [],
    List<GanttTimelineItemModel> secondItems = const [],
    double scrollOffset = 0,
  }) {
    var key = 0;
    var quarterMap = <String, GanttTimelineItemModel>{};
    for (int i = startIndex; i <= endIndex; i++) {
      var date = dates[i];
      if ((date.month == DateTime.january ||
              date.month == DateTime.april ||
              date.month == DateTime.july ||
              date.month == DateTime.october) &&
          date.day == 1) {
        key++;
      }
      var quarterValue = quarterMap['$key'];
      if (quarterValue == null) {
        quarterMap['$key'] =
            GanttTimelineItemModel(width: dayWidth, date: date);
      } else {
        quarterValue.width += dayWidth;
      }
    }
  }
}

class HalfYearHandler extends TimelineHandler {
  final double dayWidth = GanttDateUnit.halfYear.dayWidth;

  @override
  void update(
    List<DateTime> dates,
    int startIndex,
    int endIndex, {
    List<GanttTimelineItemModel> firstItems = const [],
    List<GanttTimelineItemModel> secondItems = const [],
    double scrollOffset = 0,
  }) {
    var key = 0;
    var halfYearMap = <String, GanttTimelineItemModel>{};
    for (int i = startIndex; i <= endIndex; i++) {
      var date = dates[i];
      if ((date.month == DateTime.january || date.month == DateTime.july) &&
          date.day == 1) {
        key++;
      }
      var halfYearValue = halfYearMap['$key'];
      if (halfYearValue == null) {
        halfYearMap['$key'] =
            GanttTimelineItemModel(width: dayWidth, date: date);
      } else {
        halfYearValue.width += dayWidth;
      }
    }
  }
}

class YearHandler extends TimelineHandler {
  final double dayWidth = GanttDateUnit.year.dayWidth;

  @override
  void update(
    List<DateTime> dates,
    int startIndex,
    int endIndex, {
    List<GanttTimelineItemModel> firstItems = const [],
    List<GanttTimelineItemModel> secondItems = const [],
    double scrollOffset = 0,
  }) {
    var yearMap = <String, GanttTimelineItemModel>{};
    for (int i = startIndex; i <= endIndex; i++) {
      var date = dates[i];
      var key = '${date.year}';
      var yearValue = yearMap[key];
      if (yearValue == null) {
        yearMap[key] = GanttTimelineItemModel(width: dayWidth, date: date);
      } else {
        yearValue.width += dayWidth;
      }
    }
  }
}
