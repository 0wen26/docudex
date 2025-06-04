// lib/widgets/add_category_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../models/category.dart';
import '../database/database_helper.dart';

final List<IconData> availableIcons = [
  Icons.folder,
  Icons.home,
  Icons.school,
  Icons.work,
  Icons.star,
  Icons.book,
  Icons.receipt,
  Icons.build,
];

Future<bool> showAddCategoryDialog(BuildContext context) async {
  final nameController = TextEditingController();
  Color selectedColor = Colors.grey;
  IconData selectedIcon = Icons.folder;
  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).dialogBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 4,
                width: 40,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const Center(
              child: Text(
                'Nueva Categoría',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            const SizedBox(height: 20),
            const Text('Color', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            BlockPicker(
              pickerColor: selectedColor,
              onColorChanged: (color) => selectedColor = color,
            ),
            const SizedBox(height: 20),
            const Text('Icono', style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: availableIcons.map((icon) => StatefulBuilder(
                builder: (context, setState) => GestureDetector(
                  onTap: () => setState(() => selectedIcon = icon),
                  child: CircleAvatar(
                    backgroundColor: selectedIcon == icon ? Colors.blueAccent : Colors.grey[300],
                    child: Icon(icon, color: Colors.black),
                  ),
                ),
              )).toList(),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Guardar'),
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );

  if (result == true && nameController.text.trim().isNotEmpty) {
    final hex = '#'
        // ignore: deprecated_member_use
        '${selectedColor.red.toRadixString(16).padLeft(2, '0')}'
        // ignore: deprecated_member_use
        '${selectedColor.green.toRadixString(16).padLeft(2, '0')}'
        // ignore: deprecated_member_use
        '${selectedColor.blue.toRadixString(16).padLeft(2, '0')}';

    final newCat = Category(
      name: nameController.text.trim(),
      colorHex: hex,
      iconName: selectedIcon.codePoint.toString(),
    );
    await DatabaseHelper().insertCategory(newCat);
    return true;
  }

  return false;
}
