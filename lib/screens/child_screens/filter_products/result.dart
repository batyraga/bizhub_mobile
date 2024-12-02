import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:bizhub/config/product.dart';
import 'package:bizhub/helpers/language.dart';
import 'package:bizhub/models/product.model.dart';
import 'package:bizhub/providers/filter_product.provider.dart';
import 'package:bizhub/shimmers/grid_view_for_products.shimmer.dart';
import 'package:bizhub/widgets/bizhub_fetch_error_detector.dart';
import 'package:bizhub/widgets/default_app_bar.dart';
import 'package:bizhub/widgets/product_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ProductsFilterResultRoutePage extends StatefulWidget {
  const ProductsFilterResultRoutePage({
    super.key,
  });

  @override
  State<ProductsFilterResultRoutePage> createState() =>
      _ProductsFilterResultRoutePageState();
}

class _ProductsFilterResultRoutePageState
    extends State<ProductsFilterResultRoutePage> {
  final int _pageSize = 10;
  final PagingController<int, Product> _pagingController =
      PagingController(firstPageKey: 0);
  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) async {
      final String culture = getLanguageCode(
          EasyLocalization.of(context)!.currentLocale!.languageCode);
      await loadFilterResults(pageKey, culture);
    });
  }

  Future<void> loadFilterResults(int page, String culture) async {
    try {
      final String query = context.read<FilterProduct>().prepareFilterQuery();
      debugPrint("query $query");
      final result = await api.products.filter(
          page: page, limit: _pageSize, culture: culture, filterQuery: query);
      final bool isLastPage = result.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(result);
      } else {
        _pagingController.appendPage(result, page + 1);
      }
    } catch (err) {
      debugPrint("error $err");

      _pagingController.error = err;
      BizhubFetchErrors.error();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const DefaultAppBar(
        title: "Filter Result",
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _pagingController.refresh();
        },
        child: PagedGridView<int, Product>(
            gridDelegate: productGridDelegate,
            shrinkWrap: true,
            padding: const EdgeInsets.all(15.0),
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<Product>(
                firstPageProgressIndicatorBuilder: (_) =>
                    const ShimmerGridViewForProducts(
                      disablePadding: true,
                    ),
                newPageProgressIndicatorBuilder: (_) =>
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
