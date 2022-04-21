import 'package:flutter/material.dart';

final defaultTheme = ThemeData.light().copyWith(
  primaryColor: const Color.fromARGB(255, 39, 55, 82),
  scaffoldBackgroundColor: const Color.fromARGB(255, 39, 55, 82),
  backgroundColor: const Color.fromARGB(255, 39, 55, 82),
  appBarTheme: const AppBarTheme(
    foregroundColor: Color.fromARGB(255, 252, 220, 28),
    color: Colors.black,
  ),
  colorScheme: const ColorScheme.light().copyWith(
    primary: const Color.fromARGB(255, 252, 220, 28),
    secondary: const Color.fromARGB(255, 252, 220, 28),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    labelStyle: TextStyle(
      color: Color.fromARGB(255, 252, 220, 28),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        style: BorderStyle.solid,
        color: Color.fromARGB(255, 252, 220, 28),
      ),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        style: BorderStyle.solid,
        color: Color.fromARGB(255, 252, 220, 28),
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      minimumSize: const Size(200, 75),
      side: const BorderSide(
          width: 2.5, color: Color.fromARGB(255, 252, 220, 28)),
      shape: const StadiumBorder(),
      primary: const Color.fromARGB(255, 252, 220, 28),
      backgroundColor: Colors.black,
    ),
  ),
  textTheme: ThemeData.light().textTheme.copyWith(
        headline1: const TextStyle(
          color: Color.fromARGB(255, 252, 220, 28),
        ),
        headline2: const TextStyle(
          color: Color.fromARGB(255, 252, 220, 28),
        ),
        headline3: const TextStyle(
          color: Color.fromARGB(255, 252, 220, 28),
        ),
        headline4: const TextStyle(
          color: Color.fromARGB(255, 39, 55, 82),
          fontWeight: FontWeight.bold,
        ),
        headline5: const TextStyle(
          color: Color.fromARGB(255, 252, 220, 28),
        ),
        headline6: const TextStyle(
          color: Color.fromARGB(255, 252, 220, 28),
        ),
        subtitle1: const TextStyle(
          color: Colors.white,
        ),
      ),
);
