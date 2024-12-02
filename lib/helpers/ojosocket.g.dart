// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ojosocket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OjoSocketEvent _$OjoSocketEventFromJson(Map<String, dynamic> json) =>
    OjoSocketEvent(
      json['event'] as String,
      json['payload'] as List<dynamic>? ?? const [],
    );

Map<String, dynamic> _$OjoSocketEventToJson(OjoSocketEvent instance) =>
    <String, dynamic>{
      'event': instance.event,
      'payload': instance.payload,
    };
