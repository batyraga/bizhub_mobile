import 'dart:developer';

import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/api.dart';
import 'package:bizhub/models/api_response.model.dart';
import 'package:bizhub/models/sellers.model.dart';

class WalletApi {
  Future<SellerWallet> getMySellerWallet({required String culture}) async {
    final response =
        await api.dio.get("$apiUrl/api/v1/wallet", queryParameters: {
      "culture": culture,
    });
    if (response.statusCode == 200) {
      final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
      if (data.isSuccess == true) {
        return SellerWallet.fromJson(data.result);
      }
    }
    throw Exception("failed to load my seller wallet");
  }

  Future<double> withdraw({required int sum}) async {
    final response =
        await api.dio.post("$apiUrl/api/v1/wallet/withdraw", data: {
      "sum": sum,
    });

    if (response.statusCode == 200) {
      final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
      if (data.isSuccess == true) {
        return double.parse(data.result["balance"].toString());
      }
    }

    throw Exception("failed withdraw action");
  }

  Future<WalletPayResult> pay(
      {required String action, required String type}) async {
    final response = await api.dio.post("$apiUrl/api/v1/wallet/pay", data: {
      "action": action,
      "package_type": type,
    });

    if (response.statusCode == 200) {
      final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
      log("[pay] - result - ${data.result} \n[pay] - error - ${data.error?.message}");
      if (data.isSuccess == true) {
        return WalletPayResult.fromJson(data.result);
      }
    }

    throw Exception("failed pay action");
  }

  Future<double> cancelWithdraw({required String id}) async {
    final response =
        await api.dio.post("$apiUrl/api/v1/wallet/withdraw/$id/cancel");

    if (response.statusCode == 200) {
      final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
      if (data.isSuccess == true) {
        return double.parse(data.result["balance"].toString());
      }
    }

    throw Exception("failed cancel withdraw action");
  }

  Future<List<SellerWalletHistoryTransaction>> getMySellerWalletHistory(
      {required String culture, required int page, required int limit}) async {
    final response =
        await api.dio.get("$apiUrl/api/v1/wallet/history", queryParameters: {
      "culture": culture,
      "page": page,
      "limit": limit,
    }).timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
      if (data.isSuccess == true) {
        return List<SellerWalletHistoryTransaction>.from((data.result as List)
            .map((e) => SellerWalletHistoryTransaction.fromJson(e)));
      }
    }
    throw Exception("failed to load my seller wallet history");
  }
}
