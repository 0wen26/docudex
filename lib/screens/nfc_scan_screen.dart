// lib/screens/nfc_scan_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:ndef/ndef.dart' as ndef;
import '../data/models/document.dart';
import '../database/database_helper.dart';
import '../data/models/category.dart';
import '../utils/app_utils.dart';
import 'document_detail_screen.dart';

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
      final availability = await FlutterNfcKit.nfcAvailability;
      if (availability != NFCAvailability.available) {
        if (!mounted) return;
        setState(() {
          error = 'NFC no disponible en este dispositivo.';
          scanning = false;
        });
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

      if (tagText == null || tagText.trim().isEmpty) {
        setState(() {
          error = 'No se pudo leer contenido de la etiqueta NFC.';
          scanning = false;
        });
        return;
      }

      final docs = await DatabaseHelper().getDocuments();
      final cats = await DatabaseHelper().getCategories();

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
      appBar: AppBar(title: const Text('Leer etiqueta NFC')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: scanning
            ? const Center(child: CircularProgressIndicator())
            : error != null
                ? Center(child: Text(error!, style: const TextStyle(color: Colors.red)))
                : matchedDocs.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.info_outline, size: 72),
                          const SizedBox(height: 16),
                          Text('Etiqueta leída: $tagId'),
                          const SizedBox(height: 8),
                          const Text('No se encontraron documentos vinculados.')
                        ],
                      )
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
