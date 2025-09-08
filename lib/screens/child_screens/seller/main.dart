import 'dart:developer';

import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/api.dart';
import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:bizhub/custom_painters/manufacturer.custom_painter.dart';
import 'package:bizhub/helpers/language.dart';
import 'package:bizhub/helpers/qrcode.dart';
import 'package:bizhub/models/posts.model.dart';
import 'package:bizhub/models/product.model.dart';
import 'package:bizhub/models/sellers.model.dart';
import 'package:bizhub/providers/favorites.provider.dart';
import 'package:bizhub/screens/child_screens/seller/categories.dart';
import 'package:bizhub/screens/child_screens/seller/posts.dart';
import 'package:bizhub/shimmers/seller_profile.shimmer.dart';
import 'package:bizhub/widgets/bizhub_fetch_error_detector.dart';
import 'package:bizhub/widgets/button.dart';
import 'package:bizhub/widgets/seller_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:bizhub/config/constants.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:bizhub/screens/child_screens/seller/products.dart';
import 'package:bizhub/widgets/bottom_sheet.dart';
import 'package:bizhub/widgets/default_app_bar.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:provider/provider.dart';

class SellerDetailRoutePage extends StatefulWidget {
  final String sellerId;
  final BuildContext parentContext;
  const SellerDetailRoutePage(
      {super.key, required this.parentContext, required this.sellerId});

  @override
  State<SellerDetailRoutePage> createState() => _SellerDetailRoutePageState();
}

