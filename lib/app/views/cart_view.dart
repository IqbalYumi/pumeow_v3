import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../models/product.dart';
import '../routes/app_pages.dart';

class CartView extends StatelessWidget {
  CartView({super.key});

  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Keranjang')),

      // ================= BODY =================
      body: Obx(() {
        if (cartController.cartItems.isEmpty) {
          return const Center(
            child: Text('Keranjang kosong', style: TextStyle(fontSize: 16)),
          );
        }

        return ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: cartController.cartItems.entries.map((entry) {
            final Product product = entry.key;
            final int quantity = entry.value;

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(
                  '${product.name} - ${product.variant}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Jumlah: $quantity'),
                trailing: SizedBox(
                  width: 120,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () => cartController.removeFromCart(product),
                      ),
                      Text('$quantity'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => cartController.addToCart(product),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }),

      // ================= BOTTOM BUTTON =================
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              if (cartController.cartItems.isEmpty) {
                Get.snackbar(
                  'Info',
                  'Keranjang masih kosong',
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }
              Get.toNamed(Routes.CHECKOUT);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Beli',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}


