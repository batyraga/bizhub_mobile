import 'package:bizhub/config/constants.dart';
import 'package:bizhub/shimmers/grid_view_for_products.shimmer.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCollection extends StatelessWidget {
  const ShimmerCollection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 15.0,
          ),
          Shimmer.fromColors(
              baseColor: shimmerBaseColor,
              highlightColor: shimmerHighlightColor,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0)),
                width: 100,
                height: 22.0,
              )),
          const SizedBox(
            height: 15.0,
          ),
          const ShimmerGridViewForProducts(
            disablePadding: true,
            // shrinkWrap: false,
            productsCount: 2,
          ),
          const SizedBox(
            height: 15.0,
          ),
        ],
      ),
    );
  }
}
