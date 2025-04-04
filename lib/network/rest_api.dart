import 'dart:convert';
import 'dart:developer';

import 'package:box_app/core/my_shared_preferences.dart';
import 'package:box_app/model/auth/area_model.dart';
import 'package:box_app/model/auth/login_model.dart';
import 'package:box_app/model/auth/sign_up_model.dart';
import 'package:box_app/model/home/ads_model.dart';
import 'package:box_app/model/home/category_model.dart';
import 'package:box_app/model/home/product_model.dart';
import 'package:box_app/model/home/sub_category_model.dart';
import 'package:box_app/model/order/order_model.dart';
import 'package:box_app/network/api_url.dart';
import 'package:http/http.dart' as http;

import '../model/home/brand_model.dart';

class RestApi {
  static String token = mySharedPreferences.token;

  static Future<LoginModel> login(var body) async {
    Uri url = Uri.parse('${ApiUrl.baseUrl}${ApiUrl.login}');
    var headers = {'accept': '*/*', 'Content-Type': 'application/json'};
    final response = await http.post(url, body: body, headers: headers);
    log('**************************************');
    log('url : $url');
    log('body : $body');
    log('status code : ${response.statusCode}');
    log('login : ${response.body}');
    log('**************************************');

    if (response.statusCode == 200 || response.statusCode == 400) {
      return LoginModel.fromJson(jsonDecode(response.body));
    } else {
      return LoginModel.fromJson({});
    }
  }

  static Future<SignUpModel> signUp(var body) async {
    Uri url = Uri.parse('${ApiUrl.baseUrl}${ApiUrl.signup}');
    var headers = {'accept': '*/*', 'Content-Type': 'application/json'};
    final response = await http.post(url, body: body, headers: headers);
    log('**************************************');
    log('url : $url');
    log('body : $body');
    log('status code : ${response.statusCode}');
    log('signUp : ${response.body}');
    log('**************************************');

    if (response.statusCode == 200 || response.statusCode == 400) {
      return SignUpModel.fromJson(jsonDecode(response.body));
    } else {
      return SignUpModel.fromJson({});
    }
  }

