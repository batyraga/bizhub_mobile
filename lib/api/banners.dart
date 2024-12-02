import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/api.dart';
import 'package:bizhub/models/api_response.model.dart';

class BannersApi {
  Future<List<String>> getAll({
    required String culture,
  }) async {
    final response = await api.dio
        .get("$apiUrl/api/v1/banners", queryParameters: {"culture": culture});
    final ApiResponse decoded = ApiResponse.fromJson(response.data);

    return List<String>.from(decoded.result);
  }
}
