import 'package:flutter/material.dart';
import 'package:shop_online/models/Product.dart';
import 'package:provider/provider.dart';
import '../../core/core.dart';
import '../../providers/cart_provider.dart';

class CartItem extends StatefulWidget {
  Product product;
  final int index;

   CartItem({
      super.key,
      required this.product,
     required this.index
   });

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context) {
    AppConfigSize.init(context);


    return Consumer<CartProvider>(
        builder: (context, cartProvider, child)
        => Container(
          padding: EdgeInsets.all(12),
          margin: EdgeInsets.only(left: 20, right: 20, top: 15),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSecondary,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 10),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image de la chaussure
              /*Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.deepPurpleAccent, // Couleur du cercle violet
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(6), // Pour laisser un petit espace entre l'image et le bord
                child: ClipOval(
                  child: Image.asset(
                    widget.product.imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

               */
              SizedBox(
                height: 80,
                width: 80,
                child: Stack(
                  clipBehavior: Clip.none, // Permet à l'image de dépasser le cercle
                  children: [
                    // Cercle violet
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    // Image qui peut dépasser
                    Positioned(
                      top: -15, // Tu peux ajuster le débordement ici
                      left: -10,
                      right: -10,
                      bottom: -15,
                      child: Image.network(
                        widget.product.imagePath,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 12),
              // Détails
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.product.name,
                        style: AppTextStyles.subtitle1.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        onPressed: (){
                          cartProvider.decrementQuantity(widget.index);
                          setState(() {}); // Force UI update
                        },
                        icon: Icon(
                            Icons.remove_circle_outline,
                            color: Theme.of(context).colorScheme.primary
                        ),
                      ),
                      Text(
                        "x${cartProvider.getQuantity(widget.product)}",
                        style: TextStyle(
                            fontSize: 16,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      IconButton(
                        onPressed: (){
                          cartProvider.incrementQuantity(widget.index);
                          setState(() {}); // Force UI update
                        },
                        icon: Icon(
                            Icons.add_circle_outline,
                            color: Theme.of(context).colorScheme.primary
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Spacer(),
              // Supprimer + Prix
              Column(
                children: [
                  IconButton(
                    onPressed: () {
                      cartProvider.removeItemFromCart(widget.product);
                    },
                    icon: Icon(Icons.delete, color: Colors.red),
                  ),
                  Text(
                    '\$${widget.product.price.toStringAsFixed(2)}',
                    style: AppTextStyles.bodyText1.copyWith(
                      fontSize: 17,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
    );
  }
}
