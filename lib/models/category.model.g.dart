// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryAttribute _$CategoryAttributeFromJson(Map<String, dynamic> json) =>
    CategoryAttribute(
      id: json['_id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$CategoryAttributeToJson(CategoryAttribute instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
    };

CategoryAttributeDetail _$CategoryAttributeDetailFromJson(
        Map<String, dynamic> json) =>
    CategoryAttributeDetail(
      id: json['_id'] as String,
      isNumber: json['is_number'] as bool,
      name: json['name'] as String,
      unitsArray: (json['units_array'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$CategoryAttributeDetailToJson(
        CategoryAttributeDetail instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'units_array': instance.unitsArray,
      'is_number': instance.isNumber,
    };

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      id: json['_id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
    };

ParentCategory _$ParentCategoryFromJson(Map<String, dynamic> json) =>
    ParentCategory(
      id: json['_id'] as String,
      image: json['image'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$ParentCategoryToJson(ParentCategory instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'image': instance.image,
    };

ProductCategory _$ProductCategoryFromJson(Map<String, dynamic> json) =>
    ProductCategory(
      id: json['_id'] as String,
      name: json['name'] as String,
      parent: Category.fromJson(json['parent'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProductCategoryToJson(ProductCategory instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'parent': instance.parent,
    };
