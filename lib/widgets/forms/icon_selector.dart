import 'package:flutter/material.dart';

/// Displays a list of icons allowing the user to select one.
class IconSelector extends StatelessWidget {
  final List<IconData> icons;
  final IconData selected;
  final ValueChanged<IconData> onSelected;

  const IconSelector({
    super.key,
    required this.icons,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: icons
          .map(
            (icon) => GestureDetector(
              onTap: () => onSelected(icon),
              child: CircleAvatar(
                backgroundColor: selected == icon ? Colors.blueAccent : Colors.grey[300],
                child: Icon(icon, color: Colors.black),
              ),
            ),
          )
          .toList(),
    );
  }
}
