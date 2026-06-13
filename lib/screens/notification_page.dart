// lib/screens/notification_page.dart
import 'package:flutter/material.dart';
import '../models/notification_model.dart';
import '../services/notification_service.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late List<NotificationModel> notifications = [];

  Future<void> _loadNotifications() async {
    final fetchedNotifs = await NotificationService.instance.fetchNotifications();
    setState(() {
      notifications = fetchedNotifs;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     NotificationService.showDemoNotification(
      //       id: DateTime.now().millisecond, // ID unik agar notif menumpuk
      //       title: 'Stok Kritis!',
      //       body:
      //           'Gula Pasir 1kg sisa 1 Pcs. Segera lakukan restock ke Supplier.',
      //     );
      //   },
      //   backgroundColor: Colors.indigo,
      //   foregroundColor: Colors.white,
      //   icon: const Icon(Icons.notification_add_outlined),
      //   label: const Text('Test Notif Android'),
      // ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: notifications.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          thickness: 1,
          color: Colors.grey.shade200,
          indent: 72,
          endIndent: 16,
        ),
        itemBuilder: (context, index) {
          final notif = notifications[index];
          return _buildNotificationTile(notif);
        },
      ),
    );
  }

  Widget _buildNotificationTile(NotificationModel notif) {
    Color iconColor;
    Color bgColor;
    IconData icon;

    if (notif.isRead) {
      iconColor = Colors.grey.shade400;
      bgColor = Colors.grey.shade200;
      icon = Icons.notifications_none_outlined;
    } else {
      iconColor = Colors.indigo;
      bgColor = Colors.indigo.withValues(alpha: 0.1);
      icon = Icons.notifications_active_outlined;
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
        child: Icon(icon, color: iconColor, size: 24),
      ),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                notif.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
            ),
            Text(
              notif.createdAt.toLocal().toString().substring(11, 16), // Hanya jam dan menit
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      subtitle: Text(
        notif.body,
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey.shade700,
          height: 1.4,
        ),
      ),
      onTap: () {
        NotificationService.instance.markNotificationAsRead(notif.id);
      },
    );
  }
}
