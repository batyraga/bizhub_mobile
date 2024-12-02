import 'package:bizhub/models/product.model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat.model.g.dart';

@JsonSerializable()
class ChatMessageContentProduct {
  @JsonKey(name: "_id")
  final String id;
  @JsonKey()
  final String text;
  @JsonKey(name: "detail", includeIfNull: true)
  final Product? detail;
  const ChatMessageContentProduct({
    required this.id,
    required this.text,
    this.detail,
  });

  factory ChatMessageContentProduct.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageContentProductFromJson(json);
  Map<String, dynamic> toJson() => _$ChatMessageContentProductToJson(this);
}

@JsonSerializable()
class ChatMessageContentProductCommentOf {
  @JsonKey(name: "_id")
  final String id;
  @JsonKey()
  final String text;
  const ChatMessageContentProductCommentOf({
    required this.id,
    required this.text,
  });

  factory ChatMessageContentProductCommentOf.fromJson(
          Map<String, dynamic> json) =>
      _$ChatMessageContentProductCommentOfFromJson(json);
  Map<String, dynamic> toJson() =>
      _$ChatMessageContentProductCommentOfToJson(this);
}

@JsonSerializable()
class ChatMessageContent {
  @JsonKey(includeIfNull: true)
  final String? text;
  @JsonKey(includeIfNull: true)
  final ChatMessageContentProduct? product;
  @JsonKey(name: "image_path", includeIfNull: true)
  final String? imagePath;
  const ChatMessageContent({
    this.imagePath,
    this.product,
    this.text,
  });

  factory ChatMessageContent.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageContentFromJson(json);
  Map<String, dynamic> toJson() => _$ChatMessageContentToJson(this);
}

@JsonSerializable()
class ChatMessageContentCommentOf {
  @JsonKey(includeIfNull: true)
  final String? text;
  @JsonKey(includeIfNull: true)
  final ChatMessageContentProductCommentOf? product;
  @JsonKey(name: "image_path", includeIfNull: true)
  final String? imagePath;
  const ChatMessageContentCommentOf({
    this.imagePath,
    this.product,
    this.text,
  });

  factory ChatMessageContentCommentOf.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageContentCommentOfFromJson(json);
  Map<String, dynamic> toJson() => _$ChatMessageContentCommentOfToJson(this);
}

@JsonSerializable()
class ChatMessage {
  @JsonKey(name: "_id") // chat message id
  final String id;
  @JsonKey(name: "sender")
  final String sender; // customer id (not seller id)
  @JsonKey(name: "room")
  final String room; // room id
  @JsonKey(name: "comment_of", includeIfNull: true)
  final ChatMessageCommentOf? commentOf;
  @JsonKey(name: "created_at")
  final DateTime createdAt;
  @JsonKey(name: "type")
  final String type;
  @JsonKey(name: "content")
  final ChatMessageContent content;

  const ChatMessage({
    required this.id,
    this.commentOf,
    required this.content,
    required this.createdAt,
    required this.room,
    required this.sender,
    required this.type,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);
  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);
}

@JsonSerializable()
class ChatMessageCommentOf {
  @JsonKey(name: "_id") // chat message id
  final String id;
  @JsonKey(name: "type")
  final String type;
  @JsonKey(name: "content")
  final ChatMessageContentCommentOf content;

  const ChatMessageCommentOf({
    required this.id,
    required this.content,
    required this.type,
  });

  factory ChatMessageCommentOf.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageCommentOfFromJson(json);
  Map<String, dynamic> toJson() => _$ChatMessageCommentOfToJson(this);
}

@JsonSerializable()
class LastChatRoomMessage {
  @JsonKey()
  final String text;
  @JsonKey()
  final String type;

  const LastChatRoomMessage({
    required this.text,
    required this.type,
  });

  factory LastChatRoomMessage.fromJson(Map<String, dynamic> json) =>
      _$LastChatRoomMessageFromJson(json);
  Map<String, dynamic> toJson() => _$LastChatRoomMessageToJson(this);
}

@JsonSerializable()
class ChatRoom {
  @JsonKey(name: "_id")
  final String id;
  @JsonKey()
  final String logo;
  @JsonKey()
  final String name;
  @JsonKey(name: "last_message", includeIfNull: true)
  LastChatRoomMessage? lastMessage;

  ChatRoom({
    required this.id,
    required this.logo,
    required this.name,
    this.lastMessage,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomFromJson(json);
  Map<String, dynamic> toJson() => _$ChatRoomToJson(this);
}
