class MeetingHistory {
  late final int meetingId;
  late final int meetingState;
  late final String createdOn;
  late final int createdBy;
  late final String startTime;
  late final String endTime;

  MeetingHistory({
    required this.meetingId,
    required this.meetingState,
    required this.createdOn,
    required this.createdBy,
    required this.startTime,
    required this.endTime,
  });

  MeetingHistory.fromJson(Map<String, dynamic> json) {
    meetingId = json['meeting_id'] as int;
    meetingState = json['meeting_state'] as int;
    createdOn = json['created_on'] as String;
    createdBy = json['created_by'] as int;
    startTime = json['start_time'] as String;
    endTime = json['end_time'] as String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['meeting_id'] = meetingId;
    data['meeting_state'] = meetingState;
    data['created_on'] = createdOn;
    data['created_by'] = createdBy;
    data['start_time'] = startTime;
    data['end_time'] = endTime;

    return data;
  }
}
