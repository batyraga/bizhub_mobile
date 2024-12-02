import 'package:bizhub/config/langs/config.dart';
import 'package:bizhub/providers/language.provider.dart';
import 'package:bizhub/widgets/restart_app.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:bizhub/config/constants.dart';
import 'package:bizhub/widgets/bottom_sheet.dart';
import 'package:provider/provider.dart';

class LanguageModalBottomSheet extends StatefulWidget {
  final BuildContext parentContext;
  const LanguageModalBottomSheet({super.key, required this.parentContext});

  @override
  State<LanguageModalBottomSheet> createState() =>
      _LanguageModalBottomSheetState();
}

class _LanguageModalBottomSheetState extends State<LanguageModalBottomSheet> {
  late final Locale? _language = EasyLocalization.of(context)!.currentLocale;
  void changeLanguage(Locale locale) async {
    context.read<Language>().setLocale(context, locale);
    // await EasyLocalization.of(context)!.setLocale(locale);
    // setState(() {
    //   _language = newValue!;
    // });
    (() {
      // SplashApp.restartApp(context);
      BizhubRunner.restartApp(context);
    })();

    // await Navigator.pop(widget.parentContext, true);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: defaultPadding),
        child: ListView(
          shrinkWrap: true,
          children: supportedLocales.map((e) {
            return BottomSheetButton(
              disableVerticalPadding: true,
              icon: Radio(
                  value: e,
                  groupValue: _language,
                  onChanged: (Locale? v) {
                    if (v != null) {
                      changeLanguage(v);
                    }
                  }),
              title: getLanguageNameViaCode(e.languageCode),
              onTap: () {
                changeLanguage(e);
              },
            );
          }).toList(),
        ));
  }
}
