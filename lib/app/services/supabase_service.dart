import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/product.dart';

class SupabaseService {
  SupabaseService() : _client = Supabase.instance.client;

  final SupabaseClient _client;

  Future<List<Product>> fetchProducts() async {
    final data = await _client.from('products').select();
    if (data is! List) return [];

    return data.map((item) {
      final map = item as Map<String, dynamic>;
      return Product.fromMap(map);
    }).toList();
  }

  Future<String?> createOrder({
    required String method,
    required Map<Product, int> cartItems,
    double? lat,
    double? lng,
  }) async {
    final user = _client.auth.currentUser;
    final total = cartItems.entries.fold<double>(
      0,
      (sum, e) => sum + (e.key.price * e.value),
    );

    final orderPayload = {
      'user_id': user?.id,
      'method': method,
      'total': total,
      'lat': lat,
      'lng': lng,
    };

    final orderResp =
        await _client.from('orders').insert(orderPayload).select().maybeSingle();
    final orderId = orderResp != null ? orderResp['id']?.toString() : null;

    if (orderId != null && cartItems.isNotEmpty) {
      final itemsPayload = cartItems.entries.map((entry) {
        return {
          'order_id': orderId,
          'product_id': entry.key.id,
          'quantity': entry.value,
          'price': entry.key.price,
        };
      }).toList();

      await _client.from('order_items').insert(itemsPayload);
    }

    return orderId;
  }
}
