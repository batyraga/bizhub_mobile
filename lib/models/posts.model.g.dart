// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posts.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      title: json['title'] as String,
      id: json['_id'] as String,
      seller:
          SellerOrReporterBee.fromJson(json['seller'] as Map<String, dynamic>),
      status: json['status'] as String? ?? 'published',
      image: json['image'] as String,
      viewed: json['viewed'] as int? ?? 0,
      likes: json['likes'] as int? ?? 0,
    );

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'image': instance.image,
      'seller': instance.seller,
      'viewed': instance.viewed,
      'likes': instance.likes,
      'status': instance.status,
    };

RelatedProductForPost _$RelatedProductForPostFromJson(
        Map<String, dynamic> json) =>
    RelatedProductForPost(
      heading: json['heading'] as String,
      id: json['_id'] as String,
      image: json['image'] as String,
    );

Map<String, dynamic> _$RelatedProductForPostToJson(
        RelatedProductForPost instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'heading': instance.heading,
      'image': instance.image,
    };

PostWithoutSeller _$PostWithoutSellerFromJson(Map<String, dynamic> json) =>
    PostWithoutSeller(
      title: json['title'] as String,
      id: json['_id'] as String,
      sellerId: json['seller_id'] as String,
      image: json['image'] as String,
      status: json['status'] as String? ?? 'published',
      viewed: json['viewed'] as int? ?? 0,
      likes: json['likes'] as int? ?? 0,
    );

Map<String, dynamic> _$PostWithoutSellerToJson(PostWithoutSeller instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'image': instance.image,
      'seller_id': instance.sellerId,
      'viewed': instance.viewed,
      'likes': instance.likes,
      'status': instance.status,
    };

PostDetail _$PostDetailFromJson(Map<String, dynamic> json) => PostDetail(
      title: json['title'] as String,
      id: json['_id'] as String,
      status: json['status'] as String? ?? 'published',
      seller:
          SellerOrReporterBee.fromJson(json['seller'] as Map<String, dynamic>),
      sellerId: json['seller_id'] as String,
      image: json['image'] as String,
      body: json['body'] as String,
      relatedProducts: (json['related_products'] as List<dynamic>)
          .map((e) => RelatedProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
      viewed: json['viewed'] as int? ?? 0,
      likes: json['likes'] as int? ?? 0,
    );

Map<String, dynamic> _$PostDetailToJson(PostDetail instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'image': instance.image,
      'seller_id': instance.sellerId,
      'seller': instance.seller,
      'related_products': instance.relatedProducts,
      'viewed': instance.viewed,
      'likes': instance.likes,
      'status': instance.status,
    };

RelatedProduct _$RelatedProductFromJson(Map<String, dynamic> json) =>
    RelatedProduct(
      id: json['_id'] as String,
      image: json['image'] as String,
    );

Map<String, dynamic> _$RelatedProductToJson(RelatedProduct instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'image': instance.image,
    };
