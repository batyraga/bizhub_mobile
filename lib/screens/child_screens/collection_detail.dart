import 'dart:developer';

import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/product.dart';
import 'package:bizhub/helpers/language.dart';
import 'package:bizhub/models/product.model.dart';
import 'package:bizhub/shimmers/grid_view_for_products.shimmer.dart';
import 'package:bizhub/shimmers/product_card.shimmer.dart';
import 'package:bizhub/widgets/bizhub_fetch_error_detector.dart';
import 'package:bizhub/widgets/default_app_bar.dart';
import 'package:bizhub/widgets/grid_view_for_products.dart';
import 'package:bizhub/widgets/product_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class CollectionDetailRoutePage extends StatefulWidget {
  final String title;
  final String collectionPath;
  const CollectionDetailRoutePage(
      {super.key, required this.collectionPath, required this.title});
  @override
  State<CollectionDetailRoutePage> createState() =>
      _CollectionDetailRoutePageState();
}

class _CollectionDetailRoutePageState extends State<CollectionDetailRoutePage> {
  final int _pageSize = 10;
  final PagingController<int, Product> _pagingController =
      PagingController(firstPageKey: 0);
  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) async {
      final String culture = getLanguageCode(
          EasyLocalization.of(context)!.currentLocale!.languageCode);
      await loadCollectionProducts(pageKey, culture);
    });
  }

  Future<void> loadCollectionProducts(int page, String culture) async {
    try {
      final result = await api.collections.getCollectionProducts(
          culture: culture,
          path: widget.collectionPath,
          page: page,
          limit: _pageSize);
      final bool isLastPage = result.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(result);
      } else {
        _pagingController.appendPage(result, page + 1);
      }
    } catch (err) {
      log("[loadCollectionProducts] - error - $err");
      _pagingController.error = err;
      BizhubFetchErrors.error();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: widget.title,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _pagingController.refresh();
        },
        child: PagedGridView(
            padding: const EdgeInsets.all(15.0),
            pagingController: _pagingController,
            gridDelegate: productGridDelegate,
            shrinkWrap: true,
            builderDelegate: PagedChildBuilderDelegate<Product>(
                firstPageProgressIndicatorBuilder: (context) =>
                    const ShimmerGridViewForProducts(
                      disablePadding: true,
                    ),
                newPageProgressIndicatorBuilder: (context) =>
                    const ShimmerGridViewForProducts(
                      disablePadding: true,
                    ),
                itemBuilder: (context, item, index) {
                  return ProductCard(product: item);
                })),
      ),
    );
  }
}
