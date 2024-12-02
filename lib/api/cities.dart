import 'dart:convert';

import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/api.dart';
import 'package:bizhub/models/api_response.model.dart';
import 'package:bizhub/models/city.model.dart';
import 'package:http/http.dart' as http;

class CitiesApi {
  Future<List<City>> getAll(
      {required String culture, required int page, required int limit}) async {
    final http.Client client = http.Client();
    try {
      final response = await api.dio
          .get("$apiUrl/api/v1/cities?page=$page&limit=$limit&culture=$culture")
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
        if (data.isSuccess == true) {
          return List<City>.from(
              (data.result as List).map((e) => City.fromJson(e)));
        }
      }
      throw Exception("failed to load cities");
    } finally {
      client.close();
    }
  }
}
