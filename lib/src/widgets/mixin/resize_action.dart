import 'package:flutter/material.dart';

import '../gantt_item.dart';

mixin ResizeActionMixin<T extends StatefulWidget> on GanttItemState<T> {
  void resizeLeftStart(double dx) {
    pressedOffset = dx - left;
  }

  void resizeLeftUpdate(double dx) {
    var leftWidthSum = left + width;
    var tempLeft = dx - pressedOffset;
    var tempWidth = leftWidthSum - tempLeft;
    if (tempLeft > leftWidthSum) {
      left = leftWidthSum;
      width = 0;
    } else {
      left = tempLeft;
      width = tempWidth;
    }
  }

  //开始向右调整大小
  void resizeRightStart(double dx) {
    pressedOffset = dx - width;
  }

  //正在向右调整大小
  void resizeRightUpdate(double dx) {
    width = dx - pressedOffset;
  }
}
