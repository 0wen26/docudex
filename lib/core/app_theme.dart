import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Colors.blueGrey;
  static const Color scaffoldBackgroundColor = Colors.black;
  static const Color cardColor = Color(0xFF212121); // Colors.grey[900]
  static const Color textColor = Colors.white70;

  // Paddings
  static const EdgeInsets screenPadding = EdgeInsets.all(16);
  static const EdgeInsets cardPadding = EdgeInsets.all(12.0);
  static const EdgeInsets formFieldMargin = EdgeInsets.only(bottom: 16);

  // Generic spacing value
  static const double elementSpacing = 12.0;

  // Text styles
  static const TextStyle headingStyle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

  static final ThemeData themeData = ThemeData.dark().copyWith(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: scaffoldBackgroundColor,
    cardColor: cardColor,
    textTheme: const TextTheme(bodyMedium: TextStyle(color: textColor)),
  );
}
