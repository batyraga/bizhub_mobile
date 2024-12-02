import 'dart:convert';
import 'dart:developer';
import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/api.dart';
import 'package:bizhub/models/api_response.model.dart';
import 'package:bizhub/models/posts.model.dart';
import 'package:bizhub/models/product.model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductsApi {
  Future<bool> add({
    required String culture,
    required FormData form,
  }) async {
    final response = await api.dio
        .post("$apiUrl/api/v1/auth/seller_profile/products?culture=$culture",
            data: form)
        .timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
      log("${data.error?.code} ${data.error?.message}");
      if (data.isSuccess == true) {
        return true;
      }
    }

    throw Exception("Failed to add new product");
  }

  Future<bool> edit({
    required String culture,
    required FormData form,
    required String id,
  }) async {
    final response = await api.dio
        .put("$apiUrl/api/v1/auth/seller_profile/products/$id?culture=$culture",
            data: form)
        .timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
      log("${data.error?.code} ${data.error?.message}");
      if (data.isSuccess == true) {
        return true;
      }
    }

    throw Exception("Failed to edit product");
  }

  Future<ProductDetailForEdit> getProductDetailForEdit({
    required String culture,
    required String id,
  }) async {
    final response = await api.dio
        .get("$apiUrl/api/v1/auth/seller_profile/products/$id?culture=$culture")
        .timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
      if (data.isSuccess == true) {
        return ProductDetailForEdit.fromJson(data.result);
      }
    }

    throw Exception("Failed to load original product detail for edit");
  }

  Future<bool> delete({
    required String productId,
  }) async {
    final response = await api.dio
        .delete("$apiUrl/api/v1/auth/seller_profile/products/$productId")
        .timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
      log("${data.error?.code} ${data.error?.message}");
      if (data.isSuccess == true) {
        return true;
      }
    }

    throw Exception("Failed to delete product");
  }

  Future<List<Product>> filter(
      {required String culture,
      required int page,
      required int limit,
      required String filterQuery}) async {
    final http.Client client = http.Client();
    debugPrint("hi");
    try {
      debugPrint(
          "filter route => !http://192.168.1.107:3000/api/v1/products/filter?page=$page&limit=$limit$filterQuery!");
      final response = await api.dio
          .get(
              "$apiUrl/api/v1/products/filter?page=$page&limit=$limit$filterQuery")
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
        if (data.isSuccess == true) {
          return List<Product>.from(
              (data.result as List).map((e) => Product.fromJson(e)));
        }
      }
      throw Exception("failed to load filter products");
    } finally {
      client.close();
    }
  }

  Future<bool> removeDiscountFromProduct({
    required String productId,
  }) async {
    final response =
        await api.dio.delete("$apiUrl/api/v1/products/$productId/discount");

    if (response.statusCode == 200) {
      final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);

      return data.isSuccess;
    }

    throw Exception("failed remove discount from product :(");
  }

  Future<bool> setDiscountToProduct({
    required String productId,
    required ProductDiscountData data,
  }) async {
    final response = await api.dio
        .post("$apiUrl/api/v1/products/$productId/discount", data: data);

    if (response.statusCode == 200) {
      final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);

      return data.isSuccess;
    }

    throw Exception("failed set discount to product :(");
  }

  Future<ProductDetail> getProductDetail(
      {required String culture, required String id}) async {
    debugPrint(
        "route http://192.168.1.107:3000/api/v1/products/$id?culture=$culture");
    final response = await api.dio
        .get("$apiUrl/api/v1/products/$id?culture=$culture")
        .timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
      if (data.isSuccess == true) {
        return ProductDetail.fromJson(data.result);
      }
    }
    throw Exception("failed to load product detail");
  }

  Future<List<Product>> getSellerProducts(
      {required String culture,
      required String sellerId,
      required int page,
      required int limit}) async {
    final http.Client client = http.Client();
    try {
      final response = await api.dio
          .get(
              "$apiUrl/api/v1/sellers/$sellerId/products?culture=$culture&page=$page&limit=$limit")
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
        if (data.isSuccess == true) {
          return List<Product>.from(
              (data.result as List).map((e) => Product.fromJson(e)));
        }
      }
      throw Exception("failed to load seller products");
    } finally {
      client.close();
    }
  }

  Future<List<RelatedProductForPost>> getMyProductsForPost(
      {required String culture, required int page, required int limit}) async {
    final response = await api.dio
        .get(
            "$apiUrl/api/v1/auth/seller_profile/products_post?culture=$culture&page=$page&limit=$limit")
        .timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
      if (data.isSuccess == true) {
        return List<RelatedProductForPost>.from((data.result as List)
            .map((e) => RelatedProductForPost.fromJson(e)));
      }
    }
    throw Exception("failed to load seller products for post");
  }

  Future<List<Product>> search(
      {required String q,
      required String culture,
      required int page,
      required int limit}) async {
    final http.Client client = http.Client();
    try {
      final response = await api.dio
          .get(
              "$apiUrl/api/v1/products/search?culture=$culture&q=$q&page=$page&limit=$limit")
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
        if (data.isSuccess == true) {
          return List<Product>.from(
              (data.result as List).map((e) => Product.fromJson(e)));
        }
      }
      throw Exception("failed to load sellers");
    } finally {
      client.close();
    }
  }
}
