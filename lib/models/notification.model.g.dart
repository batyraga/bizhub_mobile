// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BizhubNotification _$BizhubNotificationFromJson(Map<String, dynamic> json) =>
    BizhubNotification(
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$BizhubNotificationToJson(BizhubNotification instance) =>
    <String, dynamic>{
      'content': instance.content,
      'created_at': instance.createdAt.toIso8601String(),
    };
