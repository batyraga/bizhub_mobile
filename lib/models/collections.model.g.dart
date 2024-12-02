// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collections.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Collection _$CollectionFromJson(Map<String, dynamic> json) => Collection(
      id: json['_id'] as String,
      path: json['path'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$CollectionToJson(Collection instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'path': instance.path,
    };
