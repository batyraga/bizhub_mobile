import 'package:flutter/material.dart';

class Palette {
  static const MaterialColor bizhub = MaterialColor(
    0xff6E5AD1, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xff6351bc), //10%
      100: Color(0xff5848a7), //20%
      200: Color(0xff4d3f92), //30%
      300: Color(0xff42367d), //40%
      400: Color(0xff372d69), //50%
      500: Color(0xff2c2454), //60%
      600: Color(0xff211b3f), //70%
      700: Color(0xff16122a), //80%
      800: Color(0xff0b0915), //90%
      900: Color(0xff000000), //100%
    },
  );
}
