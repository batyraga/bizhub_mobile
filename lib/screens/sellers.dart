import 'dart:developer';

import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:bizhub/helpers/language.dart';
import 'package:bizhub/providers/auth.provider.dart';
import 'package:bizhub/screens/child_screens/filter_sellers/main.dart';
import 'package:bizhub/screens/child_screens/search_seller.dart';
import 'package:bizhub/shimmers/sellers.shimmer.dart';
import 'package:bizhub/widgets/bizhub_fetch_error_detector.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:bizhub/config/constants.dart';
import 'package:bizhub/models/sellers.model.dart';
import 'package:bizhub/widgets/seller_card.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:page_transition/page_transition.dart';

class SellersScreen extends StatefulWidget {
  const SellersScreen({Key? key}) : super(key: key);

  @override
  State<SellersScreen> createState() => _SellersScreenState();
}

class _SellersScreenState extends State<SellersScreen> {
  final int _pageSize = 10;
  final PagingController<int, Seller> _pagingController =
      PagingController(firstPageKey: 0);
  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) async {
      final String culture = getLanguageCode(
          EasyLocalization.of(context)!.currentLocale!.languageCode);
      await loadSellers(pageKey, culture);
    });
  }

  Future<void> loadSellers(int pageKey, String culture) async {
    try {
      // await Future.delayed(const Duration(minutes: 10));
      final result = await api.sellers.getAll(
          culture: culture,
          page: pageKey,
          limit: _pageSize,
          sellerId: context.read<Auth>().currentUser?.sellerId);
      final bool isLastPage = result.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(result);
      } else {
        _pagingController.appendPage(result, pageKey + 1);
      }
    } catch (err) {
      log("[loadSellers] - error - $err");
      _pagingController.error = err;
      BizhubFetchErrors.error();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            foregroundColor: Theme.of(context).colorScheme.primary,
            elevation: 0,
            titleSpacing: defaultPadding,
            backgroundColor: Colors.transparent,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              ctx: context,
                              type: PageTransitionType.fade,
                              child: SearchSellerRoutePage(
                                  parentContext: context)));
                    },
                    child: SizedBox(
                      height: 40,
                      child: TextField(
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 15.0),
                            hintText: LocaleKeys.searchSeller.tr(),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100.0),
                                borderSide:
                                    const BorderSide(color: Colors.black)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100.0),
                                borderSide:
                                    const BorderSide(color: Colors.black)),
                            disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100.0),
                                borderSide:
                                    const BorderSide(color: Colors.black)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100.0),
                                borderSide:
                                    const BorderSide(color: Colors.black))),
                        enabled: false,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            ctx: context,
                            type: PageTransitionType.fade,
                            child: FilterSellersRoutePage(
                                parentContext: context)));
                  },
                  borderRadius: BorderRadius.circular(100.0),
                  child: const Padding(
                      padding: EdgeInsets.all(2),
                      child: Icon(
                        Icons.settings,
                        size: 25,
                        color: Colors.black,
                      )),
                )
              ],
            )),
        body: RefreshIndicator(
          onRefresh: () async {
            _pagingController.refresh();
          },
          child: PagedListView(
              // padding: const EdgeInsets.symmetric(horizontal: 15.0),
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<Seller>(
                  newPageProgressIndicatorBuilder: (_) =>
                      const ShimmerSellers(),
                  firstPageProgressIndicatorBuilder: (_) =>
                      const ShimmerSellers(),
                  itemBuilder: (context, item, index) {
                    return SellerCard(seller: item);
                  })),
        ));
  }
}
