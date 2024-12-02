import 'package:bizhub/shimmers/seller_card.shimmer.dart';
import 'package:flutter/material.dart';

class ShimmerSellers extends StatelessWidget {
  const ShimmerSellers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: const [
          ShimmerSellerCard(),
          ShimmerSellerCard(),
          ShimmerSellerCard(),
          ShimmerSellerCard(),
          ShimmerSellerCard(),
          ShimmerSellerCard(),
        ],
      ),
    );
  }
}
