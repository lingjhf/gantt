import 'package:flutter/material.dart';

import '../mixins/event_bus.dart';
import 'connect_line_controller.dart';

//控制添加连接和删除连接
class GanttConnectContainerController with EventBusMixin {
  GanttConnectContainerController();

  final GlobalKey key = GlobalKey();

  final List<GanttConnectLineController> connectLines = [];

  Offset getRelativeOffset(Offset point) {
    return (key.currentContext?.findRenderObject() as RenderBox?)
            ?.globalToLocal(point) ??
        Offset.zero;
  }

  void addConnectLine(GanttConnectLineController connectLine) {
    connectLines.add(
      connectLine
        ..startOffset = getRelativeOffset(connectLine.startOffset)
        ..endOffset = getRelativeOffset(connectLine.endOffset),
    );
    emit('addConnectLine');
  }
}
