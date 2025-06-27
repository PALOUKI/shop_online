import 'package:shop_online/models/Product.dart';


class Category {
  final String? id;
  final String imagePath;
  final String name;
  final String description;
  final List<Product> products;

  Category({
    this.id,
    required this.imagePath,
    required this.name,
    required this.description,
    required this.products,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'image_path': imagePath,
    'name': name,
    'description': description,
    'products': products.map((p) => p.toJson()).toList(),
  };
}