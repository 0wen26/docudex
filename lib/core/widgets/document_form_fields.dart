// lib/widgets/document_form_fields.dart

import 'package:flutter/material.dart';
import '../../services/nfc_service.dart';
import '../../data/models/category.dart';
//import 'add_category_dialog.dart';

import '../../widgets/labeled_text_field.dart';
import '../../widgets/date_picker_field.dart';
import '../../widgets/category_selector.dart';
import '../../widgets/location_dropdown.dart';

class DocumentFormFields extends StatefulWidget {
  final TextEditingController titleController;
  final TextEditingController noteController;
  final TextEditingController referenceController;
  final TextEditingController dateController;
  final TextEditingController reminderController;
  final List<Category> categories;
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
  final VoidCallback onReadNfc;
  final bool isSaving;

  const DocumentFormFields({super.key,
    required this.titleController,
    required this.noteController,
    required this.referenceController,
    required this.dateController,
    required this.reminderController,
    required this.categories,
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
          label: 'Título',
          isRequired: true,
        ),
        CategorySelector(
          categories: widget.categories,
          selectedId: widget.selectedCategoryId,
          onChanged: widget.onCategoryChanged,
          onAdd: widget.onAddCategory,
        ),
        LocationDropdown(
          type: 'room',
          value: widget.selectedRoom,
          onChanged: widget.onRoomChanged,
          validator: (val) => val == null ? 'Campo obligatorio' : null,
        ),
        LocationDropdown(
          type: 'area',
          value: widget.selectedArea,
          onChanged: widget.onAreaChanged,
          validator: (val) => val == null ? 'Campo obligatorio' : null,
        ),
        LocationDropdown(
          type: 'box',
          value: widget.selectedBox,
          onChanged: widget.onBoxChanged,
          validator: (val) => val == null ? 'Campo obligatorio' : null,
        ),
        Row(
          children: [
            Expanded(
              child: LabeledTextField(
                controller: widget.referenceController,
                label: 'Nº de referencia (NFC)',
                isRequired: true,
              ),
            ),
            IconButton(icon: const Icon(Icons.nfc), onPressed: _readNfcTag),
          ],
        ),
        LabeledTextField(
          controller: widget.noteController,
          label: 'Nota (opcional)',
        ),
        DatePickerField(
          controller: widget.dateController,
          label: 'Fecha de caducidad (opcional)',
        ),
        LabeledTextField(
          controller: widget.reminderController,
          label: 'Recordatorio días antes (opcional)',
          keyboardType: TextInputType.number,
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
