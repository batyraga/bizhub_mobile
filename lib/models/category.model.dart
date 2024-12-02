import 'package:bizhub/models/unit.model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category.model.g.dart';

@JsonSerializable()
class CategoryAttribute {
  @JsonKey(name: "_id")
  final String id;
  @JsonKey()
  final String name;
  const CategoryAttribute({
    required this.id,
    required this.name,
  });
  factory CategoryAttribute.fromJson(Map<String, dynamic> json) =>
      _$CategoryAttributeFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryAttributeToJson(this);
}

@JsonSerializable()
class CategoryAttributeDetail {
  @JsonKey(name: "_id")
  final String id;
  @JsonKey()
  final String name;
  @JsonKey(name: "units_array")
  final List<String> unitsArray;
  @JsonKey(name: "is_number")
  final bool isNumber;

  const CategoryAttributeDetail({
    required this.id,
    required this.isNumber,
    required this.name,
    required this.unitsArray,
  });

  factory CategoryAttributeDetail.fromJson(Map<String, dynamic> json) =>
      _$CategoryAttributeDetailFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryAttributeDetailToJson(this);
}

@JsonSerializable()
class Category {
  @JsonKey(name: "_id")
  final String id;
  @JsonKey()
  final String name;
  const Category({required this.id, required this.name});
  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}

@JsonSerializable()
class ParentCategory {
  @JsonKey(name: "_id")
  final String id;
  @JsonKey()
  final String name;
  @JsonKey()
  final String image;
  const ParentCategory(
      {required this.id, required this.image, required this.name});
  factory ParentCategory.fromJson(Map<String, dynamic> json) =>
      _$ParentCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$ParentCategoryToJson(this);
}

@JsonSerializable()
class ProductCategory {
  @JsonKey(name: "_id")
  final String id;
  @JsonKey()
  final String name;
  @JsonKey()
  final Category parent;

  const ProductCategory(
      {required this.id, required this.name, required this.parent});
  factory ProductCategory.fromJson(Map<String, dynamic> json) =>
      _$ProductCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$ProductCategoryToJson(this);
}

class FilterCategory {
  final String id;
  final String name;
  const FilterCategory({required this.id, required this.name});
}

class MergedCategory {
  final String id;
  final String parentId;
  final String name;
  const MergedCategory(
      {required this.id, required this.parentId, required this.name});
}
