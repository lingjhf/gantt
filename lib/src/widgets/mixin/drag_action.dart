import 'package:flutter/material.dart';

import '../gantt_item.dart';


mixin DragActionMixin<T extends StatefulWidget> on GanttItemState<T> {
  //开始拖拽
  void dragStart(double dx) {
    pressedOffset = dx - left;
  }

  //正在拖拽
  void dragUpdate(double dx) {
    left = dx - pressedOffset;
  }
}

