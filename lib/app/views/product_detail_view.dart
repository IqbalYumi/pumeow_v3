import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/product.dart';
import '../controllers/cart_controller.dart';

class ProductDetailView extends StatelessWidget {
  final CartController cartController = Get.find<CartController>();

  ProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final Product product = Get.arguments as Product;

    return Scaffold(
      appBar: AppBar(title: Text('${product.name} - ${product.variant}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: Image.asset(
                  product.imageAsset,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: const Color(0xfff3f4f6),
                    child: const Icon(
                      Icons.image_not_supported_outlined,
                      color: Color(0xff9ca3af),
                      size: 42,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Chip(
                  label: Text(product.variant),
                  backgroundColor: Colors.teal.shade50,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: Color(0xffffc400),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      product.rating.toStringAsFixed(1),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              product.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 18,
                  color: Color(0xff9ca3af),
                ),
                const SizedBox(width: 4),
                Text(
                  product.location,
                  style: const TextStyle(color: Color(0xff6b7280)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              product.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 18),
            Text(
              'Rp${product.price.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  cartController.addToCart(product);
                  Get.snackbar(
                    'Berhasil',
                    'Produk ditambahkan ke keranjang',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('Tambah ke Keranjang'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
