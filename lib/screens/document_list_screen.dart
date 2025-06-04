// lib/screens/document_list_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../data/models/document.dart';
import '../data/models/category.dart';
import '../injection_container.dart';
import '../domain/usecases/get_documents.dart';
import '../domain/repositories/category_repository.dart';
import '../services/backup_service.dart';
import '../core/widgets/document_card.dart';
import '../core/widgets/search_bar.dart';
import '../core/widgets/filters_bar.dart';
import '../core/widgets/sort_menu.dart';
import '../widgets/shared/custom_app_bar.dart';
import '../widgets/shared/empty_state.dart';
import 'add_edit_document_screen.dart';
import 'category_management_screen.dart';
import 'document_detail_screen.dart';
import 'nfc_scan_screen.dart';
import 'nfc_write_screen.dart';

class DocumentListScreen extends StatefulWidget {
  const DocumentListScreen({super.key});

  @override
  State<DocumentListScreen> createState() => _DocumentListScreenState();
}

class _DocumentListScreenState extends State<DocumentListScreen> {
  List<Document> documents = [];
  List<Category> categories = [];
  List<Document> filteredDocuments = [];
  final TextEditingController _searchController = TextEditingController();
  int? selectedCategoryId;
  String urgencyFilter = 'all';
  DocumentSortOption selectedSort = DocumentSortOption.createdDesc;

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(() => _filterDocuments());
  }

  Future<void> _loadData() async {
    final docs = await getIt<GetDocuments>()();
    final cats = await getIt<CategoryRepository>().getCategories();
    setState(() {
      documents = docs;
      categories = cats;
    });
    _filterDocuments();
  }

  void _filterDocuments() {
    final query = _searchController.text.toLowerCase();
    List<Document> temp = documents.where((doc) {
      final matchesSearch =
          doc.title.toLowerCase().contains(query) ||
          doc.referenceNumber?.toLowerCase().contains(query) == true ||
          doc.locationRoom.toLowerCase().contains(query) ||
          doc.locationArea.toLowerCase().contains(query) ||
          doc.locationBox.toLowerCase().contains(query);

      final matchesCategory = selectedCategoryId == null || doc.categoryId == selectedCategoryId;
      final matchesUrgency = _matchesUrgency(doc.date);

      return matchesSearch && matchesCategory && matchesUrgency;
    }).toList();

    temp.sort(_compareDocuments);
    setState(() {
      filteredDocuments = temp;
    });
  }

  int _compareDocuments(Document a, Document b) {
    switch (selectedSort) {
      case DocumentSortOption.titleAsc:
        return a.title.toLowerCase().compareTo(b.title.toLowerCase());
      case DocumentSortOption.titleDesc:
        return b.title.toLowerCase().compareTo(a.title.toLowerCase());
      case DocumentSortOption.dateAsc:
        return _parseDate(a.date).compareTo(_parseDate(b.date));
      case DocumentSortOption.dateDesc:
        return _parseDate(b.date).compareTo(_parseDate(a.date));
      case DocumentSortOption.createdDesc:
        return b.createdAt.compareTo(a.createdAt);
    }
  }

  DateTime _parseDate(String? dateStr) {
    return DateTime.tryParse(dateStr ?? '') ?? DateTime(2100);
  }

  bool _matchesUrgency(String? dateStr) {
    if (urgencyFilter == 'all') return true;
    if (dateStr == null || dateStr.isEmpty) return false;
    final now = DateTime.now();
    final date = DateTime.tryParse(dateStr);
    if (date == null) return false;
    final diff = date.difference(now).inDays;

    return (urgencyFilter == 'valid' && diff > 7) ||
        (urgencyFilter == 'soon' && diff >= 0 && diff <= 7) ||
        (urgencyFilter == 'expired' && diff < 0);
  }

  Category _getCategory(int categoryId) {
    return categories.firstWhere(
      (cat) => cat.id == categoryId,
      orElse: () => Category(name: 'Sin categoría', colorHex: '#666666', iconName: '0xe2c7'),
    );
  }

  void _navigateToAddDocument() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddEditDocumentScreen()),
    );
    if (result == true) _loadData();
  }

  void _navigateToCategories() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CategoryManagementScreen()),
    );
    _loadData();
  }

  void _navigateToDetail(Document doc) async {
    final cat = _getCategory(doc.categoryId);
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DocumentDetailScreen(document: doc, category: cat),
      ),
    );
    if (result == true) _loadData();
  }

  void _navigateToNfcRead() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NfcScanScreen()),
    );
  }

  void _navigateToNfcWrite() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NfcWriteScreen()),
    );
  }

  Future<void> _exportBackup() async {
    final path = await BackupService().exportToJson();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Exportado a: $path')),
      );
    }
  }

  Future<void> _importBackup() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['json']);
    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final count = await BackupService().importFromJson(file);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Se importaron $count documentos')),
        );
        _loadData();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Mis Documentos',
        actions: [
          IconButton(icon: const Icon(Icons.upload_file), onPressed: _exportBackup, tooltip: 'Exportar JSON'),
          IconButton(icon: const Icon(Icons.download), onPressed: _importBackup, tooltip: 'Importar JSON'),
          IconButton(icon: const Icon(Icons.category), onPressed: _navigateToCategories),
        ],
      ),
      body: Column(
        children: [
          DocumentSearchBar(
            controller: _searchController,
            onChanged: (_) => _filterDocuments(),
          ),
          DocumentFiltersBar(
            categories: categories,
            selectedCategoryId: selectedCategoryId,
            urgencyFilter: urgencyFilter,
            onCategorySelected: (id) {
              setState(() => selectedCategoryId = id);
              _filterDocuments();
            },
            onUrgencySelected: (filter) {
              setState(() => urgencyFilter = filter);
              _filterDocuments();
            },
          ),
          Expanded(
            child: filteredDocuments.isEmpty
                ? const EmptyState(message: 'No hay documentos que coincidan')
                : ListView.builder(
                    itemCount: filteredDocuments.length,
                    itemBuilder: (context, index) {
                      final doc = filteredDocuments[index];
                      final cat = _getCategory(doc.categoryId);
                      return DocumentCard(
                        document: doc,
                        categoryName: cat.name,
                        categoryColor: cat.colorHex,
                        categoryIcon: cat.iconName,
                        onTap: () => _navigateToDetail(doc),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'nfcWrite',
            onPressed: _navigateToNfcWrite,
            tooltip: 'Escribir etiqueta NFC',
            child: const Icon(Icons.edit_note),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'nfcRead',
            onPressed: _navigateToNfcRead,
            tooltip: 'Leer etiqueta NFC',
            child: const Icon(Icons.nfc),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'addDoc',
            onPressed: _navigateToAddDocument,
            tooltip: 'Añadir documento',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
