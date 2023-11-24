class RailTicketDetails {
  late final int ticketId;
  late final int trainId;
  late final String journeyOn;
  late final String createdOn;
  late final int createdBy;

  RailTicketDetails({
    required this.ticketId,
    required this.trainId,
    required this.journeyOn,
    required this.createdOn,
    required this.createdBy,
  });

  RailTicketDetails.fromJson(Map<String, dynamic> json) {
    ticketId = json['ticket_id'] as int;
    trainId = json['train_id'] as int;
    journeyOn = json['journey_on'] as String;
    createdOn = json['created_on'] as String;
    createdBy = json['created_by'] as int;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ticket_id'] = ticketId;
    data['train_id'] = trainId;
    data['journey_on'] = journeyOn;
    data['created_on'] = createdOn;
    data['created_by'] = createdBy;

    return data;
  }
}
