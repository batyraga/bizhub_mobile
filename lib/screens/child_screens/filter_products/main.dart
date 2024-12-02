import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:bizhub/widgets/fade_transition_page_route.dart';
import 'package:bizhub/providers/filter_product.provider.dart';
import 'package:bizhub/screens/child_screens/filter_products/price.dart';
import 'package:bizhub/screens/child_screens/filter_products/result.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:bizhub/widgets/filter/bare_item.dart';
import 'package:bizhub/widgets/filter/item.dart';
import 'package:flutter/material.dart';
import 'package:bizhub/screens/child_screens/filter_products/brands.dart';
import 'package:bizhub/screens/child_screens/filter_products/categories.dart';
import 'package:bizhub/screens/child_screens/filter_products/cities.dart';
import 'package:bizhub/screens/child_screens/filter_products/sellers.dart';
import 'package:bizhub/screens/child_screens/filter_products/sort.dart';
import 'package:bizhub/widgets/button.dart';
import 'package:bizhub/widgets/default_app_bar.dart';
import 'package:bizhub/models/category.model.dart';
import 'package:easy_localization/easy_localization.dart';

class FilterRoutePage extends StatefulWidget {
  final BuildContext parentContext;
  const FilterRoutePage({super.key, required this.parentContext});

  @override
  State<FilterRoutePage> createState() => _FilterRoutePageState();
}

class _FilterRoutePageState extends State<FilterRoutePage> {
  void submit() async {
    Navigator.push(
        context,
        PageTransition(
            ctx: context,
            type: PageTransitionType.fade,
            child: const ProductsFilterResultRoutePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: LocaleKeys.filter.tr(),
        actions: [
          InkWell(
              highlightColor: Colors.white,
              onTap: context.read<FilterProduct>().clear,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                ),
                alignment: Alignment.center,
                child: const Text(
                  LocaleKeys.clear,
                  style: TextStyle(
                      fontFamily: "Dosis",
                      fontWeight: FontWeight.w600,
                      fontSize: 14.0,
                      color: Color.fromRGBO(110, 90, 209, 1)),
                ).tr(),
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FilterItem(
                      onTap: () async {
                        final Map<String, List<MergedCategory>>? r =
                            await Navigator.push(
                                context,
                                PageTransition(
                                    ctx: context,
                                    type: PageTransitionType.fade,
                                    child: CategoriesRoutePage(
                                        selected: context
                                            .read<FilterProduct>()
                                            .categories
                                            .map((key, value) => MapEntry(
                                                key,
                                                value
                                                    .map((v) => MergedCategory(
                                                        parentId: key,
                                                        id: v.id,
                                                        name: v.name))
                                                    .toList())),
                                        parentContext: context)));
                        if (r != null) {
                          r.forEach((key, value) {
                            context.read<FilterProduct>().setCategories(
                                key,
                                value
                                    .map((e) =>
                                        FilterCategory(id: e.id, name: e.name))
                                    .toList());
                          });
                        }
                      },
                      description: context
                          .watch<FilterProduct>()
                          .beautifyCategoriesAsString(),
                      title: LocaleKeys.category.tr()),
                  const SizedBox(
                    height: 20.0,
                  ),
                  FilterItem(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                ctx: context,
                                type: PageTransitionType.fade,
                                child:
                                    BrandsRoutePage(parentContext: context)));
                      },
                      description: context
                          .watch<FilterProduct>()
                          .beautifyBrandsAsString(),
                      title: LocaleKeys.brand.tr()),
                  const SizedBox(
                    height: 20.0,
                  ),
                  FilterItem(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                ctx: context,
                                type: PageTransitionType.fade,
                                child:
                                    SellersRoutePage(parentContext: context)));
                      },
                      description: context
                          .watch<FilterProduct>()
                          .beautifySellersAsString(),
                      title: LocaleKeys.sellers.tr()),
                  const SizedBox(
                    height: 20.0,
                  ),
                  FilterItem(
                      onTap: () {
                        showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (BuildContext context) =>
                                LocationModalBottomSheet(
                                  parentContext: context,
                                ),
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20.0))));
                      },
                      description: context
                          .watch<FilterProduct>()
                          .beautifyCitiesAsString(),
                      title: LocaleKeys.city.tr()),
                  const SizedBox(
                    height: 20.0,
                  ),
                  FilterBareItem(
                      title: LocaleKeys.price.tr(), child: const FilterPrice()),
                  const SizedBox(
                    height: 20.0,
                  ),
                  FilterItem(
                      onTap: () {
                        showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (BuildContext context) =>
                                SortModalBottomSheet(parentContext: context),
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20.0))));
                      },
                      description:
                          context.watch<FilterProduct>().beautifySortAsString(),
                      title: LocaleKeys.sort.tr()),
                ],
              ),
            )),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: SecondaryButton(
                child: LocaleKeys.showResults.tr(),
                onPressed: submit,
              ),
            )
          ],
        ),
      ), // filter page
    );
  }
}
