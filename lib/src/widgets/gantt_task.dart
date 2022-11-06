import 'package:flutter/material.dart';
import 'package:gantt/src/widgets/focus_container.dart';

import 'gantt_item.dart';
import 'gantt_progress_bar.dart';
import 'mixin/drag_action.dart';
import 'mixin/progress_action.dart';
import 'mixin/resize_action.dart';

typedef GanttTaskActionCallback = void Function(double left, double width);

class GanttTaskWidget extends StatefulWidget {
  const GanttTaskWidget({
    super.key,
    this.title = '',
    this.left = 0,
    this.width = 0,
    this.containerHeight = 36,
    this.progressHeight = 20,
    this.progress = 0,
    this.progressBackgroundColor = const Color(0xFFBBDEFB),
    this.progressProgressColor = Colors.blue,
    this.onResizeLeftStart,
    this.onResizeLeft,
    this.onResizeLeftEnd,
    this.onResizeRightStart,
    this.onResizeRight,
    this.onResizeRightEnd,
    this.onDragStart,
    this.onDrag,
    this.onDragEnd,
    this.onProgressChangeStart,
    this.onProgressChange,
    this.onProgressChangeEnd,
    this.onFocusIn,
    this.onFocusOut,
  });
  final String title;
  final double left;
  final double width;
  final int progress;
  final double containerHeight;
  final double progressHeight;
  final double progressCursorSize = 12;
  final double resizeHandleWidth = 12;
  final Color progressBackgroundColor;
  final Color progressProgressColor;

  //开始调整大小
  final GanttTaskActionCallback? onResizeLeftStart;

  //调整大小的回调函数
  final GanttTaskActionCallback? onResizeLeft;

  //左偏移量调整大小结束的回调函数
  final GanttTaskActionCallback? onResizeLeftEnd;

  //开始调整大小
  final GanttTaskActionCallback? onResizeRightStart;

  //调整大小的回调函数
  final GanttTaskActionCallback? onResizeRight;

  //右偏移量调整大小结束的回调函数
  final GanttTaskActionCallback? onResizeRightEnd;

  //拖拽开始的回调函数
  final GanttTaskActionCallback? onDragStart;

  //拖拽的回调函数
  final GanttTaskActionCallback? onDrag;

  //拖拽结束的回调函数
  final GanttTaskActionCallback? onDragEnd;

  final ValueChanged<int>? onProgressChangeStart;

  final ValueChanged<int>? onProgressChange;

  final ValueChanged<int>? onProgressChangeEnd;

  final VoidCallback? onFocusIn;

  final VoidCallback? onFocusOut;

  @override
  State<StatefulWidget> createState() => _GanttTaskWidgetState();
}

class _GanttTaskWidgetState extends GanttItemState<GanttTaskWidget>
    with DragActionMixin, ResizeActionMixin, ProgressActionMixin {
  //任务是否聚焦
  bool isFocus = false;

  //当任务聚焦时位置加上左边可调整大小的宽度
  //当任务失去焦点时等于任务实际位置
  double get taskLeft => isFocus ? left - widget.resizeHandleWidth : left;

  double get taskWidth =>
      isFocus ? width + widget.resizeHandleWidth * 2 : width;

  double get cursorLeft =>
      widget.resizeHandleWidth - widget.progressCursorSize / 2 + progressWidth;

  @override
  void initState() {
    left = widget.left;
    width = widget.width;
    progress = widget.progress;
    updateProgressWidth();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant GanttTaskWidget oldWidget) {
    pressedOffset -= widget.left - left;
    left = widget.left;
    width = widget.width;
    progress = widget.progress;
    updateProgressWidth();
    super.didUpdateWidget(oldWidget);
  }

  void onFocusIn() {
    setState(() {
      isFocus = true;
    });
    widget.onFocusIn?.call();
  }

  void onFocusOut() {
    setState(() {
      isFocus = false;
    });
    widget.onFocusOut?.call();
  }

  void onDragStart(DragStartDetails details) {
    dragStart(details.globalPosition.dx);
    widget.onDragStart?.call(left, width);
  }

  void onDragUpdate(DragUpdateDetails details) {
    setState(() => dragUpdate(details.globalPosition.dx));
    widget.onDrag?.call(left, width);
  }

  void onDragEnd(DragEndDetails details) {
    widget.onDragEnd?.call(left, width);
  }

  void onResizeLeftStart(DragStartDetails details) {
    resizeLeftStart(details.globalPosition.dx);
    widget.onResizeLeftStart?.call(left, width);
  }

  void onResizeLeftUpdate(DragUpdateDetails details) {
    setState(() {
      resizeLeftUpdate(details.globalPosition.dx);
      updateProgressWidth();
    });
    widget.onResizeLeft?.call(left, width);
  }

  void onResizeLeftEnd(DragEndDetails details) {
    widget.onResizeLeftEnd?.call(left, width);
  }

  void onResizeRightStart(DragStartDetails details) {
    resizeRightStart(details.globalPosition.dx);
    widget.onResizeRightStart?.call(left, width);
  }

  void onResizeRightUpdate(DragUpdateDetails details) {
    setState(() {
      resizeRightUpdate(details.globalPosition.dx);
      updateProgressWidth();
    });

    widget.onResizeRight?.call(left, width);
  }

  void onResizeRightEnd(DragEndDetails details) {
    widget.onResizeRightEnd?.call(left, width);
  }

  void onProgressStart(DragStartDetails details) {
    progressStart(details.globalPosition.dx);
    widget.onProgressChangeStart?.call(progress);
  }

  void onProgressUpdate(DragUpdateDetails details) {
    setState(() => progressUpdate(details.globalPosition.dx));
    widget.onProgressChange?.call(progress);
  }

  void onProgressEnd(DragEndDetails details) {
    widget.onProgressChangeEnd?.call(progress);
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
        onHorizontalDragEnd: onProgressEnd,
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
          child: FocusContainer(
            focus: isFocus,
            onFocusIn: onFocusIn,
            onFocusOut: onFocusOut,
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
                              visible: isFocus, child: buildResizeLeft()),
                          GestureDetector(
                            onHorizontalDragStart: onDragStart,
                            onHorizontalDragUpdate: onDragUpdate,
                            onHorizontalDragEnd: onDragEnd,
                            child: GanttProgressBar(
                              width: width,
                              progressWidth: progressWidth,
                              backgroundColor: widget.progressBackgroundColor,
                              progressColor: widget.progressProgressColor,
                            ),
                          ),
                          Visibility(
                              visible: isFocus, child: buildResizeRight()),
                        ],
                      ),
                    ),
                  ),
                  Visibility(visible: isFocus, child: buildCursor()),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
