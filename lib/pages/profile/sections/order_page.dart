import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/core.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/order_provider.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  void initState() {
    super.initState();
    // Charger les commandes au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      if (authProvider.isAuthenticated) {
        context.read<OrderProvider>().loadUserOrders(
          authProvider.currentUser!.id,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Row(
              children: [
                SizedBox(width: getWidth(15)),
                Container(
                  height: getHeight(40),
                  width: getWidth(40),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSecondary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new_outlined,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                SizedBox(width: getWidth(50)),
                Text(
                  "Mes commandes",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: Consumer<OrderProvider>(
              builder: (context, orderProvider, child) {
                if (orderProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (orderProvider.orders.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: Text('Aucune commande pour le moment'),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: orderProvider.orders.length,
                  itemBuilder: (context, index) {
                    final order = orderProvider.orders[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ExpansionTile(
                        title: Text(
                          //'Commande #${order.id}',
                          'Commande #',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              'Date: ${order.orderDate.day}/${order.orderDate.month}/${order.orderDate.year}',
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Total: ${order.totalAmount.toStringAsFixed(2)} €',
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: order.getStatusColor().withOpacity(
                                  0.1,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                order.getStatusText(),
                                style: TextStyle(
                                  color: order.getStatusColor(),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        children: [
                          if (order.items.isEmpty)
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Aucun article dans cette commande',
                              ),
                            )
                          else
                          // Remove NeverScrollableScrollPhysics here
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: order.items.length,
                              itemBuilder: (context, itemIndex) {
                                final item = order.items[itemIndex];
                                return ListTile(
                                  leading: item.imageUrl != null
                                      ? Image.network(
                                    item.imageUrl!,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  )
                                      : const Icon(
                                    Icons.image_not_supported,
                                  ),
                                  title: Text(item.productName),
                                  subtitle: Text(
                                    'Quantité: ${item.quantity}',
                                  ),
                                  trailing: Text(
                                    '${item.price.toStringAsFixed(2)} €',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}