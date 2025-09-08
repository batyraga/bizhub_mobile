import 'dart:convert';
import 'dart:developer';

import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/api.dart';
import 'package:bizhub/config/constants.dart';
import 'package:bizhub/custom_painters/manufacturer.custom_painter.dart';
import 'package:bizhub/helpers/language.dart';
import 'package:bizhub/models/posts.model.dart';
import 'package:bizhub/models/product.model.dart';
import 'package:bizhub/models/sellers.model.dart';
import 'package:bizhub/providers/auth.provider.dart';
import 'package:bizhub/providers/events.provider.dart';
import 'package:bizhub/providers/favorites.provider.dart';
import 'package:bizhub/providers/language.provider.dart';
import 'package:bizhub/screens/child_screens/seller/categories.dart';
import 'package:bizhub/screens/user_profile/child_screens/edit_seller_profile.dart';
import 'package:bizhub/widgets/bizhub_fetch_error_detector.dart';
import 'package:bizhub/widgets/bottom_sheet.dart';
import 'package:bizhub/widgets/button.dart';
import 'package:bizhub/widgets/post_card.dart';
import 'package:bizhub/widgets/product_card.dart';
import 'package:bizhub/widgets/seller_card.dart';
import 'package:provider/provider.dart';
import 'package:bizhub/providers/storage.provider.dart';
import 'package:bizhub/screens/user_profile/categories.dart';
import 'package:bizhub/screens/user_profile/child_screens/edit_profile.dart';
import 'package:bizhub/screens/user_profile/posts.dart';
import 'package:bizhub/screens/user_profile/products.dart';
import 'package:bizhub/shimmers/seller_profile.shimmer.dart';
import 'package:bizhub/widgets/error_viewer.dart';
import 'package:bizhub/widgets/fade_transition_page_route.dart';
import 'package:bizhub/widgets/use_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class MySellerProfile extends StatefulWidget {
  final BuildContext parentContext;
  const MySellerProfile({
    super.key,
    required this.parentContext,
  });

  @override
  State<MySellerProfile> createState() => _MySellerProfileState();
}

class _MySellerProfileState extends State<MySellerProfile> {
  late Future<SellerDetail> future;
  Seller? reducedSeller;
  late String culture;
  PagingController<int, Post> postPagingController =
      PagingController(firstPageKey: 0);
  PagingController<int, Product> productPagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();

    culture = getLang(context);

    future = getSellerProfile(culture);

