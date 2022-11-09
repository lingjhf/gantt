import 'package:flutter/material.dart';

import '../utils/gantt.dart';
import 'subject_controller.dart';
import 'timeline_conroller.dart';

import '../mixins/drag_resize.dart';

class GanttTaskController extends GanttSubjectController with DragResizeMixin {
  GanttTaskController({
    required this.timelineController,
    required this.scrollController,
    DateTime? startDate,
    DateTime? endDate,
    this.progress = 0,
  })  : _startDate = startDate ?? DateTime.now(),
        _endDate = endDate ?? DateTime.now() {
    _updateWidthByDate();
    _updateLeftByDate();
  }

  GanttTimelineController timelineController;
  ScrollController scrollController;

  bool focused = false;

  DateTime _startDate;

  DateTime _endDate;

  //进度
  int progress;

  //进度条的宽度
  double _progressWidth = 0;

  //每一个百分点的宽度
  double _percentageWidth = 0;

  final Map<String, GanttSubjectController> _subjectTree = {};

  double get progressWidth => _progressWidth;

  double get dayWidth => timelineController.unit.dayWidth;

  set startDate(DateTime value) {
    _startDate = value;
    _updateWidthByDate();
    _updateLeftByDate();
  }

  set endDate(DateTime value) {
    _endDate = value;
    _updateWidthByDate();
  }

  void _updateLeftByDate() {
    var startIndex = timelineController.dates.indexOf(_startDate);
    startIndex = startIndex < 0 ? 0 : startIndex;
    var tempLeft = startIndex * dayWidth;
    pressedOffset = pressedOffset - (tempLeft - left);
    left = tempLeft;
  }

  void _updateWidthByDate() {
    width = (_endDate.difference(_startDate).inDays + 1) * dayWidth;
  }

  //显示时间轴高亮日期
  void visibleTimelineHighlight() {
    timelineController.updateHighlight(
      visible: true,
      startDate: _startDate,
      endDate: _endDate,
    );
  }

  //隐藏时间轴高亮日期
  void invisibleTimelineHighlight() {
    timelineController.updateHighlight(visible: false);
  }

  bool _needAddDayForward(double left) {
    if (left < 0) {
      timelineController.addForwardDay();
      _updateLeftByDate();
      timelineController.updateHighlight(left: this.left);
      return true;
    }

    return false;
  }

  bool _needAddDayBack(double left, double width) {
    if (left + width > timelineController.totalWidth) {
      timelineController.addBackDay();
      _updateLeftByDate();
      return true;
    }

    return false;
  }

  bool _needScrollLeft(double left) {
    if (left < scrollController.offset) {
      scrollController.jumpTo(left);
      return true;
    }
    return false;
  }

  bool _needScrollRight(double left, double width) {
    var leftWidthSum = left + width;
    var offsetWidthSum = scrollController.offset + timelineController.viewWidth;
    if (leftWidthSum > offsetWidthSum) {
      scrollController
          .jumpTo(scrollController.offset + (leftWidthSum - offsetWidthSum));
      return true;
    }
    return false;
  }

  //连接下一个subject
  void connectNextSubject(GanttSubjectController subject) {
    // _subjectTree[subject]
  }

  //更新进度条宽度
  void updateProgressWidth() {
    _progressWidth = width * progress / 100;
  }

  //开始改变进度
  void progressStart(double dx) {
    _percentageWidth = width / 100;
    pressedOffset = dx - _progressWidth;
  }

  //改变进度
  void progressUpdate(double dx) {
    var w = _percentageWidth * ((dx - pressedOffset) ~/ _percentageWidth);

    if (w > width) {
      w = width;
    }
    if (w < 0) {
      w = 0;
    }
    progress = w > 0 ? w * 100 ~/ width : 0;
    _progressWidth = w;
  }

  //注册时间轴高亮
  @override
  void dragStart(double dx) {
    super.dragStart(dx);
    visibleTimelineHighlight();
  }

  //1.判断位置是否小于第一天，小于则需要向前加一天
  //2.判断位置是否大于最后一天，大于则需要向后加一天
  //3.判断位置是否小于可视范围第一天，小于则需要向左移动滚动条
  //4.判断位置是否大于可视范围最后一天，大于则需要向右移动滚动条
  @override
  void dragUpdate(double dx) {
    super.dragUpdate(dx);
    if (_needAddDayForward(left)) {
      return;
    }
    if (_needAddDayBack(left, width)) {
      return;
    }

    _needScrollLeft(left) || _needScrollRight(left, width);
    var startIndex = getStartIndex(left, dayWidth);
    var endIndex = getEndIndex(left, width, dayWidth);

    startDate = timelineController.dates[startIndex];
    endDate = timelineController.dates[endIndex - 1];

    timelineController.updateHighlight(
      left: startIndex * dayWidth,
      startDate: _startDate,
      endDate: _endDate,
    );
  }

  void dragEnd() {
    if (!focused) {
      invisibleTimelineHighlight();
    }
    left = timelineController.highlightLeft;
  }

  @override
  void resizeLeftStart(double dx) {
    super.resizeLeftStart(dx);
    visibleTimelineHighlight();
  }

  @override
  void resizeLeftUpdate(double dx) {
    super.resizeLeftUpdate(dx);
    updateProgressWidth();
    if (_needAddDayForward(left)) return;
    _needScrollLeft(left);
    if (width > dayWidth) {
      var startIndex = getStartIndex(left, dayWidth);
      startDate = timelineController.dates[startIndex];
    }
    double highlightLeft = 0;
    double highlightWidth = 0;
    var leftWidthSum = left + width;
    if (width < dayWidth) {
      highlightLeft = leftWidthSum - dayWidth;
      highlightWidth = dayWidth;
    }
    highlightLeft = getAlignLeft(left, dayWidth);
    highlightWidth = leftWidthSum - highlightLeft;
    timelineController.updateHighlight(
      startDate: _startDate,
      left: highlightLeft,
      width: highlightWidth,
    );
  }

  void resizeLeftEnd() {
    if (!focused) {
      invisibleTimelineHighlight();
    }
    left = timelineController.highlightLeft;
    width = timelineController.highlightWidth;
  }

  @override
  void resizeRightStart(double dx) {
    super.resizeRightStart(dx);
    visibleTimelineHighlight();
  }

  @override
  void resizeRightUpdate(double dx) {
    super.resizeRightUpdate(dx);
    updateProgressWidth();
    if (_needAddDayBack(left, width)) return;
    _needScrollRight(left, width);
    if (width > dayWidth) {
      var endIndex = getEndIndex(left, width, dayWidth);
      endDate = timelineController.dates[endIndex - 1];
    }
    double highlightWidth = 0;
    if (width < dayWidth) {
      highlightWidth = dayWidth;
    } else {
      var leftWidthSum = left + width;
      var endIndex = (leftWidthSum / dayWidth).round();
      highlightWidth = dayWidth * endIndex - left;
    }
    timelineController.updateHighlight(
      endDate: _endDate,
      width: highlightWidth,
    );
  }

  void resizeRightEnd() {
    if (!focused) {
      invisibleTimelineHighlight();
    }
    width = timelineController.highlightWidth;
  }
}
