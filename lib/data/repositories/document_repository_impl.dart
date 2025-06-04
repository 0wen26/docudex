import '../../database/database_helper.dart';
import '../models/document.dart';
import '../../domain/repositories/document_repository.dart';

class DocumentRepositoryImpl implements DocumentRepository {
  final DatabaseHelper databaseHelper;

  DocumentRepositoryImpl({required this.databaseHelper});

  @override
  Future<int> deleteDocument(int id) {
    return databaseHelper.deleteDocument(id);
  }

  @override
  Future<List<Document>> getDocuments() {
    return databaseHelper.getDocuments();
  }

  @override
  Future<int> insertDocument(Document doc) {
    return databaseHelper.insertDocument(doc);
  }

  @override
  Future<int> updateDocument(Document doc) {
    return databaseHelper.updateDocument(doc);
  }
}
