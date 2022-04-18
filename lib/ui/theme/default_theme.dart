import 'package:flutter/material.dart';

final defaultTheme = ThemeData.dark().copyWith(
  primaryColor: Colors.orange,
  secondaryHeaderColor: Colors.green,
  backgroundColor: const Color(0xff202124),
  selectedRowColor: Colors.orange,
  unselectedWidgetColor: Colors.white,
  disabledColor: Colors.grey,
  canvasColor: Colors.white,
  colorScheme: const ColorScheme.dark().copyWith(
    primary: Colors.white,
    secondary: Colors.white,
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      minimumSize: const Size(200, 75),
      shape: const StadiumBorder(),
      primary: Colors.white,
      backgroundColor: const Color.fromARGB(255, 150, 0, 0),
    ),
  ),
  textTheme: ThemeData.dark().textTheme.copyWith(
        bodyText1: const TextStyle(color: Colors.white),
        bodyText2: const TextStyle(fontSize: 12),
        headline1: const TextStyle(
          color: Colors.white,
        ),
        headline2: const TextStyle(
          color: Colors.white,
        ),
        headline4: const TextStyle(
          color: Colors.white,
        ),
      ),
);
