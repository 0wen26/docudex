import 'package:flutter/material.dart';

/// Parses a color hex code like "#ffffff" to a [Color].
Color hexToColor(String hex) {
  return Color(int.parse(hex.replaceFirst('#', '0xff')));
}
