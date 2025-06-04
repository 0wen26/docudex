import 'package:flutter/material.dart';

import '../data/models/category.dart';

class CategorySelector extends StatelessWidget {
  final List<Category> categories;
  final int? selectedId;
  final ValueChanged<int?> onChanged;
  final VoidCallback onAdd;
  final String label;

  const CategorySelector({
    super.key,
    required this.categories,
    required this.selectedId,
    required this.onChanged,
    required this.onAdd,
    this.label = 'Categoría',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<int>(
            value: selectedId,
            items: categories
                .map((cat) => DropdownMenuItem(
                      value: cat.id,
                      child: Text(cat.name),
                    ))
                .toList(),
            onChanged: onChanged,
            decoration: InputDecoration(labelText: label),
            validator: (val) => val == null ? 'Campo obligatorio' : null,
          ),
        ),
        IconButton(icon: const Icon(Icons.add), onPressed: onAdd),
      ],
    );
  }
}
