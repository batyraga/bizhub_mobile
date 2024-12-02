import 'dart:developer';

import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/api.dart';
import 'package:bizhub/config/dynamic_links.dart';
import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:bizhub/helpers/language.dart';
import 'package:bizhub/providers/auth.provider.dart';
import 'package:bizhub/screens/child_screens/seller/main.dart';
import 'package:bizhub/widgets/bizhub_fetch_error_detector.dart';
import 'package:bizhub/widgets/fade_transition_page_route.dart';
import 'package:bizhub/providers/favorites.provider.dart';
import 'package:bizhub/screens/child_screens/product_detail.dart';
import 'package:bizhub/widgets/button.dart';
import 'package:bizhub/widgets/item_status_cards.dart';
import 'package:bizhub/widgets/seller_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:bizhub/models/posts.model.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class PostDetailRoutePage extends StatefulWidget {
  final String postId;
  final BuildContext parentContext;
  final bool navigateToSeller;
  const PostDetailRoutePage(
      {super.key,
      required this.postId,
      this.navigateToSeller = true,
      required this.parentContext});

  @override
  State<PostDetailRoutePage> createState() => _PostDetailRoutePageState();
}

class _PostDetailRoutePageState extends State<PostDetailRoutePage> {
  late Future<PostDetail> futurePost;
  int _likes = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    futurePost = loadPostDetail();
  }

  Future<PostDetail> loadPostDetail() async {
    try {
      final String culture = getLanguageCode(
          EasyLocalization.of(context)!.currentLocale!.languageCode);
      final post =
          await api.posts.getPostDetail(culture: culture, id: widget.postId);
      setState(() {
        _likes = post.likes;
      });

      log("[loadPostDetail] - result $post");
      return post;
    } catch (err) {
      log("[loadPostDetail] - error - $err");
      BizhubFetchErrors.error();

      return Future.error(err);
    }
  }

  Future onRefresh() async {
    setState(() {
      futurePost = loadPostDetail();
    });
  }

  sharePost(PostDetail post) async {
    Uri link = Uri.parse("$apiUrl/links?postId=${post.id}");

    final params = DynamicLinkParameters(
        link: link,
        uriPrefix: DynamicLinksConfig.urlPrefix,
        androidParameters: const AndroidParameters(
          packageName: "com.example.bizhub",
        ),
        socialMetaTagParameters: SocialMetaTagParameters(
          title: post.title,
          imageUrl: Uri.parse("$cdnUrl${post.image}"),
          description: "Click & read more",
        ));

    final dynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(params);

    final box =
        (await Future.sync(() => context.findRenderObject())) as RenderBox?;

    await Share.share(dynamicLink.shortUrl.toString(),
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: FutureBuilder<PostDetail>(
          future: futurePost,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final PostDetail post = snapshot.data!;
              final bool isMe =
                  post.seller.id != context.watch<Auth>().currentUser?.sellerId;
              return RefreshIndicator(
                onRefresh: onRefresh,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).padding.top,
                          ),
                          Stack(
                            children: [
                              AspectRatio(
                                aspectRatio: 4 / 3,
                                child: CachedNetworkImage(
                                  imageUrl: "$cdnUrl${post.image}",
                                  // height: 290.0,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Positioned(
                                top: 15.0,
                                left: 15.0,
                                child: Material(
                                  color: Colors.transparent,
                                  child: GestureDetector(
                                    // splashColor:
                                    //     Theme.of(context).colorScheme.secondary,
                                    onTap: () {
                                      Navigator.pop(widget.parentContext);
                                    },
                                    // borderRadius: BorderRadius.circular(5.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        // color: Colors.red,
                                        color: const Color.fromRGBO(
                                            64, 64, 124, 0.1),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      child: const Icon(
                                        Icons.arrow_back,
                                        size: 20.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          if (post.isChecking == false)
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 0.0,
                                  left: 15.0,
                                  right: 15.0,
                                  bottom: 0.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      FavoriteButtonWithCount(
                                        id: post.id,
                                        likes: _likes,
                                        iconSize: 20.0,
                                        onTap: (newLikes) {
                                          context
                                              .read<Favorites>()
                                              .addOrRemoveFromFavoritePosts(
                                                  post.id);
                                          setState(() {
                                            _likes = newLikes;
                                          });
                                        },
                                        disabled: (post.seller.id ==
                                            context
                                                .watch<Auth>()
                                                .currentUser
                                                ?.sellerId),
                                        type: "product",
                                        isFavorite: context
                                            .watch<Favorites>()
                                            .isFavoritePost(post.id),
                                      ),
                                      const SizedBox(
                                        width: 15.0,
                                      ),
                                      TextButton(
                                          onPressed: null,
                                          style: TextButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 3.5,
                                                      horizontal: 4),
                                              minimumSize: Size.zero,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100.0))),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.remove_red_eye_outlined,
                                                color: Colors.black,
                                                size: 20.0,
                                              ),
                                              const SizedBox(
                                                width: 3.5,
                                              ),
                                              Text(
                                                post.viewed.toString(),
                                                style: const TextStyle(
                                                    fontSize: 13.0,
                                                    fontFamily: "Inter",
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black),
                                              )
                                            ],
                                          ))
                                    ],
                                  ),
                                  if (post.isRejected == false)
                                    Row(
                                      children: [
                                        InkWell(
                                            splashColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () {
                                              sharePost(post);
                                            },
                                            child: const Icon(
                                              Icons.share,
                                              color: Colors.black,
                                              size: 20.0,
                                            )),
                                      ],
                                    )
                                ],
                              ),
                            ),
                          if (post.isChecking) const ItemCheckingCard(),
                          if (post.isRejected)
                            const ItemRejectedCard(type: "post"),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post.title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                                const SizedBox(
                                  height: 12.5,
                                ),
                                Text(
                                  post.body,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          if (post.relatedProducts.isNotEmpty)
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: Text(
                                  "${LocaleKeys.relatedProducts.tr()}:",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0),
                                )),
                          if (post.relatedProducts.isNotEmpty)
                            const SizedBox(
                              height: 15.0,
                            ),
                          if (post.relatedProducts.isNotEmpty)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Wrap(
                                spacing: 10.0,
                                children: post.relatedProducts
                                    .map((p) => InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                PageTransition(
                                                    ctx: context,
                                                    type:
                                                        PageTransitionType.fade,
                                                    child:
                                                        ProductDetailRoutePage(
                                                            parentContext:
                                                                context,
                                                            id: p.id)));
                                          },
                                          child: Container(
                                            width: 80.0,
                                            height: 80.0,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                border: Border.all(
                                                    color: const Color.fromRGBO(
                                                        0, 0, 0, 0.15),
                                                    width: 1,
                                                    style: BorderStyle.solid)),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              child: CachedNetworkImage(
                                                imageUrl: "$cdnUrl${p.image}",
                                                width: 80,
                                                height: 80,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ),
                          if (post.relatedProducts.isNotEmpty)
                            const SizedBox(
                              height: 15.0,
                            ),
                        ],
                      ),
                      InkWell(
                        onTap: (post.seller.id ==
                                context.watch<Auth>().currentUser?.sellerId)
                            ? null
                            : widget.navigateToSeller
                                ? () {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            ctx: context,
                                            type: PageTransitionType.fade,
                                            child: SellerDetailRoutePage(
                                              parentContext: context,
                                              sellerId: post.seller.id,
                                            )));
                                  }
                                : null,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 15.0),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: const Color(0xffE5E5E5))),
                                child: CircleAvatar(
                                  radius: 25.0,
                                  foregroundImage: CachedNetworkImageProvider(
                                      "$cdnUrl${post.seller.logo}"),
                                ),
                              ),
                              const SizedBox(
                                width: 15.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(post.seller.name,
                                      style: const TextStyle(
                                          fontFamily: "Dosis",
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16.0)),
                                  if (!post.seller.isReporterBee())
                                    const SizedBox(
                                      height: 4.0,
                                    ),
                                  if (!post.seller.isReporterBee())
                                    Text(
                                      post.seller.city!.name,
                                      style: const TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w400,
                                          color:
                                              Color.fromRGBO(141, 141, 219, 1)),
                                    )
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Error doredi"),
                  const SizedBox(
                    height: 10.0,
                  ),
                  PrimaryButton(
                      onPressed: () {
                        futurePost = loadPostDetail();
                      },
                      child: "Retry")
                ],
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
