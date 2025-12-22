import 'package:get/get.dart';
import '../models/product.dart';

class PurchaseHistoryEntry {
  final Product product;
  final int quantity;
  final String method; // pickup / delivery
  final DateTime createdAt;

  PurchaseHistoryEntry({
    required this.product,
    required this.quantity,
    required this.method,
    required this.createdAt,
  });
}

class CartController extends GetxController {
  var cartItems = <Product, int>{}.obs;
  var purchaseHistory = <PurchaseHistoryEntry>[].obs;

  void addToCart(Product product) {
    if (cartItems.containsKey(product)) {
      cartItems[product] = cartItems[product]! + 1;
    } else {
      cartItems[product] = 1;
    }
    cartItems.refresh();
  }

  void removeFromCart(Product product) {
    if (!cartItems.containsKey(product)) return;
    if (cartItems[product]! > 1) {
      cartItems[product] = cartItems[product]! - 1;
    } else {
      cartItems.remove(product);
    }
    cartItems.refresh();
  }

  void checkout(String method) {
    if (cartItems.isEmpty) return;

    final now = DateTime.now();
    purchaseHistory.addAll(
      cartItems.entries.map(
        (e) => PurchaseHistoryEntry(
          product: e.key,
          quantity: e.value,
          method: method,
          createdAt: now,
        ),
      ),
    );
    purchaseHistory.refresh();

    cartItems.clear();
    cartItems.refresh();
  }
}
