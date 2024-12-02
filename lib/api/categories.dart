import 'dart:convert';

import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/api.dart';
import 'package:bizhub/models/api_response.model.dart';
import 'package:http/http.dart' as http;
import 'package:bizhub/models/category.model.dart';

class CategoriesApi {
  Future<List<Category>> getCategoryChildren(
      {required String culture,
      required String id,
      required int page,
      required int limit}) async {
    final http.Client client = http.Client();
    try {
      final response = await api.dio
          .get(
              "$apiUrl/api/v1/categories/$id?culture=$culture&limit=$limit&page=$page")
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
        if (data.isSuccess == true) {
          return List<Category>.from(
              (data.result as List).map((e) => Category.fromJson(e)));
        }
      }
      throw Exception("failed to load category children");
    } finally {
      client.close();
    }
  }

  Future<List<CategoryAttributeDetail>> getCategoryAttributes({
    required String culture,
    required String categoryId,
  }) async {
    final response = await api.dio.get(
        "$apiUrl/api/v1/categories/$categoryId/attributes",
        queryParameters: {
          'culture': culture,
        }).timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
      if (data.isSuccess == true) {
        return List<CategoryAttributeDetail>.from(
            (data.result["attributes"] as List)
                .map((e) => CategoryAttributeDetail.fromJson(e)));
      }
    }
    throw Exception("failed to load category attributes");
  }

  Future<List<ParentCategory>> getCategories(
      {required String culture, required int page, required int limit}) async {
    final http.Client client = http.Client();
    try {
      final response = await api.dio
          .get(
              "$apiUrl/api/v1/categories?culture=$culture&limit=$limit&page=$page")
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
        if (data.isSuccess == true) {
          return List<ParentCategory>.from(
              (data.result as List).map((e) => ParentCategory.fromJson(e)));
        }
      }
      throw Exception("failed to load categories");
    } finally {
      client.close();
    }
  }

  Future<List<Category>> getSellerCategories(
      {required String culture, required String id}) async {
    final http.Client client = http.Client();
    try {
      final response = await api.dio
          .get("$apiUrl/api/v1/sellers/$id/categories?culture=$culture")
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
        if (data.isSuccess == true) {
          return List<Category>.from(
              (data.result as List).map((e) => Category.fromJson(e)));
        }
      }
      throw Exception("failed to load seller categories");
    } finally {
      client.close();
    }
  }
}
