import 'package:flutter/material.dart';

import '../mixins/drag_resize.dart';
import '../utils/gantt.dart';
import 'progress_controller.dart';
import 'subject_controller.dart';

class GanttTaskController extends GanttSubjectController with DragResizeMixin {
  GanttTaskController({
    required super.ganttController,
    required super.timelineController,
    required super.connectLineController,
    DateTime? startDate,
    DateTime? endDate,
    int progress = 0,
  })  : _startDate = startDate ?? DateTime.now(),
        _endDate = endDate ?? DateTime.now() {
    _updateWidthByDate();
    _updateLeftByDate();
    _progressController = ProgressController(progress: progress, width: width);
  }

  DateTime _startDate;

  DateTime _endDate;

  late ProgressController _progressController;

  double get progressWidth => _progressController.progressWidth;

  void _updateLeftByDate() {
    left = getSubjectLeft(_startDate);
  }

  void _updateWidthByDate() {
    width = (_endDate.difference(_startDate).inDays + 1) * dayWidth;
  }

  //显示时间轴高亮日期
  @override
  void visibleTimelineHighlight() {
    timelineController.updateHighlight(
      visible: true,
      width: width,
      left: left,
      startDate: _startDate,
      endDate: _endDate,
    );
  }

  void progressStart(double dx) {
    _progressController.progressStart(dx);
  }

  void progressUpdate(double dx) {
    _progressController.progressUpdate(dx);
  }

  //注册时间轴高亮
  @override
  void dragStart(double dx) {
    super.dragStart(dx);
    if (id != ganttController.currentSubject?.id) {
      focused = true;
      ganttController.setCurrentSubject(this);
    }
    visibleTimelineHighlight();
  }

  //1.判断位置是否小于第一天，小于则需要向前加一天
  //2.判断位置是否大于最后一天，大于则需要向后加一天
  //3.判断位置是否小于可视范围第一天，小于则需要向左移动滚动条
  //4.判断位置是否大于可视范围最后一天，大于则需要向右移动滚动条
  @override
  void dragUpdate(double dx) {
    super.dragUpdate(dx);
    if (leftOverflowTimeline(_startDate)) {
      return;
    }
    if (rightOverflowTimeline(_startDate)) {
      return;
    }
    if (deltaX == 0) return;
    if (deltaX < 0) {
      leftOverflowViewWidth();
    } else {
      rightOverflowViewWidth();
    }
    var startIndex = getStartIndex(left, dayWidth);
    var endIndex = getEndIndex(left, width, dayWidth);

    _startDate = timelineController.dates[startIndex];
    _endDate = timelineController.dates[endIndex - 1];

    timelineController.updateHighlight(
      left: startIndex * dayWidth,
      width: width,
      startDate: _startDate,
      endDate: _endDate,
    );
  }

  void dragEnd() {
    if (!focused) {
      invisibleTimelineHighlight();
    }
    left = timelineController.highlight.left;
  }

  @override
  void resizeLeftStart(double dx) {
    super.resizeLeftStart(dx);
    visibleTimelineHighlight();
  }

  @override
  void resizeLeftUpdate(double dx) {
    super.resizeLeftUpdate(dx);
    _progressController.width = width;
    if (leftOverflowTimeline(_startDate)) return;
    leftOverflowViewWidth();
    if (width > dayWidth) {
      var startIndex = getStartIndex(left, dayWidth);
      _startDate = timelineController.dates[startIndex];
    }
    double highlightLeft = 0;
    double highlightWidth = 0;
    var leftWidthSum = left + width;
    if (width < dayWidth) {
      highlightLeft = leftWidthSum - dayWidth;
      highlightWidth = dayWidth;
    } else {
      highlightLeft = getAlignLeft(left, dayWidth);
      highlightWidth = leftWidthSum - highlightLeft;
    }

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
    left = timelineController.highlight.left;
    width = timelineController.highlight.width;
    _progressController.width = width;
  }

  @override
  void resizeRightStart(double dx) {
    super.resizeRightStart(dx);
    visibleTimelineHighlight();
  }

  @override
  void resizeRightUpdate(double dx) {
    super.resizeRightUpdate(dx);
    _progressController.width = width;
    if (rightOverflowTimeline(_startDate)) return;
    rightOverflowViewWidth();
    if (width > dayWidth) {
      var endIndex = getEndIndex(left, width, dayWidth);
      _endDate = timelineController.dates[endIndex - 1];
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
    width = timelineController.highlight.width;
    _progressController.width = width;
  }

  void onLeftChange(VoidCallback callback) {
    timelineController.on('onAddForwardDay', (p0) {
      _updateLeftByDate();
      callback();
    });
  }
}
