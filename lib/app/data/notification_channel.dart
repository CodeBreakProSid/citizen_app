class NotificationChannel {
  late final String channelId;
  late final String subscriberId;
  late final String accessToken;
  late final String createdOn;
  late final String? connectedOn;

  NotificationChannel({
    required this.channelId,
    required this.subscriberId,
    required this.accessToken,
    required this.createdOn,
    this.connectedOn,
  });

  NotificationChannel.fromJson(Map<String, dynamic> json) {
    channelId = json['channel_id'] as String;
    subscriberId = json['subscriber_id'] as String;
    accessToken = json['access_token'] as String;
    createdOn = json['created_on'] as String;
    connectedOn = json['connected_on'] as String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['channel_id'] = channelId;
    data['subscriber_id'] = subscriberId;
    data['access_token'] = accessToken;
    data['created_on'] = createdOn;
    data['connected_on'] = connectedOn;

    return data;
  }
}
