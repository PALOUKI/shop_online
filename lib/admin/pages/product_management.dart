import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../core/core.dart';
import '../../models/Category.dart';
import '../../models/Product.dart';
import '../../services/supabase_service.dart';

class ProductManagement extends StatefulWidget {
  const ProductManagement({super.key});

  @override
  State<ProductManagement> createState() => _ProductManagementState();
}

class _ProductManagementState extends State<ProductManagement> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  bool _inStock = true;
  String? _selectedCategoryId;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  List<Category> _categories = [];
  List<Product> _products = [];
  bool _isLoading = false;
  Product? _selectedProduct;
  bool _isEditing = false;

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && _selectedCategoryId != null) {
      try {
        String imagePath = '';
        if (_selectedImage != null) {
          imagePath = await SupabaseService.uploadImage(_selectedImage!, 'products');
        }

        // Nettoyage et validation des valeurs
        final priceText = _priceController.text.replaceAll('€', '').trim();
        final quantityText = _quantityController.text.trim();
        
        double price;
        int quantity;
        
        try {
          price = double.parse(priceText);
          quantity = int.parse(quantityText);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Prix ou quantité invalide')),
          );
          return;
        }
        
        final productData = {
          'name': _nameController.text.trim(),
          'description': _descriptionController.text.trim(),
          'price': price,
          'quantity': quantity,
          'in_stock': _inStock,
          'image_path': imagePath,
        };

        if (_isEditing && _selectedProduct != null) {
          if (imagePath.isEmpty) {
            productData.remove('image_path');
          } else if (_selectedProduct!.imagePath.isNotEmpty) {
            await SupabaseService.deleteImage(_selectedProduct!.imagePath, 'products');
          }
          await SupabaseService.updateProduct(_selectedProduct!.id!, productData);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Produit modifié avec succès!')),
          );
        } else {
          if (_selectedImage == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Veuillez sélectionner une image')),
            );
            return;
          }
          if (_selectedImage == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Veuillez sélectionner une image')),
            );
            return;
          }
          await SupabaseService.createProduct(_selectedCategoryId!, productData, _selectedImage!);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Produit créé avec succès!')),
          );
        }
        _resetForm();
        await _loadProducts();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'opération: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs requis')),
      );
    }
  }

  void _resetForm() {
    _nameController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _quantityController.text = '1';
    setState(() {
      _selectedImage = null;
      _selectedCategoryId = null;
      _inStock = true;
      _selectedProduct = null;
      _isEditing = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _quantityController.text = '1';
    _loadCategories();
    _loadProducts();
  }

  Future<void> _loadCategories() async {
    print('Début de _loadCategories()'); // Debug
    setState(() {
      _isLoading = true;
    });
    try {
      final categories = await SupabaseService.getCategories();
      print('Catégories reçues: ${categories.length}'); // Debug
      print('Première catégorie: ${categories.isNotEmpty ? categories[0].toJson() : "aucune"}'); // Debug
      setState(() {
        _categories = categories;
      });
    } catch (e, stackTrace) {
      print('Erreur dans _loadCategories: $e'); // Debug
      print('Stack trace: $stackTrace'); // Debug
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors du chargement des catégories: $e')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final products = await SupabaseService.getProducts();
      setState(() {
        _products = products;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors du chargement des produits: $e')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _editProduct(Product product) {
    setState(() {
      _selectedProduct = product;
      _isEditing = true;
      _nameController.text = product.name;
      _descriptionController.text = product.description;
      _priceController.text = product.price.toString();
      _quantityController.text = product.quantity.toString();
      _inStock = product.inStock;
      _selectedCategoryId = product.categoryId;
    });
  }

  Future<void> _deleteProduct(Product product) async {
    try {
      await SupabaseService.deleteProduct(product.id!, product.imagePath);
      await _loadProducts();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produit supprimé avec succès!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la suppression: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  'Gérer des produits',
                  style: AppTextStyles.headline2.copyWith(
                      color: Theme.of(context).colorScheme.tertiary
                  ),
                ),
              ),
              Card(
                color: Theme.of(context).colorScheme.secondary,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                       Text(
                        'Nouveau produit',
                        style: AppTextStyles.headline3.copyWith(
                          color: Colors.deepPurpleAccent
                        )
                      ),
                      const SizedBox(height: 16),
                      _categories.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Aucune catégorie disponible. Veuillez d\'abord créer une catégorie.',
                                style: TextStyle(color: Colors.red),
                              ),
                            )
                          : SizedBox(
                            height: getHeight(50) ,
                            child: DropdownButtonFormField<String>(
                                                    value: _selectedCategoryId,
                                                    decoration: const InputDecoration(
                            labelText: 'Catégorie',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(13)),
                            ),
                                                    ),
                                                    items: _categories.map((category) {
                            return DropdownMenuItem<String>(
                              value: category.id, // 👈 utiliser l'id ici
                              child: Text(category.name),
                            );
                                                    }).toList(),
                                                    onChanged: (value) {
                            setState(() {
                              _selectedCategoryId = value;
                            });
                                                    },
                                                    validator: (value) {
                            if (value == null) {
                              return 'Veuillez sélectionner une catégorie';
                            }
                            return null;
                                                    },
                                                  ),
                          ),

                      const SizedBox(height: 16),
                      SizedBox(
                        height: getHeight(45),
                        child: TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Nom du produit',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(13)),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer un nom';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(13)),
                          ),
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer une description';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: getHeight(45),
                              child: TextFormField(
                                controller: _priceController,
                                decoration: const InputDecoration(
                                  labelText: 'Prix',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(13)),
                                  ),
                                  prefixText: 'FCFA ',
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez entrer un prix';
                                  }
                                  if (double.tryParse(value) == null) {
                                    return 'Prix invalide';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: SizedBox(
                              height: getHeight(45),
                              child: TextFormField(
                                controller: _quantityController,
                                decoration: const InputDecoration(
                                  labelText: 'Quantité',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(13)),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez entrer une quantité';
                                  }
                                  if (int.tryParse(value) == null) {
                                    return 'Quantité invalide';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        activeColor: Colors.deepPurpleAccent,
                        title: const Text('En stock'),
                        value: _inStock,
                        onChanged: (bool value) {
                          setState(() {
                            _inStock = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.image),
                        label: const Text('Sélectionner une image'),
                      ),
                      if (_selectedImage != null) ...[
                        const SizedBox(height: 8),
                        Image.file(
                          _selectedImage!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ],
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          backgroundColor: Colors.deepPurpleAccent
                        ),
                        child: Text(
                            'Créer le produit',
                          style: AppTextStyles.button
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 24),
              Text(
                'Produits existants',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_products.isEmpty)
                const Center(child: Text('Aucun produit disponible'))
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    final product = _products[index];
                    final category = _categories.firstWhere(
                      (c) => c.id == product.categoryId,
                      orElse: () => Category(
                        name: 'Catégorie inconnue',
                        description: '',
                        imagePath: '',
                        products: [],
                      ),
                    );
                    return Card(
                      color: Theme.of(context).colorScheme.secondary,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            product.imagePath,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.error),
                          ),
                        ),
                        title: Text(product.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Catégorie: ${category.name}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Text(
                              'Prix: €${product.price.toStringAsFixed(2)} | Quantité: ${product.quantity}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              product.inStock ? 'En stock' : 'Hors stock',
                              style: TextStyle(
                                color: product.inStock ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _editProduct(product),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Confirmer la suppression'),
                                  content: Text(
                                      'Voulez-vous vraiment supprimer le produit "${product.name}" ?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Annuler'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _deleteProduct(product);
                                      },
                                      child: const Text('Supprimer',
                                          style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }
}
