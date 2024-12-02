import 'package:bizhub/config/langs/config.dart';
import 'package:bizhub/providers/storage.provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

String getLang(BuildContext context) {
  return context.read<Language>().lang;
}

class Language with ChangeNotifier {
  Locale locale = fallbackLocale;

  String get lang {
    switch (locale.languageCode) {
      case "th":
        return "tm";
      case "en":
        return "en";
      case "ru":
        return "ru";
      case "tr":
        return "tr";
      default:
        return "tm";
    }
  }

  Language initState() {
    final String? oldLocaleAsString = storage.read("lang");
    if (oldLocaleAsString != null) {
      final Locale oldLocale = Locale(oldLocaleAsString);
      locale = oldLocale;
      notifyListeners();
    } else {
      locale = fallbackLocale;
    }
    return this;
  }

  void setLocale(BuildContext context, Locale locale_) {
    EasyLocalization.of(context)?.setLocale(locale_);
    locale = locale_;
    storage.write("lang", locale.languageCode);

    notifyListeners();
  }
}
