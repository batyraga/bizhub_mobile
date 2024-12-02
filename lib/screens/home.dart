import 'dart:developer';

import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/api.dart';
import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:bizhub/helpers/language.dart';
import 'package:bizhub/models/sellers.model.dart';
import 'package:bizhub/providers/auth.provider.dart';
import 'package:bizhub/providers/language.provider.dart';
import 'package:bizhub/shimmers/posts.shimmer.dart';
import 'package:bizhub/widgets/bizhub_fetch_error_detector.dart';
import 'package:bizhub/widgets/error_ui.dart';
import 'package:provider/provider.dart';
import 'package:bizhub/widgets/seller_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:bizhub/config/constants.dart';
import 'package:bizhub/models/posts.model.dart';
import 'package:bizhub/screens/child_screens/messages/main.dart';
import 'package:bizhub/widgets/post_card.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PagingController<int, Post> _pagingController =
      PagingController(firstPageKey: 0);
  final int _pageSize = 10;
  late String culture;
  late Future<List<String>> futureBanners;
  final CarouselController _bannersController = CarouselController();
  int _activeBannersIndex = 0;
  UniqueKey top5Key = UniqueKey();
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    culture = getLang(context);

    futureBanners = loadBanners();

    _pagingController.addPageRequestListener((pageKey) {
      debugPrint("lang code $culture");
      loadPosts(pageKey, culture);
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<List<String>> loadBanners() async {
    try {
      // await Future.delayed(const Duration(seconds: 10));
      final List<String> banners = await api.banners.getAll(culture: culture);
      return banners;
    } catch (err) {
      log("[loadBanners] - error - $err");
      if (!hasError) {
        BizhubFetchErrors.error();
        setState(() {
          hasError = true;
        });
      }
      return Future.error(err);
    }
  }

  Future<void> loadPosts(int pageKey, String culture) async {
    try {
      // await Future.delayed(const Duration(seconds: 5));
      debugPrint("get next page");
      final newPosts = await api.posts
          .getHomePosts(page: pageKey, limit: _pageSize, culture: culture);
      final isLastPage = newPosts.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newPosts);
      } else {
        _pagingController.appendPage(newPosts, pageKey + 1);
      }
    } catch (err) {
      _pagingController.error = err;
      if (!hasError) {
        BizhubFetchErrors.error();
        setState(() {
          hasError = true;
        });
      }
    }
  }

  Future onRefresh() async {
    setState(() {
      _activeBannersIndex = 0;
      hasError = false;
      futureBanners = loadBanners();
    });
    Future.sync(() => _pagingController.refresh());
    top5Key = UniqueKey();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.transparent,
        //   elevation: 0,
        //   foregroundColor: Colors.black,
        //   title: const Text("bizhub",
        //       style: TextStyle(
        //         fontWeight: FontWeight.bold,
        //         fontSize: 25,
        //         fontFamily: "Urbanist",
        //       )),
        //   actions: [
        //     IconButton(
        //         onPressed: () {
        //           Navigator.push(
        //               context,
        //               PageTransition(
        //                   ctx: context,
        //                   type: PageTransitionType.fade,
        //                   child: MessagesRoutePage(parentContext: context)));
        //         },
        //         icon: const Icon(Icons.send_rounded)),
        //   ],
        // ),

        body: RefreshIndicator(
      onRefresh: onRefresh,
      child: CustomScrollView(slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
          title: const Text("bizhub",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                fontFamily: "Urbanist",
              )),
          shadowColor: const Color.fromRGBO(0, 0, 0, 0.3),
          scrolledUnderElevation: 2.0,
          actions: context.watch<Auth>().isAuthenticated
              ? [
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                ctx: context,
                                type: PageTransitionType.fade,
                                child:
                                    MessagesRoutePage(parentContext: context)));
                      },
                      icon: const Icon(Icons.send_rounded)),
                ]
              : null,
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          FutureBuilder<List<String>>(
              future: futureBanners,
              builder: (context, snapshot) {
                // if (snapshot.connectionState != ConnectionState.waiting) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  final List<String> banners = snapshot.data!;

                  return Stack(
                    children: [
                      CarouselSlider(
                        carouselController: _bannersController,
                        options: CarouselOptions(
                            aspectRatio: 5 / 3,
                            padEnds: true,
                            // height: height,
                            viewportFraction: 1,
                            autoPlay: true,
                            enableInfiniteScroll: true,
                            onPageChanged: (index, _) {
                              setState(() {
                                _activeBannersIndex = index;
                              });
                            }),
                        items: banners.map((banner) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: CachedNetworkImage(
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.fill,
                                  imageUrl: "$cdnUrl$banner"),
                            ),
                          );
                        }).toList(),
                      ),
                      Positioned(
                          bottom: 10.0,
                          right: 25.0,
                          child: AnimatedSmoothIndicator(
                              onDotClicked: (index) {
                                setState(() {
                                  _activeBannersIndex = index;
                                  _bannersController.animateToPage(index);
                                });
                              },
                              effect: CustomizableEffect(
                                  spacing: 5.0,
                                  dotDecoration: DotDecoration(
                                    borderRadius: BorderRadius.circular(100.0),
                                    color: const Color.fromRGBO(
                                        229, 229, 229, 0.35),
                                    height: 5.0,
                                    width: 5.0,
                                    // dotBorder: const DotBorder(
                                    //     color:
                                    //         Color.fromARGB(255, 218, 218, 218)),
                                  ),
                                  activeDotDecoration: DotDecoration(
                                    borderRadius: BorderRadius.circular(100.0),
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    height: 7.0,
                                    width: 7.0,
                                    dotBorder: DotBorder(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                  )),
                              activeIndex: _activeBannersIndex,
                              count: banners.length)),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return AspectRatio(
                    aspectRatio: 5 / 3,
                    child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        child: Text(
                          "Failed to load banners",
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Theme.of(context).colorScheme.onSecondary),
                        )),
                  );
                }
                // else if (snapshot.hasError) {
                //   return const SizedBox();
                // }

                return AspectRatio(
                  aspectRatio: 5 / 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Shimmer.fromColors(
                        baseColor: shimmerBaseColor,
                        highlightColor: shimmerHighlightColor,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white,
                          ),
                        )),
                  ),
                );
              }),
          KeyedSubtree(
            key: top5Key,
            child: const HomeScreenTop5(),
          ),
        ])),
        PagedSliverList.separated(
            shrinkWrapFirstPageIndicators: true,
            separatorBuilder: (context, index) => const Divider(
                  color: Color.fromRGBO(0, 0, 0, 0.15),
                  height: 1,
                ),
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<Post>(
                firstPageProgressIndicatorBuilder: (_) => const ShimmerPosts(),
                newPageProgressIndicatorBuilder: (_) => const ShimmerPosts(),
                firstPageErrorIndicatorBuilder: (context) {
                  return FetchingError(onRefresh: () async {
                    _pagingController.refresh();
                  });
                },
                noItemsFoundIndicatorBuilder: (context) {
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text(
                          "Maglumat yok",
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  );
                },
                itemBuilder: (context, post, index) {
                  return PostCard(post: post);
                })),
      ]),
    ));
  }
}

