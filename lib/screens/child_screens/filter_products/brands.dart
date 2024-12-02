import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/api.dart';
import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:bizhub/helpers/language.dart';
import 'package:bizhub/models/brand.model.dart';
import 'package:bizhub/widgets/bizhub_fetch_error_detector.dart';
import 'package:bizhub/widgets/fade_transition_page_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:bizhub/screens/child_screens/filter_products/brand_children.dart';
import 'package:bizhub/widgets/default_app_bar.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:page_transition/page_transition.dart';

class BrandsRoutePage extends StatefulWidget {
  final BuildContext parentContext;
  final bool singleSelect;
  final Map<String, List<MergedBrand>>? selected;
  final String? categoryId;
  const BrandsRoutePage({
    super.key,
    this.categoryId,
    required this.parentContext,
    this.selected,
    this.singleSelect = false,
  });

  @override
  State<BrandsRoutePage> createState() => _BrandsRoutePageState();
}

class _BrandsRoutePageState extends State<BrandsRoutePage> {
  final int _pageSize = 10;
  final PagingController<int, ParentBrand> _pagingController =
      PagingController(firstPageKey: 0);

  Map<String, List<MergedBrand>> selecteds = {};

  @override
  void initState() {
    super.initState();

    if (widget.selected != null) {
      selecteds = widget.selected!;
    }

    _pagingController.addPageRequestListener((pageKey) async {
      final String culture = getLanguageCode(
          EasyLocalization.of(context)!.currentLocale!.languageCode);
      await loadFilterCategories(pageKey, culture);
    });
  }

  Future<void> loadFilterCategories(int page, String culture) async {
    try {
      final result = await api.brands.getBrands(
          culture: culture,
          page: page,
          limit: _pageSize,
          categoryId: widget.categoryId);
      final bool isLastPage = result.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(result);
      } else {
        _pagingController.appendPage(result, page + 1);
      }
    } catch (err) {
      _pagingController.error = err;
      BizhubFetchErrors.error();
    }
  }

  void showChildren(String id, String name) async {
    final List<MergedBrand>? r = await Navigator.push(
        context,
        PageTransition(
            ctx: context,
            type: PageTransitionType.fade,
            child: BrandChildrenRoutePage(
                categoryId: widget.categoryId,
                singleSelect: widget.singleSelect,
                selected:
                    (selecteds[id]?.map((e) => e.id).cast<String>().toList()) ??
                        [],
                id: id,
                parentName: name,
                parentContext: context)));

    if (r != null) {
      if (widget.singleSelect == true) {
        Future.sync(() => Navigator.pop(context, r[0]));
        return;
      }
      setState(() {
        selecteds[id] = r;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: DefaultAppBar(
          title: LocaleKeys.brands.tr(),
          onBack: () {
            if (widget.singleSelect == true) {
              Navigator.pop(context, selecteds[0]);
              return;
            }
            Navigator.pop(context, selecteds);
          },
          actions: widget.singleSelect != true
              ? [
                  TextButton(
                      onPressed: () {
                        setState(() {
                          selecteds.clear();
                        });
                        Navigator.pop(context, selecteds);
                      },
                      child: const Text(LocaleKeys.clear).tr())
                ]
              : null,
        ),
        body: PagedListView<int, ParentBrand>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<ParentBrand>(
              itemBuilder: (contex, item, index) {
            return InkWell(
              onTap: () {
                showChildren(item.id, item.name);
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 20.0,
                              foregroundImage: CachedNetworkImageProvider(
                                  "$cdnUrl${item.logo}"),
                            ),
                            const SizedBox(
                              width: 15.0,
                            ),
                            Text(
                              item.name,
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ]),
                    ),
                    Icon(
                      Icons.arrow_right_outlined,
                      size: 26.0,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  ],
                ),
              ),
            );
          }),
        ));
  }
}
