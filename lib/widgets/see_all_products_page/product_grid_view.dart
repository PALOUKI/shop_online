import 'package:flutter/material.dart';
import 'package:redacted/redacted.dart';

import '../../core/routes/routes_names.dart';
import '../../models/Product.dart';
import '../category_page/product_tile.dart';

class ProductGridView extends StatefulWidget {
  final bool isLoading;
  final List<Product> products;
  final List<Product> filteredProducts;
  const ProductGridView({
    super.key,
    required this.isLoading,
    required this.products,
    required this.filteredProducts
  });

  @override
  State<ProductGridView> createState() => _ProductGridViewState();
}

class _ProductGridViewState extends State<ProductGridView> {
  @override
  Widget build(BuildContext context) {
    return widget.isLoading
        ? Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.75,
        ),
        itemCount: 6, // Nombre fictif
        itemBuilder: (context, index) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(10),
          ),
        ).redacted( // Appliquer ici
          context: context,
          redact: true,
        ),
      ),
    )
        : widget.products.isEmpty
        ? Expanded(child: Center(child: Text("Vous êtes hors connexion !!!"),))
        : Expanded(
      child: Container(
        child: GridView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Deux colonnes
            crossAxisSpacing: 10, // Espacement horizontal
            mainAxisSpacing: 10, // Espacement vertical
            childAspectRatio: 0.75, // Proportion largeur/hauteur pour éviter les débordements
          ),
          itemCount: widget.filteredProducts.length,
          itemBuilder: (context, index) {
            final product = widget.filteredProducts[index];
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
    );
  }
}
