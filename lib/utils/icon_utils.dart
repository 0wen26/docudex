import 'package:flutter/material.dart';

/// Converts an icon code point string to [IconData].
IconData iconFromCodePoint(String code) =>
    IconData(int.parse(code), fontFamily: 'MaterialIcons');

