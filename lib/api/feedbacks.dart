import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/api.dart';
import 'package:bizhub/models/api_response.model.dart';

class FeedbacksApi {
  Future<bool> addFeedback({
    required String message,
  }) async {
    final response = await api.dio.post(
      "$apiUrl/api/v1/feedbacks",
      data: {
        "message": message,
      },
    );

    final ApiResponse decoded = ApiResponse.fromJson(response.data);
    return decoded.isSuccess;
  }
}
