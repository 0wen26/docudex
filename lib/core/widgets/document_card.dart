// lib/widgets/document_card.dart

import 'package:flutter/material.dart';
import 'package:docudex/data/models/document.dart';
import 'package:docudex/utils/document_utils.dart';
import 'package:docudex/utils/app_utils.dart';
import 'package:docudex/utils/icon_utils.dart';
import '../app_theme.dart';

class DocumentCard extends StatelessWidget {
  final Document document;
  final String categoryName;
  final String categoryColor;
  final String categoryIcon;
  final VoidCallback onTap;

  const DocumentCard({
    super.key,
    required this.document,
    required this.categoryName,
    required this.categoryColor,
    required this.categoryIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final urgencyColor = getUrgencyColor(document.date);
    final borderColor = hexToColor(categoryColor);
    final icon = iconFromCodePoint(categoryIcon);

    return Card(
      margin: AppTheme.cardPadding,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              backgroundColor: borderColor,
              child: Icon(icon, color: Colors.white),
            ),
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: urgencyColor,
                border: Border.all(color: Colors.white, width: 1),
              ),
            ),
          ],
        ),
        title: Text(document.title),
        subtitle: Text(
          '$categoryName\n${document.locationRoom} / ${document.locationArea} / ${document.locationBox}\n${document.date ?? 'Sin fecha'}',
        ),
        isThreeLine: true,
      ),
    );
  }
}
