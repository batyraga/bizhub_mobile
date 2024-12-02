import 'dart:convert';
import 'dart:developer';

import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/api.dart';
import 'package:bizhub/models/api_response.model.dart';
import 'package:bizhub/models/collections.model.dart';
import 'package:bizhub/models/product.model.dart';
import 'package:http/http.dart' as http;

class CollectionsApi {
  Future<List<Product>> getCollectionProducts(
      {required String culture,
      required String path,
      required int page,
      required int limit}) async {
    final response = await api.dio
        .get(
            "$apiUrl/api/v1/collections/$path?culture=$culture&page=$page&limit=$limit")
        .timeout(const Duration(seconds: 10));
    log("[getCollectionProducts] - response - $response");

    if (response.statusCode == 200) {
      final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
      if (data.isSuccess == true) {
        return List<Product>.from(
            (data.result as List).map((e) => Product.fromJson(e)));
      }
    }
    throw Exception("failed to load collection products");
  }

  Future<List<Collection>> getCollections({required String culture}) async {
    final http.Client client = http.Client();
    try {
      final response = await api.dio
          .get("$apiUrl/api/v1/collections?culture=$culture")
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
        if (data.isSuccess == true) {
          return List<Collection>.from(
              (data.result as List).map((e) => Collection.fromJson(e)));
        }
      }
      throw Exception("Failed to load collections");
    } catch (err) {
      rethrow;
    } finally {
      client.close();
    }
  }

  Future<List<Product>> getCollection(
      {required String culture, required String path}) async {
    final response = await api.dio
        .get("$apiUrl/api/v1/collections/quick/$path?culture=$culture")
        .timeout(const Duration(seconds: 10));
    log("$response");
    if (response.statusCode == 200) {
      final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
      if (data.isSuccess == true) {
        return List<Product>.from(
            (data.result as List).map((e) => Product.fromJson(e)));
      }
    }
    throw Exception("Failed to load collection product brief");
  }
}
