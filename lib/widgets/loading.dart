import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class Loading extends StatefulWidget {
  final bool loading;
  final Widget child;
  const Loading({
    Key? key,
    required this.loading,
    required this.child,
  }) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: widget.loading ? 0 : 1,
      children: [
        const Center(
          child: CircularProgressIndicator(),
        ),
        widget.child,
      ],
    );
  }
}
