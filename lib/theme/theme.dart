import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeProvider extends ChangeNotifier {
  //ThemeData _themeData = ThemeData.light();

  //ThemeData getTheme() => _themeData;

  //void setTheme(ThemeData themeData) {
  //  _themeData = themeData;
  //  notifyListeners();
  //}

  static ThemeData getTheme() {
    return ThemeData(
      useMaterial3: true,

      // Define the default brightness and colors.
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.teal,
        // ···
        brightness: Brightness.light,
      ),

      // Define the default `TextTheme`. Use this to specify the default
      // text styling for headlines, titles, bodies of text, and more.
      textTheme: TextTheme(
        displayLarge: const TextStyle(
          fontSize: 72,
          fontWeight: FontWeight.bold,
        ),
        // ···
        titleLarge: GoogleFonts.oswald(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
        bodyMedium: GoogleFonts.merriweather(),
        displaySmall: GoogleFonts.pacifico(),
      ),
    );
  }
}
