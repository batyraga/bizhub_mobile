import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/product.dart';
import 'package:bizhub/helpers/language.dart';
import 'package:bizhub/models/product.model.dart';
import 'package:bizhub/shimmers/grid_view_for_products.shimmer.dart';
import 'package:bizhub/widgets/bizhub_fetch_error_detector.dart';
import 'package:bizhub/widgets/product_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ProductsTab extends StatefulWidget {
  final String sellerId;
  final PagingController<int, Product> pagingController;
  const ProductsTab(
      {super.key, required this.sellerId, required this.pagingController});

  @override
  State<ProductsTab> createState() => _ProductsTabState();
}

class _ProductsTabState extends State<ProductsTab> {
  final int _pageSize = 10;
  // final PagingController<int, Product> _pagingController =
  //     PagingController(firstPageKey: 0);
  @override
  void initState() {
    super.initState();
    widget.pagingController.addPageRequestListener((pageKey) async {
      final String culture = getLanguageCode(
          EasyLocalization.of(context)!.currentLocale!.languageCode);
      await loadSellerProducts(pageKey, culture);
    });
  }

  Future<void> loadSellerProducts(int page, String culture) async {
    try {
      final result = await api.products.getSellerProducts(
        culture: culture,
        page: page,
        limit: _pageSize,
        sellerId: widget.sellerId,
      );
      final bool isLastPage = result.length < _pageSize;
      if (isLastPage) {
        widget.pagingController.appendLastPage(result);
      } else {
        widget.pagingController.appendPage(result, page + 1);
      }
    } catch (err) {
      widget.pagingController.error = err;
      BizhubFetchErrors.error();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PagedGridView(
        shrinkWrap: true,
        padding: const EdgeInsets.only(left: 15.0, top: 15.0, right: 15.0),
        pagingController: widget.pagingController,
        builderDelegate: PagedChildBuilderDelegate<Product>(
            firstPageProgressIndicatorBuilder: (context) =>
                const ShimmerGridViewForProducts(
                  disablePadding: true,
                ),
            newPageProgressIndicatorBuilder: (context) =>
                const ShimmerGridViewForProducts(disablePadding: true),
            itemBuilder: (context, product, index) {
              return ProductCard(product: product, navigateToSeller: false);
            }),
        gridDelegate: productGridDelegate);
  }
}
