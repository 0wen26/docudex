import 'package:flutter/material.dart';

class LabeledTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String? hint;
  final bool isRequired;
  final TextInputType? keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? validator;

  const LabeledTextField({
    super.key,
    this.controller,
    required this.label,
    this.hint,
    this.isRequired = false,
    this.keyboardType,
    this.readOnly = false,
    this.onTap,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label + (isRequired ? '*' : ''),
        hintText: hint,
      ),
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return '$label es obligatorio';
        }
        if (validator != null) {
          return validator!(value);
        }
        return null;
      },
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
    );
  }
}
