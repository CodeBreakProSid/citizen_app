class RailNotification {
  int? id;
  String? notificationMessage;
  String? notificationType;
  String? notificationTypeLabel;
  int? itemId;
  String? date;
  String? citizenId;

  RailNotification({
    this.id,
    this.notificationMessage,
    this.notificationType,
    this.notificationTypeLabel,
    this.itemId,
    this.date,
    this.citizenId,
  });

  RailNotification.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    notificationMessage = json['notification_message'] as String;
    notificationType = json['notification_type'] as String;
    notificationTypeLabel = json['notification_type_label'] as String;
    itemId = json['item_id'] as int;
    date = json['date'] as String;
    citizenId = json['citizen_id'] as String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['notification_message'] = notificationMessage;
    data['notification_type'] = notificationType;
    data['notification_type_label'] = notificationTypeLabel;
    data['item_id'] = itemId;
    data['date'] = date;
    data['citizen_id'] = citizenId;

    return data;
  }
}
