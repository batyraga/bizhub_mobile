import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:bizhub/config/constants.dart';
import 'package:bizhub/widgets/grid_view_for_products.dart';
import 'package:easy_localization/easy_localization.dart';

class ProductGroup extends StatelessWidget {
  final String groupTitle;
  final List<Widget> children;
  const ProductGroup(
      {super.key, required this.groupTitle, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding, vertical: 3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                groupTitle,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                      padding: const EdgeInsets.only(
                          bottom: 6, top: 6, right: 0, left: 6),
                      minimumSize: Size.zero),
                  child: const Text(LocaleKeys.seeAll,
                          style: TextStyle(color: defaultPrimaryText))
                      .tr())
            ],
          ),
        ),
        GridViewForProducts(children: children),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }
}
