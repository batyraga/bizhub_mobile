import 'dart:convert';
import 'dart:developer';

import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:bizhub/config/product.dart';
import 'package:bizhub/helpers/language.dart';
import 'package:bizhub/models/product.model.dart';
import 'package:bizhub/models/sellers.model.dart';
import 'package:bizhub/providers/events.provider.dart';
import 'package:bizhub/providers/favorites.provider.dart';
import 'package:bizhub/providers/language.provider.dart';
import 'package:bizhub/providers/storage.provider.dart';
import 'package:bizhub/shimmers/grid_view_for_products.shimmer.dart';
import 'package:bizhub/shimmers/product_card.shimmer.dart';
import 'package:bizhub/shimmers/sellers.shimmer.dart';
import 'package:bizhub/widgets/bizhub_fetch_error_detector.dart';
import 'package:bizhub/widgets/product_card.dart';
import 'package:bizhub/widgets/seller_card.dart';
import 'package:bizhub/widgets/use_auth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:bizhub/config/constants.dart';
import 'package:bizhub/widgets/default_app_bar.dart';
import 'package:bizhub/widgets/grid_view_for_products.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen>
    with SingleTickerProviderStateMixin {
  late TabController controller = TabController(length: 2, vsync: this);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: LocaleKeys.favorites.tr(),
        disableDefaultElevationAnimation: true,
      ),
      body: UseAuth(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                pinned: true,
                elevation: 0.0,
                backgroundColor: Colors.white,
                toolbarHeight: 50.0,
                scrolledUnderElevation: 2.0,
                shadowColor: const Color.fromRGBO(0, 0, 0, 0.3),
                flexibleSpace: Container(
                  height: 45.0,
                  padding: const EdgeInsets.all(5),
                  margin:
                      const EdgeInsets.symmetric(horizontal: defaultPadding),
                  decoration: BoxDecoration(
                      color: defaultPrimaryBackgroundColor,
                      borderRadius: BorderRadius.circular(defaultBorderRadius)),
                  child: TabBar(
                      controller: controller,
                      labelColor: Colors.black,
                      indicator: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(7.0), // Creates border
                          color: Colors.white),
                      labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500),
                      unselectedLabelColor: Colors.white,
                      unselectedLabelStyle: const TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.white),
                      tabs: [
                        Tab(
                          text: LocaleKeys.products.tr(),
                        ),
                        Tab(
                          text: LocaleKeys.sellers.tr(),
                        ),
                      ]),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: controller,
            children: [
              FavoritedProducts(controller: controller),
              FavoritedSellers(controller: controller),
            ],
          ),
        ),
      ),
    );
  }
}

const int _limitProducts = 10;
const int _limitSellers = 10;

class FavoritedProducts extends StatefulWidget {
  final TabController controller;
  const FavoritedProducts({super.key, required this.controller});

  @override
  State<FavoritedProducts> createState() => _FavoriteProductsState();
}

class _FavoriteProductsState extends State<FavoritedProducts> {
  late String culture;
  final PagingController<int, Product> controller =
      PagingController(firstPageKey: 0);

  Future pageReq(int pageKey) async {
    try {
      final List<Product> result = await api.auth.myFavorites<Product>(
        culture: culture,
        type: "products",
        customJsonDecoder: Product.fromJson,
        limit: _limitProducts,
        page: pageKey,
      );

      if (result.length < _limitProducts) {
        controller.appendLastPage(result);
      } else {
        controller.appendPage(result, pageKey + 1);
      }
    } catch (err) {
      controller.error = err;
      BizhubFetchErrors.error();
    }
  }

  Future onRefresh() async {
    return controller.refresh();
  }

  @override
  void initState() {
    super.initState();
    culture = getLang(context);

    controller.addPageRequestListener(pageReq);

    context.read<Favorites>().addListener(onRefresh);
  }

  // @override
  // void dispose() {
  //   super.dispose();

  //   controller.removePageRequestListener(pageReq);

  //   context.read<Favorites>().removeListener(onRefresh);
  // }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: widget.controller.indexIsChanging ? () async {} : onRefresh,
      child: PagedGridView<int, Product>(
          shrinkWrap: true,
          pagingController: controller,
          gridDelegate: productGridDelegate,
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          builderDelegate: PagedChildBuilderDelegate<Product>(
              itemBuilder: (context, item, index) {
                return ProductCard(product: item);
              },
              firstPageProgressIndicatorBuilder: (_) =>
                  const ShimmerGridViewForProducts(
                    disablePadding: true,
                  ),
              newPageProgressIndicatorBuilder: (_) =>
                  const ShimmerGridViewForProducts(
                    disablePadding: true,
                  ))),
    );
  }
}

class FavoritedSellers extends StatefulWidget {
  final TabController controller;
  const FavoritedSellers({super.key, required this.controller});

  @override
  State<FavoritedSellers> createState() => _FavoriteSellersState();
}

class _FavoriteSellersState extends State<FavoritedSellers> {
  late String culture;
  final PagingController<int, Seller> controller =
      PagingController(firstPageKey: 0);

  Future pageReq(int pageKey) async {
    try {
      final List<Seller> result = await api.auth.myFavorites<Seller>(
        culture: culture,
        type: "sellers",
        customJsonDecoder: Seller.fromJson,
        limit: _limitSellers,
        page: pageKey,
      );

      if (result.length < _limitSellers) {
        controller.appendLastPage(result);
      } else {
        controller.appendPage(result, pageKey + 1);
      }
    } catch (err) {
      controller.error = err;
      BizhubFetchErrors.error();
    }
  }

  Future onRefresh() async {
    return controller.refresh();
  }

  @override
  void initState() {
    super.initState();
    culture = getLang(context);

    controller.addPageRequestListener(pageReq);

    context.read<Favorites>().addListener(onRefresh);
  }

  // @override
  // void dispose() {
  //   super.dispose();

  //   controller.removePageRequestListener(pageReq);

  //   context.read<Favorites>().removeListener(onRefresh);
  // }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: widget.controller.indexIsChanging ? () async {} : onRefresh,
      child: PagedListView<int, Seller>(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          pagingController: controller,
          builderDelegate: PagedChildBuilderDelegate<Seller>(
              itemBuilder: (context, item, index) {
                return SellerCard(seller: item);
              },
              firstPageProgressIndicatorBuilder: (_) => const ShimmerSellers(),
              newPageProgressIndicatorBuilder: (_) => const ShimmerSellers())),
    );
  }
}
