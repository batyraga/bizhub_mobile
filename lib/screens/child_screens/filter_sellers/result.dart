import 'dart:developer';

import 'package:bizhub/api/main.dart';
import 'package:bizhub/helpers/language.dart';
import 'package:bizhub/shimmers/sellers.shimmer.dart';
import 'package:bizhub/widgets/bizhub_fetch_error_detector.dart';
import 'package:bizhub/widgets/fade_transition_page_route.dart';
import 'package:bizhub/models/sellers.model.dart';
import 'package:bizhub/screens/child_screens/filter_sellers/main.dart';
import 'package:bizhub/widgets/default_app_bar.dart';
import 'package:bizhub/widgets/seller_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:page_transition/page_transition.dart';

class SellersFilterResultRoutePage extends StatefulWidget {
  final List<String> cities;
  final String sellerType;
  const SellersFilterResultRoutePage(
      {super.key, required this.cities, required this.sellerType});

  @override
  State<SellersFilterResultRoutePage> createState() =>
      _SellersFilterResultRoutePageState();
}

class _SellersFilterResultRoutePageState
    extends State<SellersFilterResultRoutePage> {
  List<String> cities = [];
  String sellerType = "all";
  final int _pageSize = 10;
  final PagingController<int, Seller> _pagingController =
      PagingController(firstPageKey: 0);
  @override
  void initState() {
    super.initState();
    cities = widget.cities;
    sellerType = widget.sellerType;
    _pagingController.addPageRequestListener((pageKey) async {
      final String culture = getLanguageCode(
          EasyLocalization.of(context)!.currentLocale!.languageCode);
      await loadFilterResults(pageKey, culture);
    });
  }

  Future<void> loadFilterResults(int page, String culture) async {
    try {
      final result = await api.sellers.filter(
          page: page,
          limit: _pageSize,
          culture: culture,
          cities: cities,
          sellerType: sellerType);
      final bool isLastPage = result.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(result);
      } else {
        _pagingController.appendPage(result, page + 1);
      }
    } catch (err) {
      log("[loadFilterResults] - error - $err");
      _pagingController.error = err;
      BizhubFetchErrors.error();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DefaultAppBar(
        // leading: const BackButton(color: Colors.black),
        // elevation: 0.0,
        // backgroundColor: Colors.white,
        // foregroundColor: Colors.black,
        title: "Filter result",
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    PageTransition(
                        ctx: context,
                        type: PageTransitionType.fade,
                        child: FilterSellersRoutePage(
                            cities: cities,
                            sellerType: sellerType,
                            parentContext: context,
                            onSubmit: (c, type) {
                              Navigator.pop(context);
                              setState(() {
                                cities = c;
                                sellerType = type;
                              });
                              _pagingController.refresh();
                            })));
              },
              icon: const Icon(Icons.settings))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _pagingController.refresh();
        },
        child: PagedListView<int, Seller>(
            // padding: const EdgeInsets.symmetric(horizontal: 15.0),
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<Seller>(
                newPageProgressIndicatorBuilder: (_) => const ShimmerSellers(),
                firstPageProgressIndicatorBuilder: (_) =>
                    const ShimmerSellers(),
                itemBuilder: (context, item, index) {
                  return SellerCard(seller: item);
                })),
      ),
    );
  }
}
