class MeetingDetails {
  late final String token;
  late final int expiryInSec;
  late final String meetingID;
  late final String title;
  late final String role;
  late final String type;

  MeetingDetails({
    required this.token,
    required this.expiryInSec,
    required this.meetingID,
    required this.title,
    required this.role,
    required this.type,
  });

  MeetingDetails.fromJson(Map<String, dynamic> json) {
    token = json['token'] as String;
    expiryInSec = json['expiryInSec'] as int;
    meetingID = json['meetingID'] as String;
    title = json['title'] as String;
    role = json['role'] as String;
    type = json['type'] as String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['expiryInSec'] = expiryInSec;
    data['meetingID'] = meetingID;
    data['title'] = title;
    data['role'] = role;
    data['type'] = type;

    return data;
  }
}
