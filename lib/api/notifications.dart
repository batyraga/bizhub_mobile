import 'dart:developer';

import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/api.dart';
import 'package:bizhub/models/api_response.model.dart';

class NotificationsApi {
  Future<bool> saveNotificationToken(String token) async {
    final response =
        await api.dio.get("$apiUrl/add-notification-token", queryParameters: {
      "token": token,
    });

    log("[saveNotificationToken] - response - ${response.data}");

    final ApiResponse decoded = ApiResponse.fromJson(response.data);

    return decoded.isSuccess;
  }
}
