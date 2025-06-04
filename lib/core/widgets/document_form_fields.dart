// lib/widgets/document_form_fields.dart

import 'package:flutter/material.dart';
import '../../services/nfc_service.dart';
import '../../data/models/category.dart';
//import 'add_category_dialog.dart';
import 'location_dialog.dart';
import '../../widgets/labeled_text_field.dart';
import '../../widgets/date_picker_field.dart';
import '../../widgets/category_selector.dart';

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
  final bool isSaving;

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
    required this.onReadNfc,
    required this.isSaving});

  @override
  State<DocumentFormFields> createState() => _DocumentFormFieldsState();
}

class _DocumentFormFieldsState extends State<DocumentFormFields> {

  Future<void> _readNfcTag() async {
    try {
      final id = await NfcService.readTag();
      if (!mounted) return;
      if (id != null) {
        widget.referenceController.text = id;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Referencia le\u00edda: ' + id)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo leer la etiqueta.')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al leer NFC: ' + e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LabeledTextField(
          controller: widget.titleController,
          label: 'Título*',
          validator: (value) =>
              (value == null || value.isEmpty) ? 'Campo obligatorio' : null,
        ),
        CategorySelector(
          categories: widget.categories,
          selectedId: widget.selectedCategoryId,
          onChanged: widget.onCategoryChanged,
          onAdd: widget.onAddCategory,
        ),
        buildLocationDropdown(
          context,
          'Sala',
          'room',
          widget.rooms,
          widget.selectedRoom,
          widget.onRoomChanged,
          widget.onReload,
          (val) => val == null ? 'Campo obligatorio' : null,
        ),
        buildLocationDropdown(
          context,
          'Área',
          'area',
          widget.areas,
          widget.selectedArea,
          widget.onAreaChanged,
          widget.onReload,
          (val) => val == null ? 'Campo obligatorio' : null,
        ),
        buildLocationDropdown(
          context,
          'Caja',
          'box',
          widget.boxes,
          widget.selectedBox,
          widget.onBoxChanged,
          widget.onReload,
          (val) => val == null ? 'Campo obligatorio' : null,
        ),
        Row(
          children: [
            Expanded(
              child: LabeledTextField(
                controller: widget.referenceController,
                label: 'Nº de referencia (NFC)',
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Campo obligatorio' : null,
              ),
            ),
            IconButton(icon: const Icon(Icons.nfc), onPressed: _readNfcTag),
          ],
        ),
        LabeledTextField(
          controller: widget.noteController,
          label: 'Nota (opcional)',
          validator: (value) =>
              (value == null || value.isEmpty) ? 'Campo obligatorio' : null,
        ),
        DatePickerField(
          controller: widget.dateController,
          label: 'Fecha de caducidad (opcional)',
          validator: (value) =>
              (value == null || value.isEmpty) ? 'Campo obligatorio' : null,
        ),
        LabeledTextField(
          controller: widget.reminderController,
          label: 'Recordatorio días antes (opcional)',
          keyboardType: TextInputType.number,
          validator: (value) =>
              (value == null || value.isEmpty) ? 'Campo obligatorio' : null,
        ),
        SwitchListTile(
          value: widget.isPrivate,
          onChanged: widget.onPrivateChanged,
          title: const Text('Marcar como privado'),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: widget.isSaving ? null : widget.onSubmit,
          child: widget.isSaving
              ? const CircularProgressIndicator()
              : const Text('Guardar'),
        ),
      ],
    );
  }
}
