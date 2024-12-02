import 'package:bizhub/models/city.model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sellers.model.g.dart';

@JsonSerializable()
class Seller {
  @JsonKey(name: "_id")
  final String id;
  @JsonKey()
  final String name;
  @JsonKey()
  final String logo;
  @JsonKey(defaultValue: "regular")
  final String type;
  @JsonKey()
  final City city;

  const Seller(
      {required this.name,
      required this.logo,
      required this.id,
      required this.city,
      required this.type});
  factory Seller.fromJson(Map<String, dynamic> json) => _$SellerFromJson(json);
  Map<String, dynamic> toJson() => _$SellerToJson(this);
}

@JsonSerializable()
class TopSeller {
  @JsonKey(name: "_id")
  final String id;
  @JsonKey()
  final String logo;

  const TopSeller({
    required this.logo,
    required this.id,
  });
  factory TopSeller.fromJson(Map<String, dynamic> json) =>
      _$TopSellerFromJson(json);
  Map<String, dynamic> toJson() => _$TopSellerToJson(this);
}

@JsonSerializable()
class SellerOrReporterBee {
  @JsonKey(name: "_id")
  final String id;
  @JsonKey()
  final String name;
  @JsonKey()
  final String logo;
  @JsonKey(defaultValue: "regular")
  final String type;
  // @JsonKey(name: "city_id", includeIfNull: true)
  // final String? cityId;
  @JsonKey(includeIfNull: true)
  final City? city;

  const SellerOrReporterBee(
      {required this.name,
      // required this.cityId,
      required this.logo,
      required this.id,
      required this.city,
      required this.type});

  bool isReporterBee() {
    return type == "reporterbee";
  }

  factory SellerOrReporterBee.fromJson(Map<String, dynamic> json) =>
      _$SellerOrReporterBeeFromJson(json);
  SellerOrReporterBee.fromSeller(Seller seller)
      : id = seller.id,
        name = seller.name,
        city = seller.city,
        logo = seller.logo,
        type = seller.type;
  Map<String, dynamic> toJson() => _$SellerOrReporterBeeToJson(this);
}

@JsonSerializable()
class SellersFilterAggregations {
  @JsonKey()
  final List<City> cities;
  const SellersFilterAggregations({required this.cities});

  factory SellersFilterAggregations.fromJson(Map<String, dynamic> json) =>
      _$SellersFilterAggregationsFromJson(json);
  Map<String, dynamic> toJson() => _$SellersFilterAggregationsToJson(this);
}

@JsonSerializable()
class SellerDetail {
  @JsonKey(name: "_id")
  final String id;
  @JsonKey()
  final String name;
  @JsonKey()
  final String logo;
  @JsonKey()
  final String type;
  @JsonKey(name: "city_id")
  final String cityId;
  @JsonKey()
  final City city;
  @JsonKey()
  final String address;
  @JsonKey()
  final String bio;
  @JsonKey()
  final int likes;
  @JsonKey()
  final String status;
  const SellerDetail({
    required this.address,
    required this.bio,
    required this.status,
    required this.city,
    required this.cityId,
    required this.likes,
    required this.id,
    required this.logo,
    required this.name,
    required this.type,
  });
  factory SellerDetail.fromJson(Map<String, dynamic> json) =>
      _$SellerDetailFromJson(json);
  Map<String, dynamic> toJson() => _$SellerDetailToJson(this);
  Seller reduce() =>
      Seller(name: name, logo: logo, id: id, city: city, type: type);
}

class FilterSeller {
  final String id;
  final String name;
  const FilterSeller({required this.id, required this.name});
}

@JsonSerializable()
class SellerWallet {
  @JsonKey(defaultValue: 0.0)
  final double balance;

  @JsonKey(includeIfNull: null)
  final SellerWalletPackage? package;
  @JsonKey(name: "in_auction")
  final List<SellerWalletInAuction> inAuction;

  const SellerWallet(
      {required this.balance, required this.inAuction, required this.package});

  factory SellerWallet.fromJson(Map<String, dynamic> json) =>
      _$SellerWalletFromJson(json);
  Map<String, dynamic> toJson() => _$SellerWalletToJson(this);
}

