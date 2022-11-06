import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/timeline_highlight_provider.dart';
import 'utils/datetime.dart';

class GanttTimelineHighlight extends ConsumerWidget {
  const GanttTimelineHighlight({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.watch(ganttTimelineHighlightProvider);
    if (provider == null) {
      return const Positioned(left: 0, child: SizedBox());
    }

    return Positioned(
      left: provider.left,
      top: 0,
      bottom: 0,
      child: Container(
        width: provider.width,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: const BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.all(Radius.circular(2)),
        ),
        child: Row(
          children: [
            Text(provider.startDate.format('MM-dd')),
            const Spacer(),
            if (provider.startDate != provider.endDate)
              Text(provider.endDate.format('MM-dd'))
          ],
        ),
      ),
    );
  }
}
