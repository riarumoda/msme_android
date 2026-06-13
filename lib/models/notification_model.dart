class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String itemId;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.itemId,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final dataMap = json['data'] ?? {};

    return NotificationModel(
      id: json['id']?.toString() ?? '',
      title: dataMap['title']?.toString() ?? 'Peringatan Stok',
      body: dataMap['body']?.toString() ?? 'Silakan cek stok barang Anda.',
      itemId: dataMap['item_id']?.toString() ?? '',
      isRead: json['read_at'] != null,
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at']) ?? DateTime.now() 
          : DateTime.now(),
    );
  }
}