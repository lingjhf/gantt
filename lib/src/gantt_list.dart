import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GanttList extends ConsumerWidget {
  const GanttList({super.key, this.children = const []});

  final List<Widget> children;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      itemCount: children.length,
      itemBuilder: (context, index) {
        return Container(
          height: 60,
          padding: const EdgeInsets.only(top: 8),
          child: children[index],
        );
      },
    );
  }
}
