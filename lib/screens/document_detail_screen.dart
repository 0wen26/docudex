// lib/screens/document_detail_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import '../data/models/document.dart';
import '../data/models/category.dart';
import '../domain/repositories/document_repository.dart';
import '../injection_container.dart';
import '../utils/app_utils.dart';
import '../utils/icon_utils.dart';
import '../utils/document_utils.dart';
import 'add_edit_document_screen.dart';

class DocumentDetailScreen extends StatelessWidget {
  final Document document;
  final Category category;

  const DocumentDetailScreen({super.key, required this.document, required this.category});


  @override
  Widget build(BuildContext context) {
    final color = hexToColor(category.colorHex);
    final icon = iconFromCodePoint(category.iconName);
    final urgencyColor = getUrgencyColor(document.date);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Documento'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEditDocumentScreen(existingDocument: document),
                ),
              );
              if (result == true && context.mounted) Navigator.pop(context, true);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Eliminar Documento'),
                  content: const Text('¿Estás seguro de que deseas eliminar este documento?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
                    TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Eliminar')),
                  ],
                ),
              );
              if (confirm == true) {
                await getIt<DocumentRepository>().deleteDocument(document.id!);
                if (context.mounted) Navigator.pop(context, true);
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(backgroundColor: color, child: Icon(icon, color: Colors.white)),
                  const SizedBox(width: 12),
                  Text(category.name, style: Theme.of(context).textTheme.titleLarge),
                  const Spacer(),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: urgencyColor,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),
              Text('Título', style: Theme.of(context).textTheme.labelMedium),
              Text(document.title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              Text('Ubicación', style: Theme.of(context).textTheme.labelMedium),
              Text('${document.locationRoom} / ${document.locationArea} / ${document.locationBox}'),
              const SizedBox(height: 12),
              if (document.referenceNumber != null) ...[
                Text('Nº de referencia', style: Theme.of(context).textTheme.labelMedium),
                Text(document.referenceNumber!),
                const SizedBox(height: 12),
              ],
              if (document.date != null) ...[
                Text('Fecha de caducidad', style: Theme.of(context).textTheme.labelMedium),
                Text(document.date!),
                const SizedBox(height: 12),
              ],
              if (document.reminderDays != null) ...[
                Text('Recordatorio', style: Theme.of(context).textTheme.labelMedium),
                Text('${document.reminderDays} días antes'),
                const SizedBox(height: 12),
              ],
              if (document.note != null && document.note!.isNotEmpty) ...[
                Text('Nota', style: Theme.of(context).textTheme.labelMedium),
                Text(document.note!),
                const SizedBox(height: 12),
              ],
              if (document.imagePath != null && File(document.imagePath!).existsSync()) ...[
                Text('Foto adjunta', style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(document.imagePath!),
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
