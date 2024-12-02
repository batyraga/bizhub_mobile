import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:bizhub/helpers/language.dart';
import 'package:bizhub/providers/filter_product.provider.dart';
import 'package:bizhub/widgets/bizhub_fetch_error_detector.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:bizhub/widgets/default_app_bar.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:bizhub/models/category.model.dart';
import 'package:provider/provider.dart';

class CategoryChildrenRoutePage extends StatefulWidget {
  final BuildContext parentContext;
  final String parentName;
  final String id;
  final bool singleSelect;
  final List<String> selected;
  const CategoryChildrenRoutePage(
      {super.key,
      required this.parentContext,
      required this.id,
      this.singleSelect = false,
      required this.selected,
      required this.parentName});

  @override
  State<CategoryChildrenRoutePage> createState() =>
      _CategoryChildrenRoutePageState();
}

class _CategoryChildrenRoutePageState extends State<CategoryChildrenRoutePage> {
  final int _pageSize = 10;
  final PagingController<int, Category> _pagingController =
      PagingController(firstPageKey: 0);
  List<String> _selected = [];

  @override
  void initState() {
    super.initState();
    _selected = widget.selected;
    // _selected =
    //     context.read<FilterProduct>().getCategoryChildrenAsString(widget.id);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _pagingController.addPageRequestListener((pageKey) async {
      final String culture = getLanguageCode(
          EasyLocalization.of(context)!.currentLocale!.languageCode);
      await loadCategoryChildren(pageKey, culture);
    });
  }

  Future<void> loadCategoryChildren(int page, String culture) async {
    try {
      final result = await api.categories.getCategoryChildren(
          culture: culture, page: page, id: widget.id, limit: _pageSize);
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

  void selectAll() {
    setState(() {
      _selected.clear();
    });
  }

  void selectOrUnSelect(String id) {
    if (widget.singleSelect) {
      if (_selected.length == 1 && _selected[0] == id) {
        return;
      }
      Navigator.pop(context, [
        MergedCategory(
            parentId: widget.id,
            id: id,
            name:
                "${widget.parentName} / ${_pagingController.itemList!.firstWhere((element) => element.id == id).name}")
      ]);
      return;
    }

    setState(() {
      if (_selected.contains(id)) {
        _selected.remove(id);
      } else {
        _selected.add(id);
      }
    });
  }

  List<MergedCategory> selectedToFilterCategory() {
    return _selected
        .map((e) => MergedCategory(
            id: e,
            parentId: widget.id,
            name:
                "${widget.parentName} / ${_pagingController.itemList!.firstWhere((element) => element.id == e).name}"))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: widget.parentName,
        actions: widget.singleSelect != true
            ? [
                IconButton(
                    onPressed: () {
                      // context
                      //     .read<FilterProduct>()
                      // .setCategories(widget.id, selectedToFilterCategory());

                      Navigator.pop(
                        context,
                        selectedToFilterCategory(),
                      );
                    },
                    icon: Icon(
                      Icons.check,
                      color: Theme.of(context).colorScheme.primary,
                    ))
              ]
            : null,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _pagingController.refresh();
        },
        child: CustomScrollView(
          slivers: [
            if (widget.singleSelect != true)
              SliverList(
                  delegate: SliverChildListDelegate([
                InkWell(
                  onTap: selectAll,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            LocaleKeys.all,
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.w600),
                          ).tr(),
                          SizedBox(
                            height: 20.0,
                            width: 20.0,
                            child: Checkbox(
                                splashRadius: 20.0,
                                value: _selected.isEmpty,
                                onChanged: (bool? newValue) {
                                  selectAll();
                                }),
                          )
                        ]),
                  ),
                ),
              ])),
            PagedSliverList<int, Category>(
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<Category>(
                    itemBuilder: (context, item, index) {
                  return InkWell(
                    onTap: () {
                      selectOrUnSelect(item.id);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.name,
                              style: const TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 20.0,
                              width: 20.0,
                              child: Checkbox(
                                  splashRadius: 20.0,
                                  value: _selected.contains(item.id),
                                  onChanged: (bool? newValue) {
                                    selectOrUnSelect(item.id);
                                  }),
                            )
                            // CustomCheckBox(
                            //   checked: _selected.contains(item.id),
                            // )
                          ]),
                    ),
                  );
                })),
          ],
        ),
      ),
    );
  }
}
