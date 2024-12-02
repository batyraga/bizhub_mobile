import 'package:flutter/material.dart';

extension HexColor on Color {
  static Color fromHex(String hexString) {
    String str = hexString.replaceFirst("#", "");
    if (str.length == 6 || str.length == 7) {
      str = "ff$str";
    }
    return Color(int.parse(str, radix: 16));
  }
}
