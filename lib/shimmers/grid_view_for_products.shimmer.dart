import 'package:bizhub/shimmers/product_card.shimmer.dart';
import 'package:bizhub/widgets/grid_view_for_products.dart';
import 'package:flutter/material.dart';

class ShimmerGridViewForProducts extends StatelessWidget {
  final int productsCount;
  final bool? shrinkWrap;
  final bool? disablePadding;
  const ShimmerGridViewForProducts(
      {Key? key, this.productsCount = 4, this.shrinkWrap, this.disablePadding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridViewForProducts(
        shrinkWrap: shrinkWrap,
        disablePadding: disablePadding,
        scrollable: false,
        children: List<Widget>.generate(
            productsCount, (index) => const ShimmerProductCard()).toList());
  }
}
