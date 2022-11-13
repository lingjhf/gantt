class ProgressController {
  ProgressController({int progress = 0, double width = 0})
      : _progress = progress,
        _width = width {
    _updateProgressWidth();
  }
  //进度
  int _progress = 0;

  double _width = 0;

  //进度条的宽度
  double _progressWidth = 0;

  //每一个百分点的宽度
  double _percentageWidth = 0;

  double _pressedOffset = 0;

  double get progressWidth => _progressWidth;

  set width(double value) {
    _width = value;
    _updateProgressWidth();
  }

  int get progress => _progress;

  set progress(int value) {
    _progress = value;
    _updateProgressWidth();
  }

  void _updateProgressWidth() {
    _progressWidth = _width * _progress / 100;
  }

  //开始改变进度
  void progressStart(double dx) {
    _percentageWidth = _width / 100;
    _pressedOffset = dx - _progressWidth;
  }

  //改变进度
  void progressUpdate(double dx) {
    var w = _percentageWidth * ((dx - _pressedOffset) ~/ _percentageWidth);

    if (w > _width) {
      w = _width;
    }
    if (w < 0) {
      w = 0;
    }
    _progress = w > 0 ? w * 100 ~/ _width : 0;
    _progressWidth = w;
  }
}
