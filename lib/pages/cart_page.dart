import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/core.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import '../widgets/cart_page/cart_item.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    AppConfigSize.init(context);
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final cartItems = cartProvider.getUserCart();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Padding(
              padding:  EdgeInsets.only(left: getWidth(5), top: getHeight(40) ),
              child: Text(
                "Mon panier",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),

            cartItems.length != 0
            ?
              Expanded(
                //flex: 2,
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final product = cartItems[index];
                    return CartItem(product: product, index: index);
                  },
                ),
              )
            : Expanded(
                child: Center(
                  child: Image.asset(AssetsConstants.emptyCart),
                )
            ),


            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          '${cartProvider.getTotalPrice.toStringAsFixed(2)} €',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: getHeight(54),
                      child: ElevatedButton(
                        onPressed: () async {
                          final authProvider = context.read<AuthProvider>();
                          if (!authProvider.isAuthenticated) {
                            Navigator.pushNamed(context, RouteName.login);
                            return;
                          }
                          
                          final orderProvider = context.read<OrderProvider>();
                          
                          // Convertir les produits en CartItems
                          final cartItemsList = cartItems.asMap().entries.map((entry) =>
                            CartItem(
                              product: entry.value,
                              index: entry.key,
                            )
                          ).toList();


                          if(cartItemsList.isNotEmpty){

                              final newOrder = await orderProvider.createOrder(
                                userId: authProvider.currentUser!.id,
                                cartItems: cartItemsList,
                                totalAmount: cartProvider.getTotalPrice,
                                shippingAddress: null, // À implémenter plus tard
                              );

                              if (newOrder != null) {
                                cartProvider.clearCart();
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.success,
                                  title: 'Commande',
                                  desc: 'Commande validé avec succès',
                                  btnOkText: "Voir",
                                  btnCancelText: "Fermer",
                                  btnCancelOnPress: () {
                                    Navigator.pop(context);
                                  },
                                  btnOkOnPress: () {
                                    Navigator.pushNamed(
                                        context,
                                        RouteName.orderPage,
                                        arguments: null
                                    );
                                  },
                                ).show();
                              }

                          } else {

                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              title: 'Commande',
                              desc: 'Veuillez choisir des articles avant de valider votre commande',
                              btnOkText: "Voir articles",
                              btnCancelText: "Fermer",
                              btnCancelOnPress: () {
                                Navigator.pop(context);
                              },
                              btnOkOnPress: () {
                                Navigator.pushNamed(
                                    context,
                                    RouteName.seeAllProducts,
                                    arguments: null
                                );
                              },
                            ).show();




                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.onSecondary,
                          foregroundColor:
                              Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.shopping_cart_checkout),
                            SizedBox(width: 10),
                            Text(
                              'Commander',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
