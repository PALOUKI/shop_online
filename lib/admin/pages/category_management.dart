import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../core/core.dart';
import '../../models/Category.dart';
import '../../services/supabase_service.dart';

class CategoryManagement extends StatefulWidget {
  const CategoryManagement({super.key});

  @override
  State<CategoryManagement> createState() => _CategoryManagementState();
}

class _CategoryManagementState extends State<CategoryManagement> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  List<Category> _categories = [];
  bool _isLoading = false;
  Category? _selectedCategory;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final categories = await SupabaseService.getCategories();
      setState(() {
        _categories = categories;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du chargement des catégories: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _editCategory(Category category) {
    setState(() {
      _selectedCategory = category;
      _isEditing = true;
      _nameController.text = category.name;
      _descriptionController.text = category.description;
    });
  }

  Future<void> _deleteCategory(Category category) async {
    try {
      await SupabaseService.deleteCategory(category.id!, category.imagePath);
      await _loadCategories();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Catégorie supprimée avec succès!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la suppression: $e')),
      );
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        String imagePath = '';
        if (_selectedImage != null) {
          imagePath = await SupabaseService.uploadImage(_selectedImage!, 'categories');
        }

        if (_isEditing && _selectedCategory != null) {
          final updates = {
            'name': _nameController.text,
            'description': _descriptionController.text,
            if (imagePath.isNotEmpty) 'image_path': imagePath,
          };
          await SupabaseService.updateCategory(_selectedCategory!.id!, updates);
          if (imagePath.isNotEmpty && _selectedCategory!.imagePath.isNotEmpty) {
            await SupabaseService.deleteImage(_selectedCategory!.imagePath, 'categories');
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Catégorie modifiée avec succès!')),
          );
        } else {
          if (_selectedImage == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Veuillez sélectionner une image')),
            );
            return;
          }
          final category = Category(
            name: _nameController.text,
            description: _descriptionController.text,
            imagePath: '', // Sera mis à jour par createCategory
            products: [],
          );
          await SupabaseService.createCategory(category, _selectedImage!);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Catégorie créée avec succès!')),
          );
        }
        _resetForm();
        await _loadCategories();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'opération: $e')),
        );
      }
    }
  }

  void _resetForm() {
    _nameController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedImage = null;
      _selectedCategory = null;
      _isEditing = false;
    });
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
                  'Gérer des cathégories',
                  style: AppTextStyles.headline2.copyWith(
                      color: Theme.of(context).colorScheme.tertiary
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                          'Nouvelle cathégorie',
                          style: AppTextStyles.headline3.copyWith(
                              color: Colors.deepPurpleAccent
                          )
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: getSize(45),
                        child: TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Nom de la catégorie',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(13))
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
                            borderRadius: BorderRadius.all(Radius.circular(13))
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
                            _isEditing
                                ? 'Modifier la catégorie'
                                : 'Créer la catégorie',
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
                'Catégories existantes',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_categories.isEmpty)
                const Center(child: Text('Aucune catégorie disponible'))
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            category.imagePath,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.error),
                          ),
                        ),
                        title: Text(category.name),
                        subtitle: Text(
                          category.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _editCategory(category),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Confirmer la suppression'),
                                  content: Text(
                                      'Voulez-vous vraiment supprimer la catégorie "${category.name}" ?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Annuler'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _deleteCategory(category);
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
    super.dispose();
  }
}
