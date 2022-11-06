import 'package:flutter/material.dart';

class FocusContainer extends StatefulWidget {
  const FocusContainer({
    super.key,
    required this.child,
    this.focus = false,
    this.onFocusIn,
    this.onFocusOut,
  });

  final bool focus;
  final Widget child;

  final void Function()? onFocusIn;

  final void Function()? onFocusOut;

  @override
  State<StatefulWidget> createState() => _FocusContainer();
}

class _FocusContainer extends State<FocusContainer> {
  late FocusNode focusNode;

  @override
  void initState() {
    focusNode = FocusNode();
    super.initState();
  }

  void onTap() {
    focusNode.requestFocus();
  }

  void onFocusChange(bool value) {
    if (value) {
      widget.onFocusIn?.call();
    } else {
      widget.onFocusOut?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      focusNode: focusNode,
      mouseCursor: SystemMouseCursors.basic,
      onTap: onTap,
      onFocusChange: onFocusChange,
      child: widget.child,
    );
  }
}
