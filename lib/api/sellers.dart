import 'dart:convert';
import 'dart:developer';

import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/api.dart';
import 'package:bizhub/models/api_response.model.dart';
import 'package:bizhub/models/sellers.model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SellersApi {
  Future<List<Seller>> getAll(
      {required String culture,
      required int page,
      required int limit,
      required String? sellerId}) async {
    final http.Client client = http.Client();
    try {
      final response = await api.dio
          .get(
              "$apiUrl/api/v1/sellers?page=$page&limit=$limit&culture=$culture")
          .timeout(const Duration(seconds: 10));
      log("[sellers] - response - $response");
      if (response.statusCode == 200) {
        final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
        if (data.isSuccess == true) {
          return List<Seller>.from(
                  (data.result as List).map((e) => Seller.fromJson(e)))
              .where((element) => element.id != sellerId)
              .toList();
        }
      }
      throw Exception("failed to load sellers");
    } finally {
      client.close();
    }
  }

  Future<List<TopSeller>> top() async {
    final response = await api.dio
        .get("$apiUrl/api/v1/sellers/top")
        .timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
      if (data.isSuccess == true) {
        return List<TopSeller>.from(
            (data.result as List).map((e) => TopSeller.fromJson(e))).toList();
      }
    }
    throw Exception("failed to load sellers");
  }

  Future<List<Seller>> filter(
      {required String culture,
      required int page,
      required int limit,
      required List<String> cities,
      required String sellerType}) async {
    final http.Client client = http.Client();
    try {
      final response =
          await api.dio.get("$apiUrl/api/v1/sellers/filter", queryParameters: {
        "culture": culture,
        "limit": limit,
        "page": page,
        "cities": cities,
        "only": sellerType,
      }).timeout(const Duration(seconds: 10));
      debugPrint(
          "filter route => !http://192.168.1.107:3000/api/v1/sellers/filter?page=$page&limit=$limit&cities=$cities&only=$sellerType!");
      if (response.statusCode == 200) {
        final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
        if (data.isSuccess == true) {
          return List<Seller>.from(
              (data.result as List).map((e) => Seller.fromJson(e)));
        }
      }
      throw Exception("failed to load sellers");
    } finally {
      client.close();
    }
  }

  Future<List<Seller>> search(
      {required String q,
      required String culture,
      required int page,
      required int limit}) async {
    final http.Client client = http.Client();
    try {
      final response = await api.dio
          .get(
              "$apiUrl/api/v1/sellers/search?culture=$culture&q=$q&page=$page&limit=$limit")
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
        if (data.isSuccess == true) {
          return List<Seller>.from(
              (data.result as List).map((e) => Seller.fromJson(e)));
        }
      }
      throw Exception("failed to load sellers");
    } finally {
      client.close();
    }
  }

  Future<SellerDetail> getSellerDetail(
      {required String culture, required String sellerId}) async {
    final http.Client client = http.Client();
    try {
      final response = await api.dio
          .get("$apiUrl/api/v1/sellers/$sellerId?culture=$culture")
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
        if (data.isSuccess == true) {
          return SellerDetail.fromJson(data.result);
        }
      }
      throw Exception("failed to load seller detail");
    } finally {
      client.close();
    }
  }

  Future<SellersFilterAggregations> filterAggregations({
    required String culture,
  }) async {
    final http.Client client = http.Client();
    try {
      final response = await api.dio
          .get("$apiUrl/api/v1/sellers/filter/aggregations?culture=$culture")
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
        if (data.isSuccess == true) {
          return SellersFilterAggregations.fromJson(data.result);
        }
      }
      throw Exception("failed to load sellers filter aggregations");
    } finally {
      client.close();
    }
  }
}
