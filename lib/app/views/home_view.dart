import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import '../controllers/cart_controller.dart';
import '../models/product.dart';
import '../routes/app_pages.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ProductController productController = Get.find<ProductController>();
  final CartController cartController = Get.find<CartController>();
  final TextEditingController searchController = TextEditingController();
  String selectedVariant = 'Semua';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(theme),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: _buildSearchBar(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: _buildFilterChips(),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: Obx(() {
                final query = searchController.text.toLowerCase();

                final filteredProducts = productController.productList.where((p) {
                  final matchQuery = p.name.toLowerCase().contains(query) ||
                      p.variant.toLowerCase().contains(query) ||
                      p.description.toLowerCase().contains(query);
                  final matchFilter =
                      selectedVariant == 'Semua' || p.variant == selectedVariant;
                  return matchQuery && matchFilter;
                }).toList();

                if (filteredProducts.isEmpty) {
                  return const Center(child: Text('Produk tidak ditemukan'));
                }

                return ListView.builder(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                  itemCount: filteredProducts.length,
                  itemBuilder: (_, index) {
                    final product = filteredProducts[index];
                    return _ProductCard(
                      product: product,
                      onTap: () {
                        Get.toNamed(Routes.PRODUCT_DETAIL,
                            arguments: product);
                      },
                      onAddToCart: () {
                        cartController.addToCart(product);
                        Get.snackbar(
                          'Keranjang',
                          '${product.name} ditambahkan',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _circleButton(
                icon: Icons.menu,
                onTap: () => Get.toNamed(Routes.PROFILE),
              ),
              _circleButton(
                icon: Icons.shopping_cart_outlined,
                onTap: () => Get.toNamed(Routes.CART),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xfff4f2ff),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.emoji_food_beverage,
                    color: Color(0xff6f5bd5),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pumeow Pudding',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: const Color(0xff111827),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Dessert lembut untuk temani harimu',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: TextField(
        controller: searchController,
        onChanged: (_) => setState(() {}),
        decoration: const InputDecoration(
          hintText: 'Cari pudding...',
          prefixIcon: Icon(Icons.search),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Obx(() {
      final variants = [
        'Semua',
        ...productController.productList.map((p) => p.variant).toSet().toList(),
      ];

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: variants.map((variant) {
            final isSelected = selectedVariant == variant;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(variant),
                selected: isSelected,
                onSelected: (_) => setState(() => selectedVariant = variant),
                selectedColor: const Color(0xffe8f1ff),
                backgroundColor: Colors.white,
                side: BorderSide(
                  color: isSelected
                      ? const Color(0xff2563eb)
                      : const Color(0xffe5e7eb),
                ),
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: isSelected
                      ? const Color(0xff1d4ed8)
                      : const Color(0xff374151),
                ),
              ),
            );
          }).toList(),
        ),
      );
    });
  }

  Widget _circleButton({required IconData icon, required VoidCallback onTap}) {
    return Ink(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Icon(
          icon,
          color: const Color(0xff111827),
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.product,
    required this.onTap,
    required this.onAddToCart,
  });

  final Product product;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: SizedBox(
                  width: 110,
                  height: 100,
                  child: Image.asset(
                    product.imageAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xfff3f4f6),
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        color: Color(0xff9ca3af),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xffe6f7ef),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            product.variant.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff2f8f5b),
                            ),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: onAddToCart,
                          icon: const Icon(Icons.favorite_border),
                          color: const Color(0xff9ca3af),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xff111827),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: Color(0xff9ca3af),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            product.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xff6b7280),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 18,
                          color: Color(0xffffc400),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          product.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Color(0xff374151),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Rp${product.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Color(0xff1f6feb),
                            fontSize: 17,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: product.isAvailable
                                ? const Color(0xffe8f5e9)
                                : const Color(0xffffebee),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            product.isAvailable ? 'Tersedia' : 'Habis',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: product.isAvailable
                                  ? const Color(0xff2e7d32)
                                  : const Color(0xffc62828),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
