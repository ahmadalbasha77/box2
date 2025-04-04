class CategoryModel {
  bool success;
  String message;
  Result data;

  CategoryModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        success: json["success"],
        message: json["message"],
        data: Result.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}

class Result {
  int pageNumber;
  int pageSize;
  int totalCount;
  int totalPages;
  List<CategoryData> items;

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
        items: json["items"] == null
            ? []
            : List<CategoryData>.from(
                json["items"].map((x) => CategoryData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "totalCount": totalCount,
        "totalPages": totalPages,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class CategoryData {
  int id;
  String name;
  String description;
  String imageUrl;

  CategoryData({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) => CategoryData(
        id: json["id"] ?? 0,
        name: json["name"] ?? '',
        description: json["description"] ?? '',
        imageUrl: json["imageUrl"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "imageUrl": imageUrl,
      };
}
