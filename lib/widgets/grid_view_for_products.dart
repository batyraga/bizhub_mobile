import 'package:bizhub/config/product.dart';
import 'package:flutter/material.dart';
import 'package:bizhub/config/constants.dart';

class GridViewForProducts extends StatelessWidget {
  final List<Widget> children;
  final ScrollController? controller;
  final bool scrollable;
  final bool? shrinkWrap;
  final bool? disablePadding;
  const GridViewForProducts(
      {super.key,
      required this.children,
      this.controller,
      this.scrollable = false,
      this.shrinkWrap,
      this.disablePadding});
  @override
  Widget build(BuildContext context) {
    return GridView(
      controller: controller,
      shrinkWrap: shrinkWrap ?? true,
      padding: disablePadding != true
          ? const EdgeInsets.symmetric(horizontal: defaultPadding)
          : null,
      physics: !scrollable ? const NeverScrollableScrollPhysics() : null,
      gridDelegate: productGridDelegate,
      // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      //     crossAxisCount: 2,
      //     mainAxisExtent: 250, // 250 // 230 -> 235 -> 255
      //     mainAxisSpacing: defaultPadding,
      //     crossAxisSpacing: defaultPadding),
      children: children,
    );
  }
}
