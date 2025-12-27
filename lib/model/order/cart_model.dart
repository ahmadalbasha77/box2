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

  /// من JSON
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: ProductData.fromJson(json['product']),
      unit: ProductUnit.fromJson(json['unit']),
      quantity: json['quantity'] ?? 1,
    );
  }

  /// إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'unit': unit.toJson(),
      'quantity': quantity,
    };
  }
}
