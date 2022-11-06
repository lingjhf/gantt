import 'package:flutter/material.dart';

abstract class GanttItemState<T extends StatefulWidget> extends State<T> {
  double left = 0;
  double _width = 0;

  set width(double value) {
    if (value < 0) {
      _width = 0;
      return;
    }
    _width = value;
  }

  double get width => _width;
  double pressedOffset = 0;
}
