import '../data/models/category.dart';

/// Returns the matching [Category] by id or a default placeholder.
Category getCategoryById(List<Category> categories, int id) {
  return categories.firstWhere(
    (cat) => cat.id == id,
    orElse: () => Category(
      name: 'Sin categoría',
      colorHex: '#666666',
      iconName: '0xe2c7',
    ),
  );
}
