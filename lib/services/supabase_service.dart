import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import '../models/Category.dart';
import '../models/Product.dart';
import '../config/supabase_config.dart';

class SupabaseService {
  static final supabase = Supabase.instance.client;

  // Noms des buckets pour le stockage
  static const String categoriesBucket = 'categories';
  static const String productsBucket = 'products';

  // Initialiser Supabase
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      anonKey: SupabaseConfig.anonKey,
    );
  }

  // Upload une image vers Supabase Storage
  static Future<String> uploadImage(File imageFile, String bucket) async {
    final fileExt = imageFile.path.split('.').last;
    final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
    await supabase.storage
        .from(bucket)
        .upload(
          fileName,
          imageFile,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
        );
    return supabase.storage.from(bucket).getPublicUrl(fileName);
  }

  // Supprimer une image de Supabase Storage
  static Future<void> deleteImage(String imagePath, String bucket) async {
    final fileName = imagePath.split('/').last;
    await supabase.storage.from(bucket).remove([fileName]);
  }

  // Récupérer toutes les catégories
  static Future<List<Category>> getCategories() async {
    try {
      print('Début de getCategories()'); // Debug
      final response = await supabase
          .from('categories')
          .select('*, products(*)')
          .order('name');

      print('Response brute de Supabase: $response'); // Debug
      print('Nombre de catégories reçues: ${(response as List).length}'); // Debug

      final List<Category> categories = [];
      for (var category in (response as List)) {
        final List<Product> products = [];

        // Gestion des produits si présents
        if (category['products'] != null) {
          for (var product in (category['products'] as List)) {
            products.add(
              Product(
                id: (product['id'] ?? '').toString(),
                name: product['name'] ?? '',
                description: product['description'] ?? '',
                //price: product['price'].toDouble(),
                //price: double.parse(product['price'].toString()),
                price: double.tryParse(product['price'].toString()) ?? 0.0,
                quantity: int.tryParse(product['quantity'].toString()) ?? 0,
                inStock: product['in_stock'] ?? false,
                imagePath: product['image_path'] ?? '',
                categoryId: (product['category_id'] ?? '').toString(),
              ),
            );
          }
        }

        categories.add(
          Category(
            id: (category['id'] ?? '').toString(),
            name: category['name'] ?? '',
            description: category['description'] ?? '',
            imagePath: category['image_path'] ?? '',
            products: products,
          ),
        );
      }

      return categories;
    } catch (e, stackTrace) {
      print('Erreur dans getCategories: $e');
      print('Stack trace: $stackTrace');
      return [];
    }
  }

  // Créer une nouvelle catégorie
  static Future<void> createCategory(Category category, File imageFile) async {
    // Upload l'image d'abord
    final imagePath = await uploadImage(imageFile, categoriesBucket);

    // Crée la catégorie avec le chemin de l'image
    await supabase.from('categories').insert({
      'name': category.name,
      'description': category.description,
      'image_path': imagePath,
    });
  }

  // Modifier une catégorie
  static Future<void> updateCategory(
    String id,
    Map<String, dynamic> updates,
  ) async {
    await supabase.from('categories').update(updates).eq('id', id);
  }

  // Supprimer une catégorie
  static Future<void> deleteCategory(String id, String imagePath) async {
    // Supprime l'image d'abord
    await deleteImage(imagePath, categoriesBucket);

    // Supprime la catégorie
    await supabase.from('categories').delete().eq('id', id);
  }

  // Récupérer tous les produits
  static Future<List<Product>> getProducts() async {
    try {
      final response = await supabase
          .from('products')
          .select('*, categories(*)')
          .order('name');

      print('Response brute de Supabase (products): $response'); // Debug

      final List<Product> products = [];
      for (var product in (response as List)) {
        products.add(
          Product(
            id: (product['id'] ?? '').toString(),
            name: product['name'] ?? '',
            description: product['description'] ?? '',
            /*
            price: (product['price'] ?? 0.0).toDouble(),
            quantity: (product['quantity'] ?? 0),

             */
            price: double.tryParse(product['price'].toString()) ?? 0.0,
            quantity: int.tryParse(product['quantity'].toString()) ?? 0,
            inStock: product['in_stock'] ?? false,
            imagePath: product['image_path'] ?? '',
            categoryId: (product['category_id'] ?? '').toString(),
          ),
        );
      }

      return products;
    } catch (e, stackTrace) {
      print('Erreur dans getProducts: $e');
      print('Stack trace: $stackTrace');
      return [];
    }
  }

  // Créer un nouveau produit
  static Future<void> createProduct(
    String categoryId,
    Map<String, dynamic> product,
    File imageFile,
  ) async {
    // Upload l'image d'abord
    final imagePath = await uploadImage(imageFile, productsBucket);

    // Crée le produit avec le chemin de l'image
    try {
      // S'assurer que les valeurs sont du bon type
      if (!(product['price'] is num)) {
        throw FormatException('Le prix doit être un nombre');
      }
      if (!(product['quantity'] is num)) {
        throw FormatException('La quantité doit être un nombre');
      }

      await supabase.from('products').insert({
        'category_id': categoryId,
        'name': (product['name'] ?? '').toString(),
        'description': (product['description'] ?? '').toString(),
        'price': product['price'],
        'quantity': product['quantity'],
        'in_stock': product['in_stock'] ?? true,
        'image_path': imagePath,
      });
    } catch (e) {
      print('Erreur lors de la création du produit: $e');
      throw Exception('Erreur lors de la création du produit: $e');
    }
  }

  // Modifier un produit
  static Future<void> updateProduct(
    String id,
    Map<String, dynamic> updates,
  ) async {
    await supabase.from('products').update(updates).eq('id', id);
  }

  // Supprimer un produit
  static Future<void> deleteProduct(String id, String imagePath) async {
    // Supprime l'image d'abord
    await deleteImage(imagePath, productsBucket);

    // Supprime le produit
    await supabase.from('products').delete().eq('id', id);
  }
}
