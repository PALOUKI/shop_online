import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order_model.dart';
import '../widgets/cart_page/cart_item.dart';

class OrderService {
  static const String _ordersKey = 'orders';
  final SharedPreferences _prefs;

  OrderService(this._prefs);

  Future<List<OrderModel>> getUserOrders(String userId) async {
    final ordersJson = _prefs.getStringList(_ordersKey) ?? [];
    return ordersJson.map((json) => OrderModel.fromJson(jsonDecode(json))).where((order) => order.userId == userId).toList();
  }

  Future<OrderModel> createOrder({
    required String userId,
    required List<CartItem> cartItems,
    required double totalAmount,
    required String? shippingAddress,
  }) async {
    final ordersJson = _prefs.getStringList(_ordersKey) ?? [];
    final orders = ordersJson.map((json) => OrderModel.fromJson(jsonDecode(json))).toList();

    // Créer une nouvelle commande
    final newOrder = OrderModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      items: cartItems.map((item) => OrderItem(
        productId: item.product.id.toString(),
        productName: item.product.name,
        price: item.product.price,
        quantity: cartItems.firstWhere((cartItem) => cartItem.product.id == item.product.id).index,
        imageUrl: item.product.imagePath,
      )).toList(),
      totalAmount: totalAmount,
      orderDate: DateTime.now(),
      status: OrderStatus.pending,
      shippingAddress: shippingAddress,
    );

    // Ajouter la nouvelle commande à la liste
    orders.add(newOrder);

    // Sauvegarder la liste mise à jour
    await _prefs.setStringList(
      _ordersKey,
      orders.map((order) => jsonEncode(order.toJson())).toList(),
    );

    return newOrder;
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    final ordersJson = _prefs.getStringList(_ordersKey) ?? [];
    final orders = ordersJson.map((json) => OrderModel.fromJson(jsonDecode(json))).toList();

    final orderIndex = orders.indexWhere((order) => order.id == orderId);
    if (orderIndex != -1) {
      final updatedOrder = OrderModel(
        id: orders[orderIndex].id,
        userId: orders[orderIndex].userId,
        items: orders[orderIndex].items,
        totalAmount: orders[orderIndex].totalAmount,
        orderDate: orders[orderIndex].orderDate,
        status: newStatus,
        shippingAddress: orders[orderIndex].shippingAddress,
      );

      orders[orderIndex] = updatedOrder;

      await _prefs.setStringList(
        _ordersKey,
        orders.map((order) => jsonEncode(order.toJson())).toList(),
      );
    }
  }
}
