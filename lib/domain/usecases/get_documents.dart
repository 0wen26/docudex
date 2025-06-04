import '../../data/models/document.dart';
import '../repositories/document_repository.dart';

class GetDocuments {
  final DocumentRepository repository;

  const GetDocuments(this.repository);

  Future<List<Document>> call() => repository.getDocuments();
}
