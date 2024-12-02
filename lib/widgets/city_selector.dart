import 'package:bizhub/api/main.dart';
import 'package:bizhub/helpers/language.dart';
import 'package:bizhub/models/city.model.dart';
import 'package:bizhub/widgets/bizhub_fetch_error_detector.dart';
import 'package:bizhub/widgets/bottom_sheet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class CitySelectorResult {
  final String id;
  final String name;

  const CitySelectorResult({
    required this.id,
    required this.name,
  });
}

class CitySelector extends StatefulWidget {
  final String? selected;
  const CitySelector({Key? key, this.selected}) : super(key: key);

  @override
  State<CitySelector> createState() => _CitySelectorState();
}

class _CitySelectorState extends State<CitySelector> {
  final int _pageSize = 10;
  final PagingController<int, City> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();

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

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.5),
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: CustomScrollView(
        shrinkWrap: true,
        slivers: [
          PagedSliverList<int, City>(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<City>(
                  itemBuilder: (context, item, index) {
                return BottomSheetButton(
                  color: widget.selected == item.id
                      ? Theme.of(context).colorScheme.primary
                      : Colors.black,
                  title: item.name,
                  onTap: () {
                    Navigator.pop(context,
                        CitySelectorResult(id: item.id, name: item.name));
                  },
                );
              })),
        ],
      ),
    );
  }
}

Future<CitySelectorResult?> selectCity(
  BuildContext context, {
  String? selected,
}) async {
  return await showCustomModalBottomSheet<CitySelectorResult>(
      context: context,
      disablePadding: true,
      builder: (context) {
        return CitySelector(selected: selected);
      });
}
