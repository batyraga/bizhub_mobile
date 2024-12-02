import 'package:bizhub/api/main.dart';
import 'package:bizhub/helpers/language.dart';
import 'package:bizhub/models/posts.model.dart';
import 'package:bizhub/models/sellers.model.dart';
import 'package:bizhub/widgets/bizhub_fetch_error_detector.dart';
import 'package:bizhub/widgets/post_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class PostsTab extends StatefulWidget {
  final String sellerId;
  final Seller seller;
  final PagingController<int, Post> pagingController;
  const PostsTab(
      {super.key,
      required this.sellerId,
      required this.pagingController,
      required this.seller});

  @override
  State<PostsTab> createState() => _PostsTabState();
}

class _PostsTabState extends State<PostsTab> {
  final int _pageSize = 10;
  // final PagingController<int, Post> _pagingController =
  //     PagingController(firstPageKey: 0);
  @override
  void initState() {
    super.initState();

    widget.pagingController.addPageRequestListener((pageKey) async {
      final String culture = getLanguageCode(
          EasyLocalization.of(context)!.currentLocale!.languageCode);
      await loadSellerPosts(pageKey, culture);
    });
  }

  Future<void> loadSellerPosts(int page, String culture) async {
    try {
      final result = await api.posts.getSellerPosts(
        culture: culture,
        page: page,
        limit: _pageSize,
        sellerId: widget.sellerId,
      );
      final bool isLastPage = result.length < _pageSize;
      final resultToPostList = result
          .map((e) => e.toPost(SellerOrReporterBee.fromSeller(widget.seller)))
          .toList();
      if (isLastPage) {
        widget.pagingController.appendLastPage(resultToPostList);
      } else {
        widget.pagingController.appendPage(resultToPostList, page + 1);
      }
    } catch (err) {
      widget.pagingController.error = err;
      BizhubFetchErrors.error();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PagedListView.separated(
      pagingController: widget.pagingController,
      separatorBuilder: (context, index) => const Divider(
        color: Color.fromRGBO(0, 0, 0, 0.15),
        height: 1,
      ),
      builderDelegate:
          PagedChildBuilderDelegate<Post>(itemBuilder: (context, post, index) {
        return PostCard(post: post, navigateToSeller: false);
      }),
    );
  }
}
