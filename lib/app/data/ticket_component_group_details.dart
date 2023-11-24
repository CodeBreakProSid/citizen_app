import 'resource_component_details.dart';

class TicketComponentGroupDetails {
  late final Message? message;
  late final Meeting? meeting;
  late final List<ResourceComponentDetails>? resource;

  TicketComponentGroupDetails({this.message, this.meeting, this.resource});

  TicketComponentGroupDetails.fromJson(Map<String, dynamic> json) {
    message = json['message'] != null
        ? Message.fromJson(json['message'] as Map<String, dynamic>)
        : null;
    meeting = json['meeting'] != null
        ? Meeting.fromJson(json['meeting'] as Map<String, dynamic>)
        : null;
    if (json['resource'] != null) {
      resource = <ResourceComponentDetails>[];
      for (final element in json['resource'] as List) {
        resource!.add(
          ResourceComponentDetails.fromJson(element as Map<String, dynamic>),
        );
      }
    } else {
      resource = null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (message != null) {
      data['message'] = message!.toJson();
    }
    if (meeting != null) {
      data['meeting'] = meeting!.toJson();
    }
    if (resource != null) {
      data['resource'] = resource!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Message {
  late final int? messageId;
  late final int? groupId;
  late final String? messageText;

  Message({this.messageId, this.groupId, this.messageText});

  Message.fromJson(Map<String, dynamic> json) {
    messageId = json['message_id'] as int?;
    groupId = json['group_id'] as int?;
    messageText = json['message_text'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message_id'] = messageId;
    data['group_id'] = groupId;
    data['message_text'] = messageText;

    return data;
  }
}

class Meeting {
  int? meetingId;
  int? componentGroupId;

  Meeting({this.meetingId, this.componentGroupId});

  Meeting.fromJson(Map<String, dynamic> json) {
    meetingId = json['meeting_id'] as int?;
    componentGroupId = json['group_id'] as int?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['meeting_id'] = meetingId;
    data['group_id'] = componentGroupId;

    return data;
  }
}
