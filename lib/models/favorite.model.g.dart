// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnsavedFavoritePost _$UnsavedFavoritePostFromJson(Map<String, dynamic> json) =>
    UnsavedFavoritePost(
      liked: json['liked'] as bool,
      postId: json['post_id'] as String,
    );

Map<String, dynamic> _$UnsavedFavoritePostToJson(
        UnsavedFavoritePost instance) =>
    <String, dynamic>{
      'post_id': instance.postId,
      'liked': instance.liked,
    };

UnsavedFavoriteProduct _$UnsavedFavoriteProductFromJson(
        Map<String, dynamic> json) =>
    UnsavedFavoriteProduct(
      liked: json['liked'] as bool,
      productId: json['product_id'] as String,
    );

Map<String, dynamic> _$UnsavedFavoriteProductToJson(
        UnsavedFavoriteProduct instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'liked': instance.liked,
    };

UnsavedFavoriteSeller _$UnsavedFavoriteSellerFromJson(
        Map<String, dynamic> json) =>
    UnsavedFavoriteSeller(
      liked: json['liked'] as bool,
      sellerId: json['seller_id'] as String,
    );

Map<String, dynamic> _$UnsavedFavoriteSellerToJson(
        UnsavedFavoriteSeller instance) =>
    <String, dynamic>{
      'seller_id': instance.sellerId,
      'liked': instance.liked,
    };
