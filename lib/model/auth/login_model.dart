class LoginModel {
  bool success;
  String message;
  LoginResult data;
  List<dynamic> errors;

  LoginModel({
    required this.success,
    required this.message,
    required this.data,
    required this.errors,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        success: json["success"] ?? false,
        message: json["message"] ?? '',
        data: json["data"] == null
            ? LoginResult.fromJson({})
            : LoginResult.fromJson(json["data"]),
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

class LoginResult {
  int userId;
  String email;
  String phone;
  String token;
  bool isActive;
  String username;
  int userRole;



  LoginResult({
    required this.userId,
    required this.email,
    required this.phone,
    required this.token,
    required this.isActive,
    required this.username,
    required this.userRole,
  });

  factory LoginResult.fromJson(Map<String, dynamic> json) => LoginResult(
        userId: json["userId"] ?? 0,
        email: json["email"] ?? '',
        phone: json["phone"] ?? '',
        token: json["token"] ?? '',
        isActive: json["isActive"] ?? false,
        username: json["username"] ?? '',
        userRole: json["userRole"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "email": email,
        "phone": phone,
        "token": token,
        "isActive": isActive,
        "username": username,
        "userRole": userRole,
      };
}
