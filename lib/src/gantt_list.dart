import 'package:flutter/material.dart';

class GanttList extends StatelessWidget {
  const GanttList({super.key, this.children = const []});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
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
