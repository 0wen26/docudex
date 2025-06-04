// lib/widgets/location_dialog.dart

import 'package:flutter/material.dart';
import '../../domain/repositories/location_repository.dart';
import '../../widgets/location_dropdown.dart';
import '../../injection_container.dart';

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
    await getIt<LocationRepository>().insertLocation(type, result);
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
  String? Function(String?)? validator,
) {
  return Row(
    children: [
      Expanded(
        child: LocationDropdown(
          label: label,
          options: values,
          value: selectedValue,
          onChanged: onChanged,
          validator: validator,
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