import 'package:bizhub/shimmers/post.shimmer.dart';
import 'package:flutter/material.dart';

class ShimmerPosts extends StatelessWidget {
  const ShimmerPosts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        ShimmerPost(),
        ShimmerPost(),
        ShimmerPost(),
        ShimmerPost(),
      ],
    );
  }
}
