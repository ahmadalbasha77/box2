class ProductModel {
  bool success;
  String message;
  Result data;
  List<dynamic> errors;

  ProductModel({
    required this.success,
    required this.message,
    required this.data,
    required this.errors,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    success: json["success"] ?? false,
    message: json["message"] ?? '',
    data: Result.fromJson(json["data"]),
    errors: List<dynamic>.from(json["errors"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data.toJson(),
    "errors": List<dynamic>.from(errors.map((x) => x)),
  };
}

class Result {
  int pageNumber;
  int pageSize;
  int totalCount;
  int totalPages;
  List<ProductData> items;

  Result({
    required this.pageNumber,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.items,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    pageNumber: json["pageNumber"] ?? 0,
    pageSize: json["pageSize"] ?? 0,
    totalCount: json["totalCount"] ?? 0,
    totalPages: json["totalPages"] ?? 0,
    items: List<ProductData>.from(
        json["items"].map((x) => ProductData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "pageNumber": pageNumber,
    "pageSize": pageSize,
    "totalCount": totalCount,
    "totalPages": totalPages,
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
  };
}

class ProductData {
  int id;
  String name;
  String description;
  String imageUrl;
  bool isSoldOut;
  List<ProductUnit> productUnits;

  ProductData({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.isSoldOut,
    required this.productUnits,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) {
    List units = json["productUnits"] ?? [];
    return ProductData(
      id: json["id"] ?? 0,
      name: json["name"] ?? '',
      description: json["description"] ?? '',
      imageUrl: json["imageUrl"] ?? '',
      isSoldOut: json["isSoldOut"] ?? false,
      productUnits: units.map((e) => ProductUnit.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "imageUrl": imageUrl,
    "isSoldOut": isSoldOut,
    "productUnits": List<dynamic>.from(productUnits.map((x) => x.toJson())),
  };
}

class ProductUnit {
  int id;
  String unit;
  double price;
  double size;
  int quantity;
  bool isDefault;

  ProductUnit({
    required this.id,
    required this.unit,
    required this.price,
    required this.size,
    required this.quantity,
    required this.isDefault,
  });

  factory ProductUnit.fromJson(Map<String, dynamic> json) => ProductUnit(
    id: json["id"] ?? 0,
    unit: json["unit"] ?? '',
    price: (json["price"] ?? 0).toDouble(),
    size: (json["size"] ?? 0).toDouble(),
    quantity: (json["quantity"] is int)
        ? json["quantity"]
        : (json["quantity"] ?? 0).toDouble().toInt(),
    isDefault: json["isDefault"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "unit": unit,
    "price": price,
    "size": size,
    "quantity": quantity,
    "isDefault": isDefault,
  };
}
