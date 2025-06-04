import 'package:flutter/material.dart';

/// Converts an icon code point string to [IconData].
IconData iconFromCodePoint(String codePoint) {
  return IconData(int.parse(codePoint), fontFamily: 'MaterialIcons');
}

