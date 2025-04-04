class AreaModel {
  bool success;
  String message;
  Data data;
  List<dynamic> errors;

  AreaModel({
    required this.success,
    required this.message,
    required this.data,
    required this.errors,
  });

  factory AreaModel.fromJson(Map<String, dynamic> json) => AreaModel(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
        errors: List<dynamic>.from(json["errors"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
        "errors": List<dynamic>.from(errors.map((x) => x)),
      };
}

class Data {
  int pageNumber;
  int pageSize;
  int totalCount;
  int totalPages;
  List<AreaItem> items;

  Data({
    required this.pageNumber,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.items,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        totalCount: json["totalCount"],
        totalPages: json["totalPages"],
        items: List<AreaItem>.from(json["items"].map((x) => AreaItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "totalCount": totalCount,
        "totalPages": totalPages,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class AreaItem {
  int id;
  String name;

  AreaItem({
    required this.id,
    required this.name,
  });

  factory AreaItem.fromJson(Map<String, dynamic> json) => AreaItem(
        id: json["id"] ?? 0,
        name: json["name"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