  static Future<AreaModel> getArea({
    required int pageSize,
    required int pageIndex,
  }) async {
    String url = '${ApiUrl.baseUrl}${ApiUrl.area}';
    Uri uri = Uri.parse(url);
    var headers = {
      'accept': 'text/plain',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    http.Response response = await http.get(uri, headers: headers);
    log('url : $url');
    log('statusCode : ${response.statusCode}');
    log('getArea : ${response.body}');
    if (response.statusCode == 200) {
      return AreaModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 400) {
      return AreaModel.fromJson({});
    } else {
      return AreaModel.fromJson({});
    }
  }

  static Future<bool> deleteAccount() async {
    Uri url = Uri.parse(
        '${ApiUrl.baseUrl}${ApiUrl.deleteAccount}?id=${mySharedPreferences.userId}');
    var headers = {
      'accept': '*/*',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final response = await http.delete(url, headers: headers);
    log('**************************************');
    log('url : $url');
    log('id : ${mySharedPreferences.userId}');
    log('status code : ${response.statusCode}');
    log('Delete Account : ${response.body}');
    log('**************************************');

    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['success'] == true) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  static Future<bool> addOrder(var body) async {
    Uri url = Uri.parse('${ApiUrl.baseUrl}${ApiUrl.addOrder}');
    var headers = {
      'accept': '*/*',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final response = await http.post(url, body: body, headers: headers);
    log('**************************************');
    log('url : $url');
    log('body : $body');
    log('status code : ${response.statusCode}');
    log('signUp : ${response.body}');
    log('**************************************');

    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['success'] == true) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  static Future<OrderModel> getOrder({
    required int pageSize,
    required int pageIndex,
  }) async {
    String url =
        '${ApiUrl.baseUrl}${ApiUrl.getOrder}?PageSize=$pageSize&PageNumber=$pageIndex';
    Uri uri = Uri.parse(url);
    var headers = {
      'accept': 'text/plain',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    http.Response response = await http.get(uri, headers: headers);
    log('url : $url');
    log('statusCode : ${response.statusCode}');
    log('getOrder : ${response.body}');
    if (response.statusCode == 200) {
      return OrderModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 400) {
      return OrderModel.fromJson({});
    } else {
      return OrderModel.fromJson({});
    }
  }

  static Future<AdsModel> getAds({
    required int pageSize,
    required int pageIndex,
  }) async {
    String url =
        '${ApiUrl.baseUrl}${ApiUrl.ads}?PageSize=$pageSize&PageNumber=$pageIndex';
    Uri uri = Uri.parse(url);
    var headers = {
      'accept': 'text/plain',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    http.Response response = await http.get(uri, headers: headers);
    log('url : $url');
    log('aaaa : ${response.statusCode}');
    log('statusCode : ${response.statusCode}');
    log('getSeasons : ${response.body}');
    if (response.statusCode == 200) {
      return AdsModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 400) {
      return AdsModel.fromJson({});
    } else {
      return AdsModel.fromJson({});
    }
  }

  static Future<BrandModel> getBrand({
    required int pageSize,
    required int pageIndex,
    String? search,
  }) async {
    String url =
        '${ApiUrl.baseUrl}${ApiUrl.brand}?PageSize=$pageSize&PageNumber=$pageIndex';
    if (search != null) {
      url += '&name=$search';
    }
    Uri uri = Uri.parse(url);
    var headers = {
      'accept': 'text/plain',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    http.Response response = await http.get(uri, headers: headers);
    log('url : $url');
    log('aaaa : ${response.statusCode}');
    log('statusCode : ${response.statusCode}');
    log('getSeasons : ${response.body}');
    if (response.statusCode == 200) {
      return BrandModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 400) {
      return BrandModel.fromJson({});
    } else {
      return BrandModel.fromJson({});
    }
  }

  static Future<CategoryModel> getCategory({
    required int pageSize,
    required int pageIndex,
    String? search,
  }) async {
    String url =
        '${ApiUrl.baseUrl}${ApiUrl.category}?PageSize=$pageSize&PageNumber=$pageIndex';
    if (search != null) {
      url += '&name=$search';
    }
    Uri uri = Uri.parse(url);
    var headers = {
      'accept': 'text/plain',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    http.Response response = await http.get(uri, headers: headers);
    log('url : $url');
    log('aaaa : ${response.statusCode}');
    log('statusCode : ${response.statusCode}');
    log('getSeasons : ${response.body}');
    if (response.statusCode == 200) {
      return CategoryModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 400) {
      return CategoryModel.fromJson({});
    } else {
      return CategoryModel.fromJson({});
    }
  }

  static Future<SubCategoryModel> getSubCategory({
    required int pageSize,
    required int pageIndex,
    required int categoryId,
    String? search,
  }) async {
    String url =
        '${ApiUrl.baseUrl}${ApiUrl.subCategory}?PageSize=$pageSize&PageNumber=$pageIndex&categoryId=$categoryId';
    if (search != null) {
      url += '&name=$search';
    }
    Uri uri = Uri.parse(url);
    var headers = {
      'accept': 'text/plain',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    http.Response response = await http.get(uri, headers: headers);
    log('url : $url');
    log('getSubCategory : ${response.statusCode}');
    log('statusCode : ${response.statusCode}');
    log('getSeasons : ${response.body}');
    if (response.statusCode == 200) {
      return SubCategoryModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 400) {
      return SubCategoryModel.fromJson({});
    } else {
      return SubCategoryModel.fromJson({});
    }
  }

  static Future<ProductModel> getProduct({
    required int pageSize,
    required int pageIndex,
    required int subCategoryId,
    required int brandId,
    String? search,
  }) async {
    String url =
        '${ApiUrl.baseUrl}${ApiUrl.product}?PageSize=$pageSize&PageNumber=$pageIndex';
    if (search != null) {
      url += '&name=$search';
    }
    if (subCategoryId != -1) {
      url += '&subCategoryId=$subCategoryId';
    }
    if (brandId != -1) {
      url += '&brandId=$brandId';
    }
    Uri uri = Uri.parse(url);
    var headers = {
      'accept': 'text/plain',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    http.Response response = await http.get(uri, headers: headers);
    log('url : $url');
    log('product : ${response.statusCode}');
    log('statusCode : ${response.statusCode}');
    log('getSeasons : ${response.body}');
    if (response.statusCode == 200) {
      return ProductModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 400) {
      return ProductModel.fromJson({});
    } else {
      return ProductModel.fromJson({});
    }
  }
}
