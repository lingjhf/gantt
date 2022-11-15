import 'package:flutter/material.dart';

import '../models/connect_line.dart';

class GanttConnectLineController {
  GanttConnectLineController();

  final List<ConnectLineData> _connectLines = [];

  Offset getOffsetByGlobalKey(GlobalKey key) {
    var renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    var offset = renderBox?.globalToLocal(Offset.zero);
    return offset ?? Offset.zero;
  }

  void addByGlobKey(GlobalKey startKey, GlobalKey endKey) {
    _connectLines.add(
      ConnectLineData(
        startOffset: getOffsetByGlobalKey(startKey),
        endOffset: getOffsetByGlobalKey(endKey),
      ),
    );
  }
}