@JsonSerializable()
class SellerWalletPackage {
  @JsonKey()
  final String type;
  @JsonKey(name: "expires_at")
  DateTime expiresAt;
  @JsonKey()
  final String name;
  @JsonKey(name: "max_products", includeIfNull: true)
  final int? maxProducts;
  @JsonKey()
  final double price;

  SellerWalletPackage(
      {required this.maxProducts,
      required this.name,
      required this.price,
      required this.expiresAt,
      required this.type});

  factory SellerWalletPackage.fromJson(Map<String, dynamic> json) =>
      _$SellerWalletPackageFromJson(json);
  Map<String, dynamic> toJson() => _$SellerWalletPackageToJson(this);
}

@JsonSerializable()
class SellerPackageDetail {
  @JsonKey(name: "_id")
  final String id;
  @JsonKey()
  final String type;
  @JsonKey()
  final String name;
  @JsonKey(name: "max_products", includeIfNull: true)
  final int? maxProducts;
  @JsonKey()
  final double price;

  const SellerPackageDetail(
      {required this.maxProducts,
      required this.name,
      required this.price,
      required this.id,
      required this.type});

  factory SellerPackageDetail.fromJson(Map<String, dynamic> json) =>
      _$SellerPackageDetailFromJson(json);
  Map<String, dynamic> toJson() => _$SellerPackageDetailToJson(this);
}

@JsonSerializable()
class SellerWalletInAuction {
  @JsonKey(name: "auction_id")
  final String auctionId;
  @JsonKey()
  final double amount;
  @JsonKey()
  final String name;
  const SellerWalletInAuction(
      {required this.amount, required this.auctionId, required this.name});

  factory SellerWalletInAuction.fromJson(Map<String, dynamic> json) =>
      _$SellerWalletInAuctionFromJson(json);
  Map<String, dynamic> toJson() => _$SellerWalletInAuctionToJson(this);
}

@JsonSerializable()
class SellerPackage {
  @JsonKey(name: "_id")
  final String id;
  @JsonKey()
  final String name;
  @JsonKey()
  final String type;
  @JsonKey()
  final String color;
  @JsonKey(name: "text_color")
  final String textColor;
  @JsonKey()
  final double price;
  @JsonKey(name: "max_products")
  final int maxProducts;

  const SellerPackage({
    required this.id,
    required this.color,
    required this.maxProducts,
    required this.name,
    required this.price,
    required this.textColor,
    required this.type,
  });

  factory SellerPackage.fromJson(Map<String, dynamic> json) =>
      _$SellerPackageFromJson(json);
  Map<String, dynamic> toJson() => _$SellerPackageToJson(this);
}

@JsonSerializable()
class SellerWalletHistoryTransaction {
  @JsonKey(name: "_id")
  final String id;

  @JsonKey(name: "created_at")
  final DateTime createdAt;

  @JsonKey()
  final String intent;

  @JsonKey(includeIfNull: true)
  final String? note;

  @JsonKey(includeIfNull: true)
  final String? code;

  @JsonKey()
  final String status;

  @JsonKey(defaultValue: 0.0)
  final double amount;

  const SellerWalletHistoryTransaction(
      {required this.createdAt,
      required this.id,
      required this.intent,
      required this.note,
      required this.code,
      required this.status,
      required this.amount});

  factory SellerWalletHistoryTransaction.fromJson(Map<String, dynamic> json) =>
      _$SellerWalletHistoryTransactionFromJson(json);
  Map<String, dynamic> toJson() => _$SellerWalletHistoryTransactionToJson(this);
}

@JsonSerializable()
class WalletPayResult {
  @JsonKey(defaultValue: 0.0)
  final double balance;
  @JsonKey(name: "package_expires_at")
  final DateTime packageExpiresAt;
  const WalletPayResult({
    required this.balance,
    required this.packageExpiresAt,
  });

  factory WalletPayResult.fromJson(Map<String, dynamic> json) =>
      _$WalletPayResultFromJson(json);
  Map<String, dynamic> toJson() => _$WalletPayResultToJson(this);
}
