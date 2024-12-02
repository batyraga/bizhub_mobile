import 'package:json_annotation/json_annotation.dart';

part 'favorite.model.g.dart';

@JsonSerializable()
class UnsavedFavoritePost {
  @JsonKey(name: "post_id")
  final String postId;
  @JsonKey()
  final bool liked;
  const UnsavedFavoritePost({required this.liked, required this.postId});
  factory UnsavedFavoritePost.fromJson(Map<String, dynamic> json) =>
      _$UnsavedFavoritePostFromJson(json);
  Map<String, dynamic> toJson() => _$UnsavedFavoritePostToJson(this);
}

@JsonSerializable()
class UnsavedFavoriteProduct {
  @JsonKey(name: "product_id")
  final String productId;
  @JsonKey()
  final bool liked;
  const UnsavedFavoriteProduct({required this.liked, required this.productId});
  factory UnsavedFavoriteProduct.fromJson(Map<String, dynamic> json) =>
      _$UnsavedFavoriteProductFromJson(json);
  Map<String, dynamic> toJson() => _$UnsavedFavoriteProductToJson(this);
}

@JsonSerializable()
class UnsavedFavoriteSeller {
  @JsonKey(name: "seller_id")
  final String sellerId;
  @JsonKey()
  final bool liked;
  const UnsavedFavoriteSeller({required this.liked, required this.sellerId});
  factory UnsavedFavoriteSeller.fromJson(Map<String, dynamic> json) =>
      _$UnsavedFavoriteSellerFromJson(json);
  Map<String, dynamic> toJson() => _$UnsavedFavoriteSellerToJson(this);
}
