import 'dart:developer';

import 'package:bizhub/api/main.dart';
import 'package:bizhub/helpers/language.dart';
import 'package:bizhub/models/posts.model.dart';
import 'package:bizhub/models/sellers.model.dart';
import 'package:bizhub/providers/events.provider.dart';
import 'package:bizhub/shimmers/posts.shimmer.dart';
import 'package:bizhub/widgets/bizhub_fetch_error_detector.dart';
import 'package:bizhub/widgets/post_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class MySellerProfilePostsTab extends StatefulWidget {
  final Seller reducedSeller;
  final PagingController<int, Post> controller;
  final Function(String, String) onDelete;
  const MySellerProfilePostsTab({
    super.key,
    required this.controller,
    required this.reducedSeller,
    required this.onDelete,
  });

  @override
  State<MySellerProfilePostsTab> createState() =>
      _MySellerProfilePostsTabState();
}

class _MySellerProfilePostsTabState extends State<MySellerProfilePostsTab> {
  final int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    globalEvents.on(
      "profile:posts:refresh",
      onRefreshGB,
    );
    widget.controller.addPageRequestListener((pageKey) async {
      final String culture = getLanguageCode(
          EasyLocalization.of(context)!.currentLocale!.languageCode);
      await loadSellerPosts(pageKey, culture);
    });
  }

  @override
  void dispose() {
    globalEvents.off(
      "profile:posts:refresh",
      onRefreshGB,
    );

    super.dispose();
  }

  Future<void> onRefreshGB([List<dynamic>? data]) async {
    return widget.controller.refresh();
  }

  Future<void> loadSellerPosts(int page, String culture) async {
    try {
      final result = await api.auth.mySellerProfilePosts(
        culture: culture,
        page: page,
        limit: _pageSize,
      );
      final asPost = result
          .map((e) =>
              e.toPost(SellerOrReporterBee.fromSeller(widget.reducedSeller)))
          .toList();
      final bool isLastPage = result.length < _pageSize;
      if (isLastPage) {
        widget.controller.appendLastPage(asPost);
      } else {
        widget.controller.appendPage(asPost, page + 1);
      }
    } catch (err) {
      log("[loadSellerPosts] - error - $err");
      widget.controller.error = err;
      BizhubFetchErrors.error();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PagedListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      // padding: const EdgeInsets.only(
      //   top: 15.0,
      // ),
      pagingController: widget.controller,
      builderDelegate: PagedChildBuilderDelegate<Post>(
          firstPageProgressIndicatorBuilder: (context) => const ShimmerPosts(),
          newPageProgressIndicatorBuilder: (context) => const ShimmerPosts(),
          itemBuilder: (context, post, index) {
            return PostCard(
              onLongPress: () {
                widget.onDelete(post.id, post.title);
              },
              disableFavorite: true,
              post: post,
              navigateToSeller: false,
            );
          }),
    );
  }
}
