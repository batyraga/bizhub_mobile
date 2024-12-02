import 'dart:developer';

import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/api.dart';
import 'package:bizhub/models/api_response.model.dart';
import 'package:bizhub/models/auction.model.dart';
import 'package:bizhub/screens/user_profile/child_screens/wallet/auctions/auction_detail.dart';

class AuctionsApi {
  Future<List<Auction>> getAll({
    required String culture,
    required int page,
    required int limit,
  }) async {
    final response =
        await api.dio.get("$apiUrl/api/v1/auctions", queryParameters: {
      "culture": culture,
      "page": page,
      "limit": limit,
    }).timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
      if (data.isSuccess == true) {
        return List<Auction>.from(
            (data.result as List).map((e) => Auction.fromJson(e)));
      }
    }
    throw Exception("failed to load auctions");
  }

  Future<AuctionBidResult> bid({
    required String auctionId,
    required int sum,
    required String culture,
  }) async {
    final response = await api.dio
        .post("$apiUrl/api/v1/auctions/$auctionId/bid", queryParameters: {
      "culture": culture,
    }, data: {
      "sum": sum,
    }).timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
      log("|api| [bid] - result - ${data.result}");
      if (data.isSuccess == true) {
        return AuctionBidResult.fromJson(data.result);
      }
    }
    throw Exception("failed to load auctions");
  }

  Future<AuctionDetail> getAuctionDetail(
      {required String culture, required String auctionId}) async {
    final response = await api.dio
        .get("$apiUrl/api/v1/auctions/$auctionId", queryParameters: {
      culture: culture,
    }).timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      final ApiResponse<dynamic> data = ApiResponse.fromJson(response.data);
      if (data.isSuccess == true) {
        return AuctionDetail.fromJson(data.result);
      }
    }
    throw Exception("failed to load auction detail");
  }
}
