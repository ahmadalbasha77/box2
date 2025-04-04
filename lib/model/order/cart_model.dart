import '../home/product_model.dart';

class CartItem {
  final ProductData product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}
