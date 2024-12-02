import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:bizhub/helpers/language.dart';
import 'package:bizhub/models/city.model.dart';
import 'package:bizhub/providers/filter_product.provider.dart';
import 'package:bizhub/widgets/bizhub_fetch_error_detector.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bizhub/widgets/bottom_sheet.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class LocationModalBottomSheet extends StatefulWidget {
  final BuildContext parentContext;
  const LocationModalBottomSheet({super.key, required this.parentContext});

  @override
  State<LocationModalBottomSheet> createState() =>
      _LocationModalBottomSheetState();
}

class _LocationModalBottomSheetState extends State<LocationModalBottomSheet> {
  final int _pageSize = 10;
  final PagingController<int, City> _pagingController =
      PagingController(firstPageKey: 0);
  List<String> _selected = [];
  void addOrRemoveCity(String id, String name) {
    context
        .read<FilterProduct>()
        .addOrRemoveCity(FilterCity(id: id, name: name));
    Navigator.pop(widget.parentContext);
  }

  @override
  void initState() {
    super.initState();
    _selected = context.read<FilterProduct>().getCitiesAsString();
    _pagingController.addPageRequestListener((pageKey) async {
      final String culture = getLanguageCode(
          EasyLocalization.of(context)!.currentLocale!.languageCode);
      await loadCities(pageKey, culture);
    });
  }

  Future<void> loadCities(int page, String culture) async {
    try {
      final result = await api.cities
          .getAll(culture: culture, page: page, limit: _pageSize);
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
    context.read<FilterProduct>().clearCities();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.5),
      child: CustomScrollView(
        shrinkWrap: true,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.only(top: 15.0),
            sliver: SliverList(
                delegate: SliverChildListDelegate([
              BottomSheetButton(
                disableVerticalPadding: true,
                icon: Checkbox(
                  onChanged: (_) => selectAll(),
                  value: _selected.isEmpty,
                ),
                title: LocaleKeys.notSet.tr(),
                onTap: selectAll,
              )
            ])),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 15.0),
            sliver: PagedSliverList<int, City>(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<City>(
                  itemBuilder: (context, item, index) {
                return BottomSheetButton(
                  disableVerticalPadding: true,
                  icon: Checkbox(
                      value: _selected.contains(item.id),
                      onChanged: (_) {
                        addOrRemoveCity(item.id, item.name);
                      }),
                  title: item.name,
                  onTap: () {
                    addOrRemoveCity(item.id, item.name);
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
