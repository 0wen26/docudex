// lib/screens/nfc_scan_screen.dart

import 'package:flutter/material.dart';
import '../services/nfc_service.dart';
import '../data/models/document.dart';
import '../data/models/category.dart';
import '../domain/repositories/document_repository.dart';
import '../domain/repositories/category_repository.dart';
import '../injection_container.dart';
import '../utils/app_utils.dart';
import '../utils/icon_utils.dart';
import 'document_detail_screen.dart';
import '../widgets/shared/custom_app_bar.dart';
import '../widgets/shared/empty_state.dart';

class NfcScanScreen extends StatefulWidget {
  const NfcScanScreen({super.key});

  @override
  State<NfcScanScreen> createState() => _NfcScanScreenState();
}

class _NfcScanScreenState extends State<NfcScanScreen> {
  String? tagId;
  String? error;
  bool scanning = true;
  List<Document> matchedDocs = [];
  List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  Future<void> _startScan() async {
    setState(() {
      tagId = null;
      error = null;
      matchedDocs = [];
      scanning = true;
    });

    try {
      final tagText = await NfcService.readNdefText();

      if (!mounted) return;

      if (tagText == null || tagText.trim().isEmpty) {
        setState(() {
          error = 'No se pudo leer contenido de la etiqueta NFC.';
          scanning = false;
        });
        return;
      }

      final docs = await getIt<DocumentRepository>().getDocuments();
      final cats = await getIt<CategoryRepository>().getCategories();

      final matches = docs.where((doc) => doc.referenceNumber == tagText).toList();

      setState(() {
        tagId = tagText;
        categories = cats;
        matchedDocs = matches;
        scanning = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = 'Error al escanear: \$e';
        scanning = false;
      });
    }
  }

  Category _getCategory(int categoryId) {
    return categories.firstWhere(
      (cat) => cat.id == categoryId,
      orElse: () => Category(name: 'Sin categoría', colorHex: '#666666', iconName: '0xe2c7'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Leer etiqueta NFC'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: scanning
            ? const Center(child: CircularProgressIndicator())
            : error != null
                ? Center(child: Text(error!, style: const TextStyle(color: Colors.red)))
                : matchedDocs.isEmpty
                    ? EmptyState(message: 'Etiqueta $tagId sin documentos vinculados')
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Etiqueta leída: $tagId', style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 16),
                          Text('Documentos encontrados:', style: Theme.of(context).textTheme.titleSmall),
                          const SizedBox(height: 8),
                          Expanded(
                            child: ListView.builder(
                              itemCount: matchedDocs.length,
                              itemBuilder: (context, index) {
                                final doc = matchedDocs[index];
                                final cat = _getCategory(doc.categoryId);
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: hexToColor(cat.colorHex),
                                    child: Icon(
                                      iconFromCodePoint(cat.iconName),
                                      color: Colors.white,
                                    ),
                                  ),
                                  title: Text(doc.title),
                                  subtitle: Text('${doc.locationRoom} / ${doc.locationBox}'),
                                  onTap: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DocumentDetailScreen(document: doc, category: cat),
                                      ),
                                    );
                                    if (result == true) _startScan();
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _startScan,
        icon: const Icon(Icons.refresh),
        label: const Text('Reescanear'),
      ),
    );
  }
}
