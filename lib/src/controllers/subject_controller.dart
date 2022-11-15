import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'connect_controller.dart';
import 'gantt_controller.dart';
import 'timeline_controller.dart';

typedef SubjectMap = Map<String, GanttSubjectController>;

abstract class GanttSubjectController {
  GanttSubjectController({
    String? id,
    required this.ganttController,
    required this.timelineController,
    required this.connectLineController,
  }) : id = id ?? const Uuid().v1();
  final String id;

  final GlobalKey key = GlobalKey();

  double left = 0;

  double width = 0;

  bool focused = false;

  GanttController ganttController;

  GanttTimelineController timelineController;

  GanttConnectLineController connectLineController;

  final SubjectMap _nextSubjects = {};

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

  GanttSubjectController? getNextSubject(String id) {
    return _nextSubjects[id];
  }

  void addNextSubject(String id, GanttSubjectController subject) {
    _nextSubjects[id] = subject;
  }

  void remoteNextSubject(String id) {
    _nextSubjects.remove(id);
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
    if (!ganttController.currentSubject!.connectActive) return;
    if (ganttController.currentSubject!.getNextSubject(id) != null) return;
    if (checkCircularConnect(ganttController.currentSubject!.id)) return;
    ganttController.currentSubject!.addNextSubject(id, this);
    connectLineController.addByGlobKey(
      ganttController.currentSubject!.key,
      key,
    );
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
