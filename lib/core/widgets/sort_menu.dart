// lib/widgets/sort_menu.dart

import 'package:flutter/material.dart';

enum DocumentSortOption {
  titleAsc,
  titleDesc,
  dateAsc,
  dateDesc,
  createdDesc,
}

class DocumentSortMenu extends StatelessWidget {
  final DocumentSortOption selected;
  final ValueChanged<DocumentSortOption> onSelected;

  const DocumentSortMenu({super.key, required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<DocumentSortOption>(
      icon: const Icon(Icons.sort),
      initialValue: selected,
      onSelected: onSelected,
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: DocumentSortOption.titleAsc,
          child: const Text('Título A-Z'),
        ),
        PopupMenuItem(
          value: DocumentSortOption.titleDesc,
          child: const Text('Título Z-A'),
        ),
        PopupMenuItem(
          value: DocumentSortOption.dateAsc,
          child: const Text('Fecha más próxima'),
        ),
        PopupMenuItem(
          value: DocumentSortOption.dateDesc,
          child: const Text('Fecha más lejana'),
        ),
        PopupMenuItem(
          value: DocumentSortOption.createdDesc,
          child: const Text('Más reciente creado'),
        ),
      ],
    );
  }
}
