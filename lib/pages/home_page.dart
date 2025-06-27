import 'package:flutter/material.dart';
import 'package:shop_online/core/core.dart';
import 'package:shop_online/widgets/home_page/category_tile.dart';
import 'package:shop_online/widgets/home_page/news_section.dart';
import 'package:redacted/redacted.dart';
import '../models/Category.dart';
import '../services/supabase_service.dart';
import '../widgets/search_bar_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TextEditingController _searchController = TextEditingController();
  List<Category> _filteredCategories = [];
  List<Category> _categories = [];
  bool _isLoading = false;



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

  void filterCategories(String query) {
    final filtered = _categories.where((category) {
      final nameLower = category.name.toLowerCase();
      final searchLower = query.toLowerCase();
      return nameLower.contains(searchLower);
    }).toList();

    setState(() {
      _filteredCategories = filtered;
    });
  }


  @override
  Widget build(BuildContext context) {
    AppConfigSize.init(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: Column(
          children: [
            //search part
            CustomSearchBar(
              isLoading: _isLoading,
              controller: _searchController,
              onChanged: filterCategories,
            ),

            const SizedBox(height: 10),
            Text(
              "Everyone flies... Some fly longer than others",
              style: TextStyle(
                color: Colors.grey[500],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Coup de coeur 🔥",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),

                   _filteredCategories.isEmpty
                  ?
                   Image.asset(AssetsConstants.noInternet, height: 80, width: 80,)
                       :
                   TextButton(
                    child: Text(
                        "Voir tout",
                        style: TextStyle(color: Colors.deepPurpleAccent)
                    ),
                     onPressed: (){
                      Navigator.pushNamed(context, RouteName.seeAllProducts);
                     },
                  ),
                ],
              ),
            ),
        
        
        
            const NewsSection(),
        
        
        
            
            Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                bottom: 5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Catégories",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            _isLoading
                        ? SizedBox(
              height: 220, // Ajustez la hauteur en fonction de votre CategoryTile
              child: ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: 3, // Nombre de placeholders à afficher pendant le chargement
                itemBuilder: (context, index) => CategoryTile(
                  categories: [], // La liste n'est pas nécessaire en mode redacted
                  index: index,
                  isRedacted: true, // Indique au CategoryTile d'afficher sa version redacted
                ),
                separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(width: 10),
              ),
            )
                : _categories.isEmpty
                    ? Center(
                child: Image.asset(AssetsConstants.noInternet)
              )
                    :
             ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _filteredCategories.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        RouteName.categoryPage,
                        arguments: _filteredCategories[index],
                      );
                    },
                    child: CategoryTile(
                      categories: _filteredCategories,
                      index: index,
                    ),
                  );
                }, separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(width: 10,);
            },
            ),
          ],
        ),
      ),
    );
  }
}
