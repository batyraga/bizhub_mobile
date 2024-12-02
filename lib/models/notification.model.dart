import 'package:json_annotation/json_annotation.dart';

part 'notification.model.g.dart';

@JsonSerializable()
class BizhubNotification {
  @JsonKey()
  final String content;
  @JsonKey(name: "created_at")
  final DateTime createdAt;

  const BizhubNotification({
    required this.content,
    required this.createdAt,
  });

  factory BizhubNotification.fromJson(Map<String, dynamic> json) =>
      _$BizhubNotificationFromJson(json);
  Map<String, dynamic> toJson() => _$BizhubNotificationToJson(this);
}
