import 'package:flutter/material.dart';

final colorScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xFF114AB8),
  brightness: Brightness.dark,
  secondary: const Color(0xff2d2f33),
  onSecondary: const Color(0xffacacac),
  background: const Color(0xff202024),
  primary: const Color(0xFF114AB8),
  onPrimary: Colors.white,
  error: const Color(0xFFD01B1B),
);

// TODO TMMR-59 determine the correct colours when building the shared widgets and layouts
final tmmrThemeData = ThemeData(
  // Define the default brightness and colors.
  colorScheme: colorScheme,
  scaffoldBackgroundColor: colorScheme.background,
  // Define the default font family.
  fontFamily: 'Karla',

  // Define the default `TextTheme`. Use this to specify the default
  // text styling for headlines, titles, bodies of text, and more.
  textTheme: const TextTheme(
    headline1: TextStyle(
        fontSize: 80.0, fontWeight: FontWeight.bold, color: Colors.white),
    headline2: TextStyle(
        fontSize: 28.0, fontWeight: FontWeight.bold, color: Colors.white),
    headline3: TextStyle(
        fontSize: 24.0, fontWeight: FontWeight.normal, color: Colors.white),
    headline4: TextStyle(
        fontSize: 18.0, fontWeight: FontWeight.normal, color: Colors.white),
    headline5: TextStyle(
        fontSize: 14.0, fontStyle: FontStyle.normal, color: Colors.white),
    headline6: TextStyle(
        fontSize: 10.0, fontStyle: FontStyle.normal, color: Colors.white),
    bodyText2: TextStyle(fontSize: 13.0, color: Colors.white),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0))),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.fromLTRB(0, 18, 0, 18)))),

  textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white))),

  inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Color(0xff1A1E1E),
      hintStyle: TextStyle(
        color: Colors.white,
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
      floatingLabelBehavior: FloatingLabelBehavior.never),
);
