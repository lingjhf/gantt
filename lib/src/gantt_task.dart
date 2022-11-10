import 'package:flutter/material.dart';

import 'controllers/task_controller.dart';
import 'gantt_progress_bar.dart';

class GanttTask extends StatefulWidget {
  const GanttTask({
    super.key,
    required this.controller,
    this.title = '',
    this.containerHeight = 36,
    this.progressHeight = 20,
    this.progressBackgroundColor = const Color(0xFFBBDEFB),
    this.progressProgressColor = Colors.blue,
  });
  final String title;

  final double containerHeight;
  final double progressHeight;
  final double progressCursorSize = 12;
  final double resizeHandleWidth = 12;
  final Color progressBackgroundColor;
  final Color progressProgressColor;
  final GanttTaskController controller;

  @override
  State<StatefulWidget> createState() => _GanttTaskState();
}

class _GanttTaskState extends State<GanttTask> {
  //当任务聚焦时位置加上左边可调整大小的宽度
  //当任务失去焦点时等于任务实际位置
  double get taskLeft => widget.controller.focused
      ? widget.controller.left - widget.resizeHandleWidth
      : widget.controller.left;

  double get taskWidth => widget.controller.focused
      ? widget.controller.width + widget.resizeHandleWidth * 2
      : widget.controller.width;

  double get cursorLeft =>
      widget.resizeHandleWidth -
      widget.progressCursorSize / 2 +
      widget.controller.progressWidth;

  @override
  void initState() {
    widget.controller.onFocusOut(() => setState(() {}));
    super.initState();
  }

  @override
  void didUpdateWidget(covariant GanttTask oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void onDragStart(DragStartDetails details) {
    widget.controller.dragStart(details.globalPosition.dx);
  }

  void onDragUpdate(DragUpdateDetails details) {
    setState(() => widget.controller.dragUpdate(details.globalPosition.dx));
  }

  void onDragEnd(DragEndDetails details) {
    setState(() => widget.controller.dragEnd());
  }

  void onResizeLeftStart(DragStartDetails details) {
    widget.controller.resizeLeftStart(details.globalPosition.dx);
  }

  void onResizeLeftUpdate(DragUpdateDetails details) {
    setState(
        () => widget.controller.resizeLeftUpdate(details.globalPosition.dx));
  }

  void onResizeLeftEnd(DragEndDetails details) {
    setState(() => widget.controller.resizeLeftEnd());
  }

  void onResizeRightStart(DragStartDetails details) {
    widget.controller.resizeRightStart(details.globalPosition.dx);
  }

  void onResizeRightUpdate(DragUpdateDetails details) {
    setState(
        () => widget.controller.resizeRightUpdate(details.globalPosition.dx));
  }

  void onResizeRightEnd(DragEndDetails details) {
    setState(() => widget.controller.resizeRightEnd());
  }

  void onProgressStart(DragStartDetails details) {
    widget.controller.progressStart(details.globalPosition.dx);
  }

  void onProgressUpdate(DragUpdateDetails details) {
    setState(() => widget.controller.progressUpdate(details.globalPosition.dx));
  }

  void onTap() {
    widget.controller.onFocusIn(() => setState(() {}));
  }

  Widget buildResizeLeft() {
    return SizedBox(
      width: widget.resizeHandleWidth,
      child: GestureDetector(
        onHorizontalDragStart: onResizeLeftStart,
        onHorizontalDragUpdate: onResizeLeftUpdate,
        onHorizontalDragEnd: onResizeLeftEnd,
        child: MouseRegion(
          cursor: SystemMouseCursors.resizeLeft,
          child: Row(
            children: [
              Container(
                width: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    width: 2,
                    color: Colors.grey,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildResizeRight() {
    return SizedBox(
      width: widget.resizeHandleWidth,
      child: GestureDetector(
        onHorizontalDragStart: onResizeRightStart,
        onHorizontalDragUpdate: onResizeRightUpdate,
        onHorizontalDragEnd: onResizeRightEnd,
        child: MouseRegion(
          cursor: SystemMouseCursors.resizeRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    width: 2,
                    color: Colors.grey,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCursor() {
    return Positioned(
      left: cursorLeft,
      bottom: 0,
      child: GestureDetector(
        onHorizontalDragStart: onProgressStart,
        onHorizontalDragUpdate: onProgressUpdate,
        child: Container(
          width: widget.progressCursorSize,
          height: widget.progressCursorSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 2, color: Colors.grey),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: taskLeft,
          child: SizedBox(
            width: taskWidth,
            height: widget.containerHeight,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  child: SizedBox(
                    height: widget.progressHeight,
                    child: Row(
                      children: [
                        Visibility(
                          visible: widget.controller.focused,
                          child: buildResizeLeft(),
                        ),
                        GestureDetector(
                          onTap: onTap,
                          onHorizontalDragStart: onDragStart,
                          onHorizontalDragUpdate: onDragUpdate,
                          onHorizontalDragEnd: onDragEnd,
                          child: GanttProgressBar(
                            width: widget.controller.width,
                            progressWidth: widget.controller.progressWidth,
                            backgroundColor: widget.progressBackgroundColor,
                            progressColor: widget.progressProgressColor,
                          ),
                        ),
                        Visibility(
                          visible: widget.controller.focused,
                          child: buildResizeRight(),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                    visible: widget.controller.focused, child: buildCursor()),
              ],
            ),
          ),
        )
      ],
    );
  }
}
