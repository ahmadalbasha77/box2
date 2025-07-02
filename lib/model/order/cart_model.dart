import '../home/product_model.dart';

class CartItem {
  final ProductData product;
  final ProductUnit unit;
  int quantity;

  CartItem({
    required this.product,
    required this.unit,
    this.quantity = 1,
  });
}
