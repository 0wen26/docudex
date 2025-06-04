// lib/widgets/document_form_fields.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:ndef/ndef.dart' as ndef;
import 'package:docudex/data/models/category.dart';
//import 'add_category_dialog.dart';
import 'location_dialog.dart';

class DocumentFormFields extends StatefulWidget {
  final TextEditingController titleController;
  final TextEditingController noteController;
  final TextEditingController referenceController;
  final TextEditingController dateController;
  final TextEditingController reminderController;
  final List<Category> categories;
  final List<String> rooms, areas, boxes;
  final int? selectedCategoryId;
  final String? selectedRoom, selectedArea, selectedBox;
  final bool isPrivate;
  final void Function(int?) onCategoryChanged;
  final void Function(String?) onRoomChanged;
  final void Function(String?) onAreaChanged;
  final void Function(String?) onBoxChanged;
  final void Function(bool) onPrivateChanged;
  final VoidCallback onSubmit;
  final Future<void> Function() onAddCategory;
  final Future<void> Function() onReload;
  final VoidCallback onReadNfc;

  const DocumentFormFields({super.key,
    required this.titleController,
    required this.noteController,
    required this.referenceController,
    required this.dateController,
    required this.reminderController,
    required this.categories,
    required this.rooms,
    required this.areas,
    required this.boxes,
    required this.selectedCategoryId,
    required this.selectedRoom,
    required this.selectedArea,
    required this.selectedBox,
    required this.isPrivate,
    required this.onCategoryChanged,
    required this.onRoomChanged,
    required this.onAreaChanged,
    required this.onBoxChanged,
    required this.onPrivateChanged,
    required this.onSubmit,
    required this.onAddCategory,
    required this.onReload,
    required this.onReadNfc});

  @override
  State<DocumentFormFields> createState() => _DocumentFormFieldsState();
}

class _DocumentFormFieldsState extends State<DocumentFormFields> {
  Future<void> _selectDate(BuildContext context) async {
    DateTime initial = DateTime.now();
    if (widget.dateController.text.isNotEmpty) {
      initial = DateTime.tryParse(widget.dateController.text) ?? initial;
    }
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && mounted) {
      widget.dateController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> _readNfcTag() async {
    try {
      final availability = await FlutterNfcKit.nfcAvailability;
      if (availability != NFCAvailability.available) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('NFC no disponible.')),
        );
        return;
      }

      await FlutterNfcKit.poll(timeout: const Duration(seconds: 10));
      final records = await FlutterNfcKit.readNDEFRecords();

      String? tagText;
      for (var record in records) {
        if (record is ndef.TextRecord) {
          tagText = record.text;
          break;
        }
      }

      await FlutterNfcKit.finish();

      if (!mounted) return;

      if (tagText != null && tagText.trim().isNotEmpty) {
        widget.referenceController.text = tagText;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Referencia leída: \$tagText')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se encontró texto válido en la etiqueta.')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al leer NFC: \$e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: widget.titleController,
          decoration: const InputDecoration(labelText: 'Título'),
        ),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<int>(
                value: widget.selectedCategoryId,
                items: widget.categories.map((cat) => DropdownMenuItem(value: cat.id, child: Text(cat.name))).toList(),
                onChanged: widget.onCategoryChanged,
                decoration: const InputDecoration(labelText: 'Categoría'),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: widget.onAddCategory,
            ),
          ],
        ),
        buildLocationDropdown(context, 'Sala', 'room', widget.rooms, widget.selectedRoom, widget.onRoomChanged, widget.onReload),
        buildLocationDropdown(context, 'Área', 'area', widget.areas, widget.selectedArea, widget.onAreaChanged, widget.onReload),
        buildLocationDropdown(context, 'Caja', 'box', widget.boxes, widget.selectedBox, widget.onBoxChanged, widget.onReload),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: widget.referenceController,
                decoration: const InputDecoration(labelText: 'Nº de referencia (NFC)'),
              ),
            ),
            IconButton(icon: const Icon(Icons.nfc), onPressed: _readNfcTag),
          ],
        ),
        TextFormField(controller: widget.noteController, decoration: const InputDecoration(labelText: 'Nota (opcional)')),
        TextFormField(
          controller: widget.dateController,
          decoration: InputDecoration(
            labelText: 'Fecha de caducidad (opcional)',
            suffixIcon: IconButton(icon: const Icon(Icons.clear), onPressed: () => widget.dateController.clear()),
          ),
          readOnly: true,
          onTap: () => _selectDate(context),
        ),
        TextFormField(
          controller: widget.reminderController,
          decoration: const InputDecoration(labelText: 'Recordatorio días antes (opcional)'),
          keyboardType: TextInputType.number,
        ),
        SwitchListTile(
          value: widget.isPrivate,
          onChanged: widget.onPrivateChanged,
          title: const Text('Marcar como privado'),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: widget.onSubmit,
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}