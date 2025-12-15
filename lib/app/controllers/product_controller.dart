import 'package:get/get.dart';
import '../models/product.dart';

class ProductController extends GetxController {
  var productList = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts(); // ✅ AKHIRNYA TERPAKAI
  }

  void fetchProducts() {
    productList.assignAll([
      Product(
        id: 1,
        name: "Pudding Milk",
        variant: "Vanilla",
        price: 12000,
        description: "Pudding rasa vanilla.",
      ),
      Product(
        id: 2,
        name: "Pudding Chocolate",
        variant: "Chocolate",
        price: 13000,
        description: "Pudding rasa coklat.",
      ),
      Product(
        id: 3,
        name: "Pudding Mango",
        variant: "Mango",
        price: 14000,
        description: "Pudding rasa mangga.",
      ),
    ]);
  }
}
