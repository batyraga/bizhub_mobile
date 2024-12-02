import 'package:flutter/material.dart';

class SlideTransitionPageRoute extends PageRouteBuilder {
  final Widget child;
  SlideTransitionPageRoute({required this.child})
      : super(
            transitionDuration: const Duration(milliseconds: 150),
            reverseTransitionDuration: const Duration(milliseconds: 150),
            pageBuilder: (context, animation, secondaryAnimation) => child);
  @override
  Widget buildTransitions(context, animation, secondaryAnimation, child) {
    return SlideTransition(
        position: Tween<Offset>(end: Offset.zero, begin: const Offset(1, 0))
            .animate(animation),
        child: child);
  }
}
