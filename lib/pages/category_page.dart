import 'package:flutter/material.dart';
import 'package:shop_online/core/appConfigSize.dart';
import 'package:shop_online/core/core.dart';
import 'package:shop_online/widgets/category_page//product_tile.dart';
import '../models/Category.dart';

class CategoryPage extends StatefulWidget {
  final Category category;
  const CategoryPage({super.key, required this.category});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {



  @override
  Widget build(BuildContext context) {
    AppConfigSize.init(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: Stack(
                  children: [
                    Image.network(
                      widget.category.imagePath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height:  MediaQuery.of(context).orientation == Orientation.portrait ? getHeight(300) : getHeight(400),
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: getHeight(300),
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: Icon(Icons.error_outline, color: Colors.grey[500]),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: getHeight(300),
                          width: double.infinity,
                          color: Colors.grey[200],
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height:  MediaQuery.of(context).orientation == Orientation.portrait ? getHeight(120) : getHeight(180),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.category.name,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              widget.category.description,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.9),
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //TODO: make clothes items GridView.builder
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: GridView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(20),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Deux colonnes
                      crossAxisSpacing: 10, // Espacement horizontal
                      mainAxisSpacing: 10, // Espacement vertical
                      childAspectRatio: 0.75, // Proportion largeur/hauteur pour éviter les débordements
                    ),
                    itemCount: widget.category.products.length,
                    itemBuilder: (context, index) {
                      final product = widget.category.products[index];
                      return ProductTile(
                          onTap: () {
                            Navigator.pushNamed(
                                context,
                                RouteName.detailPage,
                              arguments: product
                            );

                          },
                          //onPressed: () => addClothToCart(clothItem)
                          product: product
                      );

                    },
                  ),
                ),
              )

            ],
          ),
          //TODO: Button to retun to home page
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 15,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  RouteName.navigation,
                  arguments: 0,
                );
              },
              child: Container(
                height: getHeight(40),
                width: getWidth(40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  size: 20,
                  color: Colors.black,
                ),
              ),
            ),
          ),


        ],
      ),
    );
  }
}
