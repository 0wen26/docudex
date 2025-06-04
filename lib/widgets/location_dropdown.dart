import 'package:flutter/material.dart';

import '../core/widgets/location_dialog.dart';
import '../domain/repositories/location_repository.dart';
import '../injection_container.dart';

class LocationDropdown extends StatefulWidget {
  final String type; // 'room', 'area', 'box'
  final String label;
  final String? value;
  final ValueChanged<String?> onChanged;
  final FormFieldValidator<String>? validator;
  final bool showAddButton;

  const LocationDropdown({
    super.key,
    required this.type,
    required this.label,
    required this.onChanged,
    this.value,
    this.validator,
    this.showAddButton = true,
  });

  @override
  State<LocationDropdown> createState() => _LocationDropdownState();
}

class _LocationDropdownState extends State<LocationDropdown> {
  List<String> _options = [];

  @override
  void initState() {
    super.initState();
    _loadOptions();
  }

  Future<void> _loadOptions() async {
    final values =
        await getIt<LocationRepository>().getLocationValues(widget.type);
    if (mounted) {
      setState(() {
        _options = values;
      });
    }
  }

  Future<void> _addNew() async {
    final added = await showAddLocationDialog(context, widget.type);
    if (added) _loadOptions();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: widget.value,
      items: _options
          .map((opt) => DropdownMenuItem(value: opt, child: Text(opt)))
          .toList(),
      onChanged: widget.onChanged,
      validator: widget.validator,
      decoration: InputDecoration(
        labelText: widget.label,
        suffixIcon: widget.showAddButton
            ? IconButton(
                icon: const Icon(Icons.add),
                onPressed: _addNew,
              )
            : null,
      ),
    );
  }
}
