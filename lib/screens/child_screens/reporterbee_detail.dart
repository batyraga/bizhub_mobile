import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/api.dart';
import 'package:bizhub/helpers/language.dart';
import 'package:bizhub/models/posts.model.dart';
import 'package:bizhub/models/sellers.model.dart';
import 'package:bizhub/widgets/bizhub_fetch_error_detector.dart';
import 'package:bizhub/widgets/default_app_bar.dart';
import 'package:bizhub/widgets/post_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ReporterBeeDetailRoutePage extends StatefulWidget {
  final SellerOrReporterBee bee;
  const ReporterBeeDetailRoutePage({super.key, required this.bee});

  @override
  State<ReporterBeeDetailRoutePage> createState() =>
      _ReporterBeeDetailRoutePageState();
}

class _ReporterBeeDetailRoutePageState
    extends State<ReporterBeeDetailRoutePage> {
  final _pageSize = 10;
  late String culture;
  final PagingController<int, Post> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    culture = getLanguageCode(
        EasyLocalization.of(context)!.currentLocale!.languageCode);

    _pagingController.addPageRequestListener((page) async {
      try {
        final resultWithoutSeller = await api.posts.getSellerPosts(
            culture: culture,
            sellerId: widget.bee.id,
            page: page,
            limit: _pageSize);

        final bool isEndPage = resultWithoutSeller.length < _pageSize;

        final List<Post> result =
            resultWithoutSeller.map((e) => e.toPost(widget.bee)).toList();

        if (isEndPage) {
          _pagingController.appendLastPage(result);
        } else {
          _pagingController.appendPage(
            result,
            page + 1,
          );
        }
      } catch (err) {
        _pagingController.error = err;
        BizhubFetchErrors.error();
      }
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: widget.bee.name,
        // backgroundColor: const Color.fromRGBO(255, 255, 255, 0.35),
      ),
      extendBodyBehindAppBar: true,
      body: RefreshIndicator(
          edgeOffset: 120.0,
          onRefresh: () async {
            _pagingController.refresh();
          },
          child: PagedListView<int, Post>.separated(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<Post>(
                  itemBuilder: (context, post, index) {
                return PostCard(
                  post: post,
                  navigateToSeller: false,
                );
              }),
              separatorBuilder: (context, index) {
                return const Divider(
                  height: 1.0,
                );
              })),
    );
  }
}
