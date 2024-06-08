import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transport_bilty_generator/constants/constants.dart';

ThemeData lightThemeData(BuildContext context) {
  return ThemeData.light().copyWith(
    colorScheme: const ColorScheme(
      primary: Colors.black,
      secondary: Colors.blue,
      surface: Colors.white,
      background: Colors.white,
      error: kPrimaryColor,
      onPrimary: Colors.white,
      onSecondary: Colors.blue,
      onSurface: Colors.black,
      onBackground: Colors.black,
      onError: Colors.black,
      brightness: Brightness.light,
    ),
    cardTheme: const CardTheme(
      shadowColor: kCardShadowColorLight,
      elevation: 2,
    ),
    textTheme: GoogleFonts.workSansTextTheme(
      const TextTheme(
          titleLarge: TextStyle(
            color: Colors.black,
          ),
          bodySmall: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
          bodyMedium: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
          bodyLarge: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
          displayMedium: TextStyle(
            color: Colors.black,
          )).apply(
        bodyColor: Colors.black,
        displayColor: Colors.black,
      ),
    ),
    scaffoldBackgroundColor: kPrimaryColorLight,
  );
}
