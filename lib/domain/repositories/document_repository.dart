import '../../data/models/document.dart';

abstract class DocumentRepository {
  Future<int> insertDocument(Document doc);
  Future<List<Document>> getDocuments();
  Future<int> updateDocument(Document doc);
  Future<int> deleteDocument(int id);
}
