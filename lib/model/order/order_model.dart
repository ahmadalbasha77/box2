class OrderModel {
  bool success;
  String message;
  OrderData data;

  OrderModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        success: json["success"],
        message: json["message"],
        data: OrderData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}

class OrderData {
  int pageNumber;
  int pageSize;
  int totalCount;
  int totalPages;
  List<OrderItem> items;

  OrderData({
    required this.pageNumber,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.items,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) => OrderData(
        pageNumber: json["pageNumber"] ?? 0,
        pageSize: json["pageSize"] ?? 0,
        totalCount: json["totalCount"] ?? 0,
        totalPages: json["totalPages"] ?? 0,
        items: json["items"] == null
            ? []
            : List<OrderItem>.from(
                json["items"].map((x) => OrderItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "totalCount": totalCount,
        "totalPages": totalPages,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class OrderItem {
  int id;
  String name;
  int userId;
  List<CartItem> cartItems;

  double totalPrice;
  DateTime createdDate;
  int cartStatus;

  OrderItem({
    required this.id,
    required this.name,
    required this.userId,
    required this.cartItems,
    required this.totalPrice,
    required this.createdDate,
    required this.cartStatus,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        id: json["id"] ?? 0,
        name: json["name"] ?? '',
        userId: json["userId"] ?? 0,
        cartItems: json["cartItems"] == null
            ? []
            : List<CartItem>.from(
                json["cartItems"].map((x) => CartItem.fromJson(x))),
        totalPrice: (json["totalPrice"] ?? 0).toDouble() ?? 0.0,
        createdDate: DateTime.parse(json["createdDate"]),
        cartStatus: json["cartStatus"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "userId": userId,
        "cartItems": List<dynamic>.from(cartItems.map((x) => x.toJson())),
        "totalPrice": totalPrice,
        "createdDate": createdDate.toIso8601String(),
        "cartStatus": cartStatus,
      };
}

class CartItem {
  int id;
  int cartId;
  int productId;
  Product product;
  int quantity;
  double price;

  CartItem({
    required this.id,
    required this.cartId,
    required this.productId,
    required this.product,
    required this.quantity,
    required this.price,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        id: json["id"] ?? 0,
        cartId: json["cartId"] ?? 0,
        productId: json["productId"] ?? 0,
        product: json["product"] == null
            ? Product.fromJson({})
            : Product.fromJson(json["product"]),
        quantity: json["quantity"] ?? 0,
        price: json["price"].toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cartId": cartId,
        "productId": productId,
        "product": product.toJson(),
        "quantity": quantity,
        // "price": price,
      };
}

class Product {
  int id;
  String name;
  String description;
  String unit;
  String imageUrl;
  bool isSoldOut;
  double price;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.unit,
    required this.imageUrl,
    required this.isSoldOut,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"] ?? 0,
        name: json["name"] ?? '',
        description: json["description"] ?? '',
        unit: json["unit"] ?? '',
        imageUrl: json["imageUrl"] ?? '',
        isSoldOut: json["isSoldOut"] ?? false,
        price: json["price"].toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "unit": unit,
        "imageUrl": imageUrl,
        "isSoldOut": isSoldOut,
        "price": price,
      };
}