class _SellerDetailRoutePageState extends State<SellerDetailRoutePage>
    with SingleTickerProviderStateMixin {
  int _likes = 0;
  late Future<SellerDetail> futureSeller;
  PagingController<int, Post> pagingControllerOfPosts =
      PagingController(firstPageKey: 0);
  PagingController<int, Product> pagingControllerOfProducts =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    futureSeller = loadSellerDetail();
  }

  Future<SellerDetail> loadSellerDetail() async {
    try {
      final String culture = getLanguageCode(
          EasyLocalization.of(context)!.currentLocale!.languageCode);
      final seller = await api.sellers
          .getSellerDetail(culture: culture, sellerId: widget.sellerId);
      setState(() {
        _likes = seller.likes;
        pagingControllerOfPosts = PagingController(firstPageKey: 0);
        pagingControllerOfProducts = PagingController(firstPageKey: 0);
      });
      return seller;
    } catch (err) {
      BizhubFetchErrors.error();
      return Future.error(err);
    }
  }

  Future onRefresh() async {
    setState(() {
      futureSeller = loadSellerDetail();
      // post we products a seret ./
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: DefaultAppBar(
          title: LocaleKeys.seller.tr(),
          actions: [
            IconButton(
                onPressed: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (ctx) {
                        return _optionsModalBottomSheet(widget.sellerId, ctx);
                      },
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20.0))));
                },
                icon: const Icon(Icons.more_horiz_outlined))
          ],
        ),
        body: FutureBuilder<SellerDetail>(
            future: futureSeller,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                final SellerDetail seller = snapshot.data!;
                final Seller onlySeller = seller.reduce();
                return DefaultTabController(
                  length: 2,
                  child: RefreshIndicator(
                    onRefresh: () async {
                      debugPrint("refreshing...");
                      futureSeller = loadSellerDetail();
                    },
                    child: NestedScrollView(
                      headerSliverBuilder: (context, innerBoxIsScrolled) {
                        return [
                          SliverList(
                              delegate: SliverChildListDelegate([
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 10),
                              child: Row(
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color:
                                                    const Color(0xffE5E5E5))),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: 40.0,
                                          foregroundImage:
                                              CachedNetworkImageProvider(
                                                  "$cdnUrl${seller.logo}"),
                                        ),
                                      ),
                                      if (seller.type == "manufacturer")
                                        Positioned(
                                            bottom: 0.0,
                                            right: 0.0,
                                            child: CustomPaint(
                                              size: Size(
                                                  20.0, (20.0 * 1).toDouble()),
                                              painter:
                                                  ManufacturerCustomPainter(),
                                            ))
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 20.0,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          seller.name,
                                          style: const TextStyle(
                                              fontFamily: "Dosis",
                                              overflow: TextOverflow.ellipsis,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(
                                          height: 4.0,
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                right: 20),
                                            child: Text(
                                              "${seller.city.name}, ${seller.address}",
                                              style: const TextStyle(
                                                // fontFamily: "Inter",
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xff8D8DDB),
                                              ),
                                            ))
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 15.0,
                                right: 15.0,
                                top: 5.0,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                            foregroundColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            elevation: 0,
                                            shadowColor: Colors.white,
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                    width: 1,
                                                    style: BorderStyle.solid),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        5.0))),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.message_outlined,
                                              size: 18.0,
                                            ),
                                            const SizedBox(
                                              width: 10.0,
                                            ),
                                            const Text(LocaleKeys.chat,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 15.0,
                                                        color: Colors.white))
                                                .tr()
                                          ],
                                        )),
                                  ),
                                  const SizedBox(
                                    width: 20.0,
                                  ),
                                  Expanded(
                                    child: FavoriteButtonWithCountForSeller(
                                        likes: _likes,
                                        isFavorite: context
                                            .watch<Favorites>()
                                            .isFavoriteSeller(widget.sellerId),
                                        onTap: (newLikes) {
                                          final String culture =
                                              getLanguageCode(
                                                  EasyLocalization.of(context)!
                                                      .currentLocale!
                                                      .languageCode);
                                          context
                                              .read<Favorites>()
                                              .addOrRemoveFromFavoriteSellers(
                                                  onlySeller, culture);
                                          setState(() {
                                            _likes = newLikes;
                                          });
                                        },
                                        sellerId: widget.sellerId), // surasi
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 15.0,
                                  left: 15.0,
                                  top: 15,
                                  bottom: 15.0),
                              child: SellerBioRichText(text: seller.bio),
                            ),
                            SellerCategories(sellerId: widget.sellerId),
                            const SizedBox(
                              height: 10.0,
                            ),
                          ])),
                          SliverPersistentHeader(
                              // pinned: true,
                              // floating: true,
                              delegate: _StickyTabBarDelegate(
                            Container(
                              height: 45,
                              padding: const EdgeInsets.all(5),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromRGBO(64, 64, 124, 0.15),
                                  borderRadius: BorderRadius.circular(5.0)),
                              child: TabBar(
                                  labelColor: Colors.black,
                                  indicator: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3.0),
                                      color: Colors.white),
                                  labelStyle: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.0,
                                      fontFamily: "Nunito",
                                      fontWeight: FontWeight.w600),
                                  unselectedLabelColor: const Color(0xff9797BE),
                                  unselectedLabelStyle: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Nunito",
                                      fontSize: 14.0),
                                  tabs: [
                                    Tab(
                                      text: LocaleKeys.products.tr(),
                                    ),
                                    Tab(
                                      text: LocaleKeys.posts.tr(),
                                    ),
                                  ]),
                            ),
                          ))
                        ];
                      },
                      body: TabBarView(children: [
                        ProductsTab(
                          pagingController: pagingControllerOfProducts,
                          sellerId: widget.sellerId,
                        ),
                        PostsTab(
                          pagingController: pagingControllerOfPosts,
                          sellerId: widget.sellerId,
                          seller: onlySeller,
                        )
                        // Container(
                        //   color: Colors.red,
                        //   child: const Center(child: Text("tab 2")),
                        // )
                      ]),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return const Text("error");
              }
              return const ShimmerSellerProfile();
            }));
  }
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  const _StickyTabBarDelegate(this.container);
  final Container container;
  @override
  double get minExtent => 45;
  @override
  double get maxExtent => 45;
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(child: container);
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) {
    return container != oldDelegate.container;
  }
}

Widget _optionsModalBottomSheet(String sellerId, BuildContext context) {
  void closeParent() {
    Navigator.pop(context);
  }

  return Padding(
      padding: const EdgeInsets.symmetric(vertical: defaultPadding),
      child: ListView(
        shrinkWrap: true,
        children: [
          BottomSheetButton(
            icon: const Icon(Icons.qr_code_2_outlined),
            title: LocaleKeys.getQr.tr(),
            onTap: () {
              closeParent();
              showDialog(
                  context: context,
                  builder: (BuildContext context) => SimpleDialog(
                        elevation: 0,
                        insetPadding:
                            const EdgeInsets.symmetric(horizontal: 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        contentPadding: const EdgeInsets.all(20.0),
                        children: [
                          SizedBox(
                            width: 200,
                            child: QrImageView(
                              data: generateSellerQrCode(sellerId),
                            ),
                          )
                        ],
                      ));
            },
          ),
          BottomSheetButton(
            icon: const Icon(Icons.open_in_new),
            title: LocaleKeys.share.tr(),
            onTap: () {},
          ),
        ],
      ));
}
