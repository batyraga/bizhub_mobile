import 'package:bizhub/models/brand.model.dart';
import 'package:bizhub/models/city.model.dart';
import 'package:bizhub/models/sellers.model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:bizhub/models/category.model.dart';
part 'product.model.g.dart';

@JsonSerializable()
class Product {
  @JsonKey(name: "_id")
  final String id;
  @JsonKey()
  final String heading;
  @JsonKey()
  final String image;
  @JsonKey()
  final double price;
  @JsonKey(defaultValue: 0)
  final int discount;
  @JsonKey(defaultValue: false, name: "is_new")
  final bool isNew;
  @JsonKey(defaultValue: "published")
  final String status;
  const Product(
      {required this.id,
      required this.heading,
      required this.image,
      required this.price,
      this.discount = 0,
      this.isNew = false,
      this.status = "published"});
  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);

  bool get isChecking => status == "checking";
  bool get isRejected => status == "rejected";
  // Product.fromJson(Map<String, dynamic> map)
  //     : id = map["_id"],
  //       heading = map["heading"],
  //       image = map["image"],
  //       price = map["price"],
  //       discount = map["discount"],
  //       isNew = map["is_new"];
}

@JsonSerializable()
class ProductDetail {
  @JsonKey(name: "_id")
  final String id;
  @JsonKey()
  final String heading;
  @JsonKey(defaultValue: 0.0)
  final double price;
  @JsonKey(defaultValue: 0)
  final int discount;
  @JsonKey()
  final List<String> images;
  @JsonKey(name: "category_id")
  final String categoryId;
  @JsonKey(name: "brand_id")
  final String brandId;
  @JsonKey(name: "more_details")
  final String moreDetails;
  @JsonKey(name: "seller_id")
  final String sellerId;
  @JsonKey()
  final List<ProductAttribute> attributes;
  @JsonKey()
  final SellerOrReporterBee seller;
  @JsonKey()
  final ProductCategory category;
  @JsonKey()
  final ProductBrand brand;
  @JsonKey(defaultValue: 0)
  final int viewed;
  @JsonKey(defaultValue: 0)
  final int likes;
  @JsonKey(name: "discount_data", includeIfNull: true)
  final ProductDiscountData? discountDetail;
  @JsonKey(defaultValue: "published")
  final String status;

  const ProductDetail(
      {required this.id,
      required this.heading,
      required this.status,
      required this.attributes,
      required this.brand,
      required this.discountDetail,
      required this.brandId,
      required this.category,
      required this.categoryId,
      required this.discount,
      required this.images,
      required this.moreDetails,
      required this.price,
      required this.seller,
      required this.sellerId,
      required this.viewed,
      required this.likes});
  factory ProductDetail.fromJson(Map<String, dynamic> json) =>
      _$ProductDetailFromJson(json);
  Map<String, dynamic> toJson() => _$ProductDetailToJson(this);
  Product reduce() =>
      Product(id: id, heading: heading, image: images[0], price: price);

  bool get isChecking => status == "checking";
  bool get isRejected => status == "rejected";
}

@JsonSerializable()
class ProductDetailForEdit {
  @JsonKey(name: "_id")
  final String id;
  @JsonKey()
  final String heading;
  @JsonKey()
  final ProductCategory category;
  @JsonKey()
  final ProductBrand brand;
  @JsonKey(name: "attrs")
  final List<ProductAttributeForEdit> attributes;
  @JsonKey()
  final double price;
  @JsonKey(name: "more_details")
  final String moreDetails;
  @JsonKey()
  final List<String> images;

  const ProductDetailForEdit({
    required this.id,
    required this.attributes,
    required this.brand,
    required this.category,
    required this.heading,
    required this.images,
    required this.moreDetails,
    required this.price,
  });

  factory ProductDetailForEdit.fromJson(Map<String, dynamic> json) =>
      _$ProductDetailForEditFromJson(json);
  Map<String, dynamic> toJson() => _$ProductDetailForEditToJson(this);
}

@JsonSerializable()
class AttributeDetail {
  @JsonKey(name: "units_array")
  final List<String> unitsArray;
  @JsonKey()
  final String name;
  @JsonKey(name: "is_number")
  final bool isNumber;

  const AttributeDetail({
    required this.isNumber,
    required this.name,
    required this.unitsArray,
  });

  factory AttributeDetail.fromJson(Map<String, dynamic> json) =>
      _$AttributeDetailFromJson(json);
  Map<String, dynamic> toJson() => _$AttributeDetailToJson(this);
}

@JsonSerializable()
class ProductAttributeForEdit {
  @JsonKey(name: "attr_id")
  final String id;
  @JsonKey()
  final dynamic value;
  @JsonKey(name: "unit_index")
  final int unitIndex;
  @JsonKey(name: "attr_detail")
  final AttributeDetail attributeDetail;

  const ProductAttributeForEdit({
    required this.id,
    required this.attributeDetail,
    required this.unitIndex,
    required this.value,
  });

  factory ProductAttributeForEdit.fromJson(Map<String, dynamic> json) =>
      _$ProductAttributeForEditFromJson(json);
  Map<String, dynamic> toJson() => _$ProductAttributeForEditToJson(this);
}

@JsonSerializable()
class ProductDiscountData {
  @JsonKey(defaultValue: 0)
  final double percent;
  @JsonKey(defaultValue: 0)
  final double price;
  @JsonKey()
  final int duration;
  @JsonKey(name: "duration_type")
  final String durationType;
  @JsonKey()
  final String type;

  const ProductDiscountData(
      {required this.duration,
      required this.durationType,
      required this.percent,
      required this.type,
      required this.price});

  factory ProductDiscountData.fromJson(Map<String, dynamic> json) =>
      _$ProductDiscountDataFromJson(json);
  Map<String, dynamic> toJson() => _$ProductDiscountDataToJson(this);
}

@JsonSerializable()
class ProductAttribute {
  @JsonKey(name: "_id")
  final String id;
  @JsonKey()
  final dynamic value;
  @JsonKey()
  final String unit;
  // @JsonKey(name: "is_visible")
  // final bool isVisible;
  @JsonKey(name: "attribute_detail")
  final CategoryAttribute attributeDetail;

  const ProductAttribute(
      {required this.id,
      required this.unit,
      required this.attributeDetail,
      required this.value});
  factory ProductAttribute.fromJson(Map<String, dynamic> json) =>
      _$ProductAttributeFromJson(json);
  Map<String, dynamic> toJson() => _$ProductAttributeToJson(this);
}

@JsonSerializable()
class ProductFilterAggregations {
  @JsonKey()
  final List<Category> categories;
  @JsonKey()
  final List<Brand> brands;
  @JsonKey()
  final List<Seller> sellers;
  @JsonKey()
  final List<City> cities;

  const ProductFilterAggregations({
    required this.brands,
    required this.categories,
    required this.cities,
    required this.sellers,
  });

  factory ProductFilterAggregations.fromJson(Map<String, dynamic> json) =>
      _$ProductFilterAggregationsFromJson(json);
  Map<String, dynamic> toJson() => _$ProductFilterAggregationsToJson(this);
}

abstract class ProductStatuses {
  static const String published = "published";
  static const String checking = "checking";
  static const String rejected = "rejected";
}
