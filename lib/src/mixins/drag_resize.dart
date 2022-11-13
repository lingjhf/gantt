mixin DragResizeMixin {
  double left = 0;

  double _width = 0;

  double deltaX = 0;

  set width(double value) {
    if (value < 0) {
      _width = 0;
      return;
    }
    _width = value;
  }

  double get width => _width;
  double pressedOffset = 0;

  //开始拖拽
  void dragStart(double dx) {
    pressedOffset = dx - left;
  }

  //正在拖拽
  void dragUpdate(double dx) {
    var tempLeft = dx - pressedOffset;
    deltaX = tempLeft - left;
    left = tempLeft;
  }

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
