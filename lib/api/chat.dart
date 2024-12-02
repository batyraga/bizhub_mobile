import 'dart:developer';
import 'dart:io';

import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/api.dart';
import 'package:bizhub/models/api_response.model.dart';
import 'package:bizhub/models/chat.model.dart';
import 'package:dio/dio.dart';

class ChatApi {
  Future<String> uploadImage(File image) async {
    final image_ = await MultipartFile.fromFile(
      image.path,
      filename: image.path.split("/").last,
    );

    final f = FormData.fromMap({
      'file': image_,
    });

    final response = await api.dio
        .post<Map<String, dynamic>>(
          '$apiUrl/api/v1/chat/upload',
          data: f,
        )
        .timeout(const Duration(seconds: 10));
    log("response ${response.toString()}");
    if (response.statusCode == 200) {
      final data = ApiResponse<dynamic>.fromJson(response.data!);
      if (data.isSuccess == true) {
        return data.result as String;
      }
    }
    throw Exception("Failed to upload image for chat room");
  }

  Future<List<ChatRoom>> getRooms({
    required String culture,
    required int page,
    required int limit,
  }) async {
    final response = await api.dio.get<Map<String, dynamic>>(
        '$apiUrl/api/v1/chat/rooms',
        queryParameters: {
          'culture': culture,
          'page': page,
          'limit': limit,
        }).timeout(const Duration(seconds: 10));
    log("response ${response.toString()}");
    if (response.statusCode == 200) {
      final data = ApiResponse<dynamic>.fromJson(response.data!);
      if (data.isSuccess == true) {
        // return response.data !.result;
        return List<ChatRoom>.from(
            (data.result as List).map((e) => ChatRoom.fromJson(e)));
      }
    }
    throw Exception("Failed to load client rooms");
  }

  Future<List<ChatMessage>> getRoomMessages({
    required String culture,
    required int page,
    required int limit,
    required String room,
  }) async {
    final response = await api.dio.get<Map<String, dynamic>>(
        '$apiUrl/api/v1/chat/rooms/$room/messages',
        queryParameters: {
          'culture': culture,
          'page': page,
          'limit': limit,
        }).timeout(const Duration(seconds: 10));
    log("response: ${response.data}");
    if (response.statusCode == 200) {
      final data = ApiResponse<dynamic>.fromJson(response.data!);
      if (data.isSuccess == true) {
        return List<ChatMessage>.from(
            (data.result as List).map((e) => ChatMessage.fromJson(e)));
      }
    }

    throw Exception("Failed to load client room messages");
  }
}
