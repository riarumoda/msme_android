// lib/models/notification_model.dart

enum NotificationType { lowStock, stockIn, stockOut }

class NotificationModel {
  final String title;
  final String description;
  final String time;
  final NotificationType type;

  NotificationModel({
    required this.title,
    required this.description,
    required this.time,
    required this.type,
  });
}
