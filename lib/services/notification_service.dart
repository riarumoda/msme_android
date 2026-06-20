// lib/services/notification_service.dart
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'dart:convert';

import '../models/notification_model.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log("Background message: ${message.messageId}");
}

class NotificationService {
  NotificationService._internal();
  static final NotificationService instance = NotificationService._internal();

  final baseUrl = 'https://laravel.leviathanbolu.my.id/api';

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final ValueNotifier<int> unreadCount = ValueNotifier<int>(0);

  static Future<void> init() async {
    await instance._initLocalNotifications();
    await instance._initFirebaseMessaging();
    await instance.syncTokenWithBackend(dummyUserId: 1);
    await instance.updateUnreadCount(dummyUserId: 1);
  }

  Future<void> _initLocalNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);

    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        log('Notification tapped! Payload: ${response.payload}');
      },
    );
  }

  Future<void> _initFirebaseMessaging() async {
    await _firebaseMessaging.requestPermission(
        alert: true, badge: true, sound: true);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        _showLocalNotification(
          id: message.hashCode,
          title: message.notification!.title ?? 'Notifikasi Baru',
          body: message.notification!.body ?? '',
          payload: message.data.toString(),
        );
        _incrementUnreadCount();
      }
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      syncTokenWithBackend(dummyUserId: 1, forceToken: newToken);
    });
  }

  Future<void> syncTokenWithBackend(
      {required int dummyUserId, String? forceToken}) async {
    try {
      final fcmToken = forceToken ?? await _firebaseMessaging.getToken();
      if (fcmToken == null) return;

      final response = await http.post(
        Uri.parse('$baseUrl/fcm-token'),
        body: {
          'user_id': dummyUserId.toString(),
          'fcm_token': fcmToken,
          'device_name': 'Android Device'
        },
      );

      log('Token sync status: ${response.statusCode}');
    } catch (e) {
      log('Token sync error: $e');
    }
  }

  Future<List<NotificationModel>> fetchNotifications(
      {int page = 1, int dummyUserId = 1}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/notifications?page=$page&user_id=$dummyUserId'),
      );
      print('Fetch notif response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        // 1. Decode sebagai Map
        final Map<String, dynamic> responseBody = jsonDecode(response.body);

        // 2. Ambil list dari dalam key 'data'
        final List<dynamic> dataList = responseBody['data'] ?? [];

        // 3. Lakukan mapping
        return dataList
            .map((json) => NotificationModel.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      log('Fetch notif error: $e');
      return [];
    }
  }

  Future<NotificationModel?> fetchNotificationDetail(String notificationId,
      {int dummyUserId = 1}) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/notifications/$notificationId?user_id=$dummyUserId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return NotificationModel.fromJson(data);
      }
      return null;
    } catch (e) {
      log('Fetch detail error: $e');
      return null;
    }
  }

  Future<bool> markNotificationAsRead(String notificationId,
      {int dummyUserId = 1}) async {
    try {
      final response = await http.post(
        Uri.parse(
            '$baseUrl/notifications/$notificationId/read?user_id=$dummyUserId'),
      );

      if (response.statusCode == 200) {
        if (unreadCount.value > 0) {
          unreadCount.value = unreadCount.value - 1;
        }
        return true;
      }

      return false;
    } catch (e) {
      log('Mark read error: $e');
      return false;
    }
  }

  Future<void> _showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'inventory_channel_id',
      'Inventory Notifications',
      channelDescription: 'System notification channel',
      importance: Importance.max,
      priority: Priority.high,
      color: Colors.indigo,
      enableLights: true,
      styleInformation: BigTextStyleInformation(body, contentTitle: title),
    );

    await _localNotifications.show(
      id: id,
      title: title,
      body: body,
      payload: payload,
      notificationDetails: NotificationDetails(android: androidDetails),
    );
  }

  void _incrementUnreadCount() {
    unreadCount.value = unreadCount.value + 1;
  }

  Future<void> updateUnreadCount({int dummyUserId = 1}) async {
    final notifications = await fetchNotifications(dummyUserId: dummyUserId);
    unreadCount.value =
        notifications.where((notification) => !notification.isRead).length;
  }

  static Future<void> showDemoNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    await instance._showLocalNotification(id: id, title: title, body: body);
  }
}
