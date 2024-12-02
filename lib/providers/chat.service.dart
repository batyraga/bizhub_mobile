import 'dart:developer';

import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/api.dart';
import 'package:bizhub/models/chat.model.dart';
import 'package:bizhub/models/product.model.dart';
import 'package:bizhub/providers/auth.provider.dart';
import 'package:bizhub/providers/storage.provider.dart';
import 'package:flutter/material.dart';
import 'package:bizhub/helpers/ojosocket.dart';

class ChatRoomListenerGroup {
  Function(ChatMessage?)? onMessage;
  Function(String?)? onDeleteMessage;
  Function(LastChatRoomMessage?)? onChangeLastMessage;

  ChatRoomListenerGroup({
    this.onDeleteMessage,
    this.onMessage,
    this.onChangeLastMessage,
  });

  void setChangeLastMessageListener(Function(LastChatRoomMessage?)? f) {
    onChangeLastMessage = f;
  }

  void setMessageListener(Function(ChatMessage?)? f) {
    onMessage = f;
  }

  void setDeleteMessageListener(Function(String?)? f) {
    onDeleteMessage = f;
  }
}

class ChatService with ChangeNotifier {
  OjoSocket? ws;

  Map<String, ChatRoomListenerGroup> listeners = {};
  Function()? onNewRoomCreate;
  Function(String)? onDeleteRoomListener;

  ChatService initState(Auth auth) {
    if (auth.isAuthenticated) {
      listeners = {};
      onNewRoomCreate = null;
      disconnect();
      connect();
    }
    return this;
  }

  setNewRoomCreateListener(Function()? l) {
    onNewRoomCreate = l;
  }

  setDeleteRoomListener(Function(String)? l) {
    onDeleteRoomListener = l;
  }

  set<T>(String roomId, String type, Function(T?)? d) {
    if (!listeners.containsKey(roomId)) {
      listeners[roomId] = ChatRoomListenerGroup();
    }

    if (type == "message") {
      listeners[roomId]!.setMessageListener(d as Function(ChatMessage?)?);
    } else if (type == "delete-message") {
      listeners[roomId]!.setDeleteMessageListener(d as Function(String?)?);
    } else if (type == "change-last-message") {
      listeners[roomId]!
          .setChangeLastMessageListener(d as Function(LastChatRoomMessage?)?);
    }
  }

  deleteMessage(String roomId, String messageId) {
    if (ws == null) {
      return;
    }

    ws!.emit("delete-message", [
      {
        "room": roomId,
        "message_id": messageId,
      }
    ]);
  }

  deleteRoom(String roomId) {
    if (ws == null) {
      return;
    }

    ws!.emit("delete-room", [roomId]);
  }

  sendMessage(String roomId, String text, [ChatMessageCommentOf? commentOf]) {
    if (ws == null) {
      return;
    }

    log("hazir chat message ugrayar..");

    Map<String, dynamic>? commentOfJSON;
    if (commentOf != null) {
      commentOfJSON = commentOf.toJson();
    }

    ws!.emit("send-message", [
      <String, dynamic>{
        "type": "text",
        "content": {
          "text": text,
        },
        "room": roomId,
        "comment_of": commentOfJSON,
      }
    ]);
  }

  sendImage(
    String roomId,
    String imagePath,
  ) {
    if (ws == null) {
      return;
    }

    log("hazir chat image ugrayar..");

    ws!.emit("send-message", [
      <String, dynamic>{
        "type": "image",
        "content": {
          "image_path": imagePath,
        },
        "room": roomId,
      }
    ]);
  }

  sendProduct(
    String sellerId,
    Product product,
    String text,
  ) {
    if (ws == null) {
      return;
    }

    log("hazir chat product ugrayar..");

    ws!.emit("send-message", [
      <String, dynamic>{
        "type": "product",
        "content": {
          "product": {
            "_id": product.id,
            "text": text,
            "detail": product.toJson(),
          },
        },
      },
      sellerId,
      "seller"
    ]);
  }

  off(String roomId) {
    listeners.remove(roomId);
  }

  onChangeLastMessage([List<dynamic>? data]) {
    if (data?[0] is Map && data?[1] is String) {
      final last =
          LastChatRoomMessage.fromJson(data![0] as Map<String, dynamic>);
      final room = data[1] as String;
      if (listeners.containsKey(room)) {
        listeners[room]!.onChangeLastMessage?.call(last);
      }
    }
  }

  onMessage([List<dynamic>? data]) {
    if (data?[0] is Map) {
      final message = ChatMessage.fromJson(data![0] as Map<String, dynamic>);
      if (listeners.containsKey(message.room)) {
        listeners[message.room]!.onMessage?.call(message);
      }
    }
  }

  onDeleteMessage([List<dynamic>? data]) {
    if (data?[0] is String && data?[1] is String) {
      final roomId = data![0] as String;
      final messageId = data[1] as String;
      if (listeners.containsKey(roomId)) {
        listeners[roomId]!.onDeleteMessage?.call(messageId);
      }
    }
  }

  onNewRoom([List<dynamic>? data]) {
    if (data?[0] == true) {
      onNewRoomCreate?.call();
    }
  }

  onDeleteRoom([List<dynamic>? data]) {
    if (data?[0] is String) {
      onDeleteRoomListener?.call(data![0] as String);
    }
  }

  Future<bool> connect() async {
    try {
      final String? accessToken = storage.read("access_token");
      log("[chatService] - accessToken - $accessToken");
      if (accessToken == null) {
        return false;
      }
      ws = OjoSocket("$wsUrl/api/v1/chat/realtime");
      ws!.on("new-room", onNewRoom);
      ws!.on("last-message", onChangeLastMessage);
      ws!.on("message", onMessage);
      ws!.on("delete-message", onDeleteMessage);
      ws!.on("delete-room", onDeleteRoom);
      ws!.connect();

      ws!.emit("secret", [accessToken]);
      notifyListeners();
      return true;
    } catch (err) {
      log("[ChatService - connect] - error - $err");
    }

    return false;
  }

  Future<bool> reconnect() async {
    if (ws != null) {
      ws!.reconnect();
    } else {
      return await connect();
    }

    return true;
  }

  Future<bool> disconnect() async {
    if (ws != null) {
      ws!.disconnect();
      ws = null;
      notifyListeners();
    }

    return true;
  }
}
