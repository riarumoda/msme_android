// lib/screens/notification_page.dart
import 'package:flutter/material.dart';
import '../models/notification_model.dart';
import '../services/notification_service.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Data dummy historis
    final List<NotificationModel> notifications = [
      NotificationModel(
        title: 'Stok Menipis',
        description: 'Beras Pandan Wangi 5kg tersisa 2 karung.',
        time: '10:30',
        type: NotificationType.lowStock,
      ),
      NotificationModel(
        title: 'Barang Masuk',
        description: '+50 Dus Indomie Goreng dari Supplier A.',
        time: '08:15',
        type: NotificationType.stockIn,
      ),
      NotificationModel(
        title: 'Barang Keluar',
        description: '-10 Pcs Minyak Goreng Bimoli 2L (Order #1029).',
        time: 'Kemarin',
        type: NotificationType.stockOut,
      ),
      NotificationModel(
        title: 'Stok Kritis',
        description: 'Gula Pasir 1kg habis (0 Pcs). Segera restock!',
        time: 'Kemarin',
        type: NotificationType.lowStock,
      ),
      NotificationModel(
        title: 'Barang Masuk',
        description: '+20 Pcs Sabun Mandi Cair Lifebuoy.',
        time: '12 Okt',
        type: NotificationType.stockIn,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            tooltip: 'Tandai semua dibaca',
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          NotificationService.showDemoNotification(
            id: DateTime.now().millisecond, // ID unik agar notif menumpuk
            title: 'Stok Kritis!',
            body:
                'Gula Pasir 1kg sisa 1 Pcs. Segera lakukan restock ke Supplier.',
          );
        },
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.notification_add_outlined),
        label: const Text('Test Notif Android'),
      ),
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

    switch (notif.type) {
      case NotificationType.lowStock:
        iconColor = Colors.red.shade700;
        bgColor = Colors.red.shade50;
        icon = Icons.warning_amber_rounded;
        break;
      case NotificationType.stockIn:
        iconColor = Colors.green.shade700;
        bgColor = Colors.green.shade50;
        icon = Icons.input_rounded;
        break;
      case NotificationType.stockOut:
        iconColor = Colors.blue.shade700;
        bgColor = Colors.blue.shade50;
        icon = Icons.output_rounded;
        break;
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
              notif.time,
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
        notif.description,
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey.shade700,
          height: 1.4,
        ),
      ),
      onTap: () {},
    );
  }
}
