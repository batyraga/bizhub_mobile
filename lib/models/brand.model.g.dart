// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductBrand _$ProductBrandFromJson(Map<String, dynamic> json) => ProductBrand(
      id: json['_id'] as String,
      name: json['name'] as String,
      parent: Brand.fromJson(json['parent'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProductBrandToJson(ProductBrand instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'parent': instance.parent,
    };

Brand _$BrandFromJson(Map<String, dynamic> json) => Brand(
      id: json['_id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$BrandToJson(Brand instance) => <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
    };

ParentBrand _$ParentBrandFromJson(Map<String, dynamic> json) => ParentBrand(
      id: json['_id'] as String,
      logo: json['logo'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$ParentBrandToJson(ParentBrand instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'logo': instance.logo,
    };
