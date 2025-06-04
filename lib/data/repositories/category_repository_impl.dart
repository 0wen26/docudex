import '../../database/database_helper.dart';
import '../models/category.dart';
import '../../domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final DatabaseHelper databaseHelper;

  CategoryRepositoryImpl({required this.databaseHelper});

  @override
  Future<int> deleteCategory(int id) {
    return databaseHelper.deleteCategory(id);
  }

  @override
  Future<List<Category>> getCategories() {
    return databaseHelper.getCategories();
  }

  @override
  Future<int> insertCategory(Category category) {
    return databaseHelper.insertCategory(category);
  }

  @override
  Future<int> updateCategory(Category category) {
    return databaseHelper.updateCategory(category);
  }
}
