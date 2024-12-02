import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/api.dart';
import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:bizhub/widgets/bizhub_fetch_error_detector.dart';
import 'package:bizhub/widgets/fade_transition_page_route.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:bizhub/helpers/language.dart';
import 'package:bizhub/providers/filter_product.provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:bizhub/screens/child_screens/filter_products/category_children.dart';
import 'package:bizhub/widgets/default_app_bar.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:bizhub/models/category.model.dart';

class CategoriesRoutePage extends StatefulWidget {
  final BuildContext parentContext;
  final bool singleSelect;
  final Map<String, List<MergedCategory>>? selected;
  const CategoriesRoutePage({
    super.key,
    this.selected,
    this.singleSelect = false,
    required this.parentContext,
  });

  @override
  State<CategoriesRoutePage> createState() => _CategoriesRoutePageState();
}

class _CategoriesRoutePageState extends State<CategoriesRoutePage> {
  final int _pageSize = 10;
  final PagingController<int, ParentCategory> _pagingController =
      PagingController(firstPageKey: 0);

  Map<String, List<MergedCategory>> selecteds = {};

  @override
  void initState() {
    super.initState();

    if (widget.selected != null) {
      selecteds = widget.selected!;
    }

    _pagingController.addPageRequestListener((pageKey) async {
      final String culture = getLanguageCode(
          EasyLocalization.of(context)!.currentLocale!.languageCode);
      await loadCategories(pageKey, culture);
    });
  }

  Future<void> loadCategories(int page, String culture) async {
    try {
      final result = await api.categories
          .getCategories(culture: culture, page: page, limit: _pageSize);
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

  void showChildren(String id, String parentName) async {
    final List<MergedCategory>? r = await Navigator.push(
        context,
        PageTransition(
            ctx: context,
            type: PageTransitionType.fade,
            child: CategoryChildrenRoutePage(
                singleSelect: widget.singleSelect,
                selected:
                    (selecteds[id]?.map((e) => e.id).cast<String>().toList()) ??
                        [],
                parentName: parentName,
                parentContext: context,
                id: id)));

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
          title: "categories".tr(),
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
                      // onPressed: context.read<FilterProduct>().clearCategories,
                      child: const Text(LocaleKeys.clear).tr())
                ]
              : null,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            _pagingController.refresh();
          },
          child: PagedListView(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<ParentCategory>(
                itemBuilder: (context, item, index) {
              return InkWell(
                onTap: () {
                  showChildren(item.id, item.name);
                },
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CachedNetworkImage(
                                  height: 20.0,
                                  width: 20.0,
                                  fit: BoxFit.fill,
                                  alignment: Alignment.center,
                                  imageUrl: "$cdnUrl${item.image}"),
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
          ),
        )
        //       SingleChildScrollView(
        //         child: Column(children: [
        //           InkWell(
        //             onTap: showChilds,
        //             child: Padding(
        //               padding: const EdgeInsets.all(15.0),
        //               child: Row(
        //                 crossAxisAlignment: CrossAxisAlignment.center,
        //                 children: [
        //                   Expanded(
        //                     child: Row(
        //                         crossAxisAlignment: CrossAxisAlignment.center,
        //                         children: const [
        //                           Icon(
        //                             Icons.tv_sharp,
        //                           ),
        //                           SizedBox(
        //                             width: 15.0,
        //                           ),
        //                           Text(
        //                             "Smartphones 'n Gadgets",
        //                             style: TextStyle(
        //                               fontSize: 16.0,
        //                               fontWeight: FontWeight.w600,
        //                             ),
        //                           )
        //                         ]),
        //                   ),
        //                   Icon(
        //                     Icons.arrow_right_outlined,
        //                     size: 26.0,
        //                     color: Theme.of(context).colorScheme.primary,
        //                   )
        //                 ],
        //               ),
        //             ),
        //           ),
        //  ]),
        //       )
        );
  }
}
