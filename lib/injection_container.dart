import 'package:get_it/get_it.dart';

import 'database/database_helper.dart';
import 'data/repositories/document_repository_impl.dart';
import 'data/repositories/category_repository_impl.dart';
import 'data/repositories/location_repository_impl.dart';
import 'domain/usecases/get_documents.dart';
import 'domain/usecases/get_categories.dart';
import 'domain/repositories/document_repository.dart';
import 'domain/repositories/category_repository.dart';
import 'domain/repositories/location_repository.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());
  getIt.registerLazySingleton<DocumentRepository>(
    () => DocumentRepositoryImpl(databaseHelper: getIt()),
  );
  getIt.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(databaseHelper: getIt()),
  );
  getIt.registerLazySingleton<LocationRepository>(
    () => LocationRepositoryImpl(databaseHelper: getIt()),
  );
  getIt.registerFactory(() => GetDocuments(getIt()));
  getIt.registerFactory(() => GetCategories(getIt()));
}
