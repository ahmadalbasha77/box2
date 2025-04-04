import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreferences {
  static late SharedPreferences _sharedPreferences;

  init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  void clearProfile() {
    isLogin = false;
    userId = 0;
    email = '';
    userName = '';
    token = '';
  }

  // Future<void> saveUserData(LoginResult loginResult) async {
  //   String loginModelJson = jsonEncode(loginResult.toJson());
  //   await _sharedPreferences.setString(keyUserData, loginModelJson);
  // }
  //
  // LoginResult? getUserData() {
  //   String? loginModelJson = _sharedPreferences.getString(keyUserData);
  //   if (loginModelJson != null) {
  //     return LoginResult.fromJson(jsonDecode(loginModelJson));
  //   }
  //   return LoginResult.fromJson({});
  // }
  //
  // Future<void> clearUserData() async {
  //   await _sharedPreferences.remove(keyUserData);
  // }

  bool get isLogin => _sharedPreferences.getBool(keyIsLogin) ?? false;

  set isLogin(bool value) {
    _sharedPreferences.setBool(keyIsLogin, value);
  }

  String get language => _sharedPreferences.getString(keyLanguage) ?? "en";

  set language(String value) {
    _sharedPreferences.setString(keyLanguage, value);
  }

  int get userId => _sharedPreferences.getInt(keyUserId) ?? 0;

  set userId(int value) {
    _sharedPreferences.setInt(keyUserId, value);
  }

  String get email => _sharedPreferences.getString(keyEmail) ?? "";

  set email(String value) {
    _sharedPreferences.setString(keyEmail, value);
  }

  String get userName => _sharedPreferences.getString(keyUserName) ?? "";

  set userName(String value) {
    _sharedPreferences.setString(keyUserName, value);
  }

  String get token => _sharedPreferences.getString(keyToken) ?? "";

  set token(String value) {
    _sharedPreferences.setString(keyToken, value);
  }

  String get deviceToken => _sharedPreferences.getString(keyDeviceToken) ?? "";

  set deviceToken(String value) {
    _sharedPreferences.setString(keyDeviceToken, value);
  }

  bool get isGMS => _sharedPreferences.getBool(keyIsGMS) ?? false;

  set isGMS(bool value) {
    _sharedPreferences.setBool(keyIsGMS, value);
  }
}

final mySharedPreferences = MySharedPreferences();

const String keyDeviceToken = "key_device_token";
const String keyUserId = "key_user_id";
const String keyEmail = "key_email";
const String keyUserName = "key_username";
const String keyIsGMS = "key_is_gms";
const String keyUserData = "key_user_data";
const String keyIsLogin = "key_is_login";
const String keyToken = "key_token";
const String keyIP = "key_ip";
const String keyLanguage = "key_language";
const String keyBranchId = "key_branch_id";
