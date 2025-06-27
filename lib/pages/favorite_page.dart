import 'package:flutter/material.dart';
import 'package:shop_online/providers/cart_provider.dart';
import 'package:shop_online/providers/favorite_provider.dart';
import 'package:shop_online/widgets/favorite_page/favorite_item.dart';
import '../core/core.dart';
import '../models/Product.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    
    AppConfigSize.init(context);
    
    final favoriteProvider = FavoriteProvider.of(context);
    final cartProvider = CartProvider.of(context);
    final favoritesProducts = favoriteProvider.favoriteProducts;

    return Container(
      child: Column(
        children: [
          Padding(
            padding:  EdgeInsets.only(left: getWidth(5), top: getHeight(40) ),
            child: Row(
              children: [
                Text(
                  "Mes favoris",
                  style: AppTextStyles.headline2.copyWith(
                    color: Colors.grey.shade500,
                  ),
                ),
                Icon(Icons.favorite, color: Colors.red),
              ],
            ),
          ),
          favoritesProducts.length != 0
          ?
          Expanded(
            //flex: 2,
            child: ListView.builder(
              itemCount: favoritesProducts.length,
              itemBuilder: (context, index) {
                //get individual Product
                Product product = favoritesProducts[index];

                //return the cart item
                return GestureDetector(
                  onTap:
                      () => Navigator.pushNamed(
                        context,
                        RouteName.detailPage,
                        arguments: product,
                      ),
                  child: FavoriteItem(
                    product: product,
                    onPressed:
                        () => Navigator.pushNamed(
                          context,
                          RouteName.detailPage,
                          arguments: product,
                        ),
                  ),
                );
              },
            ),
          )
              :
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Aucun favoris",
                        style: AppTextStyles.subtitle1.copyWith(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Icon(Icons.favorite, size: 50, color: Theme.of(context).colorScheme.tertiary,)
                    ],
                  ),
                ),
              )
        ],
      ),
    );
  }
}
