// lib/screens/add_edit_document_screen.dart

import 'package:flutter/material.dart';
import '../data/models/document.dart';
import '../core/widgets/add_edit_document_form.dart';

class AddEditDocumentScreen extends StatefulWidget {
  final Document? existingDocument;

  const AddEditDocumentScreen({super.key, this.existingDocument});

  @override
  State<AddEditDocumentScreen> createState() => _AddEditDocumentScreenState();
}

class _AddEditDocumentScreenState extends State<AddEditDocumentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingDocument == null ? 'Añadir Documento' : 'Editar Documento'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: AddEditDocumentForm(
          existingDocument: widget.existingDocument,
          onSaved: () => Navigator.pop(context, true),
        ),
      ),
    );
  }
}
