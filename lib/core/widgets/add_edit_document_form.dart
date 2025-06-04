// lib/widgets/add_edit_document_form.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../../data/models/document.dart';
import '../../data/models/category.dart';
import '../../domain/repositories/document_repository.dart';
import '../../domain/repositories/category_repository.dart';
import '../../domain/repositories/location_repository.dart';
import '../../injection_container.dart';
import 'document_form_fields.dart';
import 'add_category_dialog.dart';
import '../../document_form_controllers.dart';

class AddEditDocumentForm extends StatefulWidget {
  final Document? existingDocument;
  final void Function()? onSaved;

  const AddEditDocumentForm({super.key, this.existingDocument, this.onSaved});

  @override
  State<AddEditDocumentForm> createState() => _AddEditDocumentFormState();
}

class _AddEditDocumentFormState extends State<AddEditDocumentForm> {
  final _formKey = GlobalKey<FormState>();
  final _controllers = DocumentFormControllers();
  bool _isSaving = false;

  List<Category> categories = [];
  List<String> rooms = [], areas = [], boxes = [];
  int? selectedCategoryId;
  String? selectedRoom, selectedArea, selectedBox;
  bool isPrivate = false;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final cats = await getIt<CategoryRepository>().getCategories();
    final r = await getIt<LocationRepository>().getLocationValues('room');
    final a = await getIt<LocationRepository>().getLocationValues('area');
    final b = await getIt<LocationRepository>().getLocationValues('box');

    if (!mounted) return;

    setState(() {
      categories = cats;
      rooms = r;
      areas = a;
      boxes = b;

      final doc = widget.existingDocument;
      if (doc != null) {
        _controllers.title.text = doc.title;
        selectedRoom = doc.locationRoom;
        selectedArea = doc.locationArea;
        selectedBox = doc.locationBox;
        _controllers.note.text = doc.note ?? '';
        _controllers.reference.text = doc.referenceNumber ?? '';
        _controllers.date.text = doc.date ?? '';
        _controllers.reminder.text = doc.reminderDays?.toString() ?? '';
        isPrivate = doc.isPrivate;
        selectedCategoryId = doc.categoryId;
        _imagePath = doc.imagePath;
      } else if (cats.isNotEmpty) {
        selectedCategoryId = cats.first.id;
      }
    });
  }

  Future<void> _addCategory() async {
    final added = await showAddCategoryDialog(context);
    if (added) _loadData();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      final dir = await getApplicationDocumentsDirectory();
      final fileName = path.basename(picked.path);
      final savedImage = await File(picked.path).copy('${dir.path}/$fileName');
      setState(() => _imagePath = savedImage.path);
    }
  }

  Future<void> _saveDocument() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isSaving ||
        selectedCategoryId == null ||
        selectedRoom == null ||
        selectedArea == null ||
        selectedBox == null) {
      return;
    }

    setState(() => _isSaving = true);

    final now = DateTime.now().toIso8601String();
    final doc = Document(
      id: widget.existingDocument?.id,
      title: _controllers.title.text.trim(),
      categoryId: selectedCategoryId!,
      locationRoom: selectedRoom!,
      locationArea: selectedArea!,
      locationBox: selectedBox!,
      note: _controllers.note.text.trim().isEmpty ? null : _controllers.note.text.trim(),
      referenceNumber: _controllers.reference.text.trim().isEmpty ? null : _controllers.reference.text.trim(),
      date: _controllers.date.text.trim().isEmpty ? null : _controllers.date.text.trim(),
      reminderDays: int.tryParse(_controllers.reminder.text.trim()),
      isPrivate: isPrivate,
      nfcId: widget.existingDocument?.nfcId,
      imagePath: _imagePath,
      createdAt: widget.existingDocument?.createdAt ?? now,
      updatedAt: now,
    );

    if (widget.existingDocument == null) {
      await getIt<DocumentRepository>().insertDocument(doc);
    } else {
      await getIt<DocumentRepository>().updateDocument(doc);
    }

    if (mounted) setState(() => _isSaving = false);
    widget.onSaved?.call();
  }

  @override
  void dispose() {
    _controllers.title.dispose();
    _controllers.note.dispose();
    _controllers.reference.dispose();
    _controllers.date.dispose();
    _controllers.reminder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          DocumentFormFields(
          titleController: _controllers.title,
          noteController: _controllers.note,
          referenceController: _controllers.reference,
          dateController: _controllers.date,
          reminderController: _controllers.reminder,
          isSaving: _isSaving,
          categories: categories,
          rooms: rooms,
          areas: areas,
          boxes: boxes,
          selectedCategoryId: selectedCategoryId,
          selectedRoom: selectedRoom,
          selectedArea: selectedArea,
          selectedBox: selectedBox,
          isPrivate: isPrivate,
          onCategoryChanged: (val) => setState(() => selectedCategoryId = val),
          onRoomChanged: (val) => setState(() => selectedRoom = val),
          onAreaChanged: (val) => setState(() => selectedArea = val),
          onBoxChanged: (val) => setState(() => selectedBox = val),
          onPrivateChanged: (val) => setState(() => isPrivate = val),
          onSubmit: _saveDocument,
          onAddCategory: _addCategory,
          onReload: _loadData,
          onReadNfc: () {},
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Hacer foto'),
            ),
            const SizedBox(width: 12),
            if (_imagePath != null)
              Expanded(
                child: Text(
                  'Imagen guardada: ${path.basename(_imagePath!)}',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
