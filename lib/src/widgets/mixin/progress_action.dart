import 'package:flutter/material.dart';

import '../gantt_item.dart';

mixin ProgressActionMixin<T extends StatefulWidget> on GanttItemState<T> {
  int progress = 0;

  //进度条的宽度
  double progressWidth = 0;

  //每一个百分点的宽度
  double percentageWidth = 0;

  void updateProgressWidth() {
    progressWidth = width * progress / 100;
  }

  void progressStart(double dx) {
    percentageWidth = width / 100;
    pressedOffset = dx - progressWidth;
  }

  void progressUpdate(double dx) {
    var w = percentageWidth * ((dx - pressedOffset) ~/ percentageWidth);

    if (w > width) {
      w = width;
    }
    if (w < 0) {
      w = 0;
    }
    progress = w > 0 ? w * 100 ~/ width : 0;
    progressWidth = w;
  }
}
