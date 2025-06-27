import 'package:flutter/material.dart';
import 'package:shop_online/core/appConfigSize.dart';
import 'package:shop_online/core/appStyles.dart';
import 'package:shop_online/core/assetsConstants.dart';
import 'package:shop_online/models/Product.dart';
import 'package:shop_online/providers/favorite_provider.dart';
import 'package:provider/provider.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  final void Function()? onTap;

  const ProductTile({
    super.key,
    required this.product,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {

    //final provider = FavoriteProvider.of(context);
    //final isExist = provider.isExist(product);


    return Consumer<FavoriteProvider>(
      builder: (context, favoriteProvider, child)
      => GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSecondary,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                    child: Container(
                      height: getHeight(150), // Hauteur fixe pour l'image
                      width: double.infinity,
                      child: Image.network(
                        product.imagePath,
                        fit: BoxFit.contain, // Ajustement pour éviter les débordements
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      color: Colors.black54.withOpacity(0.7),
                      child: Text(
                        product.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14, // Réduction de la taille de la police
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 8,
                    child: IconButton(
                        onPressed: () => favoriteProvider.toggleFavorites(product),
                        icon:  favoriteProvider.isExist(product) ? Icon(Icons.favorite, color: Colors.red,) : Icon(Icons.favorite_border_outlined, color: Colors.red,)
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, left: 10), // Réduction du padding
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if(product.inStock)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "En Stock",
                            style: AppTextStyles.subtitle1.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 12, // Réduction de la taille de la police
                            ),
                          ),
                          Image.asset(AssetsConstants.inStock, width: 20, height: 20,), // Réduction de la taille de l'image
                        ],
                      ),
                    if(!product.inStock)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Stock épuisé",
                            style: AppTextStyles.subtitle1.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 12, // Réduction de la taille de la police
                            ),
                          ),
                          Image.asset(AssetsConstants.outOfStock, width: 20, height: 20,), // Réduction de la taille de l'image
                        ],
                      )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'prix:',
                      style: AppTextStyles.subtitle2.copyWith(
                        color: Colors.grey.shade900,
                        fontWeight: FontWeight.bold,
                        fontSize: 12, // Réduction de la taille de la police
                      ),
                    ),
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: AppTextStyles.subtitle2.copyWith(
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.bold,
                        fontSize: 12, // Réduction de la taille de la police
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
