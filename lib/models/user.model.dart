import 'package:json_annotation/json_annotation.dart';

part 'user.model.g.dart';

@JsonSerializable()
class User {
  @JsonKey(name: "_id")
  final String id;
  @JsonKey()
  String name;
  @JsonKey()
  String? logo;
  @JsonKey()
  final String phone;
  @JsonKey(name: "seller_id")
  String? sellerId;
  User(
      {required this.id,
      required this.logo,
      required this.name,
      required this.phone,
      required this.sellerId});
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  void setSellerId(String s) {
    sellerId = s;
  }

  void setLogo(String l) {
    logo = l;
  }

  void setName(String n) {
    name = n;
  }
}
