import 'package:flutter/material.dart';

class LabeledTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final bool isRequired;
  final String? Function(String?)? validator;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;

  const LabeledTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.isRequired = false,
    this.validator,
    this.readOnly = false,
    this.onTap,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label + (isRequired ? '*' : ''),
        hintText: hint,
      ),
      validator: validator ??
          (isRequired
              ? (value) =>
                  (value == null || value.isEmpty) ? '$label es obligatorio' : null
              : null),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: keyboardType,
    );
  }
}
