import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

part 'ojosocket.g.dart';

typedef OjoSocketListener = Function([List<dynamic>? data]);

@JsonSerializable()
class OjoSocketEvent {
  @JsonKey(name: "event")
  final String event;
  @JsonKey(name: "payload")
  final List<dynamic> payload;

  const OjoSocketEvent(this.event, [this.payload = const []]);

  factory OjoSocketEvent.fromJson(Map<String, dynamic> json) =>
      _$OjoSocketEventFromJson(json);
  Map<String, dynamic> toJson() => _$OjoSocketEventToJson(this);
}

class OjoSocketGlobalEvents {
  static const error = "error";
  static const message = "message";
  static const connect = "connect";
  static const disconnect = "disconnect";
  static const reconnecting = "reconnecting";
}

class OjoSocket {
  final String url;
  final Map<String, dynamic>? headers;
  Map<String, List<OjoSocketListener>> listeners = {};
  Map<String, List<List<dynamic>>> pendingEvents = {};
  IOWebSocketChannel? ws;

  OjoSocket(
    this.url, {
    this.headers,
  });

  connect() {
    if (ws == null) {
      ws = IOWebSocketChannel.connect(url, headers: headers);
      ws!.stream.listen(_onData,
          cancelOnError: true, onDone: _onDone, onError: _onError);
      _emitToListeners(const OjoSocketEvent(OjoSocketGlobalEvents.connect));
      log("[OjoSocket] - connected");
    }
  }

  reconnect() {
    if (ws != null) {
      disconnect();
      connect();
    }
  }

  disconnect() {
    if (ws != null) {
      ws!.sink.close(status.normalClosure);
      ws = null;
      pendingEvents = {};
      log("[OjoSocket] - disconnected");
    }
  }

  on(String event, OjoSocketListener l) {
    if (listeners.containsKey(event)) {
      listeners[event]!.add(l);
    } else {
      listeners[event] = [l];
    }

    if (pendingEvents.containsKey(event)) {
      for (var value in pendingEvents[event]!) {
        _emitToListeners(OjoSocketEvent(event, value));
      }
      pendingEvents.remove(event);
    }
  }

  once(String event, OjoSocketListener l) {
    dynamic runAndDestroy([List<dynamic>? payload]) {
      l(payload);
      off(event, runAndDestroy);
    }

    on(event, runAndDestroy);
  }

  off(String event, OjoSocketListener l) {
    if (listeners.containsKey(event)) {
      listeners[event]!.remove(l);
    }
  }

  emit(String event, [List payload = const []]) {
    log("[ws] - event: $event | payload: $payload | wsAlive: ${ws != null}");
    if (ws != null) {
      ws!.sink.add(jsonEncode({
        'event': event,
        'payload': payload,
      }));
    }
  }

  _emitToListeners(OjoSocketEvent event) {
    if (listeners.containsKey(event.event)) {
      for (var l in listeners[event.event]!) {
        if (event.payload.isEmpty) {
          l();
        } else {
          l(event.payload);
        }
      }
    } else {
      if (pendingEvents.containsKey(event.event)) {
        pendingEvents[event.event]!.add(event.payload);
      } else {
        pendingEvents[event.event] = [event.payload];
      }
    }
  }

  _onData(dynamic data) {
    log("[OjoSocket] - message - $data");

    if (data is String) {
      final decoded = jsonDecode(data);
      final event = OjoSocketEvent.fromJson(decoded);

      _emitToListeners(event);

      // final
    }
  }

  _onDone() {
    log("[OjoSocket] - done!");

    ws = null;

    _emitToListeners(const OjoSocketEvent(OjoSocketGlobalEvents.disconnect));
  }

  _onError(Object error) {
    log("[OjoSocket] - error - $error");

    _emitToListeners(OjoSocketEvent(OjoSocketGlobalEvents.error, [error]));
  }
}
