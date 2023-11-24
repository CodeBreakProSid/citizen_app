class UserNotification {
  late final int notificationId;
  late final int userId;
  late final String createdOn;
  late final int notificationType;
  late final Notification notification;

  UserNotification({
    required this.notificationId,
    required this.userId,
    required this.createdOn,
    required this.notificationType,
    required this.notification,
  });

  UserNotification.fromJson(Map<String, dynamic> json) {
    notificationId = json['notification_id'] as int;
    userId = json['user_id'] as int;
    createdOn = json['created_on'] as String;
    notificationType = json['notification_type'] as int;
    if (json['notification'] != {}) {
      notification =
          Notification.fromJson(json['notification'] as Map<String, dynamic>);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['notification_id'] = notificationId;
    data['user_id'] = userId;
    data['created_on'] = createdOn;
    data['notification_type'] = notificationType;
    data['notification'] = notification.toJson();

    return data;
  }
}

class Notification {
  late final String message;
  late final int ticketId;

  Notification({required this.message, required this.ticketId});

  Notification.fromJson(Map<String, dynamic> json) {
    message = json['message'] as String;
    ticketId = json['ticket_id'] as int;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['ticket_id'] = ticketId;

    return data;
  }
}
