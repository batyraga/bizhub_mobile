import 'package:flutter/material.dart';
import 'package:bizhub/config/constants.dart';

class DefaultScrollView extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  const DefaultScrollView({super.key, this.padding, required this.child});
  @override
  State<DefaultScrollView> createState() => _DefaultScrollViewState();
}

class _DefaultScrollViewState extends State<DefaultScrollView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: widget.padding ??
          const EdgeInsets.only(
              left: defaultPadding,
              right: defaultPadding,
              bottom: defaultPadding),
      child: widget.child,
    );
  }
}
