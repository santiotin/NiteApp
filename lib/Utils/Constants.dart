import 'package:flutter/material.dart';
class Constants{

  static String appName = "Nite";

  //Colors for theme
  static const Color main = Color(0xFF14212d);

  static const Color accent = Color(0xffd81b60);
  static const Color accentLight = Color(0xfff81b60);

  static const Color white = Color(0xFFFFFFFF);
  static const Color transparentWhite = Color(0x00FFFFFF);

  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color background = Color(0xFFDEDEDE);
  static const Color grey = Color(0xFF808080);

  static Color lightPrimary = white;
  static Color darkPrimary = main;
  static Color lightAccent = accent;
  static Color darkAccent = accent;
  static Color lightBG = white;
  static Color darkBG = main;

  static ThemeData lightTheme = ThemeData(
    backgroundColor: lightBG,
    primaryColor: lightPrimary,
    accentColor:  lightAccent,
    cursorColor: lightAccent,
    textSelectionHandleColor: lightAccent,
    textSelectionColor: lightAccent,
    scaffoldBackgroundColor: lightBG,
    appBarTheme: AppBarTheme(
      elevation: 4.0,
      textTheme: TextTheme(
        title: TextStyle(
          color: darkBG,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    backgroundColor: darkBG,
    primaryColor: darkPrimary,
    accentColor: darkAccent,
    scaffoldBackgroundColor: darkBG,
    cursorColor: darkAccent,
    textSelectionHandleColor: darkAccent,
    textSelectionColor: darkAccent,
    appBarTheme: AppBarTheme(
      elevation: 0,
      textTheme: TextTheme(
        title: TextStyle(
          color: lightBG,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
  );


}