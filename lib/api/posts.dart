import 'dart:convert';
import 'dart:developer';

import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/api.dart';
import 'package:bizhub/models/api_response.model.dart';
import 'package:bizhub/models/posts.model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PostsApi {
  Future<bool> add({
    required String culture,
    required FormData form,
  }) async {
    final response = await api.dio
        .post("$apiUrl/api/v1/auth/seller_profile/posts?culture=$culture",
            data: form)
        .timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
      log("${data.error?.code} ${data.error?.message}");
      if (data.isSuccess == true) {
        return true;
      }
    }
    throw Exception("Failed to add new post");
  }

  Future<bool> delete({
    required String postId,
  }) async {
    final response = await api.dio
        .delete("$apiUrl/api/v1/auth/seller_profile/posts/$postId")
        .timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
      log("${data.error?.code} ${data.error?.message}");
      if (data.isSuccess == true) {
        return true;
      }
    }

    throw Exception("Failed to delete post");
  }

  Future<PostDetail> getPostDetail(
      {required String culture, required String id}) async {
    final response = await api.dio
        .get("$apiUrl/api/v1/posts/$id?culture=$culture")
        .timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
      if (data.isSuccess == true) {
        return PostDetail.fromJson(data.result);
      }
    }
    throw Exception("Failed to load post detail");
  }

  Future<List<Post>> getHomePosts(
      {required int page, required int limit, required String culture}) async {
    final response = await api.dio.get<Map<String, dynamic>>(
      '$apiUrl/api/v1/posts',
      queryParameters: {
        "page": page,
        "limit": limit,
        "culture": culture,
      },
    ).timeout(const Duration(seconds: 10));
    debugPrint("response ${response.toString()}");
    if (response.statusCode == 200) {
      final data = ApiResponse<dynamic>.fromJson(response.data!);
      if (data.isSuccess == true) {
        // return response.data !.result;
        return List<Post>.from(
            (data.result as List).map((e) => Post.fromJson(e)));
      }
    }
    throw Exception("Failed to load posts");
  }

  // Future<List<Post>> getHomePosts(
  //     {required int page, required int limit, required String culture}) async {
  //   final response = await api.dio.get<Map<String, dynamic>>(
  //     '$apiUrl/api/v1/posts',
  //     queryParameters: {
  //       "page": page,
  //       "limit": limit,
  //       "culture": culture,
  //     },
  //   ).timeout(const Duration(seconds: 10));
  //   debugPrint("response ${response.toString()}");
  //   if (response.statusCode == 200) {
  //     final data = ApiResponse<dynamic>.fromJson(response.data!);
  //     if (data.isSuccess == true) {
  //       // return response.data !.result;
  //       return List<Post>.from(
  //           (data.result as List).map((e) => Post.fromJson(e)));
  //     }
  //   }
  //   throw Exception("Failed to load posts");
  // }

  Future<List<PostWithoutSeller>> getSellerPosts(
      {required String culture,
      required String sellerId,
      required int page,
      required int limit}) async {
    final http.Client client = http.Client();
    try {
      debugPrint(
          "$apiUrl/api/v1/sellers/$sellerId/posts?culture=$culture&page=$page&limit=$limit");
      final response = await api.dio
          .get(
              "$apiUrl/api/v1/sellers/$sellerId/posts?culture=$culture&page=$page&limit=$limit")
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
        if (data.isSuccess == true) {
          return List<PostWithoutSeller>.from(
              (data.result as List).map((e) => PostWithoutSeller.fromJson(e)));
        }
      }
      throw Exception("failed to load seller posts");
    } finally {
      client.close();
    }
  }
}
