import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/widgets/location_dialog.dart';
import '../providers/location_provider.dart';

class LocationDropdown extends StatelessWidget {
  final String type; // 'room', 'area', 'box'
  final String? value;
  final ValueChanged<String?> onChanged;
  final FormFieldValidator<String>? validator;
  final bool showAddButton;

  const LocationDropdown({
    super.key,
    required this.type,
    required this.onChanged,
    this.value,
    this.validator,
    this.showAddButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final locations = context.watch<LocationProvider>().getByType(type);

    return DropdownButtonFormField<String>(
      value: value,
      items: locations
          .map((loc) => DropdownMenuItem(value: loc, child: Text(loc)))
          .toList(),
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        labelText: 'Ubicación - ${_capitalize(type)}',
        suffixIcon: showAddButton
            ? IconButton(
                icon: const Icon(Icons.add),
                onPressed: () async {
                  final provider = context.read<LocationProvider>();
                  final added = await showAddLocationDialog(context, type);
                  if (added) provider.reload(type);
                },
              )
            : null,
      ),
    );
  }

  String _capitalize(String str) => str.isEmpty
      ? str
      : str[0].toUpperCase() + str.substring(1).toLowerCase();
}
