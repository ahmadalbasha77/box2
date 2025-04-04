class BrandModel {
  bool success;
  String message;
  Result data;
  List<dynamic> errors;

  BrandModel({
    required this.success,
    required this.message,
    required this.data,
    required this.errors,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) => BrandModel(
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
  List<BrandDate> data;

  Result({
    required this.pageNumber,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.data,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        totalCount: json["totalCount"],
        totalPages: json["totalPages"],
        data: List<BrandDate>.from(
            json["items"].map((x) => BrandDate.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "totalCount": totalCount,
        "totalPages": totalPages,
        "items": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class BrandDate {
  String imageUrl;
  int id;
  String name;

  BrandDate({
    required this.imageUrl,
    required this.id,
    required this.name,
  });

  factory BrandDate.fromJson(Map<String, dynamic> json) => BrandDate(
        imageUrl: json["imageUrl"] ?? '',
        id: json["id"] ?? 0,
        name: json["name"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "imageUrl": imageUrl,
        "id": id,
        "name": name,
      };
}
