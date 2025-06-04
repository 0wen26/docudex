// lib/widgets/add_edit_document_form.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../models/document.dart';
import '../models/category.dart';
import '../database/database_helper.dart';
import 'document_form_fields.dart';
import 'add_category_dialog.dart';

class AddEditDocumentForm extends StatefulWidget {
  final Document? existingDocument;
  final void Function()? onSaved;

  const AddEditDocumentForm({super.key, this.existingDocument, this.onSaved});

  @override
  State<AddEditDocumentForm> createState() => _AddEditDocumentFormState();
}

class _AddEditDocumentFormState extends State<AddEditDocumentForm> {
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  final _referenceController = TextEditingController();
  final _dateController = TextEditingController();
  final _reminderController = TextEditingController();

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
    final cats = await DatabaseHelper().getCategories();
    final r = await DatabaseHelper().getLocationValues('room');
    final a = await DatabaseHelper().getLocationValues('area');
    final b = await DatabaseHelper().getLocationValues('box');

    if (!mounted) return;

    setState(() {
      categories = cats;
      rooms = r;
      areas = a;
      boxes = b;

      final doc = widget.existingDocument;
      if (doc != null) {
        _titleController.text = doc.title;
        selectedRoom = doc.locationRoom;
        selectedArea = doc.locationArea;
        selectedBox = doc.locationBox;
        _noteController.text = doc.note ?? '';
        _referenceController.text = doc.referenceNumber ?? '';
        _dateController.text = doc.date ?? '';
        _reminderController.text = doc.reminderDays?.toString() ?? '';
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
    if (_titleController.text.trim().isEmpty ||
        selectedCategoryId == null ||
        selectedRoom == null ||
        selectedArea == null ||
        selectedBox == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos obligatorios.')),
      );
      return;
    }

    final now = DateTime.now().toIso8601String();
    final doc = Document(
      id: widget.existingDocument?.id,
      title: _titleController.text.trim(),
      categoryId: selectedCategoryId!,
      locationRoom: selectedRoom!,
      locationArea: selectedArea!,
      locationBox: selectedBox!,
      note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
      referenceNumber: _referenceController.text.trim().isEmpty ? null : _referenceController.text.trim(),
      date: _dateController.text.trim().isEmpty ? null : _dateController.text.trim(),
      reminderDays: int.tryParse(_reminderController.text.trim()),
      isPrivate: isPrivate,
      nfcId: widget.existingDocument?.nfcId,
      imagePath: _imagePath,
      createdAt: widget.existingDocument?.createdAt ?? now,
      updatedAt: now,
    );

    if (widget.existingDocument == null) {
      await DatabaseHelper().insertDocument(doc);
    } else {
      await DatabaseHelper().updateDocument(doc);
    }

    widget.onSaved?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DocumentFormFields(
          titleController: _titleController,
          noteController: _noteController,
          referenceController: _referenceController,
          dateController: _dateController,
          reminderController: _reminderController,
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
