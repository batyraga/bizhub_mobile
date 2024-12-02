import 'package:json_annotation/json_annotation.dart';

part 'unit.model.g.dart';

@JsonSerializable()
class Unit {
  @JsonKey(name: "_id")
  final String id;
  @JsonKey()
  final String name;
  const Unit({required this.id, required this.name});
  factory Unit.fromJson(Map<String, dynamic> json) => _$UnitFromJson(json);
  Map<String, dynamic> toJson() => _$UnitToJson(this);
}
