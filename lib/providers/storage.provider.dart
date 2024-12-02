import 'dart:collection';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class StorageEventType {
  static String get write => "write";
  static String get read => "read";
  static String get remove => "remove";
}

class Storage {
  // Map<String, String> storage = HashMap();
  Map<String, List<Function>> listeners = HashMap();
  SharedPreferences? secureStorage;
  Map<String, String> tempStorage = {};

  void logNow(String eventName, String key, [String? message]) {
    log("[$eventName] - $key${message != null ? " - $message" : ""}");
  }

  Future<void> init() async {
    secureStorage = await SharedPreferences.getInstance();
    log("storage init success!");
    // storage = await secureStorage.();
    // log('storage => $storage');
  }

  String _createListenerKey(String eventType, String key) =>
      '$eventType/*/$key';

  on(String eventType, String key, Function listener) {
    final String listenerKey = _createListenerKey(eventType, key);
    if (listeners.containsKey(listenerKey)) {
      listeners[listenerKey]!.add(listener);
    } else {
      listeners[listenerKey] = [listener];
    }
  }

  Future<bool> write(String key, String value, [bool? temp]) async {
    if (temp == true) {
      tempStorage[key] = value;
      return true;
    }
    if (secureStorage == null) {
      return false;
    }
    // storage[key] = value;
    logNow("write", key, value);
    final bool status = await secureStorage!.setString(key, value);
    // await secureStorage.write(key: key, value: value);

    // for listeners
    if (status == true) {
      final String listenerKey =
          _createListenerKey(StorageEventType.write, key);
      listeners[listenerKey]?.forEach((element) {
        element(value);
      });
      return true;
    }
    return false;
  }

  String? read(String key) {
    final tempContains = tempStorage.containsKey(key);

    if (tempContains == true) {
      final String? tempValue = tempStorage[key];
      return tempValue;
    }

    if (secureStorage == null) {
      return null;
    }

    String? v;
    if (secureStorage!.containsKey(key)) {
      final readValue = secureStorage!.getString(key);
      logNow("read", key, readValue);
      v = readValue;
    }

    // for listeners
    final String listenerKey = _createListenerKey(StorageEventType.read, key);
    listeners[listenerKey]?.forEach((element) {
      element(v);
    });

    return v;
  }

  Future<bool> remove(String key) async {
    final tempContains = tempStorage.containsKey(key);
    if (tempContains == true) {
      tempStorage.remove(key);
      return true;
    }

    if (secureStorage == null) {
      return false;
    }
    if (secureStorage!.containsKey(key)) {
      logNow("remove", key);
      final bool status = await secureStorage!.remove(key);

      if (status == true) {
        storage.remove(key);
        // for listeners
        final String listenerKey =
            _createListenerKey(StorageEventType.remove, key);
        listeners[listenerKey]?.forEach((element) {
          element();
        });

        return true;
      }
    }
    return false;
  }
}

final storage = Storage();
