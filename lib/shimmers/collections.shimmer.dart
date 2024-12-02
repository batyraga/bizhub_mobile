import 'package:bizhub/shimmers/collection.shimmer.dart';
import 'package:flutter/material.dart';

class ShimmerCollections extends StatelessWidget {
  const ShimmerCollections({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        ShimmerCollection(),
        SizedBox(
          height: 15.0,
        ),
        ShimmerCollection(),
        SizedBox(
          height: 15.0,
        ),
        ShimmerCollection(),
      ],
    );
  }
}
