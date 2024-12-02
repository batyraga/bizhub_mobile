import 'package:bizhub/config/constants.dart';
import 'package:bizhub/shimmers/seller_card.shimmer.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerPost extends StatelessWidget {
  const ShimmerPost({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
          left: 15.0, right: 15.0, bottom: 22.0, top: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerSellerCard(disablePadding: true),
          const SizedBox(
            height: 15.0,
          ),
          Shimmer.fromColors(
            baseColor: shimmerBaseColor,
            highlightColor: shimmerHighlightColor,
            child: LayoutBuilder(builder: (context, constraints) {
              return Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0)),
                width: constraints.maxWidth,
                height: (constraints.maxWidth / 4) * 3,
              );
            }),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Shimmer.fromColors(
            baseColor: shimmerBaseColor,
            highlightColor: shimmerHighlightColor,
            child: LayoutBuilder(builder: (context, constraints) {
              return Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0)),
                width: constraints.maxWidth * 0.8,
                height: 14.0,
              );
            }),
          ),
          const SizedBox(
            height: 5.0,
          ),
          Shimmer.fromColors(
            baseColor: shimmerBaseColor,
            highlightColor: shimmerHighlightColor,
            child: LayoutBuilder(builder: (context, constraints) {
              return Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0)),
                width: constraints.maxWidth * 0.6,
                height: 14.0,
              );
            }),
          ),
          const SizedBox(
            height: 5.0,
          ),
          Shimmer.fromColors(
            baseColor: shimmerBaseColor,
            highlightColor: shimmerHighlightColor,
            child: LayoutBuilder(builder: (context, constraints) {
              return Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0)),
                width: constraints.maxWidth * 0.3,
                height: 14.0,
              );
            }),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Row(
            children: [
              Shimmer.fromColors(
                  baseColor: shimmerBaseColor,
                  highlightColor: shimmerHighlightColor,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100.0)),
                    width: 50.0,
                    height: 34.0,
                  )),
              const SizedBox(
                width: 20.0,
              ),
              Shimmer.fromColors(
                  baseColor: shimmerBaseColor,
                  highlightColor: shimmerHighlightColor,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100.0)),
                    width: 50.0,
                    height: 34.0,
                  )),
              const Spacer(),
              Shimmer.fromColors(
                  baseColor: shimmerBaseColor,
                  highlightColor: shimmerHighlightColor,
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    width: 34.0,
                    height: 34.0,
                  )),
            ],
          )
        ],
      ),
    );
  }
}
