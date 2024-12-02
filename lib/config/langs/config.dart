import 'package:flutter/material.dart';

const List<Locale> supportedLocales = <Locale>[
  Locale("th"),
  Locale("en"),
  Locale("ru"),
  Locale("tr"),
];

const String langPath = "assets/translations";

const Locale fallbackLocale = Locale("th");

String getLanguageNameViaCode(String code) {
  switch (code) {
    case "th":
      return "Turkmence";
    case "en":
      return "English";
    case "ru":
      return "Russian";
    case "tr":
      return "Turkce";
    default:
      return "unknown";
  }
}
