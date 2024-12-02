import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/api.dart';
import 'package:bizhub/config/constants.dart';
import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:bizhub/helpers/language.dart';
import 'package:bizhub/main.dart';
import 'package:bizhub/models/sellers.model.dart';
import 'package:bizhub/providers/auth.provider.dart';
import 'package:bizhub/providers/filter_product.provider.dart';
import 'package:bizhub/widgets/bizhub_fetch_error_detector.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:bizhub/widgets/default_app_bar.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:bizhub/models/category.model.dart';
import 'package:provider/provider.dart';

class SellersRoutePage extends StatefulWidget {
  final BuildContext parentContext;
  const SellersRoutePage({
    super.key,
    required this.parentContext,
  });

  @override
  State<SellersRoutePage> createState() => _SellersRoutePageState();
}

class _SellersRoutePageState extends State<SellersRoutePage> {
  final int _pageSize = 10;
  final PagingController<int, Seller> _pagingController =
      PagingController(firstPageKey: 0);
  List<String> _selected = [];

  @override
  void initState() {
    super.initState();
    _selected = context.read<FilterProduct>().getSellersAsString();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _pagingController.addPageRequestListener((pageKey) async {
      final String culture = getLanguageCode(
          EasyLocalization.of(context)!.currentLocale!.languageCode);
      await loadSellers(pageKey, culture);
    });
  }

  Future<void> loadSellers(int page, String culture) async {
    try {
      final result = await api.sellers.getAll(
          culture: culture,
          page: page,
          limit: _pageSize,
          sellerId: context.read<Auth>().currentUser?.sellerId);
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
    setState(() {
      if (_selected.contains(id)) {
        _selected.remove(id);
      } else {
        _selected.add(id);
      }
    });
  }

  List<FilterSeller> selectedToFilterCategory() {
    return _selected
        .map((e) => FilterSeller(
            id: e,
            name: _pagingController.itemList!
                .firstWhere((element) => element.id == e)
                .name))
        .toList();
  }

  Map<String, FilterSeller> selectedToFilterSeller() {
    Map<String, FilterSeller> a = {};
    for (var element in _selected) {
      final String name =
          _pagingController.itemList!.firstWhere((e) => e.id == element).name;
      a[element] = FilterSeller(id: element, name: name);
    }
    return a;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: LocaleKeys.sellers.tr(),
        actions: [
          TextButton(
              onPressed: () {
                selectAll();
                context.read<FilterProduct>().clearSellers();
              },
              child: const Text(LocaleKeys.clear).tr()),
          IconButton(
              onPressed: () {
                context
                    .read<FilterProduct>()
                    .setSellers(selectedToFilterSeller());
                Navigator.pop(
                  context,
                );
              },
              icon: Icon(
                Icons.check,
                color: Theme.of(context).colorScheme.primary,
              ))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _pagingController.refresh();
        },
        child: CustomScrollView(
          slivers: [
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
            PagedSliverList<int, Seller>(
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<Seller>(
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
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20.0,
                                  backgroundColor: primaryColor,
                                  foregroundImage: CachedNetworkImageProvider(
                                      "$cdnUrl${item.logo}"),
                                ),
                                const SizedBox(
                                  width: 15.0,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0),
                                    ),
                                    const SizedBox(
                                      height: 3.0,
                                    ),
                                    Text(
                                      item.city.name,
                                      style: const TextStyle(
                                          color: defaultPrimaryText,
                                          fontSize: 12.0),
                                    )
                                  ],
                                )
                              ],
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
