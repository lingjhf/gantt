mixin DragResizeMixin {
  double _left = 0;
  double _width = 0;
  double _pressedOffset = 0;

  double _deltaX = 0;

  double get left => _left;
  set left(double value) {
    if (value != left) {
      _pressedOffset = _pressedOffset - (value - _left);
    }
    _left = value;
  }

  double get width => _width;
  set width(double value) {
    if (value < 0) {
      _width = 0;
      return;
    }
    _width = value;
  }

  double get deltaX => _deltaX;

  //开始拖拽
  void dragStart(double dx) {
    _pressedOffset = dx - _left;
  }

  //正在拖拽
  void dragUpdate(double dx) {
    var tempLeft = dx - _pressedOffset;
    _deltaX = tempLeft - _left;
    _left = tempLeft;
  }

  void resizeLeftStart(double dx) {
    _pressedOffset = dx - _left;
  }

  void resizeLeftUpdate(double dx) {
    var leftWidthSum = _left + width;
    var tempLeft = dx - _pressedOffset;
    var tempWidth = leftWidthSum - tempLeft;
    if (tempLeft > leftWidthSum) {
      _left = leftWidthSum;
      width = 0;
    } else {
      _left = tempLeft;
      width = tempWidth;
    }
  }

  //开始向右调整大小
  void resizeRightStart(double dx) {
    _pressedOffset = dx - width;
  }

  //正在向右调整大小
  void resizeRightUpdate(double dx) {
    width = dx - _pressedOffset;
  }
}
