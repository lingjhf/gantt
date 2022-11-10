import 'package:flutter/material.dart';
import 'package:gantt/src/controllers/timeline_conroller.dart';

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
    widget.controller.on('onHighlightChange', () {
      setState(() {});
    });
    super.initState();
  }

  String get startDateText =>
      widget.controller.highlightStartDate?.format('MM-dd') ?? '';

  String get endDateText =>
      widget.controller.highlightStartDate != widget.controller.highlightEndDate
          ? widget.controller.highlightEndDate?.format('MM-dd') ?? ''
          : '';

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.controller.highlightLeft,
      top: 0,
      bottom: 0,
      child: Visibility(
        visible: widget.controller.highlightVisible,
        child: Container(
          width: widget.controller.highlightWidth,
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
