import 'package:flutter/material.dart';

import '../mixins/event_bus.dart';
import 'subject_controller.dart';

enum ConnectUpdateType {
  start,
  end,
}

class GanttConnectLineController with EventBusMixin {
  GanttConnectLineController({
    required this.startSubject,
    required this.endSubject,
  }) {
    update();
  }

  GanttSubjectController startSubject;
  GanttSubjectController endSubject;

  Offset startOffset = Offset.zero;
  Offset endOffset = Offset.zero;

  void _updateStart() {
    final startBox =
        startSubject.key.currentContext?.findRenderObject() as RenderBox?;
    final startBoxOffset = startBox?.localToGlobal(Offset.zero) ?? Offset.zero;
    final startBoxSize = startBox?.size ?? Size.zero;
    startOffset = Offset(
      startBoxOffset.dx + startBoxSize.width,
      startBoxOffset.dy + (startBoxSize.height / 2),
    );
  }

  void _upateEnd() {
    final endBox =
        endSubject.key.currentContext?.findRenderObject() as RenderBox?;
    final endBoxOffset = endBox?.localToGlobal(Offset.zero) ?? Offset.zero;
    final endBoxSize = endBox?.size ?? Size.zero;
    endOffset = Offset(
      endBoxOffset.dx,
      endBoxOffset.dy + (endBoxSize.height / 2),
    );
  }

  void update({ConnectUpdateType? only}) {
    switch (only) {
      case ConnectUpdateType.start:
        _updateStart();
        break;
      case ConnectUpdateType.end:
        _upateEnd();
        break;
      default:
        _updateStart();
        _upateEnd();
    }
    emit('update');
  }
}
