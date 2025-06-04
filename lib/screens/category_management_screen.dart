// lib/screens/category_management_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../data/models/category.dart';
import '../database/database_helper.dart';
import '../utils/app_utils.dart';

class CategoryManagementScreen extends StatefulWidget {
  const CategoryManagementScreen({super.key});

  @override
  State<CategoryManagementScreen> createState() => _CategoryManagementScreenState();
}

class _CategoryManagementScreenState extends State<CategoryManagementScreen> {
  List<Category> categories = [];
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

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final cats = await DatabaseHelper().getCategories();
    setState(() {
      categories = cats;
    });
  }

  String colorToHex(Color color) {
  return '#'
        '${color.r.toInt().toRadixString(16).padLeft(2, '0')}'
        '${color.g.toInt().toRadixString(16).padLeft(2, '0')}'
        '${color.b.toInt().toRadixString(16).padLeft(2, '0')}';
  }


  Future<void> _addCategory() async {
    final nameController = TextEditingController();
    Color selectedColor = Colors.grey;
    IconData selectedIcon = Icons.folder;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Nueva Categoría'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                ),
                const SizedBox(height: 10),
                const Text('Color'),
                BlockPicker(
                  pickerColor: selectedColor,
                  onColorChanged: (color) => setState(() => selectedColor = color),
                ),
                const SizedBox(height: 10),
                const Text('Icono'),
                Wrap(
                  spacing: 8,
                  children: availableIcons.map((icon) => GestureDetector(
                    onTap: () => setState(() => selectedIcon = icon),
                    child: CircleAvatar(
                      backgroundColor: selectedIcon == icon ? Colors.blueAccent : Colors.grey[300],
                      child: Icon(icon, color: Colors.black),
                    ),
                  )).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
            TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Guardar')),
          ],
        ),
      ),
    );

    if (result == true && nameController.text.trim().isNotEmpty) {
      final hex = colorToHex(selectedColor);
      final newCat = Category(
        name: nameController.text.trim(),
        colorHex: hex,
        iconName: selectedIcon.codePoint.toString(),
      );
      await DatabaseHelper().insertCategory(newCat);
      _loadCategories();
    }
  }

  Future<void> _deleteCategory(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar categoría'),
        content: const Text('¿Estás seguro de que quieres eliminar esta categoría?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Eliminar')),
        ],
      ),
    );
    if (confirm == true) {
      await DatabaseHelper().deleteCategory(id);
      _loadCategories();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categorías')),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final color = hexToColor(cat.colorHex);
          final icon = iconFromCodePoint(cat.iconName);
          return ListTile(
            leading: CircleAvatar(backgroundColor: color, child: Icon(icon, color: Colors.white)),
            title: Text(cat.name),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteCategory(cat.id!),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCategory,
        child: const Icon(Icons.add),
      ),
    );
  }
}