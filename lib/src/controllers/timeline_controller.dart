import 'package:flutter/cupertino.dart';

import '../enums.dart';
import '../mixins/event_bus.dart';
import '../models/timeline.dart';

class GanttTimelineController with EventBusMixin {
  GanttTimelineController({
    required this.startDate,
    required this.endDate,
    required ScrollController scrollController,
    this.unit = GanttDateUnit.day,
    this.viewWidth = 0,
  }) : _scrollController = scrollController {
    initDates();
    setTotalWidth();
    updateTimeline();
    onScrollListener();
  }
  ScrollController _scrollController;
  DateTime startDate;
  DateTime endDate;
  GanttDateUnit unit;
  double viewWidth;
  double totalWidth = 0;

  List<DateTime> dates = [];

  int startIndex = 0;
  int endIndex = 0;

  List<GanttTimelineItemModel> headerItems = [];
  List<GanttTimelineItemModel> mainItems = [];

  GanttTimelineHighlightModel highlight = const GanttTimelineHighlightModel();

  TimelineHandler timelineHandler = DayHandler();

  set scrollController(ScrollController value) {
    _scrollController = value;
    onScrollListener();
  }

  ScrollController get scrollController => _scrollController;

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
    double offset = _scrollController.offset;
    startIndex = (offset / unit.dayWidth).floor();
    endIndex = ((offset + viewWidth) / unit.dayWidth).ceil();
    if (endIndex > dates.length - 1) {
      endIndex = dates.length - 1;
    }
    timelineHandler.update(
      dates,
      startIndex,
      endIndex,
      headerItems: headerItems,
      mainItems: mainItems,
      scrollOffset: offset,
    );
    emit('onChange');
  }

  void setTotalWidth() {
    totalWidth = dates.length * unit.dayWidth;
  }

  void onScrollListener() {
    _scrollController.addListener(() {
      updateTimeline();
    });
  }

  void addBackDay() {
    endDate = endDate.add(const Duration(days: 1));
    dates.add(endDate);
    setTotalWidth();
    updateTimeline();
    emit('onAddBackDay');
  }

  void addForwardDay() {
    startDate = startDate.subtract(const Duration(days: 1));
    dates.insert(0, startDate);
    setTotalWidth();
    updateTimeline();
    emit('onAddForwardDay');
  }

  bool addDayForwardOf(double left) {
    if (left < 0) {
      addForwardDay();
      return true;
    }
    return false;
  }

  bool addDayBackOf(double left, double width) {
    if (left + width > totalWidth) {
      addBackDay();
      return true;
    }
    return false;
  }
}

abstract class TimelineHandler {
  void update(
    List<DateTime> dates,
    int startIndex,
    int endIndex, {
    List<GanttTimelineItemModel> headerItems = const [],
    List<GanttTimelineItemModel> mainItems = const [],
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
    List<GanttTimelineItemModel> headerItems = const [],
    List<GanttTimelineItemModel> mainItems = const [],
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
      //???????????????0?????????????????????1?????????item??????
      monthMap['${date.year}_${date.month}'] =
          GanttTimelineItemModel(width: (i + 1) * dayWidth, date: date);
    }
    offset = scrollOffset;
    monthMap.forEach((key, value) {
      value.width = value.width - offset;
      value.left = offset;
      offset += value.width;
    });
    headerItems.addAll(monthMap.values);
    mainItems.addAll(dayMap.values);
  }
}

class WeekHandler extends TimelineHandler {
  final double dayWidth = GanttDateUnit.week.dayWidth;

  @override
  void update(
    List<DateTime> dates,
    int startIndex,
    int endIndex, {
    List<GanttTimelineItemModel> headerItems = const [],
    List<GanttTimelineItemModel> mainItems = const [],
    double scrollOffset = 0,
  }) {
    var key = 0;
    var weekMap = <String, GanttTimelineItemModel>{};
    var monthMap = <String, GanttTimelineItemModel>{};
    var offset = startIndex * dayWidth;
    for (int i = startIndex; i <= endIndex; i++) {
      var date = dates[i];
      if (date.weekday == DateTime.monday) {
        key++;
      }
      var weekValue = weekMap['$key'];
      if (weekValue == null) {
        weekMap['$key'] =
            GanttTimelineItemModel(width: dayWidth, left: offset, date: date);
      } else {
        weekValue.width += dayWidth;
      }
      offset += dayWidth;
      monthMap['${date.year}_${date.month}'] =
          GanttTimelineItemModel(width: (i + 1) * dayWidth, date: date);
    }
    offset = scrollOffset;
    monthMap.forEach((key, value) {
      value.width = value.width - offset;
      value.left = offset;
      offset += value.width;
    });
    headerItems.addAll(monthMap.values);
    mainItems.addAll(weekMap.values);
  }
}

