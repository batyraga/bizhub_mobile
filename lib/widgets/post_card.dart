import 'dart:developer';
import 'dart:ui';

import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/api.dart';
import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:bizhub/providers/auth.provider.dart';
import 'package:bizhub/providers/favorites.provider.dart';
import 'package:bizhub/screens/child_screens/post_detail.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bizhub/screens/child_screens/reporterbee_detail.dart';
import 'package:bizhub/screens/child_screens/seller/main.dart';
import 'package:bizhub/widgets/bottom_sheet.dart';
import 'package:bizhub/widgets/button.dart';
import 'package:bizhub/widgets/fade_transition_page_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bizhub/models/posts.model.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final bool navigateToSeller;
  final bool disableFavorite;
  final void Function()? onLongPress;

  const PostCard({
    super.key,
    required this.post,
    this.navigateToSeller = true,
    this.disableFavorite = false,
    this.onLongPress,
  });

  @override
  State<PostCard> createState() => _PostState();
}

class _PostState extends State<PostCard> {
  int _viewed = 0;
  int _likes = 0;

  void open() async {
    List<int>? newData = await Navigator.push(
        context,
        PageTransition(
            ctx: context,
            type: PageTransitionType.fade,
            child: PostDetailRoutePage(
                postId: widget.post.id,
                parentContext: context,
                navigateToSeller: widget.navigateToSeller)));
    if (newData != null) {
      setState(() {
        _viewed = newData[0];
        _likes = newData[1];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _viewed = widget.post.viewed;
    log("post ${widget.post.title} likes => ${widget.post.likes}");
    _likes = widget.post.likes;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          highlightColor: const Color.fromARGB(255, 246, 246, 246),
          onTap: open,
          onLongPress: widget.onLongPress,
          // onLongPress: widget.post.seller.id ==
          //         context.read<Auth>().currentUser?.sellerId
          //     ? widget.onLongPress
          //     : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              InkWell(
                onTap: widget.navigateToSeller == true
                    ? () {
                        if (widget.post.seller.id ==
                            context.read<Auth>().currentUser?.sellerId) {
                          return;
                        }

                        if (widget.post.seller.isReporterBee()) {
                          Navigator.push(
                              context,
                              PageTransition(
                                  ctx: context,
                                  type: PageTransitionType.fade,
                                  child: ReporterBeeDetailRoutePage(
                                    bee: widget.post.seller,
                                  )));
                        } else {
                          Navigator.push(
                              context,
                              PageTransition(
                                  ctx: context,
                                  type: PageTransitionType.fade,
                                  child: SellerDetailRoutePage(
                                    parentContext: context,
                                    sellerId: widget.post.seller.id,
                                  )));
                        }
                      }
                    : null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xffE5E5E5))),
                        child: CircleAvatar(
                          radius: 25.0,
                          foregroundImage:
                              NetworkImage("$cdnUrl${widget.post.seller.logo}"),
                          child: const Icon(Icons.person),
                        ),
                      ),
                      const SizedBox(
                        width: 15.0,
                      ),
                      Column(
                        crossAxisAlignment: widget.post.seller.isReporterBee()
                            ? CrossAxisAlignment.center
                            : CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.post.seller.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: "Dosis",
                                fontSize: 17.0),
                          ),
                          if (!widget.post.seller.isReporterBee() &&
                              widget.post.seller.city != null)
                            const SizedBox(
                              height: 3.0,
                            ),
                          if (!widget.post.seller.isReporterBee() &&
                              widget.post.seller.city != null)
                            Text(
                              widget.post.seller.city!.name,
                              style: const TextStyle(
                                  fontSize: 13.0,
                                  color: Color.fromRGBO(141, 141, 219, 1)),
                            )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              LayoutBuilder(builder: (context, constraints) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    CachedNetworkImage(
                      width: constraints.maxWidth,
                      height: (constraints.maxWidth / 4) * 3,
                      imageUrl: "$cdnUrl${widget.post.image}",
                      imageBuilder: (context, imageProvider) {
                        return Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                                opacity: widget.post.isChecking ? 0.15 : 1.0,
                              ),
                              border: Border.all(
                                  color:
                                      const Color.fromRGBO(229, 229, 229, 1))),
                        );
                      },
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      // placeholder: (context, url) =>
                      //     const CircularProgressIndicator(),
                    ),
                    if (widget.post.isChecking)
                      Positioned(
                          child: Text(
                        LocaleKeys.checking.tr(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(110, 90, 209, 1),
                          fontSize: 20.0,
                        ),
                      )),
                  ],
                );
              }),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                widget.post.title,
                maxLines: 2,
                style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w400,
                    overflow: TextOverflow.ellipsis),
              ),
              const SizedBox(
                height: 7.0,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        FavoriteButtonWithCount(
                            likes: _likes,
                            type: "post",
                            isFavorite: context
                                .watch<Favorites>()
                                .isFavoritePost(widget.post.id),
                            id: widget.post.id,
                            padding: 3.5,
                            disabled: (widget.disableFavorite)
                                ? widget.disableFavorite
                                : (widget.post.seller.id ==
                                    context
                                        .watch<Auth>()
                                        .currentUser
                                        ?.sellerId),
                            onTap: (newLikes) {
                              context
                                  .read<Favorites>()
                                  .addOrRemoveFromFavoritePosts(widget.post.id);
                              setState(() {
                                _likes = newLikes;
                              });
                            }),
                        // TextButton(
                        //     onPressed: () {
                        //       final bool isAuth =
                        //           context.read<Auth>().isAuthenticated;
                        //       if (isAuth == false) {
                        //         return showLoginModal(context);
                        //       }
                        //       context
                        //           .read<Favorites>()
                        //           .addOrRemoveFromFavoritePosts(widget.post.id);
                        //     },
                        //     style: TextButton.styleFrom(
                        //         padding: const EdgeInsets.symmetric(
                        //             vertical: 3.5, horizontal: 4),
                        //         minimumSize: Size.zero,
                        //         shape: RoundedRectangleBorder(
                        //             borderRadius: BorderRadius.circular(100.0)),
                        //         backgroundColor: isFavorite
                        //             ? Colors.red[50]
                        //             : Colors.transparent),
                        //     child: Row(
                        //       children: [
                        //         Icon(
                        //           isFavorite
                        //               ? Icons.favorite_rounded
                        //               : Icons.favorite_outline_outlined,
                        //           color: isFavorite
                        //               ? const Color.fromRGBO(244, 67, 54, 1)
                        //               : Colors.black,
                        //           size: 25.0,
                        //         ),
                        //         const SizedBox(
                        //           width: 3.5,
                        //         ),
                        //         Text(
                        //           "${_defaultFavoriteValue == isFavorite ? widget.post.likes : widget.post.likes + (isFavorite ? 1 : -1)}",
                        //           style: TextStyle(
                        //               fontSize: 16,
                        //               color:
                        //                   isFavorite ? Colors.red : Colors.black),
                        //         )
                        //       ],
                        //     )),

                        const SizedBox(
                          width: 10.0,
                        ),
                        TextButton(
                            onPressed: null,
                            style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 3.5, horizontal: 4),
                                minimumSize: Size.zero,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(100.0))),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.remove_red_eye_outlined,
                                  color: Colors.black,
                                  size: 18.0,
                                ),
                                const SizedBox(
                                  width: 3.5,
                                ),
                                Text(
                                  _viewed.toString(),
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
                    InkWell(
                        splashColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {},
                        // style: TextButton.styleFrom(
                        //   padding: const EdgeInsets.symmetric(vertical: 3.5),
                        //   minimumSize: Size.zero,
                        //   shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(100.0)),
                        // ),
                        child: const Icon(
                          Icons.share,
                          color: Colors.black,
                          size: 18.0,
                        ))
                  ],
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}

class DeletePostBottomSheet extends StatefulWidget {
  final String postId;
  final String title;
  const DeletePostBottomSheet({
    Key? key,
    required this.postId,
    required this.title,
  }) : super(key: key);

  @override
  State<DeletePostBottomSheet> createState() => _DeletePostBottomSheetState();
}

class _DeletePostBottomSheetState extends State<DeletePostBottomSheet> {
  bool loading = false;

  Future<void> delete() async {
    setState(() {
      loading = true;
    });
    try {
      final bool s = await api.posts.delete(postId: widget.postId);
      if (s == true) {
        Future.sync(() => Navigator.pop(context, true));
        return;
      }

      throw Exception("failed delete this post");
    } catch (err) {
      log("[deletePost] - error - $err");
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(
            fontSize: 18.0,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(
          height: 15.0,
        ),
        RedButton(
            onPressed: delete, loading: loading, child: "Yes, delete this post")
      ],
    );
  }
}
