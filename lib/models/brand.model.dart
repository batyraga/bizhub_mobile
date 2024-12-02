import 'package:json_annotation/json_annotation.dart';

part 'brand.model.g.dart';

@JsonSerializable()
class ProductBrand {
  @JsonKey(name: "_id")
  final String id;
  @JsonKey()
  final String name;
  @JsonKey()
  final Brand parent;
  const ProductBrand(
      {required this.id, required this.name, required this.parent});
  factory ProductBrand.fromJson(Map<String, dynamic> json) =>
      _$ProductBrandFromJson(json);
  Map<String, dynamic> toJson() => _$ProductBrandToJson(this);
}

@JsonSerializable()
class Brand {
  @JsonKey(name: "_id")
  final String id;
  @JsonKey()
  final String name;
  const Brand({required this.id, required this.name});
  factory Brand.fromJson(Map<String, dynamic> json) => _$BrandFromJson(json);
  Map<String, dynamic> toJson() => _$BrandToJson(this);
}

class FilterBrand {
  final String id;
  final String name;
  const FilterBrand({required this.id, required this.name});
}

class MergedBrand {
  final String id;
  final String parentId;
  final String name;
  const MergedBrand(
      {required this.id, required this.parentId, required this.name});
}

@JsonSerializable()
class ParentBrand {
  @JsonKey(name: "_id")
  final String id;
  @JsonKey()
  final String name;
  @JsonKey()
  final String logo;
  const ParentBrand({required this.id, required this.logo, required this.name});
  factory ParentBrand.fromJson(Map<String, dynamic> json) =>
      _$ParentBrandFromJson(json);
  Map<String, dynamic> toJson() => _$ParentBrandToJson(this);
}
