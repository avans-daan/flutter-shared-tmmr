import 'package:flutter/material.dart';

final darkColorScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xFF114AB8),
  brightness: Brightness.dark,
  secondary: const Color(0xff2d2f33),
  onSecondary: const Color(0xffacacac),
  background: const Color(0xff202024),
  primary: const Color(0xFF114AB8),
  onPrimary: Colors.white,
  error: const Color(0xFFD01B1B),
);

final lightColorScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xFF114AB8),
  brightness: Brightness.light,
  secondary: const Color(0xffd7d7d7),
  onSecondary: const Color(0xff5e5e5e),
  background: const Color(0xFFFFFFFF),
  primary: const Color(0xFF114AB8),
  onPrimary: Colors.white,
  error: const Color(0xFFD01B1B),
    surface: const Color(0xFFCCC6E2),
    shadow: const Color.fromARGB(77, 0, 0, 0)
);

final darkThemeSchema = ThemeData(
  // Define the default brightness and colors.
  colorScheme: darkColorScheme,
  scaffoldBackgroundColor: darkColorScheme.background,
  // Define the default font family.
  fontFamily: 'Karla',

  // Define the default `TextTheme`. Use this to specify the default
  // text styling for headlines, titles, bodies of text, and more.
  textTheme: TextTheme(
    headline1: const TextStyle(
        fontSize: 80.0, fontWeight: FontWeight.bold, color: Colors.white),
    headline2: TextStyle(
        fontSize: 28.0, fontWeight: FontWeight.bold, color: darkColorScheme.onPrimary),
    headline3: const TextStyle(
        fontSize: 24.0, fontWeight: FontWeight.normal, color: Colors.white),
    headline4: const TextStyle(
        fontSize: 18.0, fontWeight: FontWeight.normal, color: Colors.white),
    headline5: const TextStyle(
        fontSize: 14.0, fontStyle: FontStyle.normal, color: Colors.white),
    headline6: const TextStyle(
        fontSize: 10.0, fontStyle: FontStyle.normal, color: Colors.white),
    bodyText2: const TextStyle(fontSize: 13.0, color: Colors.white),
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

final lightThemeSchema = ThemeData(
  // Define the default brightness and colors.
  colorScheme: lightColorScheme,
  scaffoldBackgroundColor: lightColorScheme.background,
  // Define the default font family.
  fontFamily: 'Karla',

  // Define the default `TextTheme`. Use this to specify the default
  // text styling for headlines, titles, bodies of text, and more.
  textTheme: TextTheme(
    headline1: const TextStyle(
        fontSize: 80.0, fontWeight: FontWeight.bold, color: Colors.black),
    headline2: TextStyle(
        fontSize: 28.0, fontWeight: FontWeight.bold, color: darkColorScheme.onPrimary),
    headline3: const TextStyle(
        fontSize: 24.0, fontWeight: FontWeight.normal, color: Colors.black),
    headline4: const TextStyle(
        fontSize: 18.0, fontWeight: FontWeight.normal, color: Colors.black),
    headline5: const TextStyle(
        fontSize: 14.0, fontStyle: FontStyle.normal, color: Colors.black),
    headline6: const TextStyle(
        fontSize: 10.0, fontStyle: FontStyle.normal, color: Colors.black),
    bodyText2: const TextStyle(fontSize: 13.0, color: Colors.black),
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

  inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: lightColorScheme.secondary,
      hintStyle: TextStyle(
        color: lightColorScheme.onSecondary
      ),
      border: const OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
      floatingLabelBehavior: FloatingLabelBehavior.never),
);
