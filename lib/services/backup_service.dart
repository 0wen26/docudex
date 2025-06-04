// lib/services/backup_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../data/models/document.dart';
import '../domain/repositories/document_repository.dart';
import '../injection_container.dart';

class BackupService {
  Future<String> exportToJson() async {
    final documents = await getIt<DocumentRepository>().getDocuments();
    final jsonList = documents.map((doc) => doc.toMap()).toList();
    final jsonString = jsonEncode(jsonList);

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/docudex_backup.json');
    await file.writeAsString(jsonString);
    return file.path;
  }

  Future<int> importFromJson(File jsonFile) async {
    final content = await jsonFile.readAsString();
    final List<dynamic> jsonList = jsonDecode(content);

    int importedCount = 0;
    for (final item in jsonList) {
      final doc = Document.fromMap(item);
      await getIt<DocumentRepository>().insertDocument(doc);
      importedCount++;
    }

    return importedCount;
  }
}
