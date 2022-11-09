import 'package:flutter/material.dart';
import 'package:gantt/src/models/subject.dart';

import 'enums.dart';
import 'gantt_container.dart';

class Gantt extends StatelessWidget {
  const Gantt({
    super.key,
    required this.startDate,
    required this.endDate,
    this.unit = GanttDateUnit.day,
    this.scrollController,
    this.data = const [],
  });

  final DateTime startDate;
  final DateTime endDate;
  final GanttDateUnit unit;
  final ScrollController? scrollController;
  final List<GanttSubjectData> data;

  @override
  Widget build(BuildContext context) {
    var scrollController = this.scrollController ?? ScrollController();
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          child: Scrollbar(
            thumbVisibility: true,
            controller: scrollController,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: scrollController,
              child: GanttContainer(
                startDate: startDate,
                endDate: endDate,
                unit: unit,
                viewWidth: constraints.maxWidth,
                scrollController: scrollController,
                data: data,
              ),
            ),
          ),
        );
      },
    );
  }
}

// ignore: must_be_immutable