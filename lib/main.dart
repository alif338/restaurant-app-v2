import 'package:flutter/material.dart';
import 'package:restaurant_app/detail_page.dart';

import 'main_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant App',
      theme: ThemeData(
        primarySwatch: MaterialColor(
            0xff89a66b,
          const <int, Color> {
            900: Color(0xff89a66b),
            800: Color(0xe689a66b),
            700: Color(0xcc89a66b),
            600: Color(0xb389a66b),
            500: Color(0x9989a66b),
            400: Color(0x8089a66b),
            300: Color(0x6689a66b),
            200: Color(0x4d89a66b),
            100: Color(0x3389a66b),
            50: Color(0x1a89a66b)
          }),
        fontFamily: 'ChivoHeadings',
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Color(0xFFFF0000),
          selectionColor: Color(0xFFFF0000),
        ),
      ),
      home: MyHomePage(),
    );
  }
}
