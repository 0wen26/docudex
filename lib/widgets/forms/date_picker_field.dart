import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'labeled_text_field.dart';

class DatePickerField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;

  const DatePickerField({
    super.key,
    required this.controller,
    this.label = 'Fecha',
    this.validator,
  });

  Future<void> _selectDate(BuildContext context) async {
    DateTime initial = DateTime.now();
    if (controller.text.isNotEmpty) {
      initial = DateTime.tryParse(controller.text) ?? initial;
    }
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LabeledTextField(
      controller: controller,
      label: label,
      validator: validator,
      readOnly: true,
      onTap: () => _selectDate(context),
    );
  }
}
