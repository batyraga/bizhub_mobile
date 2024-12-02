import 'package:bizhub/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerSellerCard extends StatelessWidget {
  final bool? disablePadding;
  const ShimmerSellerCard({Key? key, this.disablePadding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: disablePadding != true ? const EdgeInsets.all(15.0) : null,
      child: Row(
        children: [
          Shimmer.fromColors(
              baseColor: shimmerBaseColor,
              highlightColor: shimmerHighlightColor,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                width: 50.0,
                height: 50.0,
              )),
          const SizedBox(
            width: 15.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                  baseColor: shimmerBaseColor,
                  highlightColor: shimmerHighlightColor,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.0)),
                    width: 150.0,
                    height: 15.0,
                  )),
              const SizedBox(
                height: 6.0,
              ),
              Shimmer.fromColors(
                  baseColor: shimmerBaseColor,
                  highlightColor: shimmerHighlightColor,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.0)),
                    width: 90.0,
                    height: 10.0,
                  )),
            ],
          )
        ],
      ),
    );
  }
}
