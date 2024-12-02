// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'regions.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Region _$RegionFromJson(Map<String, dynamic> json) => Region(
      name: json['name'] as String,
      id: json['_id'] as int,
    );

Map<String, dynamic> _$RegionToJson(Region instance) => <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
    };
