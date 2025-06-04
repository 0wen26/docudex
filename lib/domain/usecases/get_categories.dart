import '../../data/models/category.dart';
import '../repositories/category_repository.dart';

class GetCategories {
  final CategoryRepository repository;

  const GetCategories(this.repository);

  Future<List<Category>> call() => repository.getCategories();
}