class MonthHandler extends TimelineHandler {
  final double dayWidth = GanttDateUnit.month.dayWidth;

  @override
  void update(
    List<DateTime> dates,
    int startIndex,
    int endIndex, {
    List<GanttTimelineItemModel> headerItems = const [],
    List<GanttTimelineItemModel> mainItems = const [],
    double scrollOffset = 0,
  }) {
    var yearMap = <String, GanttTimelineItemModel>{};
    var monthMap = <String, GanttTimelineItemModel>{};
    var offset = startIndex * dayWidth;
    for (int i = startIndex; i <= endIndex; i++) {
      var date = dates[i];
      var key = '${date.year}_${date.month}';
      var monthValue = monthMap[key];
      if (monthValue == null) {
        monthMap[key] =
            GanttTimelineItemModel(width: dayWidth, left: offset, date: date);
      } else {
        monthValue.width += dayWidth;
      }
      offset += dayWidth;
      yearMap['${date.year}'] =
          GanttTimelineItemModel(width: (i + 1) * dayWidth, date: date);
    }
    offset = scrollOffset;
    yearMap.forEach((key, value) {
      value.width = value.width - offset;
      value.left = offset;
      offset += value.width;
    });
    headerItems.addAll(yearMap.values);
    mainItems.addAll(monthMap.values);
  }
}

class QuarterHandler extends TimelineHandler {
  final double dayWidth = GanttDateUnit.quarter.dayWidth;

  @override
  void update(
    List<DateTime> dates,
    int startIndex,
    int endIndex, {
    List<GanttTimelineItemModel> headerItems = const [],
    List<GanttTimelineItemModel> mainItems = const [],
    double scrollOffset = 0,
  }) {
    var key = 0;
    var yearMap = <String, GanttTimelineItemModel>{};
    var quarterMap = <String, GanttTimelineItemModel>{};
    var offset = startIndex * dayWidth;
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
            GanttTimelineItemModel(width: dayWidth, left: offset, date: date);
      } else {
        quarterValue.width += dayWidth;
      }
      offset += dayWidth;
      yearMap['${date.year}'] =
          GanttTimelineItemModel(width: (i + 1) * dayWidth, date: date);
    }
    offset = scrollOffset;
    yearMap.forEach((key, value) {
      value.width = value.width - offset;
      value.left = offset;
      offset += value.width;
    });
    headerItems.addAll(yearMap.values);
    mainItems.addAll(quarterMap.values);
  }
}

class HalfYearHandler extends TimelineHandler {
  final double dayWidth = GanttDateUnit.halfYear.dayWidth;

  @override
  void update(
    List<DateTime> dates,
    int startIndex,
    int endIndex, {
    List<GanttTimelineItemModel> headerItems = const [],
    List<GanttTimelineItemModel> mainItems = const [],
    double scrollOffset = 0,
  }) {
    var key = 0;
    var yearMap = <String, GanttTimelineItemModel>{};
    var halfYearMap = <String, GanttTimelineItemModel>{};
    var offset = startIndex * dayWidth;
    for (int i = startIndex; i <= endIndex; i++) {
      var date = dates[i];
      if ((date.month == DateTime.january || date.month == DateTime.july) &&
          date.day == 1) {
        key++;
      }
      var halfYearValue = halfYearMap['$key'];
      if (halfYearValue == null) {
        halfYearMap['$key'] =
            GanttTimelineItemModel(width: dayWidth, left: offset, date: date);
      } else {
        halfYearValue.width += dayWidth;
      }
      offset += dayWidth;
      yearMap['${date.year}'] =
          GanttTimelineItemModel(width: (i + 1) * dayWidth, date: date);
    }
    offset = scrollOffset;
    yearMap.forEach((key, value) {
      value.width = value.width - offset;
      value.left = offset;
      offset += value.width;
    });
    headerItems.addAll(yearMap.values);
    mainItems.addAll(halfYearMap.values);
  }
}

class YearHandler extends TimelineHandler {
  final double dayWidth = GanttDateUnit.year.dayWidth;

  @override
  void update(
    List<DateTime> dates,
    int startIndex,
    int endIndex, {
    List<GanttTimelineItemModel> headerItems = const [],
    List<GanttTimelineItemModel> mainItems = const [],
    double scrollOffset = 0,
  }) {
    var yearMap = <String, GanttTimelineItemModel>{};
    var offset = startIndex * dayWidth;
    for (int i = startIndex; i <= endIndex; i++) {
      var date = dates[i];
      var key = '${date.year}';
      var yearValue = yearMap[key];
      if (yearValue == null) {
        yearMap[key] =
            GanttTimelineItemModel(width: dayWidth, left: offset, date: date);
      } else {
        yearValue.width += dayWidth;
      }
      offset += dayWidth;
    }
    mainItems.addAll(yearMap.values);
  }
}
