class NotificationModel {
  bool success;
  String message;
  DataNotification data;
  List<dynamic> errors;

  NotificationModel({
    required this.success,
    required this.message,
    required this.data,
    required this.errors,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        success: json["success"] ?? false,
        message: json["message"] ?? '',
        data: json["data"] == null
            ? DataNotification.fromJson({})
            : DataNotification.fromJson(json["data"]),
        errors: json["errors"] == null
            ? []
            : List<dynamic>.from(json["errors"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
        "errors": List<dynamic>.from(errors.map((x) => x)),
      };
}

class DataNotification {
  int pageNumber;
  int pageSize;
  int totalCount;
  int totalPages;
  List<ItemNotifications> items;

  DataNotification({
    required this.pageNumber,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.items,
  });

  factory DataNotification.fromJson(Map<String, dynamic> json) => DataNotification(
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        totalCount: json["totalCount"],
        totalPages: json["totalPages"],
        items: List<ItemNotifications>.from(json["items"].map((x) => ItemNotifications.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "totalCount": totalCount,
        "totalPages": totalPages,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class ItemNotifications {
  int id;
  String name;
  String title;
  String body;
  dynamic token;
  DateTime createdDate;
  DateTime updatedDate;

  ItemNotifications({
    required this.id,
    required this.name,
    required this.title,
    required this.body,
    required this.token,
    required this.createdDate,
    required this.updatedDate,
  });

  factory ItemNotifications.fromJson(Map<String, dynamic> json) => ItemNotifications(
        id: json["id"],
        name: json["name"],
        title: json["title"],
        body: json["body"],
        token: json["token"],
        createdDate: DateTime.parse(json["createdDate"]),
        updatedDate: DateTime.parse(json["updatedDate"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "title": title,
        "body": body,
        "token": token,
        "createdDate": createdDate.toIso8601String(),
        "updatedDate": updatedDate.toIso8601String(),
      };
}
