import 'package:json_annotation/json_annotation.dart';

part 'city.model.g.dart';

@JsonSerializable()
class City {
  @JsonKey(name: "_id")
  final String id;
  @JsonKey()
  final String name;
  const City({required this.id, required this.name});

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);
  Map<String, dynamic> toJson() => _$CityToJson(this);
  // City.fromJson(Map<String, dynamic> map)
  //     : id = map["_id"],
  //       name = map["name"];
}

class FilterCity {
  final String id;
  final String name;
  const FilterCity({required this.id, required this.name});
}
