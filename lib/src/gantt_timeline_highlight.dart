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
  Widget build(BuildContext context) {
    if (!widget.controller.highlightVisible) {
      return const Positioned(left: 0, child: SizedBox());
    }

    return Positioned(
      left: widget.controller.highlightLeft,
      top: 0,
      bottom: 0,
      child: Container(
        width: widget.controller.highlightWidth,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: const BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.all(Radius.circular(2)),
        ),
        child: Row(
          children: [
            Text(widget.controller.highlightStartDate!.format('MM-dd')),
            const Spacer(),
            if (widget.controller.highlightStartDate !=
                widget.controller.highlightEndDate)
              Text(widget.controller.highlightEndDate!.format('MM-dd'))
          ],
        ),
      ),
    );
  }
}
