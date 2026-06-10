// lib/services/notification_service.dart
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // Menggunakan icon launcher bawaan aplikasi android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    // Inisialisasi plugin
    await _notificationsPlugin.initialize(settings: initializationSettings);

    // Meminta izin (permission) untuk Android 13+
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  // Fungsi untuk memicu notifikasi demo
  static Future<void> showDemoNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'inventory_channel_id',
      'Inventory Notifications',
      channelDescription: 'Notifikasi sistem untuk stok dan aktivitas barang',
      importance: Importance.max,
      priority: Priority.high,
      color: Colors.indigo, // Warna ikon indigo
      enableLights: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
    );
  }
}
