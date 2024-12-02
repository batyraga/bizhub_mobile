// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessageContentProduct _$ChatMessageContentProductFromJson(
        Map<String, dynamic> json) =>
    ChatMessageContentProduct(
      id: json['_id'] as String,
      text: json['text'] as String,
      detail: json['detail'] == null
          ? null
          : Product.fromJson(json['detail'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChatMessageContentProductToJson(
        ChatMessageContentProduct instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'text': instance.text,
      'detail': instance.detail,
    };

ChatMessageContentProductCommentOf _$ChatMessageContentProductCommentOfFromJson(
        Map<String, dynamic> json) =>
    ChatMessageContentProductCommentOf(
      id: json['_id'] as String,
      text: json['text'] as String,
    );

Map<String, dynamic> _$ChatMessageContentProductCommentOfToJson(
        ChatMessageContentProductCommentOf instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'text': instance.text,
    };

ChatMessageContent _$ChatMessageContentFromJson(Map<String, dynamic> json) =>
    ChatMessageContent(
      imagePath: json['image_path'] as String?,
      product: json['product'] == null
          ? null
          : ChatMessageContentProduct.fromJson(
              json['product'] as Map<String, dynamic>),
      text: json['text'] as String?,
    );

Map<String, dynamic> _$ChatMessageContentToJson(ChatMessageContent instance) =>
    <String, dynamic>{
      'text': instance.text,
      'product': instance.product,
      'image_path': instance.imagePath,
    };

ChatMessageContentCommentOf _$ChatMessageContentCommentOfFromJson(
        Map<String, dynamic> json) =>
    ChatMessageContentCommentOf(
      imagePath: json['image_path'] as String?,
      product: json['product'] == null
          ? null
          : ChatMessageContentProductCommentOf.fromJson(
              json['product'] as Map<String, dynamic>),
      text: json['text'] as String?,
    );

Map<String, dynamic> _$ChatMessageContentCommentOfToJson(
        ChatMessageContentCommentOf instance) =>
    <String, dynamic>{
      'text': instance.text,
      'product': instance.product,
      'image_path': instance.imagePath,
    };

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => ChatMessage(
      id: json['_id'] as String,
      commentOf: json['comment_of'] == null
          ? null
          : ChatMessageCommentOf.fromJson(
              json['comment_of'] as Map<String, dynamic>),
      content:
          ChatMessageContent.fromJson(json['content'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['created_at'] as String),
      room: json['room'] as String,
      sender: json['sender'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$ChatMessageToJson(ChatMessage instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'sender': instance.sender,
      'room': instance.room,
      'comment_of': instance.commentOf,
      'created_at': instance.createdAt.toIso8601String(),
      'type': instance.type,
      'content': instance.content,
    };

ChatMessageCommentOf _$ChatMessageCommentOfFromJson(
        Map<String, dynamic> json) =>
    ChatMessageCommentOf(
      id: json['_id'] as String,
      content: ChatMessageContentCommentOf.fromJson(
          json['content'] as Map<String, dynamic>),
      type: json['type'] as String,
    );

Map<String, dynamic> _$ChatMessageCommentOfToJson(
        ChatMessageCommentOf instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'type': instance.type,
      'content': instance.content,
    };

LastChatRoomMessage _$LastChatRoomMessageFromJson(Map<String, dynamic> json) =>
    LastChatRoomMessage(
      text: json['text'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$LastChatRoomMessageToJson(
        LastChatRoomMessage instance) =>
    <String, dynamic>{
      'text': instance.text,
      'type': instance.type,
    };

ChatRoom _$ChatRoomFromJson(Map<String, dynamic> json) => ChatRoom(
      id: json['_id'] as String,
      logo: json['logo'] as String,
      name: json['name'] as String,
      lastMessage: json['last_message'] == null
          ? null
          : LastChatRoomMessage.fromJson(
              json['last_message'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChatRoomToJson(ChatRoom instance) => <String, dynamic>{
      '_id': instance.id,
      'logo': instance.logo,
      'name': instance.name,
      'last_message': instance.lastMessage,
    };
