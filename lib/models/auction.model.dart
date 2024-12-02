import 'package:bizhub/models/sellers.model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auction.model.g.dart';

@JsonSerializable()
class Auction {
  @JsonKey(name: "_id")
  final String id;
  @JsonKey()
  final String image;
  @JsonKey()
  final String heading;
  @JsonKey(name: "text_color")
  final String textColor;
  @JsonKey(name: "started_at")
  final DateTime startedAt;
  @JsonKey(name: "finished_at")
  final DateTime finishedAt;
  @JsonKey(name: "is_finished")
  final bool isFinished;
  const Auction(
      {required this.finishedAt,
      required this.heading,
      required this.id,
      required this.image,
      required this.isFinished,
      required this.startedAt,
      required this.textColor});

  factory Auction.fromJson(Map<String, dynamic> json) =>
      _$AuctionFromJson(json);
  Map<String, dynamic> toJson() => _$AuctionToJson(this);
}

@JsonSerializable()
class AuctionDetail {
  @JsonKey(name: "_id")
  final String id;
  @JsonKey()
  final String image;
  @JsonKey()
  final String heading;
  @JsonKey()
  final String description;
  @JsonKey()
  final int participants;
  @JsonKey()
  final List<AuctionWinner> winners;
  @JsonKey(name: "initial_min_bid")
  final double initialMinimalBid;
  @JsonKey(name: "minimal_bid")
  final double minimalBid;
  @JsonKey(name: "started_at")
  final DateTime startedAt;
  @JsonKey(name: "finished_at")
  final DateTime finishedAt;
  @JsonKey(name: "is_finished")
  final bool isFinished;

  const AuctionDetail({
    required this.description,
    required this.finishedAt,
    required this.heading,
    required this.id,
    required this.image,
    required this.initialMinimalBid,
    required this.isFinished,
    required this.minimalBid,
    required this.participants,
    required this.startedAt,
    required this.winners,
  });

  factory AuctionDetail.fromJson(Map<String, dynamic> json) =>
      _$AuctionDetailFromJson(json);
  Map<String, dynamic> toJson() => _$AuctionDetailToJson(this);
}

@JsonSerializable()
class AuctionWinner {
  @JsonKey()
  final int index;
  @JsonKey(name: "seller_id")
  final String sellerId;
  @JsonKey(name: "last_bid")
  final double lastBid;
  @JsonKey(name: "created_at")
  final DateTime createdAt;
  @JsonKey()
  final Seller seller;

  const AuctionWinner({
    required this.index,
    required this.createdAt,
    required this.lastBid,
    required this.seller,
    required this.sellerId,
  });

  factory AuctionWinner.fromJson(Map<String, dynamic> json) =>
      _$AuctionWinnerFromJson(json);
  Map<String, dynamic> toJson() => _$AuctionWinnerToJson(this);
}

@JsonSerializable()
class AuctionBidResult {
  @JsonKey()
  final double balance;
  @JsonKey(name: "in_auction")
  final SellerWalletInAuction inAuction;

  const AuctionBidResult({
    required this.balance,
    required this.inAuction,
  });

  factory AuctionBidResult.fromJson(Map<String, dynamic> json) =>
      _$AuctionBidResultFromJson(json);
  Map<String, dynamic> toJson() => _$AuctionBidResultToJson(this);
}
