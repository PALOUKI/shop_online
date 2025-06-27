import 'package:flutter/material.dart';
import 'package:shop_online/models/Product.dart';
import 'package:provider/provider.dart';

class CartProvider with ChangeNotifier {
  //List of items in cart with their quantities
  final Map<Product, int> _cartItems = {};

  //get List of items in cart
  List<Product> getUserCart() {
    return _cartItems.keys.toList();
  }

  //get quantity for a specific product
  int getQuantity(Product product) {
    return _cartItems[product] ?? 0;
  }

  //remove item from cart
  void removeItemFromCart(Product item) {
    _cartItems.remove(item);
    notifyListeners();
  }

  void toggleCartProducts(Product product) {
    if (_cartItems.containsKey(product)) {
      _cartItems[product] = (_cartItems[product] ?? 0) + 1;
    } else {
      _cartItems[product] = 1;
    }
    notifyListeners();
  }

  void incrementQuantity(int index) {
    final product = getUserCart()[index];
    _cartItems[product] = (_cartItems[product] ?? 0) + 1;
    notifyListeners();
  }

  void decrementQuantity(int index) {
    final product = getUserCart()[index];
    final currentQuantity = _cartItems[product] ?? 0;
    if (currentQuantity > 1) {
      _cartItems[product] = currentQuantity - 1;
    } else {
      _cartItems.remove(product);
    }
    notifyListeners();
  }

  // get the total price
  double get getTotalPrice {
    double total = 0;
    _cartItems.forEach((product, quantity) {
      total += product.price * quantity;
    });
    return total;
  }

  static CartProvider of(BuildContext context, {listen = false}) {
    return Provider.of<CartProvider>(context, listen: listen);
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}