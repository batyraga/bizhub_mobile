import 'package:flutter/material.dart';

class FadeTransitionPageRoute<T> extends PageRouteBuilder<T>
    with MaterialRouteTransitionMixin<T> {
  final Widget Function(BuildContext context) builder;
  FadeTransitionPageRoute({required this.builder})
      : super(
            transitionDuration: const Duration(milliseconds: 150),
            reverseTransitionDuration: const Duration(milliseconds: 150),
            pageBuilder: (context, animation, secondaryAnimation) =>
                builder(context));

  @override
  Widget buildContent(BuildContext context) => builder(context);

  @override
  Widget buildTransitions(context, animation, secondaryAnimation, child) {
    return FadeTransition(
        opacity: Tween<double>(end: 1.0, begin: 0.0).animate(animation),
        child: child);
  }
}
