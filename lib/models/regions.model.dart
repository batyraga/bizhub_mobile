import 'package:json_annotation/json_annotation.dart';

part 'regions.model.g.dart';

@JsonSerializable()
class Region {
  @JsonKey(name: "_id")
  final int id;
  @JsonKey()
  final String name;
  const Region({required this.name, required this.id});
  factory Region.fromJson(Map<String, dynamic> json) => _$RegionFromJson(json);
  Map<String, dynamic> toJson() => _$RegionToJson(this);
}

const dummyRegions = <int, Region>{
  1: Region(name: "Ashgabat", id: 1),
  2: Region(name: "Mary", id: 2),
  3: Region(name: "Lebap", id: 3),
  4: Region(name: "Ahal", id: 4),
  5: Region(name: "Dashoguz", id: 5),
};
