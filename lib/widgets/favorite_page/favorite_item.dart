import 'package:flutter/material.dart';
import 'package:shop_online/models/Product.dart';
import 'package:shop_online/providers/favorite_provider.dart';
import 'package:provider/provider.dart';
import '../../core/core.dart';

class FavoriteItem extends StatelessWidget {
  final Product product;
  final VoidCallback onPressed;

  const FavoriteItem({
    super.key,
    required this.product,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {

    final favoriteProvider = Provider.of<FavoriteProvider>(context);

    void removeFormFavorites(Product product){
      favoriteProvider.removeFromFavorite(product);
    }

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10, left: 15, right: 15),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSecondary,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image dans un cercle violet
            SizedBox(
              height: 70,
              width: 70,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Positioned(
                    top: -10,
                    left: -10,
                    right: -10,
                    bottom: -10,
                    child: Image.network(
                      product.imagePath,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: getWidth(40)),

            // Infos produit
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: AppTextStyles.subtitle1.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'prix: ',
                        style: AppTextStyles.subtitle1.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: AppTextStyles.subtitle1.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),

            // Icone Add to Cart
            IconButton(
              onPressed: () {
                // Tu peux appeler ici une méthode pour ajouter au panier
                removeFormFavorites(product);
              },
              icon: Icon(Icons.delete, color: Colors.red,),
              color: Theme.of(context).colorScheme.onPrimary,
              tooltip: "Ajouter au panier",
            ),
          ],
        ),
      ),
    );
  }
}
