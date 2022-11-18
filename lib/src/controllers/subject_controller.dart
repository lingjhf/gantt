import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'connect_controller.dart';
import 'connect_line_controller.dart';
import 'gantt_controller.dart';
import 'timeline_controller.dart';

typedef SubjectMap = Map<String, GanttSubjectController>;

typedef ConnectLineMap = Map<String, GanttConnectLineController>;

abstract class GanttSubjectController {
  GanttSubjectController({
    String? id,
    required this.ganttController,
    required this.timelineController,
    required this.connectContainerController,
  }) : id = id ?? const Uuid().v1();
  final String id;

  final GlobalKey key = GlobalKey();

  double left = 0;

  double width = 0;

  bool focused = false;

  GanttController ganttController;

  GanttTimelineController timelineController;

  GanttConnectContainerController connectContainerController;

  final SubjectMap _nextSubjects = {};

  final SubjectMap _prevSubjects = {};

  final ConnectLineMap _nextConnectLines = {};

  final ConnectLineMap _prevConnectLines = {};

  bool connectActive = false;

  double get dayWidth => timelineController.unit.dayWidth;

  double get scrollOffset => timelineController.scrollController.offset;

  void scrollJumpTo(double value) {
    timelineController.scrollController.jumpTo(value);
  }

  //显示时间轴高亮日期
  void visibleTimelineHighlight() {
    timelineController.updateHighlight(visible: true);
  }

  //隐藏时间轴高亮日期
  void invisibleTimelineHighlight() {
    timelineController.updateHighlight(visible: false);
  }

  double getSubjectLeft(DateTime date) {
    var startIndex = timelineController.dates.indexOf(date);
    startIndex = startIndex < 0 ? 0 : startIndex;
    return startIndex * dayWidth;
  }

  bool leftOverflowTimeline(DateTime date) {
    if (left < 0) {
      timelineController.addForwardDay();
      left = getSubjectLeft(date);
      timelineController.updateHighlight(left: left);
      return true;
    }
    return false;
  }

  bool rightOverflowTimeline(DateTime date) {
    if (left + width > timelineController.totalWidth) {
      timelineController.addBackDay();
      left = getSubjectLeft(date);
      return true;
    }
    return false;
  }

  void leftOverflowViewWidth() {
    if (left < timelineController.scrollController.offset) {
      timelineController.scrollController.jumpTo(left);
    }
  }

  void rightOverflowViewWidth() {
    var scrollOffset = timelineController.scrollController.offset;
    var leftWidthSum = left + width;
    var offsetWidthSum = scrollOffset + timelineController.viewWidth;
    if (leftWidthSum > offsetWidthSum) {
      timelineController.scrollController
          .jumpTo(scrollOffset + (leftWidthSum - offsetWidthSum));
    }
  }

  GanttSubjectController? getPrevSubject(String id) {
    return _prevSubjects[id];
  }

  GanttConnectLineController? getPrevConnectLine(String id) {
    return _prevConnectLines[id];
  }

  void connectPrevSubject(
    String id,
    GanttSubjectController subject,
    GanttConnectLineController connect,
  ) {
    _prevSubjects[id] = subject;
    _prevConnectLines[id] = connect;
  }

  void disconnectPrevSubject(String id) {
    _prevSubjects.remove(id);
    _nextConnectLines.remove(id);
  }

  GanttSubjectController? getNextSubject(String id) {
    return _nextSubjects[id];
  }

  GanttConnectLineController? getNextConnectLine(String id) {
    return _nextConnectLines[id];
  }

  void connectNextSubject(
    String id,
    GanttSubjectController subject,
    GanttConnectLineController connect,
  ) {
    _nextSubjects[id] = subject;
    _nextConnectLines[id] = connect;
  }

  void disconnectNextSubject(String id) {
    _nextSubjects.remove(id);
    _nextConnectLines.remove(id);
  }

  //检查是否存在循环连接
  bool checkCircularConnect(String id) {
    if (getNextSubject(id) != null) return true;
    bool found = false;
    if (_nextSubjects.isNotEmpty) {
      _nextSubjects.forEach((key, value) {
        if (value.checkCircularConnect(id)) {
          focused = true;
          return;
        }
      });
    }
    return found;
  }

  //被动连接
  //1.判断是否有当期subject
  //2.判断是否激活连接
  //3.判断是否已连接
  //4.判断是否会导致循环连接
  void passiveConnect() {
    if (ganttController.currentSubject == null) return;
    final ganttCurrentSubject = ganttController.currentSubject!;
    if (!ganttCurrentSubject.connectActive) return;
    if (ganttCurrentSubject.getNextSubject(id) != null) return;
    if (checkCircularConnect(ganttCurrentSubject.id)) return;
    final connectLine = GanttConnectLineController(
      startSubject: ganttCurrentSubject,
      endSubject: this,
    );
    ganttCurrentSubject.connectNextSubject(id, this, connectLine);
    connectPrevSubject(id, ganttCurrentSubject, connectLine);
    connectContainerController.addConnectLine(connectLine);
  }

  void updateNextConnect() {
    for (final connect in _nextConnectLines.values) {
      connect.update();
      connect.startOffset =
          connectContainerController.getRelativeOffset(connect.startOffset);
      connect.endOffset =
          connectContainerController.getRelativeOffset(connect.endOffset);
    }
  }

  void updatePrevConnect() {
    for (final connect in _prevConnectLines.values) {
      connect.update();
      connect.startOffset =
          connectContainerController.getRelativeOffset(connect.startOffset);
      connect.endOffset =
          connectContainerController.getRelativeOffset(connect.endOffset);
    }
  }

  void updateConnect() {
    updateNextConnect();
    updatePrevConnect();
  }

  void onConnectNext(bool active) {
    connectActive = active;
  }

  void onFocusOut(VoidCallback callback) {
    ganttController.on('onCurrentSubjectChange', (oldId) {
      if (id == oldId) {
        focused = false;
        invisibleTimelineHighlight();
        callback();
      }
    });
  }

  void onFocusIn(VoidCallback callback) {
    if (id != ganttController.currentSubject?.id) {
      passiveConnect();
      focused = true;
      ganttController.setCurrentSubject(this);
      visibleTimelineHighlight();
      callback();
    }
  }
}
