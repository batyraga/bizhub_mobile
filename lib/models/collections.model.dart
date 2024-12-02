import 'package:json_annotation/json_annotation.dart';

part 'collections.model.g.dart';

@JsonSerializable()
class Collection {
  @JsonKey(name: "_id")
  final String id;
  @JsonKey()
  final String name;
  @JsonKey()
  final String path;

  const Collection({required this.id, required this.path, required this.name});

  factory Collection.fromJson(Map<String, dynamic> json) =>
      _$CollectionFromJson(json);
  Map<String, dynamic> toJson() => _$CollectionToJson(this);

  // Collection.fromJson(Map<String, dynamic> map)
  //     : id = map["_id"],
  //       name = map["name"];
}
