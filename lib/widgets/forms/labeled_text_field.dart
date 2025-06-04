import 'package:flutter/material.dart';

class LabeledTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String? hint;
  final bool isRequired;
  final TextInputType? keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;

  const LabeledTextField({
    super.key,
    this.controller,
    required this.label,
    this.hint,
    this.isRequired = false,
    this.keyboardType,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label + (isRequired ? '*' : ''),
        hintText: hint,
      ),
      validator: isRequired
          ? (value) => value == null || value.isEmpty
              ? '$label es obligatorio'
              : null
          : null,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
    );
  }
}
