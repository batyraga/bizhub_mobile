import 'package:bizhub/config/filter/product.dart';
import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:bizhub/providers/filter_product.provider.dart';
import 'package:flutter/material.dart';
import 'package:bizhub/config/constants.dart';
import 'package:bizhub/widgets/bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class SortModalBottomSheet extends StatefulWidget {
  final BuildContext parentContext;
  const SortModalBottomSheet({super.key, required this.parentContext});

  @override
  State<SortModalBottomSheet> createState() => _SortModalBottomSheetState();
}

class _SortModalBottomSheetState extends State<SortModalBottomSheet> {
  String _sort = "all";
  void changeSort(String? newValue) {
    setState(() {
      _sort = newValue!;
    });
    if (newValue != null && int.tryParse(newValue) != null) {
      context.read<FilterProduct>().setSort(int.parse(newValue));
      Navigator.pop(widget.parentContext);
    } else {
      clearSort();
    }
  }

  @override
  void initState() {
    super.initState();
    final newSort = context.read<FilterProduct>().sort;
    if (newSort != null) {
      _sort = newSort.toString();
    } else {
      _sort = "all";
    }
  }

  void clearSort() {
    setState(() {
      _sort = "all";
    });
    context.read<FilterProduct>().setSort(null);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: defaultPadding),
        child: ListView(
          shrinkWrap: true,
          children: [
            BottomSheetButton(
              disableVerticalPadding: true,
              icon: Radio(
                  groupValue: _sort,
                  value: "all",
                  onChanged: (String? v) {
                    changeSort(v);
                  }),
              title: LocaleKeys.notSet.tr(),
              onTap: () {
                changeSort("all");
              },
            ),
            ...(filterProductSortTypes.values
                .map((e) => BottomSheetButton(
                      disableVerticalPadding: true,
                      icon: Radio(
                          groupValue: _sort,
                          value: e.index.toString(),
                          onChanged: (String? v) {
                            changeSort(v);
                          }),
                      title: e.localeKey.tr(),
                      onTap: () {
                        changeSort(e.index.toString());
                      },
                    ))
                .toList())
          ],
        ));
  }
}
