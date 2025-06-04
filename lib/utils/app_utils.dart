import 'package:flutter/material.dart';

/// Converts an icon code point string to [IconData].
IconData iconFromCodePoint(String code) {
  return IconData(int.parse(code), fontFamily: 'MaterialIcons');
}

/// Parses a color hex code like "#ffffff" to a [Color].
Color hexToColor(String hex) {
  return Color(int.parse(hex.replaceFirst('#', '0xff')));
}
