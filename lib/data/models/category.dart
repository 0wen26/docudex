// lib/models/category.dart

class Category {
  final int? id;
  final String name;
  final String colorHex;
  final String iconName;

  Category({this.id, required this.name, required this.colorHex, required this.iconName});

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'colorHex': colorHex,
    'iconName': iconName,
  };

  static Category fromMap(Map<String, dynamic> map) => Category(
    id: map['id'],
    name: map['name'],
    colorHex: map['colorHex'],
    iconName: map['iconName'],
  );
}
