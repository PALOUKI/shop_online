import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../services/order_supabase_service.dart';
import '../widgets/cart_page/cart_item.dart';

class OrderProvider extends ChangeNotifier {
  final _orderService = OrderSupabaseService();
  List<OrderModel> _orders = [];
  bool _isLoading = false;

  OrderProvider();

  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;

  Future<void> loadUserOrders(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _orders = await _orderService.getUserOrders(userId);
    } catch (e) {
      debugPrint('Error loading orders: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<OrderModel?> createOrder({
    required String userId,
    required List<CartItem> cartItems,
    required double totalAmount,
    required String? shippingAddress,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final newOrder = await _orderService.createOrder(
        userId: userId,
        cartItems: cartItems,
        totalAmount: totalAmount,
        shippingAddress: shippingAddress,
      );

      if (newOrder != null) {
        _orders.add(newOrder);
        notifyListeners();
      }
      return newOrder;
    } catch (e) {
      debugPrint('Error creating order: $e');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    try {
      await _orderService.updateOrderStatus(orderId, newStatus);
      final orderIndex = _orders.indexWhere((order) => order.id == orderId);
      if (orderIndex != -1) {
        final updatedOrder = OrderModel(
          id: _orders[orderIndex].id,
          userId: _orders[orderIndex].userId,
          items: _orders[orderIndex].items,
          totalAmount: _orders[orderIndex].totalAmount,
          orderDate: _orders[orderIndex].orderDate,
          status: newStatus,
          shippingAddress: _orders[orderIndex].shippingAddress,
        );

        _orders[orderIndex] = updatedOrder;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating order status: $e');
    }
  }
}
