import 'package:bizhub/models/product.model.dart';
import 'package:bizhub/models/sellers.model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'posts.model.g.dart';

@JsonSerializable()
class Post {
  @JsonKey(name: '_id')
  final String id;
  @JsonKey()
  final String title;
  // @JsonKey()
  // final String body;
  @JsonKey()
  final String image;
  // @JsonKey(name: "seller_id")
  // final String sellerId;
  @JsonKey()
  final SellerOrReporterBee seller;
  @JsonKey(defaultValue: 0)
  final int viewed;
  @JsonKey(defaultValue: 0)
  final int likes;
  @JsonKey(defaultValue: "published")
  final String status;

  const Post({
    required this.title,
    required this.id,
    required this.seller,
    required this.status,
    // required this.sellerId,
    required this.image,
    // required this.body,
    required this.viewed,
    this.likes = 0,
  });

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
  Map<String, dynamic> toJson() => _$PostToJson(this);

  bool get isChecking => status == "checking";
  bool get isRejected => status == "rejected";
}

@JsonSerializable()
class RelatedProductForPost {
  @JsonKey(name: "_id")
  final String id;
  @JsonKey()
  final String heading;
  @JsonKey()
  final String image;
  const RelatedProductForPost({
    required this.heading,
    required this.id,
    required this.image,
  });

  factory RelatedProductForPost.fromJson(Map<String, dynamic> json) =>
      _$RelatedProductForPostFromJson(json);
  Map<String, dynamic> toJson() => _$RelatedProductForPostToJson(this);

  Product toProduct() => Product(
      id: id,
      heading: heading,
      image: image,
      price: 0,
      status: ProductStatuses.published);
}

@JsonSerializable()
class PostWithoutSeller {
  @JsonKey(name: '_id')
  final String id;
  @JsonKey()
  final String title;
  @JsonKey()
  // final String body;
  // @JsonKey()
  final String image;
  @JsonKey(name: "seller_id")
  final String sellerId;
  @JsonKey(defaultValue: 0)
  final int viewed;
  @JsonKey(defaultValue: 0)
  final int likes;
  @JsonKey(defaultValue: "published")
  final String status;
  const PostWithoutSeller(
      {required this.title,
      required this.id,
      required this.sellerId,
      required this.image,
      // required this.body,
      required this.status,
      required this.viewed,
      required this.likes});

  factory PostWithoutSeller.fromJson(Map<String, dynamic> json) =>
      _$PostWithoutSellerFromJson(json);
  Map<String, dynamic> toJson() => _$PostWithoutSellerToJson(this);
  Post toPost(SellerOrReporterBee seller) {
    return Post(
        title: title,
        id: id,
        seller: seller,
        // seller: SellerOrReporterBee.fromSeller(seller),
        // sellerId: sellerId,
        status: status,
        image: image,
        // body: body,
        viewed: viewed,
        likes: likes);
  }
}

@JsonSerializable()
class PostDetail {
  @JsonKey(name: "_id")
  final String id;
  @JsonKey()
  final String title;
  @JsonKey()
  final String body;
  @JsonKey()
  final String image;
  @JsonKey(name: "seller_id")
  final String sellerId;
  @JsonKey()
  final SellerOrReporterBee seller;
  @JsonKey(name: "related_products")
  final List<RelatedProduct> relatedProducts;
  @JsonKey(defaultValue: 0)
  final int viewed;
  @JsonKey(defaultValue: 0)
  final int likes;
  @JsonKey(defaultValue: "published")
  final String status;
  const PostDetail(
      {required this.title,
      required this.id,
      required this.status,
      required this.seller,
      required this.sellerId,
      required this.image,
      required this.body,
      required this.relatedProducts,
      required this.viewed,
      required this.likes});
  factory PostDetail.fromJson(Map<String, dynamic> json) =>
      _$PostDetailFromJson(json);
  Map<String, dynamic> toJson() => _$PostDetailToJson(this);

  bool get isChecking => status == "checking";
  bool get isRejected => status == "rejected";
}

@JsonSerializable()
class RelatedProduct {
  @JsonKey(name: "_id")
  final String id;
  @JsonKey()
  final String image;

  const RelatedProduct({required this.id, required this.image});
  factory RelatedProduct.fromJson(Map<String, dynamic> json) =>
      _$RelatedProductFromJson(json);
  Map<String, dynamic> toJson() => _$RelatedProductToJson(this);
}
