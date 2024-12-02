// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      id: json['_id'] as String,
      heading: json['heading'] as String,
      image: json['image'] as String,
      price: (json['price'] as num).toDouble(),
      discount: json['discount'] as int? ?? 0,
      isNew: json['is_new'] as bool? ?? false,
      status: json['status'] as String? ?? 'published',
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      '_id': instance.id,
      'heading': instance.heading,
      'image': instance.image,
      'price': instance.price,
      'discount': instance.discount,
      'is_new': instance.isNew,
      'status': instance.status,
    };

ProductDetail _$ProductDetailFromJson(Map<String, dynamic> json) =>
    ProductDetail(
      id: json['_id'] as String,
      heading: json['heading'] as String,
      status: json['status'] as String? ?? 'published',
      attributes: (json['attributes'] as List<dynamic>)
          .map((e) => ProductAttribute.fromJson(e as Map<String, dynamic>))
          .toList(),
      brand: ProductBrand.fromJson(json['brand'] as Map<String, dynamic>),
      discountDetail: json['discount_data'] == null
          ? null
          : ProductDiscountData.fromJson(
              json['discount_data'] as Map<String, dynamic>),
      brandId: json['brand_id'] as String,
      category:
          ProductCategory.fromJson(json['category'] as Map<String, dynamic>),
      categoryId: json['category_id'] as String,
      discount: json['discount'] as int? ?? 0,
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      moreDetails: json['more_details'] as String,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      seller:
          SellerOrReporterBee.fromJson(json['seller'] as Map<String, dynamic>),
      sellerId: json['seller_id'] as String,
      viewed: json['viewed'] as int? ?? 0,
      likes: json['likes'] as int? ?? 0,
    );

Map<String, dynamic> _$ProductDetailToJson(ProductDetail instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'heading': instance.heading,
      'price': instance.price,
      'discount': instance.discount,
      'images': instance.images,
      'category_id': instance.categoryId,
      'brand_id': instance.brandId,
      'more_details': instance.moreDetails,
      'seller_id': instance.sellerId,
      'attributes': instance.attributes,
      'seller': instance.seller,
      'category': instance.category,
      'brand': instance.brand,
      'viewed': instance.viewed,
      'likes': instance.likes,
      'discount_data': instance.discountDetail,
      'status': instance.status,
    };

ProductDetailForEdit _$ProductDetailForEditFromJson(
        Map<String, dynamic> json) =>
    ProductDetailForEdit(
      id: json['_id'] as String,
      attributes: (json['attrs'] as List<dynamic>)
          .map((e) =>
              ProductAttributeForEdit.fromJson(e as Map<String, dynamic>))
          .toList(),
      brand: ProductBrand.fromJson(json['brand'] as Map<String, dynamic>),
      category:
          ProductCategory.fromJson(json['category'] as Map<String, dynamic>),
      heading: json['heading'] as String,
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      moreDetails: json['more_details'] as String,
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$ProductDetailForEditToJson(
        ProductDetailForEdit instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'heading': instance.heading,
      'category': instance.category,
      'brand': instance.brand,
      'attrs': instance.attributes,
      'price': instance.price,
      'more_details': instance.moreDetails,
      'images': instance.images,
    };

AttributeDetail _$AttributeDetailFromJson(Map<String, dynamic> json) =>
    AttributeDetail(
      isNumber: json['is_number'] as bool,
      name: json['name'] as String,
      unitsArray: (json['units_array'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$AttributeDetailToJson(AttributeDetail instance) =>
    <String, dynamic>{
      'units_array': instance.unitsArray,
      'name': instance.name,
      'is_number': instance.isNumber,
    };

ProductAttributeForEdit _$ProductAttributeForEditFromJson(
        Map<String, dynamic> json) =>
    ProductAttributeForEdit(
      id: json['attr_id'] as String,
      attributeDetail:
          AttributeDetail.fromJson(json['attr_detail'] as Map<String, dynamic>),
      unitIndex: json['unit_index'] as int,
      value: json['value'],
    );

Map<String, dynamic> _$ProductAttributeForEditToJson(
        ProductAttributeForEdit instance) =>
    <String, dynamic>{
      'attr_id': instance.id,
      'value': instance.value,
      'unit_index': instance.unitIndex,
      'attr_detail': instance.attributeDetail,
    };

ProductDiscountData _$ProductDiscountDataFromJson(Map<String, dynamic> json) =>
    ProductDiscountData(
      duration: json['duration'] as int,
      durationType: json['duration_type'] as String,
      percent: (json['percent'] as num?)?.toDouble() ?? 0,
      type: json['type'] as String,
      price: (json['price'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$ProductDiscountDataToJson(
        ProductDiscountData instance) =>
    <String, dynamic>{
      'percent': instance.percent,
      'price': instance.price,
      'duration': instance.duration,
      'duration_type': instance.durationType,
      'type': instance.type,
    };

ProductAttribute _$ProductAttributeFromJson(Map<String, dynamic> json) =>
    ProductAttribute(
      id: json['_id'] as String,
      unit: json['unit'] as String,
      attributeDetail: CategoryAttribute.fromJson(
          json['attribute_detail'] as Map<String, dynamic>),
      value: json['value'],
    );

Map<String, dynamic> _$ProductAttributeToJson(ProductAttribute instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'value': instance.value,
      'unit': instance.unit,
      'attribute_detail': instance.attributeDetail,
    };

ProductFilterAggregations _$ProductFilterAggregationsFromJson(
        Map<String, dynamic> json) =>
    ProductFilterAggregations(
      brands: (json['brands'] as List<dynamic>)
          .map((e) => Brand.fromJson(e as Map<String, dynamic>))
          .toList(),
      categories: (json['categories'] as List<dynamic>)
          .map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList(),
      cities: (json['cities'] as List<dynamic>)
          .map((e) => City.fromJson(e as Map<String, dynamic>))
          .toList(),
      sellers: (json['sellers'] as List<dynamic>)
          .map((e) => Seller.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductFilterAggregationsToJson(
        ProductFilterAggregations instance) =>
    <String, dynamic>{
      'categories': instance.categories,
      'brands': instance.brands,
      'sellers': instance.sellers,
      'cities': instance.cities,
    };
