import '../models/order_model.dart';
import '../widgets/cart_page/cart_item.dart';
import 'supabase_service.dart';

class OrderSupabaseService {
  static const String _ordersTable = 'orders';
  static const String _orderItemsTable = 'order_items';

  Future<List<OrderModel>> getUserOrders(String userId) async {
    try {
      print('Récupération des commandes pour userId: $userId');

      print('Requête Supabase: $_ordersTable avec $_orderItemsTable');
      final response = await SupabaseService.supabase
          .from(_ordersTable)
          .select('*, $_orderItemsTable(*)')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      print('Réponse reçue: $response');

      return (response as List).map((order) {
        final items = (order['$_orderItemsTable'] as List).map((item) => 
          OrderItem(
            productId: item['product_id'],
            productName: item['product_name'],
            price: item['price'].toDouble(),
            quantity: item['quantity'],
            imageUrl: item['image_url'],
          )
        ).toList();

        return OrderModel(
          id: order['id'].toString(),
          userId: order['user_id'],
          items: items,
          totalAmount: order['total_amount'].toDouble(),
          orderDate: DateTime.parse(order['created_at']),
          status: OrderStatus.values.firstWhere(
            (e) => e.toString() == 'OrderStatus.${order['status']}',
            orElse: () => OrderStatus.pending,
          ),
          shippingAddress: order['shipping_address'],
        );
      }).toList();
    } catch (e) {
      print('Error getting orders: $e');
      return [];
    }
  }

  Future<OrderModel?> createOrder({
    required String userId,
    required List<CartItem> cartItems,
    required double totalAmount,
    required String? shippingAddress,
  }) async {
    try {
      print('Début création commande');
      // Récupérer l'UUID de l'utilisateur actuel
      final currentUserId = SupabaseService.supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        throw Exception('Utilisateur non authentifié');
      }
      
      print('currentUserId: $currentUserId');
      print('totalAmount: $totalAmount');
      print('cartItems length: ${cartItems.length}');
      // Créer la commande
      print('Création de la commande dans la table orders...');
      final orderData = {
        'user_id': currentUserId,
        'total_amount': totalAmount,
        'status': OrderStatus.pending.toString().split('.').last,
        'shipping_address': shippingAddress,
        'created_at': DateTime.now().toIso8601String(),
      };
      print('orderData: $orderData');
      
      final orderResponse = await SupabaseService.supabase
          .from(_ordersTable)
          .insert(orderData)
          .select()
          .single();
      
      print('Commande créée avec succès. ID: ${orderResponse['id']}');

      // Créer les éléments de la commande
      final orderItems = cartItems.map((item) => {
        'order_id': orderResponse['id'],
        'product_id': item.product.id.toString(),
        'product_name': item.product.name,
        'price': item.product.price,
        'quantity': item.index,
        'image_url': item.product.imagePath,
      }).toList();

      print('Création des items de la commande...');
      print('orderItems: $orderItems');
      await SupabaseService.supabase.from(_orderItemsTable).insert(orderItems);
      print('Items de commande créés avec succès');

      // Récupérer la commande complète
      final order = await SupabaseService.supabase
          .from(_ordersTable)
          .select('*, $_orderItemsTable(*)')
          .eq('id', orderResponse['id'])
          .single();

      final items = (order['$_orderItemsTable'] as List).map((item) =>
        OrderItem(
          productId: item['product_id'],
          productName: item['product_name'],
          price: item['price'].toDouble(),
          quantity: item['quantity'],
          imageUrl: item['image_url'],
        )
      ).toList();

      return OrderModel(
        id: order['id'].toString(),
        userId: order['user_id'],
        items: items,
        totalAmount: order['total_amount'].toDouble(),
        orderDate: DateTime.parse(order['created_at']),
        status: OrderStatus.values.firstWhere(
          (e) => e.toString() == 'OrderStatus.${order['status']}',
          orElse: () => OrderStatus.pending,
        ),
        shippingAddress: order['shipping_address'],
      );
    } catch (e, stackTrace) {
      print('Error creating order: $e');
      print('Stack trace: $stackTrace');
      return null;
    }
  }

  Future<bool> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    try {
      await SupabaseService.supabase.from(_ordersTable).update({
        'status': newStatus.toString().split('.').last,
      }).eq('id', orderId);
      return true;
    } catch (e) {
      print('Error updating order status: $e');
      return false;
    }
  }
}
