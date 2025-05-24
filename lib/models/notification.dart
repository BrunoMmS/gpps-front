class Notification {
  final int id;
  final int userId;
  final String message;
  final String timestamp; // o DateTime si lo parseás
  final bool read;

  Notification({
    required this.id,
    required this.userId,
    required this.message,
    required this.timestamp,
    required this.read,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      message: json['message'] ?? '',
      timestamp: json['timestamp'] ?? '',
      read: json['read'] ?? false,
    );
  }
}
