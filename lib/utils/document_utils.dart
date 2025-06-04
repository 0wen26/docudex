// lib/utils/document_utils.dart

import 'package:flutter/material.dart';

/// Devuelve un color según la urgencia de la fecha (verde, naranja, rojo o gris)
Color getUrgencyColor(String? dateStr) {
  if (dateStr == null || dateStr.isEmpty) return Colors.grey;
  final now = DateTime.now();
  final date = DateTime.tryParse(dateStr);
  if (date == null) return Colors.grey;

  final diff = date.difference(now).inDays;
  if (diff < 0) return Colors.red;
  if (diff <= 7) return Colors.orange;
  return Colors.green;
}

