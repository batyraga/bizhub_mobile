import 'dart:developer';
import 'dart:io';

import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/api.dart';
import 'package:bizhub/models/api_response.model.dart';
import 'package:bizhub/models/category.model.dart';
import 'package:bizhub/models/city.model.dart';
import 'package:bizhub/models/favorite.model.dart';
import 'package:bizhub/models/posts.model.dart';
import 'package:bizhub/models/product.model.dart';
import 'package:bizhub/models/sellers.model.dart';
import 'package:bizhub/providers/auth.provider.dart';
import 'package:bizhub/providers/storage.provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthApi {
  Future<bool> checkServerConnection() async {
    final response = await api.dio.get("$apiUrl/api/conn_204").timeout(const Duration(seconds: 10));

    if (response.statusCode == 204) {
      return true;
    }

    throw Exception("server not alive");
  }

  Future<bool> hasPhone(String phone) async {
    final response = await api.dio.post("$apiUrl/api/v1/auth/has_phone", data: {
      'phone': phone,
    }).timeout(const Duration(seconds: 10));
    log("$response");
    if (response.statusCode == 200) {
      final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
      if (data.isSuccess == false && data.error != null) {
        throw data.error!;
      }
      return data.isSuccess;
    }

    throw Exception("failed check phone number :(");
  }

  Future<bool> recoverPassword({required String phone, required String password}) async {
    final response = await api.dio.post("$apiUrl/api/v1/auth/recover_password", data: {
      'phone': phone,
      'password': password,
    }).timeout(const Duration(seconds: 10));
    log("$response");
    if (response.statusCode == 200) {
      final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
      if (data.isSuccess == false && data.error != null) {
        throw data.error!;
      }
      return data.isSuccess;
    }

    throw Exception("failed recover password of customer :(");
  }

  Future<bool> deleteProfile() async {
    final response = await api.dio.delete("$apiUrl/api/v1/auth/profile").timeout(const Duration(seconds: 10));
    log("$response");
    if (response.statusCode == 200) {
      final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
      if (data.isSuccess == false && data.error != null) {
        throw data.error!;
      }
      return data.isSuccess;
    }

    throw Exception("failed delete profile :(");
  }

  Future<bool> validatePassword({required String password}) async {
    final response = await api.dio.post("$apiUrl/api/v1/auth/validate_password", data: {
      'password': password,
    }).timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
      return data.isSuccess;
    }
    throw Exception("failed to validate password");
  }

  Future<List<Product>> mySellerProfileProducts({required String culture, required int page, required int limit}) async {
    final response = await api.dio.get("$apiUrl/api/v1/auth/seller_profile/products?culture=$culture&page=$page&limit=$limit").timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
      if (data.isSuccess == true) {
        return List<Product>.from((data.result as List).map((e) => Product.fromJson(e)));
      }
    }
    throw Exception("failed to load my seller profile products");
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final response = await api.dio.put("$apiUrl/api/v1/auth/change_password", data: {"old_password": currentPassword, "new_password": newPassword}).timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
      if (data.isSuccess == false && data.error != null) {
        throw data.error!;
      }
      return data.isSuccess;
    }

    throw Exception("failed change password action :(");
  }

  Future<Map<String, dynamic>> signUp(FormData formData) async {
    final response = await api.dio.post("$apiUrl/api/v1/auth/signup", data: formData).timeout(const Duration(seconds: 10));
    log("${response.data}");
    if (response.statusCode == 200) {
      final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
      if (data.isSuccess == true) {
        return data.result;
      } else {
        throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            // type: DioExceptionType.response,
            type: DioExceptionType.badCertificate,
            error: data.error);
      }
    }

    throw Exception("failed create new account [signUp] :(");
  }

  Future<String> editProfileOfCustomer({
    required String name,
    File? logo,
  }) async {
    final form = FormData.fromMap({
      "name": name,
    });

    if (logo != null) {
      final logo_ = await MultipartFile.fromFile(logo.path, filename: logo.path.split("/").last);
      form.files.add(MapEntry("logo", logo_));
    }

    final response = await api.dio.put("$apiUrl/api/v1/auth/customer_profile", data: form).timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
      if (data.isSuccess == true) {
        return data.result as String;
      }
    }

    throw Exception("failed edit profile of customer :(");
  }

  Future<bool> editProfileOfSeller({
    required String name,
    required String address,
    required String bio,
    required String culture,
    required City city,
    File? logo,
  }) async {
    final form = FormData.fromMap({
      "name": name,
      "address": address,
      "bio": bio,
      "city_id": city.id,
    });

    if (logo != null) {
      final logo_ = await MultipartFile.fromFile(logo.path, filename: logo.path.split("/").last);
      form.files.add(MapEntry("logo", logo_));
    }

    final response = await api.dio.put("$apiUrl/api/v1/auth/seller_profile", data: form, queryParameters: {
      'culture': culture,
    }).timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
      if (data.isSuccess == true) {
        return true;
      }
    }

    throw Exception("failed edit profile of seller :(");
  }

  Future<List<PostWithoutSeller>> mySellerProfilePosts({required String culture, required int page, required int limit}) async {
    final response = await api.dio.get("$apiUrl/api/v1/auth/seller_profile/posts?culture=$culture&page=$page&limit=$limit").timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
      if (data.isSuccess == true) {
        log("mySeller.posts: ${data.result}");
        return List<PostWithoutSeller>.from((data.result as List).map((e) => PostWithoutSeller.fromJson(e)));
      }
    }
    throw Exception("failed to load my seller profile posts");
  }

  Future<List<Category>> mySellerProfileCategories({
    required String culture,
  }) async {
    final response = await api.dio.get("$apiUrl/api/v1/auth/seller_profile/categories?culture=$culture").timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
      if (data.isSuccess == true) {
        return List<Category>.from((data.result as List).map((e) => Category.fromJson(e)));
      }
    }
    throw Exception("failed to load my seller profile categories");
  }

  Future<Map<String, dynamic>> login(String phone, String password) async {
    final response = await api.dio.post("$apiUrl/api/v1/auth/customer_login", data: {
      "phone": phone,
      "password": password,
    });
    if (response.statusCode == 200) {
      final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
      if (data.isSuccess == true) {
        return data.result;
      }
    }
    throw Exception("login failed");
  }

  Future<String> becomeSeller(
    void Function(int, int) onSendProgress,
    BuildContext context, {
    required File logo,
    required String name,
    required String bio,
    required String culture,
    required String address,
    required String cityId,
  }) async {
    final logo_ = await MultipartFile.fromFile(logo.path, filename: logo.path.split("/").last);
    final form = FormData.fromMap({
      'name': name,
      'address': address,
      'city_id': cityId,
      'bio': bio,
      'logo': logo_,
    });

    final response = await api.dio.post("$apiUrl/api/v1/auth/become_seller", data: form, onSendProgress: onSendProgress, queryParameters: {
      'culture': culture,
    });
    if (response.statusCode == 200) {
      final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
      log("[becomeSeller] - response - ${data.result}");
      if (data.isSuccess == true) {
        Future.sync(() {
          context.read<Auth>().setTokens(data.result["access_token"] as String, data.result["refresh_token"] as String);
        });
        return data.result["seller_id"] as String;
      }
    }

    throw Exception("become seller action failed");
  }

  Future<SellerDetail> mySellerProfile({required String culture}) async {
    final response = await api.dio.get("$apiUrl/api/v1/auth/seller_profile", queryParameters: {
      "culture": culture,
    });
    if (response.statusCode == 200) {
      final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
      if (data.isSuccess == true) {
        return SellerDetail.fromJson(data.result);
      }
    }
    throw Exception("login failed");
  }

  Future<List<T>> myFavorites<T>({required String culture, required String type, required int page, required int limit, required T Function(Map<String, dynamic>) customJsonDecoder}) async {
    try {
      final response = await api.dio.get("$apiUrl/api/v1/auth/favorites", queryParameters: {
        "culture": culture,
        "type": type,
        "page": page,
        "limit": limit,
      });
      if (response.statusCode == 200) {
        final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
        log("myFavorites result => ${data.isSuccess} ${data.result}");
        if (data.isSuccess == true) {
          return List<T>.from((data.result as List<dynamic>).map((e) => customJsonDecoder(e)));
        }
      }

      throw Exception("my favorites failed");
    } catch (err) {
      log("[myFavorites] - error - $err");
      return Future.error(err);
    }
  }

  Future<bool> favorite(String method, String type, String id) async {
    try {
      // await Future.delayed(const Duration(seconds: 10));
      final req = method == "add" ? api.dio.post : api.dio.delete;
      final response = await req("$apiUrl/api/v1/auth/favorite", data: {
        "type": type,
        "_id": id,
      });
      if (response.statusCode == 200) {
        final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
        if (data.isSuccess == true) {
          return true;
        }
      }
      throw Exception("$method favorite failed");
    } catch (err) {
      log("[favorite] - error - $err");
      return false;
    }
  }

  /// v0 -daky function
  ///
  /// @deprecated
  @Deprecated("salam")
  Future<bool> saveFavorites(Map<String, bool> unsavedPosts, Map<String, bool> unsavedProducts, Map<String, bool> unsavedSellers) async {
    try {
      List<UnsavedFavoritePost> unsavedPostList = [];
      List<UnsavedFavoriteProduct> unsavedProductList = [];
      List<UnsavedFavoriteSeller> unsavedSellerList = [];

      unsavedPosts.forEach((key, value) {
        unsavedPostList.add(UnsavedFavoritePost(liked: value, postId: key));
      });

      unsavedProducts.forEach((key, value) {
        unsavedProductList.add(UnsavedFavoriteProduct(liked: value, productId: key));
      });

      unsavedSellers.forEach((key, value) {
        unsavedSellerList.add(UnsavedFavoriteSeller(liked: value, sellerId: key));
      });

      final response = await api.dio.post("$apiUrl/api/v1/auth/save_favorites", data: {
        "favorites": {"posts": unsavedPostList, "products": unsavedProductList, "sellers": unsavedSellerList},
      });
      if (response.statusCode == 200) {
        final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
        if (data.isSuccess == true) {
          return true;
        }
      }
      throw Exception("unsaved favorites failed");
    } catch (err) {
      return false;
    }
  }

  Future<String> refreshToken() async {
    try {
      final String? refreshToken_ = storage.read("refresh_token");
      if (refreshToken_ == null) {
        throw Exception("refresh token not found");
      }
      final response = await api.dio.post("$apiUrl/api/v1/auth/refresh",
          options: Options(
            headers: {
              Headers.acceptHeader: "application/json",
              Headers.contentTypeHeader: "application/json",
              "Authorization": "Bearer $refreshToken_",
              ApiConstants.dismissInterceptor: ApiConstants.dismissInterceptor,
            },
          ));
      if (response.statusCode == 200) {
        final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
        if (data.isSuccess == true) {
          storage.write("access_token", data.result["access_token"]);
          storage.write("refresh_token", data.result["refresh_token"]);
          return data.result["access_token"];
        }
      }
      throw Exception("failed to load refresh token");
    } on DioException catch (err) {
      if (err.response?.statusCode == 401) {
        final ApiResponse<dynamic> data = ApiResponse.fromJson(err.response?.data);
        if (data.error?.code == ApiErrorConstants.refreshTokenExpired) {
          return ApiErrorConstants.refreshTokenExpired;
        }
      }
      rethrow;
    }
  }
}
