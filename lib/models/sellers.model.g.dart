// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sellers.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Seller _$SellerFromJson(Map<String, dynamic> json) => Seller(
      name: json['name'] as String,
      logo: json['logo'] as String,
      id: json['_id'] as String,
      city: City.fromJson(json['city'] as Map<String, dynamic>),
      type: json['type'] as String? ?? 'regular',
    );

Map<String, dynamic> _$SellerToJson(Seller instance) => <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'logo': instance.logo,
      'type': instance.type,
      'city': instance.city,
    };

TopSeller _$TopSellerFromJson(Map<String, dynamic> json) => TopSeller(
      logo: json['logo'] as String,
      id: json['_id'] as String,
    );

Map<String, dynamic> _$TopSellerToJson(TopSeller instance) => <String, dynamic>{
      '_id': instance.id,
      'logo': instance.logo,
    };

SellerOrReporterBee _$SellerOrReporterBeeFromJson(Map<String, dynamic> json) =>
    SellerOrReporterBee(
      name: json['name'] as String,
      logo: json['logo'] as String,
      id: json['_id'] as String,
      city: json['city'] == null
          ? null
          : City.fromJson(json['city'] as Map<String, dynamic>),
      type: json['type'] as String? ?? 'regular',
    );

Map<String, dynamic> _$SellerOrReporterBeeToJson(
        SellerOrReporterBee instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'logo': instance.logo,
      'type': instance.type,
      'city': instance.city,
    };

SellersFilterAggregations _$SellersFilterAggregationsFromJson(
        Map<String, dynamic> json) =>
    SellersFilterAggregations(
      cities: (json['cities'] as List<dynamic>)
          .map((e) => City.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SellersFilterAggregationsToJson(
        SellersFilterAggregations instance) =>
    <String, dynamic>{
      'cities': instance.cities,
    };

SellerDetail _$SellerDetailFromJson(Map<String, dynamic> json) => SellerDetail(
      address: json['address'] as String,
      bio: json['bio'] as String,
      status: json['status'] as String,
      city: City.fromJson(json['city'] as Map<String, dynamic>),
      cityId: json['city_id'] as String,
      likes: json['likes'] as int,
      id: json['_id'] as String,
      logo: json['logo'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$SellerDetailToJson(SellerDetail instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'logo': instance.logo,
      'type': instance.type,
      'city_id': instance.cityId,
      'city': instance.city,
      'address': instance.address,
      'bio': instance.bio,
      'likes': instance.likes,
      'status': instance.status,
    };

SellerWallet _$SellerWalletFromJson(Map<String, dynamic> json) => SellerWallet(
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      inAuction: (json['in_auction'] as List<dynamic>)
          .map((e) => SellerWalletInAuction.fromJson(e as Map<String, dynamic>))
          .toList(),
      package: json['package'] == null
          ? null
          : SellerWalletPackage.fromJson(
              json['package'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SellerWalletToJson(SellerWallet instance) =>
    <String, dynamic>{
      'balance': instance.balance,
      'package': instance.package,
      'in_auction': instance.inAuction,
    };

SellerWalletPackage _$SellerWalletPackageFromJson(Map<String, dynamic> json) =>
    SellerWalletPackage(
      maxProducts: json['max_products'] as int?,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      expiresAt: DateTime.parse(json['expires_at'] as String),
      type: json['type'] as String,
    );

Map<String, dynamic> _$SellerWalletPackageToJson(
        SellerWalletPackage instance) =>
    <String, dynamic>{
      'type': instance.type,
      'expires_at': instance.expiresAt.toIso8601String(),
      'name': instance.name,
      'max_products': instance.maxProducts,
      'price': instance.price,
    };

SellerPackageDetail _$SellerPackageDetailFromJson(Map<String, dynamic> json) =>
    SellerPackageDetail(
      maxProducts: json['max_products'] as int?,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      id: json['_id'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$SellerPackageDetailToJson(
        SellerPackageDetail instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'type': instance.type,
      'name': instance.name,
      'max_products': instance.maxProducts,
      'price': instance.price,
    };

SellerWalletInAuction _$SellerWalletInAuctionFromJson(
        Map<String, dynamic> json) =>
    SellerWalletInAuction(
      amount: (json['amount'] as num).toDouble(),
      auctionId: json['auction_id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$SellerWalletInAuctionToJson(
        SellerWalletInAuction instance) =>
    <String, dynamic>{
      'auction_id': instance.auctionId,
      'amount': instance.amount,
      'name': instance.name,
    };

SellerPackage _$SellerPackageFromJson(Map<String, dynamic> json) =>
    SellerPackage(
      id: json['_id'] as String,
      color: json['color'] as String,
      maxProducts: json['max_products'] as int,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      textColor: json['text_color'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$SellerPackageToJson(SellerPackage instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'color': instance.color,
      'text_color': instance.textColor,
      'price': instance.price,
      'max_products': instance.maxProducts,
    };

SellerWalletHistoryTransaction _$SellerWalletHistoryTransactionFromJson(
        Map<String, dynamic> json) =>
    SellerWalletHistoryTransaction(
      createdAt: DateTime.parse(json['created_at'] as String),
      id: json['_id'] as String,
      intent: json['intent'] as String,
      note: json['note'] as String?,
      code: json['code'] as String?,
      status: json['status'] as String,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$SellerWalletHistoryTransactionToJson(
        SellerWalletHistoryTransaction instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'created_at': instance.createdAt.toIso8601String(),
      'intent': instance.intent,
      'note': instance.note,
      'code': instance.code,
      'status': instance.status,
      'amount': instance.amount,
    };

WalletPayResult _$WalletPayResultFromJson(Map<String, dynamic> json) =>
    WalletPayResult(
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      packageExpiresAt: DateTime.parse(json['package_expires_at'] as String),
    );

Map<String, dynamic> _$WalletPayResultToJson(WalletPayResult instance) =>
    <String, dynamic>{
      'balance': instance.balance,
      'package_expires_at': instance.packageExpiresAt.toIso8601String(),
    };
