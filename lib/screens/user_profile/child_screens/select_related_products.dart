import 'dart:developer';

import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:bizhub/config/product.dart';
import 'package:bizhub/models/posts.model.dart';
import 'package:bizhub/providers/language.provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bizhub/shimmers/grid_view_for_products.shimmer.dart';
import 'package:bizhub/widgets/bizhub_fetch_error_detector.dart';
import 'package:bizhub/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:bizhub/widgets/default_app_bar.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class RelatedProductsRoutePage extends StatefulWidget {
  final List<RelatedProductForPost> alreadySelectedProducts;
  final BuildContext parentContext;
  const RelatedProductsRoutePage({
    super.key,
    required this.parentContext,
    required this.alreadySelectedProducts,
  });

  @override
  State<RelatedProductsRoutePage> createState() =>
      _RelatedProductsRoutePageState();
}

const _limit = 10;

class _RelatedProductsRoutePageState extends State<RelatedProductsRoutePage> {
  List<RelatedProductForPost> selectedProducts = [];
  final PagingController<int, RelatedProductForPost> pagingController =
      PagingController(firstPageKey: 0);

  void save() {
    Navigator.pop(context, selectedProducts.toList());
  }

  @override
  void initState() {
    super.initState();

    //* setState((){ ... }) etmesemem isleyar.. subut edildi
    selectedProducts = widget.alreadySelectedProducts.toList();

    final String culture = getLang(context);
    pagingController.addPageRequestListener((pageKey) async {
      try {
        final List<RelatedProductForPost> result =
            await api.products.getMyProductsForPost(
          culture: culture,
          limit: _limit,
          page: pageKey,
        );

        final bool isLastPage = result.length < _limit;
        if (isLastPage) {
          pagingController.appendLastPage(result);
        } else {
          pagingController.appendPage(result, pageKey + 1);
        }
      } catch (err) {
        log("[loadMyRelatedProducts] - error - $err");
        BizhubFetchErrors.error();
      }
    });
  }

  Future onRefresh() async {
    pagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: LocaleKeys.myProducts.tr(),
        actions: [
          IconButton(
              onPressed: save,
              icon: Icon(
                Icons.check,
                color: Theme.of(context).colorScheme.primary,
              ))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: PagedGridView(
            shrinkWrap: true,
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            pagingController: pagingController,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            builderDelegate: PagedChildBuilderDelegate<RelatedProductForPost>(
              firstPageProgressIndicatorBuilder: (context) =>
                  const ShimmerGridViewForProducts(
                disablePadding: true,
              ),
              newPageProgressIndicatorBuilder: (context) =>
                  const ShimmerGridViewForProducts(
                disablePadding: true,
              ),
              itemBuilder: (context, item, index) {
                final bool selected = selectedProducts
                        .indexWhere((element) => element.id == item.id) !=
                    -1;
                return ProductCard(
                  product: item.toProduct(),
                  isRelatedProduct: true,
                  selected: selected,
                  onClick: () {
                    log("clicked..");
                    setState(() {
                      if (selected) {
                        selectedProducts.remove(item);
                      } else {
                        selectedProducts.add(item);
                      }
                    });
                    log("products: $selectedProducts");
                  },
                );
              },
            ),
            // builderDelegate: ,
            gridDelegate: productGridDelegate),
      ),
    );
  }
}
