import 'package:flutter/material.dart';

final defaultTheme = ThemeData.light().copyWith(
  primaryColor: const Color.fromARGB(255, 55, 54, 123),
  appBarTheme: const AppBarTheme(color: Color.fromARGB(255, 55, 54, 123)),
  colorScheme: const ColorScheme.light().copyWith(
    primary: const Color.fromARGB(255, 55, 54, 123),
    secondary: const Color.fromARGB(255, 55, 54, 123),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      minimumSize: const Size(200, 75),
      shape: const StadiumBorder(),
      primary: Colors.white,
      backgroundColor: const Color.fromARGB(255, 55, 54, 123),
    ),
  ),
);
