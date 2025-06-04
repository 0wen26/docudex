import 'package:get_it/get_it.dart';

import 'database/database_helper.dart';
import 'data/repositories/document_repository_impl.dart';
import 'domain/usecases/get_documents.dart';
import 'domain/repositories/document_repository.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());
  getIt.registerLazySingleton<DocumentRepository>(
    () => DocumentRepositoryImpl(databaseHelper: getIt()),
  );
  getIt.registerFactory(() => GetDocuments(getIt()));
}
