import 'dart:convert';

import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/api.dart';
import 'package:bizhub/models/api_response.model.dart';
import 'package:bizhub/models/brand.model.dart';
import 'package:http/http.dart' as http;

class BrandsApi {
  Future<List<Brand>> getBrandChildren(
      {required String id,
      required String culture,
      required int page,
      String? categoryId,
      required int limit}) async {
    final response =
        await api.dio.get("$apiUrl/api/v1/brands/$id", queryParameters: {
      'culture': culture,
      'page': page,
      ...(categoryId != null ? {'categoryId': categoryId} : {}),
    }).timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
      if (data.isSuccess == true) {
        return List<Brand>.from(
            (data.result as List).map((e) => Brand.fromJson(e)));
      }
    }
    throw Exception("failed to load brand children");
  }

  Future<List<ParentBrand>> getBrands(
      {required String culture,
      required int page,
      String? categoryId,
      required int limit}) async {
    final response =
        await api.dio.get("$apiUrl/api/v1/brands", queryParameters: {
      'culture': culture,
      'page': page,
      ...(categoryId != null ? {'categoryId': categoryId} : {}),
    }).timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
      if (data.isSuccess == true) {
        return List<ParentBrand>.from(
            (data.result as List).map((e) => ParentBrand.fromJson(e)));
      }
    }

    throw Exception("failed to load brands");
  }
}
