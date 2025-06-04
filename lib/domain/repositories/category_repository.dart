import '../../data/models/category.dart';

abstract class CategoryRepository {
  Future<int> insertCategory(Category category);
  Future<List<Category>> getCategories();
  Future<int> updateCategory(Category category);
  Future<int> deleteCategory(int id);
}
