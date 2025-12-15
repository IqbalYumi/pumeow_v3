import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import '../controllers/cart_controller.dart';
import '../routes/app_pages.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final ProductController productController = Get.find<ProductController>();
  final CartController cartController = Get.find<CartController>();
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PumeowID'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Get.toNamed(Routes.CART),
          ),
        ],
      ),
      body: Column(
        children: [
          // SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Cari pudding favoritmu...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (_) => productController.refresh(),
            ),
          ),

          // PRODUCT LIST
          Expanded(
            child: Obx(() {
              final query = searchController.text.toLowerCase();

              final filteredProducts = productController.productList.where((p) {
                return p.name.toLowerCase().contains(query) ||
                    p.variant.toLowerCase().contains(query);
              }).toList();

              if (filteredProducts.isEmpty) {
                return const Center(child: Text('Produk tidak ditemukan'));
              }

              return ListView.builder(
                itemCount: filteredProducts.length,
                itemBuilder: (_, index) {
                  final product = filteredProducts[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Get.toNamed(Routes.PRODUCT_DETAIL, arguments: product);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // NAME & PRICE
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Rp ${product.price.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    color: Colors.teal,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 6),

                            // VARIANT BADGE
                            Chip(
                              label: Text(product.variant),
                              backgroundColor: Colors.teal.shade50,
                            ),

                            const SizedBox(height: 6),

                            // DESCRIPTION
                            Text(
                              product.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
