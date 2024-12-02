import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/product.dart';
import 'package:bizhub/helpers/language.dart';
import 'package:bizhub/models/product.model.dart';
import 'package:bizhub/providers/events.provider.dart';
import 'package:bizhub/shimmers/grid_view_for_products.shimmer.dart';
import 'package:bizhub/widgets/bizhub_fetch_error_detector.dart';
import 'package:bizhub/widgets/product_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class MySellerProfileProductsTab extends StatefulWidget {
  final PagingController<int, Product> controller;
  final Function(String, String) onDelete;
  const MySellerProfileProductsTab({
    super.key,
    required this.onDelete,
    required this.controller,
  });

  @override
  State<MySellerProfileProductsTab> createState() =>
      _MySellerProfileProductsTabState();
}

class _MySellerProfileProductsTabState
    extends State<MySellerProfileProductsTab> {
  final int _pageSize = 10;

  Future handler(pageKey) async {
    final String culture = getLanguageCode(
        EasyLocalization.of(context)!.currentLocale!.languageCode);
    await loadSellerProducts(pageKey, culture);
  }

  Future<void> onRefreshGB([List<dynamic>? data]) async {
    return widget.controller.refresh();
  }

  @override
  void initState() {
    super.initState();
    globalEvents.on(
      "profile:products:refresh",
      onRefreshGB,
    );
    widget.controller.addPageRequestListener(handler);
  }

  @override
  void dispose() {
    globalEvents.off(
      "profile:products:refresh",
      onRefreshGB,
    );
    widget.controller.removePageRequestListener(handler);

    super.dispose();
  }

  Future<void> loadSellerProducts(int page, String culture) async {
    try {
      final result = await api.auth.mySellerProfileProducts(
        culture: culture,
        page: page,
        limit: _pageSize,
      );
      final bool isLastPage = result.length < _pageSize;
      if (isLastPage) {
        widget.controller.appendLastPage(result);
      } else {
        widget.controller.appendPage(result, page + 1);
      }
    } catch (err) {
      widget.controller.error = err;
      BizhubFetchErrors.error();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PagedGridView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.only(
          top: 15.0,
          left: 15.0,
          right: 15.0,
        ),
        pagingController: widget.controller,
        builderDelegate: PagedChildBuilderDelegate<Product>(
            firstPageProgressIndicatorBuilder: (context) =>
                const ShimmerGridViewForProducts(disablePadding: true),
            newPageProgressIndicatorBuilder: (context) =>
                const ShimmerGridViewForProducts(
                  disablePadding: true,
                ),
            itemBuilder: (context, product, index) {
              return ProductCard(
                  showFavorite: false,
                  product: product,
                  onLongPress: () {
                    widget.onDelete(product.id, product.heading);
                  },
                  navigateToSeller: false);
            }),
        gridDelegate: productGridDelegate);
  }
}
