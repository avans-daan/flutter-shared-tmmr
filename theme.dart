import 'package:flutter/material.dart';

final colorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF114AB8),
    brightness: Brightness.dark,
    background: const Color(0xff202024),
    primary: const Color(0xFF114AB8),
    onPrimary: Colors.white,
    error: const Color(0xFFD01B1B),
);

// TODO TMMR-59 determine the correct colours when building the shared widgets and layouts
final tmmrThemeData = ThemeData(
  // Define the default brightness and colors.
  colorScheme: colorScheme,

  // Define the default font family.
  fontFamily: 'Georgia',

  // Define the default `TextTheme`. Use this to specify the default
  // text styling for headlines, titles, bodies of text, and more.
  textTheme: const TextTheme(
    headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
    headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
    bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(style:
    ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0)
            )
        )
    )
  ),
);
