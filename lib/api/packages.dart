import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/api.dart';
import 'package:bizhub/models/api_response.model.dart';
import 'package:bizhub/models/sellers.model.dart';

class PackagesApi {
  Future<List<SellerPackage>> getAll({
    required String culture,
  }) async {
    final response =
        await api.dio.get("$apiUrl/api/v1/packages", queryParameters: {
      culture: culture,
    }).timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
      if (data.isSuccess == true) {
        return List<SellerPackage>.from(
            (data.result as List).map((e) => SellerPackage.fromJson(e)));
      }
    }
    throw Exception("failed to load seller packages");
  }

  Future<SellerPackageDetail> getPackage(
      {required String culture, required String type}) async {
    final response =
        await api.dio.get("$apiUrl/api/v1/packages/$type", queryParameters: {
      culture: culture,
    }).timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
      if (data.isSuccess == true) {
        return SellerPackageDetail.fromJson(data.result);
      }
    }
    throw Exception("failed to load seller $type package");
  }
}
