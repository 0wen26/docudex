// lib/widgets/filters_bar.dart

import 'package:flutter/material.dart';
import 'package:docudex/data/models/category.dart';

class DocumentFiltersBar extends StatelessWidget {
  final List<Category> categories;
  final int? selectedCategoryId;
  final String urgencyFilter; // 'all', 'valid', 'soon', 'expired'
  final void Function(int?) onCategorySelected;
  final void Function(String) onUrgencySelected;

  const DocumentFiltersBar({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.urgencyFilter,
    required this.onCategorySelected,
    required this.onUrgencySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          ChoiceChip(
            label: const Text('Todas'),
            selected: selectedCategoryId == null,
            onSelected: (_) => onCategorySelected(null),
          ),
          ...categories.map((cat) => Padding(
            padding: const EdgeInsets.only(left: 6),
            child: ChoiceChip(
              label: Text(cat.name),
              selected: selectedCategoryId == cat.id,
              onSelected: (_) => onCategorySelected(cat.id),
            ),
          )),
          const SizedBox(width: 16),
          ChoiceChip(
            label: const Text('Todas'),
            selected: urgencyFilter == 'all',
            onSelected: (_) => onUrgencySelected('all'),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 6),
            child: ChoiceChip(
              label: const Text('Vigente'),
              selected: urgencyFilter == 'valid',
              onSelected: (_) => onUrgencySelected('valid'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 6),
            child: ChoiceChip(
              label: const Text('Por vencer'),
              selected: urgencyFilter == 'soon',
              onSelected: (_) => onUrgencySelected('soon'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 6),
            child: ChoiceChip(
              label: const Text('Vencido'),
              selected: urgencyFilter == 'expired',
              onSelected: (_) => onUrgencySelected('expired'),
            ),
          ),
        ],
      ),
    );
  }
}