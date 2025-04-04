class SignUpModel {
  bool success;
  String message;
  Data data;

  SignUpModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SignUpModel.fromJson(Map<String, dynamic> json) => SignUpModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? Data.fromJson({})
            : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  int id;
  String name;
  String userName;
  String shopName;
  String email;
  String phoneNumber;
  String token;
  int areaId;

  Data({
    required this.id,
    required this.name,
    required this.userName,
    required this.shopName,
    required this.email,
    required this.phoneNumber,
    required this.token,
    required this.areaId,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"] ?? 0,
        name: json["name"] ?? '',
        userName: json["userName"] ?? '',
        shopName: json["shopName"] ?? '',
        email: json["email"] ?? '',
        phoneNumber: json["phoneNumber"] ?? '',
    token: json["token"] ?? '',
        areaId: json["areaId"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "userName": userName,
        "shopName": shopName,
        "email": email,
        "phoneNumber": phoneNumber,
        "areaId": areaId,
      };
}
