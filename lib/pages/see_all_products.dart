import 'package:flutter/material.dart';
import 'package:shop_online/core/core.dart';
import 'package:shop_online/widgets/see_all_products_page/price_filter.dart';
import 'package:shop_online/widgets/see_all_products_page/product_grid_view.dart';
import '../models/Category.dart';
import '../models/Product.dart';
import '../services/supabase_service.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/see_all_products_page/filter_category_tile.dart';

class SeeAllProducts extends StatefulWidget {
  const SeeAllProducts({super.key});

  @override
  State<SeeAllProducts> createState() => _SeeAllProductsState();
}

class _SeeAllProductsState extends State<SeeAllProducts> {

  TextEditingController _searchController = TextEditingController();
  List<Category> _filteredCategories = [];
  List<Category> _categories = [];

  List<Product> _filteredProducts = [];
  List<Product> _products = [];
  bool _isLoading = false;




  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadProducts();
  }

  Future<void> _loadCategories() async {

    final categories = await SupabaseService.getCategories();
    setState(() {
      _categories = [
        Category(id: 'all', name: 'Tous', description: 'Tous les produits', imagePath: '', products: []),
        ...categories
      ];
      _filteredCategories = _categories;
    });

    setState(() {
      _isLoading = true;
    });
    try {
      final categories = await SupabaseService.getCategories();
      setState(() {
        _categories = categories;
        _filteredCategories = categories; // init affichage
      });
    } catch (e) {
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
        _filteredProducts = products; // init affichage
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

  void filterProducts(String query) {
    final filtered = _products.where((product) {
      final nameLower = product.name.toLowerCase();
      final searchLower = query.toLowerCase();
      return nameLower.contains(searchLower);
    }).toList();

    setState(() {
      _filteredProducts = filtered;
    });
  }

  void sortByLowPrice() {
    final sortedProducts = List<Product>.from(_filteredProducts);
    sortedProducts.sort((a, b) => a.price.compareTo(b.price));
    print("Avant tri (bas): Premier prix = ${_filteredProducts.isNotEmpty ? _filteredProducts.first.price : 'Vide'}, Dernier prix = ${_filteredProducts.isNotEmpty ? _filteredProducts.last.price : 'Vide'}");
    setState(() {
      _filteredProducts = sortedProducts;
      print("Après tri (bas): Premier prix = ${_filteredProducts.isNotEmpty ? _filteredProducts.first.price : 'Vide'}, Dernier prix = ${_filteredProducts.isNotEmpty ? _filteredProducts.last.price : 'Vide'}");
    });
  }

  void sortByHighPrice() {
    final sortedProducts = List<Product>.from(_filteredProducts);
    sortedProducts.sort((a, b) => b.price.compareTo(a.price));
    print("Avant tri (haut): Premier prix = ${_filteredProducts.isNotEmpty ? _filteredProducts.first.price : 'Vide'}, Dernier prix = ${_filteredProducts.isNotEmpty ? _filteredProducts.last.price : 'Vide'}");
    setState(() {
      _filteredProducts = sortedProducts;
      print("Après tri (haut): Premier prix = ${_filteredProducts.isNotEmpty ? _filteredProducts.first.price : 'Vide'}, Dernier prix = ${_filteredProducts.isNotEmpty ? _filteredProducts.last.price : 'Vide'}");
    });
  }


  @override
  Widget build(BuildContext context) {
    AppConfigSize.init(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: getHeight(40), left: getWidth(5)),
              child: Text(
                  "Tous nos articles",
                style: AppTextStyles.headline2.copyWith(
                  color: Theme.of(context).colorScheme.tertiary
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(  left: 8),
              child: Text(
                "prix",
                style: AppTextStyles.subtitle1.copyWith(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            //filtrer par prix
            PriceFilter(
                isLoading: _isLoading,
                categories: _categories,
                sortByHighPrice: sortByHighPrice,
                sortByLowPrice: sortByLowPrice,
            ),

            Container(
              padding: EdgeInsets.only(left: getWidth(5)),
              child: Row(
                children: [
                  Text(
                    "catégories",
                    style: AppTextStyles.subtitle1.copyWith(
                        color: Theme.of(context).colorScheme.tertiary,
                      fontWeight: FontWeight.bold
                    ),
                  )
                ],
              ),
            ),

            //filtrer par catégories
            Row(
              children: [
                GestureDetector(
                  onTap: (){
                    setState(() {
                      _filteredProducts = _products;
                    });
                  },
                  child: Container(
                    height: getHeight(60),
                      width: getWidth(60),
                      margin: EdgeInsets.only(left: 10, right: 10),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.deepOrange,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Voir",
                              style: AppTextStyles.subtitle1.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: getSize(15),
                                  color: Colors.grey[100]
                              )
                          ),
                          Text("tout",
                              style: AppTextStyles.subtitle1.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: getSize(15),
                                  color: Colors.grey[100]
                              ),
                          ),
                        ],
                      )
                  ),
                ),

                //filtrer par catégories
                Expanded(
                  child: Container(
                    height: getHeight(70),
                    child: ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            final selectedCategoryId = _filteredCategories[index].id;
                            setState(() {
                              if (selectedCategoryId == 'all') {
                                _filteredProducts = _products; // Afficher tous les produits
                              } else {
                                _filteredProducts = _products.where((product) {
                                  return product.categoryId == selectedCategoryId;
                                }).toList();
                              }
                            });
                          },
                          child: FilterCategoryTile(
                            categories: _filteredCategories,
                            index: index,
                          ),
                        );
                      }, separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(width: 0);
                    },
                    ),
                  ),
                )
              ],
            ),

            SizedBox(height: getHeight(2),),
            //search part
            // Utilisation du CustomSearchBar
            CustomSearchBar(
              isLoading: _isLoading,
              controller: _searchController,
              onChanged: filterProducts,
            ),

            //grid view of products
            ProductGridView(
                isLoading: _isLoading,
                products: _products,
                filteredProducts: _filteredProducts
            )
          ],
        ),
    );
  }
}
