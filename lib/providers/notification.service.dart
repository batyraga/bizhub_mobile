import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/constants.dart';
import 'package:bizhub/models/notification.model.dart';
import 'package:bizhub/providers/storage.provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  List<BizhubNotification> history = [];

  final channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.max,
  );

  String? token;

  Future<void> init() async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      log("[notification] - error - failed request permission");
      return;
    }

    if (!kIsWeb) {
      await flutterLocalNotificationsPlugin
          .initialize(const InitializationSettings(
              android: AndroidInitializationSettings(
        "@drawable/bizhub_notification_icon",
      )));
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }

    token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      final oldToken = storage.read("notification_token");
      await storage.write("notification_token", token!);
      if (token != oldToken) {
        sendNotificationTokenToApi(token!);
      }
    }
    log("[notification] - token - $token");

    await compute<dynamic, dynamic>(loadNotificationHistory, null);

    FirebaseMessaging.onMessage.listen(showNotification);
  }

  Future<dynamic> loadNotificationHistory(_) async {
    final String? h = storage.read("notifications");
    if (h == null) {
      return;
    }
    try {
      final List asList = jsonDecode(h);
      final List<BizhubNotification> n = List<BizhubNotification>.from(
          asList.map((e) => BizhubNotification.fromJson(e)));

      history = n;
    } catch (err) {
      log("[loadNotificationHistory] - asList.error - $err");
    }
  }

  void saveNotificationToHistory(BizhubNotification n) async {
    try {
      history.add(n);
      history = history.sublist(0, 25);
      final String asString = await compute(jsonEncode, history);
      storage.write("notifications", asString);
    } catch (err) {
      log("[saveNotificationToHistory] - error - $err");
    }
  }

  Future<void> sendNotificationTokenToApi(String token) async {
    try {
      final bool result = await api.notifications.saveNotificationToken(token);
      if (result == true) {
        log("[sendNotificationTokenToApi] - result - success!");
      }
    } catch (err) {
      log("[sendNotificationTokenToApi] - error - $err");
    }
  }

  Future<void> onMessage(RemoteMessage event) async {
    showNotification(event);
    log("[notification] - message - ${event.senderId} - ${event.notification?.title}");
  }

  Future<void> showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null) {
      saveNotificationToHistory(BizhubNotification(
          content: notification.body != null
              ? notification.body!
              : (notification.title ?? "Unknown"),
          createdAt: DateTime.now()));
    }

    if (notification != null && android != null && !kIsWeb) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            color: secondaryColor,
          ),
        ),
      );
    }
  }

  Future<void> setupInteractedMessage(
      void Function(RemoteMessage) handleMessage) async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      showNotification(initialMessage);
      handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }
}

final notificationService = NotificationService();
