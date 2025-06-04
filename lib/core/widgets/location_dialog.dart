// lib/widgets/location_dialog.dart

import 'package:flutter/material.dart';
import 'package:docudex/database/database_helper.dart';

Future<bool> showAddLocationDialog(BuildContext context, String type) async {
  final controller = TextEditingController();

  final result = await showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Añadir nueva ${type.toLowerCase()}'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(hintText: 'Nuevo valor'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, controller.text.trim()),
          child: const Text('Guardar'),
        ),
      ],
    ),
  );

  if (result != null && result.isNotEmpty) {
    await DatabaseHelper().insertLocation(type, result);
    return true;
  }
  return false;
}

Widget buildLocationDropdown(
  BuildContext context,
  String label,
  String type,
  List<String> values,
  String? selectedValue,
  void Function(String?) onChanged,
  VoidCallback onReload,
) {
  return Row(
    children: [
      Expanded(
        child: DropdownButtonFormField<String>(
          value: selectedValue,
          items: values.map((val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(labelText: label),
        ),
      ),
      IconButton(
        icon: const Icon(Icons.add),
        onPressed: () async {
          final added = await showAddLocationDialog(context, type);
          if (added) onReload();
        },
      ),
    ],
  );
}