    globalEvents.on("profile:edit", editProfile);
  }

  Future editProfile([data]) async {
    final s = await future;
    log("status: ${s.status}");
    if (s.status != "published" && s.status != "rejected") {
      return;
    }

    final phone = (await Future.sync(
        () => widget.parentContext.read<Auth>().currentUser!.phone));
    final info = SellerForEditProfile(
      address: s.address,
      bio: s.bio,
      city: s.city,
      logo: s.logo,
      name: s.name,
      phone: phone,
    );
    final bool? r = await Future.sync(() => Navigator.push(
        context,
        PageTransition(
            ctx: context,
            type: PageTransitionType.fade,
            child: EditSellerProfileRoutePage(
                defaultSellerInfo: info, parentContext: context))));
    if (r == true) {
      return onRefresh();
    }
  }

  @override
  void dispose() {
    globalEvents.on("profile:edit", editProfile);
    super.dispose();
  }

  /// @deprecated
  // Future<SellerDetail> getSellerProfileFromLocal(String culture) async {
  //   try {
  //     final fromStorage = storage.read("my_seller_profile[$culture]");
  //     if (fromStorage != null) {
  //       final parsedProfile = jsonDecode(fromStorage);
  //       final SellerDetail parsedProfileAsSellerDetail =
  //           SellerDetail.fromJson(parsedProfile);
  //       return parsedProfileAsSellerDetail;
  //     } else {
  //       return await getSellerProfileFromApi(culture);
  //     }
  //   } catch (err) {
  //     return Future.error(err);
  //   }
  // }

  Future<SellerDetail> getSellerProfile(String culture,
      [bool? forceRefreshChilds]) async {
    try {
      log("yuklenyarrrr..");
      // await Future.delayed(const Duration(seconds: 10));
      final SellerDetail profile =
          await api.auth.mySellerProfile(culture: culture);
      // storage.write("my_seller_profile[$culture]", jsonEncode(profile));
      setState(() {
        reducedSeller = profile.reduce();
      });

      if (forceRefreshChilds == true) {
        setState(() {
          postPagingController = PagingController(firstPageKey: 0);
          productPagingController = PagingController(firstPageKey: 0);
        });
      }

      return profile;
    } catch (err) {
      BizhubFetchErrors.error();

      return Future.error(err);
    }
  }

  Future onRefresh() async {
    setState(() {
      future = getSellerProfile(
        culture,
        true,
      );
    });
  }

  Future onDeletePost(String id, String title) async {
    final bool? s = await showCustomModalBottomSheetWithTitle(
        context: context,
        title: "Do you want delete this post?",
        builder: (context) {
          return DeletePostBottomSheet(
            postId: id,
            title: title,
          );
        });
    if (s == true) {
      postPagingController.refresh();
    }
  }

  Future onDeleteProduct(String id, String heading) async {
    final bool? s = await showCustomModalBottomSheetWithTitle(
        context: context,
        title: "Do you want delete this product?",
        builder: (context) {
          return DeleteProductBottomSheet(
            productId: id,
            heading: heading,
          );
        });
    if (s == true) {
      productPagingController.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return UseAuth(
      child: RefreshIndicator(
        notificationPredicate: (notification) {
          return notification.depth == 2;
        },
        onRefresh: onRefresh,
        child: FutureBuilder<SellerDetail>(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                final SellerDetail seller = snapshot.data!;
                log("logo => ${seller.logo}");
                return DefaultTabController(
                  length: 2,
                  child: NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        SliverList(
                            delegate: SliverChildListDelegate([
                          SellerStatusCard(
                            status: seller.status,
                          ),
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
                                              color: const Color(0xffE5E5E5))),
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
                                          padding:
                                              const EdgeInsets.only(right: 20),
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
                                      onPressed: editProfile,
                                      style: ElevatedButton.styleFrom(
                                          foregroundColor: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                          elevation: 0,
                                          shadowColor: Colors.white,
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  width: 1,
                                                  style: BorderStyle.solid),
                                              borderRadius:
                                                  BorderRadius.circular(5.0))),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.edit_rounded,
                                            size: 18.0,
                                          ),
                                          const SizedBox(
                                            width: 10.0,
                                          ),
                                          Text("Edit Profile",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15.0,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary))
                                        ],
                                      )),
                                ),
                                const SizedBox(
                                  width: 20.0,
                                ),
                                Expanded(
                                    child: ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            foregroundColor: const Color(0xffF6F6F6),
                                            shadowColor: Colors.white,
                                            backgroundColor: Colors.black,
                                            shape: RoundedRectangleBorder(
                                                side: const BorderSide(
                                                    color: Color(0xffE5E5E5),
                                                    width: 1,
                                                    style: BorderStyle.solid),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        5.0))),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.favorite,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              size: 18.0,
                                            ),
                                            const SizedBox(
                                              width: 10.0,
                                            ),
                                            Text(
                                              "${seller.likes}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15.0,
                                              ),
                                            )
                                          ],
                                        )))
                              ],
                            ),
                          ),
                          if (seller.bio.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 15.0,
                                  left: 15.0,
                                  top: 15,
                                  bottom: 15.0),
                              child: SellerBioRichText(text: seller.bio),
                            ),
                          SellerCategories(sellerId: seller.id),
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
                                color: const Color.fromRGBO(64, 64, 124, 0.15),
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
                                tabs: const [
                                  Tab(
                                    text: "Products",
                                  ),
                                  Tab(
                                    text: "Posts",
                                  ),
                                ]),
                          ),
                        ))
                      ];
                    },
                    body: TabBarView(children: [
                      MySellerProfileProductsTab(
                        controller: productPagingController,
                        // : widget.sellerId,
                        onDelete: onDeleteProduct,
                      ),
                      MySellerProfilePostsTab(
                        controller: postPagingController,
                        reducedSeller: reducedSeller!,
                        onDelete: onDeletePost,
                      )
                    ]),
                  ),
                );
              } else if (snapshot.hasError) {
                return BeautifyError(
                  onRetry: () async {
                    setState(() {
                      future = getSellerProfile(culture, true);
                    });
                  },
                );
              }
              return const ShimmerSellerProfile();
            }),
      ),
    );
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

class SellerStatusCard extends StatelessWidget {
  final String status;
  const SellerStatusCard({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.symmetric(
      horizontal: 15.0,
      vertical: 5.0,
    );
    if (status == 'blocked') {
      return Padding(
        padding: padding,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: const Color.fromRGBO(255, 0, 0, 0.15),
          ),
          padding: const EdgeInsets.all(10.0),
          child: const Text(
            "You are blocked, your account’s data is hidden for others.",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
                color: Color.fromRGBO(255, 0, 0, 1)),
          ),
        ),
      );
    } else if (status == 'rejected') {
      return Padding(
        padding: padding,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: const Color.fromRGBO(255, 0, 0, 0.15),
          ),
          padding: const EdgeInsets.all(10.0),
          child: const Text(
            "Your profile has been rejected. Change content, please!",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
                color: Color.fromRGBO(255, 0, 0, 1)),
          ),
        ),
      );
    } else if (status == 'notpaid') {
      return Padding(
        padding: padding,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: const Color.fromRGBO(255, 0, 0, 0.15),
          ),
          padding: const EdgeInsets.all(10.0),
          child: const Text(
            "You haven’t paid, your account’s data is hidden for others. Please pay!",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
                color: Color.fromRGBO(255, 0, 0, 1)),
          ),
        ),
      );
    } else if (status == "checking") {
      return Padding(
          padding: padding,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: const Color.fromRGBO(110, 90, 209, 0.15),
            ),
            padding: const EdgeInsets.all(10.0),
            child: const Text(
              "Your profile is being checked. Wait, please!",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0,
                  color: Color.fromRGBO(110, 90, 209, 1)),
            ),
          ));
    } else {
      return const SizedBox();
    }
  }
}