class HomeScreenTop5 extends StatefulWidget {
  const HomeScreenTop5({Key? key}) : super(key: key);

  @override
  State<HomeScreenTop5> createState() => _HomeScreenTop5State();
}

class _HomeScreenTop5State extends State<HomeScreenTop5> {
  late Future<List<TopSeller>> futureTop;

  Future<List<TopSeller>> loadTopSellers() async {
    try {
      final result = await api.sellers.top();
      return result;
    } catch (err) {
      log("[loadTopSellers] - error - $err");
      return Future.error(err);
    }
  }

  @override
  void initState() {
    super.initState();

    futureTop = loadTopSellers();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TopSeller>>(
        future: futureTop,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            final List<TopSeller> sellers = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 20.0, bottom: 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    LocaleKeys.top5,
                    style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Nunito"),
                  ).tr(),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:
                        sellers.map((e) => TopSellerCard(seller: e)).toList(),
                  ),
                  // ListView.separated(
                  //     padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  //     shrinkWrap: true,
                  //     scrollDirection: Axis.horizontal,
                  //     itemBuilder: (context, index) {
                  //       return TopSellerCard(seller: sellers[index]);
                  //     },
                  //     separatorBuilder: (context, index) {
                  //       return const SizedBox(
                  //         width: 20.0,
                  //       );
                  //     },
                  //     itemCount: sellers.length),
                ],
              ),
            );
          }
          return const SizedBox();
        });
  }
}
