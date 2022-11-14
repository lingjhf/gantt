import 'package:flutter/material.dart';

import 'controllers/timeline_controller.dart';
import 'utils/datetime.dart';

class GanttTimelineHighlight extends StatefulWidget {
  const GanttTimelineHighlight({super.key, required this.controller});

  final GanttTimelineController controller;
  @override
  State<StatefulWidget> createState() => _GanttTimelineHighlightState();
}

class _GanttTimelineHighlightState extends State<GanttTimelineHighlight> {
  @override
  void initState() {
    widget.controller.on('onHighlightChange', (arg) {
      setState(() {});
    });
    super.initState();
  }

  String get startDateText =>
      widget.controller.highlight.startDate?.format('MM-dd') ?? '';

  String get endDateText => widget.controller.highlight.startDate !=
          widget.controller.highlight.endDate
      ? widget.controller.highlight.endDate?.format('MM-dd') ?? ''
      : '';

  double singleDateMinWidth = 45;

  double multiDateMinWidth = 80;

  double get width {
    if (widget.controller.highlight.startDate ==
        widget.controller.highlight.endDate) {
      if (widget.controller.unit.dayWidth > singleDateMinWidth) {
        return widget.controller.unit.dayWidth;
      }
      return singleDateMinWidth;
    }
    if (widget.controller.highlight.width < multiDateMinWidth) {
      return multiDateMinWidth;
    }

    return widget.controller.highlight.width;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.controller.highlight.left,
      top: 0,
      bottom: 0,
      child: Visibility(
        visible: widget.controller.highlight.visible,
        child: Container(
          width: width,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: const BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.all(Radius.circular(2)),
          ),
          child: Row(
            children: [Text(startDateText), const Spacer(), Text(endDateText)],
          ),
        ),
      ),
    );
  }
}
