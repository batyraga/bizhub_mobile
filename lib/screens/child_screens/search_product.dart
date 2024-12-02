import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:bizhub/config/product.dart';
import 'package:bizhub/helpers/language.dart';
import 'package:bizhub/models/product.model.dart';
import 'package:bizhub/models/sellers.model.dart';
import 'package:bizhub/shimmers/grid_view_for_products.shimmer.dart';
import 'package:bizhub/shimmers/product_card.shimmer.dart';
import 'package:bizhub/widgets/bizhub_fetch_error_detector.dart';
import 'package:bizhub/widgets/grid_view_for_products.dart';
import 'package:bizhub/widgets/product_card.dart';
import 'package:bizhub/widgets/seller_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class SearchProductRoutePage extends StatefulWidget {
  final BuildContext parentContext;
  const SearchProductRoutePage({super.key, required this.parentContext});

  @override
  State<SearchProductRoutePage> createState() => _SearchProductRoutePageState();
}

class _SearchProductRoutePageState extends State<SearchProductRoutePage> {
  final int _pageSize = 10;
  final TextEditingController _searchFieldController = TextEditingController();
  final PagingController<int, Product> _pagingController =
      PagingController(firstPageKey: 0);
  String _searchValue = "";
  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) async {
      final String culture = getLanguageCode(
          EasyLocalization.of(context)!.currentLocale!.languageCode);

      await loadSearchResult(
        pageKey,
        culture,
      );
    });
  }

  Future<void> loadSearchResult(
    int page,
    String culture,
  ) async {
    try {
      if (_searchValue.trim().isEmpty) {
        throw Exception("search value is empty");
      }
      final result = await api.products.search(
          q: _searchValue, culture: culture, page: page, limit: _pageSize);
      final bool isLastPage = result.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(result);
      } else {
        _pagingController.appendPage(result, page + 1);
      }
    } catch (err) {
      _pagingController.error = err;
      BizhubFetchErrors.error();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: const BackButton(color: Colors.black),
          foregroundColor: Theme.of(context).colorScheme.primary,
          elevation: 0,
          titleSpacing: 15.0,
          backgroundColor: Colors.transparent,
          title: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: SizedBox(
              height: 40,
              child: TextField(
                controller: _searchFieldController,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 15.0),
                  hintText: LocaleKeys.searchProduct.tr(),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0),
                      borderSide: const BorderSide(color: Colors.black)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0),
                      borderSide: const BorderSide(color: Colors.black)),
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0),
                      borderSide: const BorderSide(color: Colors.black)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0),
                      borderSide: const BorderSide(color: Colors.black)),
                  suffixIcon: _searchFieldController.value.text.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            _searchFieldController.clear();
                            setState(() {
                              _searchValue = "";
                            });
                          },
                          child: const Icon(
                            Icons.close_outlined,
                            color: Colors.grey,
                          ),
                        )
                      : null,
                ),
                onSubmitted: (str) {
                  final String v = _searchFieldController.value.text.trim();
                  if (v.isNotEmpty) {
                    setState(() {
                      _searchValue = v;
                    });
                    _pagingController.refresh();
                  }
                },
              ),
            ),
          )),
      body: _searchValue.isNotEmpty
          ? RefreshIndicator(
              onRefresh: () async {
                _pagingController.refresh();
              },
              child: PagedGridView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(15.0),
                  pagingController: _pagingController,
                  gridDelegate: productGridDelegate,
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
            )
          : Column(
              children: const [Text("Search")],
            ),
    );
  }
}
