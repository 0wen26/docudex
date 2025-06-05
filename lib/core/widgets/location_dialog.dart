// lib/widgets/location_dialog.dart

import 'package:flutter/material.dart';
import '../../domain/repositories/location_repository.dart';
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
  controller.dispose();

  if (result != null && result.isNotEmpty) {
    await getIt<LocationRepository>().insertLocation(type, result);
    return true;
  }
  return false;
}
