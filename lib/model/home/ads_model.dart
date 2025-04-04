class AdsModel {
  bool success;
  String message;
  Result data;
  List<dynamic> errors;

  AdsModel({
    required this.success,
    required this.message,
    required this.data,
    required this.errors,
  });

  factory AdsModel.fromJson(Map<String, dynamic> json) => AdsModel(
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
  List<AdsData> items;

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
        items:
            List<AdsData>.from(json["items"].map((x) => AdsData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "totalCount": totalCount,
        "totalPages": totalPages,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class AdsData {
  int id;
  String imageUrl;
  bool isActive;

  AdsData({
    required this.id,
    required this.imageUrl,
    required this.isActive,
  });

  factory AdsData.fromJson(Map<String, dynamic> json) => AdsData(
        id: json["id"] ?? 0,
        imageUrl: json["imageUrl"] ?? '',
        isActive: json["isActive"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "imageUrl": imageUrl,
        "isActive": isActive,
      };
}
