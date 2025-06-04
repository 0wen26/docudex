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
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: DocumentSortOption.titleAsc,
          child: Text('Título A-Z'),
        ),
        const PopupMenuItem(
          value: DocumentSortOption.titleDesc,
          child: Text('Título Z-A'),
        ),
        const PopupMenuItem(
          value: DocumentSortOption.dateAsc,
          child: Text('Fecha más próxima'),
        ),
        const PopupMenuItem(
          value: DocumentSortOption.dateDesc,
          child: Text('Fecha más lejana'),
        ),
        const PopupMenuItem(
          value: DocumentSortOption.createdDesc,
          child: Text('Más reciente creado'),
        ),
      ],
    );
  }
}
