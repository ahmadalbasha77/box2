
class SubCategoryModel {
  bool success;
  String message;
  Result data;
  List<dynamic> errors;

  SubCategoryModel({
    required this.success,
    required this.message,
    required this.data,
    required this.errors,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) => SubCategoryModel(
    success: json["success"],
    message: json["message"],
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
  List<SubCategoryData> items;

  Result({
    required this.pageNumber,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.items,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    pageNumber: json["pageNumber"],
    pageSize: json["pageSize"],
    totalCount: json["totalCount"],
    totalPages: json["totalPages"],
    items: List<SubCategoryData>.from(json["items"].map((x) => SubCategoryData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "pageNumber": pageNumber,
    "pageSize": pageSize,
    "totalCount": totalCount,
    "totalPages": totalPages,
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
  };
}

class SubCategoryData {
  int id;
  String name;
  String imageUrl;
  String description;

  SubCategoryData({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
  });

  factory SubCategoryData.fromJson(Map<String, dynamic> json) => SubCategoryData(
    id: json["id"]??0,
    name: json["name"]??'',
    imageUrl: json["imageUrl"]??'',
    description: json["description"]??'',
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "imageUrl": imageUrl,
    "description": description,
  };
}
