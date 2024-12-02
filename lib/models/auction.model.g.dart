// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auction.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Auction _$AuctionFromJson(Map<String, dynamic> json) => Auction(
      finishedAt: DateTime.parse(json['finished_at'] as String),
      heading: json['heading'] as String,
      id: json['_id'] as String,
      image: json['image'] as String,
      isFinished: json['is_finished'] as bool,
      startedAt: DateTime.parse(json['started_at'] as String),
      textColor: json['text_color'] as String,
    );

Map<String, dynamic> _$AuctionToJson(Auction instance) => <String, dynamic>{
      '_id': instance.id,
      'image': instance.image,
      'heading': instance.heading,
      'text_color': instance.textColor,
      'started_at': instance.startedAt.toIso8601String(),
      'finished_at': instance.finishedAt.toIso8601String(),
      'is_finished': instance.isFinished,
    };

AuctionDetail _$AuctionDetailFromJson(Map<String, dynamic> json) =>
    AuctionDetail(
      description: json['description'] as String,
      finishedAt: DateTime.parse(json['finished_at'] as String),
      heading: json['heading'] as String,
      id: json['_id'] as String,
      image: json['image'] as String,
      initialMinimalBid: (json['initial_min_bid'] as num).toDouble(),
      isFinished: json['is_finished'] as bool,
      minimalBid: (json['minimal_bid'] as num).toDouble(),
      participants: json['participants'] as int,
      startedAt: DateTime.parse(json['started_at'] as String),
      winners: (json['winners'] as List<dynamic>)
          .map((e) => AuctionWinner.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AuctionDetailToJson(AuctionDetail instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'image': instance.image,
      'heading': instance.heading,
      'description': instance.description,
      'participants': instance.participants,
      'winners': instance.winners,
      'initial_min_bid': instance.initialMinimalBid,
      'minimal_bid': instance.minimalBid,
      'started_at': instance.startedAt.toIso8601String(),
      'finished_at': instance.finishedAt.toIso8601String(),
      'is_finished': instance.isFinished,
    };

AuctionWinner _$AuctionWinnerFromJson(Map<String, dynamic> json) =>
    AuctionWinner(
      index: json['index'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      lastBid: (json['last_bid'] as num).toDouble(),
      seller: Seller.fromJson(json['seller'] as Map<String, dynamic>),
      sellerId: json['seller_id'] as String,
    );

Map<String, dynamic> _$AuctionWinnerToJson(AuctionWinner instance) =>
    <String, dynamic>{
      'index': instance.index,
      'seller_id': instance.sellerId,
      'last_bid': instance.lastBid,
      'created_at': instance.createdAt.toIso8601String(),
      'seller': instance.seller,
    };

AuctionBidResult _$AuctionBidResultFromJson(Map<String, dynamic> json) =>
    AuctionBidResult(
      balance: (json['balance'] as num).toDouble(),
      inAuction: SellerWalletInAuction.fromJson(
          json['in_auction'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuctionBidResultToJson(AuctionBidResult instance) =>
    <String, dynamic>{
      'balance': instance.balance,
      'in_auction': instance.inAuction,
    };
