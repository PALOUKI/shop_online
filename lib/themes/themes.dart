import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade200, // background du scaffold
    primary: Colors.grey.shade900, // text en noir
    secondary: Colors.white,
    tertiary:  Colors.grey.shade500,
    onPrimary: Colors.deepPurpleAccent,
    onSecondary: Colors.white,
    onTertiary: Colors.deepPurpleAccent,
    inversePrimary: Colors.deepPurpleAccent,
  )
);

/*
  Dark mode
*/
ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
        surface: Colors.grey.shade900,
        primary: Colors.white,
        secondary: Colors.grey.shade900,
        tertiary: Colors.grey.shade700,
        onPrimary: Colors.white,
        onSecondary: Colors.grey.shade800,
      onTertiary: Colors.grey.shade900,
      inversePrimary: Colors.grey.shade500,
    ),
);