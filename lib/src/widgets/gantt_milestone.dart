import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'focus_container.dart';
import 'gantt_item.dart';
import 'mixin/drag_action.dart';

class GanttMilestoneWidget extends StatefulWidget {
  const GanttMilestoneWidget({
    super.key,
    this.title = '',
    this.left = 0,
    this.size = 16,
    this.finished = false,
    this.onDragStart,
    this.onDrag,
    this.onDragEnd,
    this.onFocusIn,
    this.onFocusOut,
  });

  //标题
  final String title;

  final double left;

  final double size;

  final bool finished;

  final ValueChanged<double>? onDragStart;

  final ValueChanged<double>? onDrag;

  final ValueChanged<double>? onDragEnd;

  final Function()? onFocusIn;

  final Function()? onFocusOut;

  @override
  State<StatefulWidget> createState() => _GanttMilestoneWidget();
}

class _GanttMilestoneWidget extends GanttItemState<GanttMilestoneWidget>
    with DragActionMixin {
  bool finished = false;

  @override
  void initState() {
    left = widget.left;
    finished = widget.finished;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant GanttMilestoneWidget oldWidget) {
    pressedOffset -= widget.left - left;
    left = widget.left;
    finished = widget.finished;
    super.didUpdateWidget(oldWidget);
  }

  void onFocusIn() {
    widget.onFocusIn?.call();
  }

  void onFocusOut() {
    widget.onFocusOut?.call();
  }

  void onDragStart(DragStartDetails details) {
    dragStart(details.globalPosition.dx);
    widget.onDragStart?.call(left);
  }

  void onDragUpdate(DragUpdateDetails details) {
    setState(() {
      dragUpdate(details.globalPosition.dx);
    });
    widget.onDrag?.call(left);
  }

  void onDragEnd(DragEndDetails details) {
    widget.onDragEnd?.call(left);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: left,
          child: FocusContainer(
            onFocusIn: onFocusIn,
            onFocusOut: onFocusOut,
            child: GestureDetector(
              onHorizontalDragStart: onDragStart,
              onHorizontalDragUpdate: onDragUpdate,
              onHorizontalDragEnd: onDragEnd,
              child: Transform.rotate(
                angle: math.pi / 4,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 2),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
