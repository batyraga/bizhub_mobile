import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:bizhub/config/constants.dart';
import 'package:bizhub/widgets/bottom_sheet.dart';
import 'package:easy_localization/easy_localization.dart';

class SellerTypeModalBottomSheet extends StatefulWidget {
  final BuildContext parentContext;
  final String state;
  const SellerTypeModalBottomSheet(
      {super.key, required this.state, required this.parentContext});

  @override
  State<SellerTypeModalBottomSheet> createState() =>
      _SellerTypeModalBottomSheetState();
}

class _SellerTypeModalBottomSheetState
    extends State<SellerTypeModalBottomSheet> {
  String _only = "all";
  void changeOnly(String? newValue) {
    setState(() {
      _only = newValue!;
    });
    Navigator.pop(widget.parentContext, _only);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _only = widget.state;
    });
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
                  value: "all",
                  groupValue: _only,
                  onChanged: (String? v) => changeOnly(v)),
              title: LocaleKeys.notSet.tr(),
              onTap: () {
                changeOnly("all");
              },
            ),
            BottomSheetButton(
              disableVerticalPadding: true,
              icon: Radio(
                  value: "regular",
                  groupValue: _only,
                  onChanged: (String? v) => changeOnly(v)),
              title: LocaleKeys.shop.tr(),
              onTap: () {
                changeOnly("regular");
              },
            ),
            BottomSheetButton(
              disableVerticalPadding: true,
              icon: Radio(
                  value: "manufacturer",
                  groupValue: _only,
                  onChanged: (String? v) => changeOnly(v)),
              title: LocaleKeys.manufacturer.tr(),
              onTap: () {
                changeOnly("manufacturer");
              },
            ),
          ],
        ));
  }
}
