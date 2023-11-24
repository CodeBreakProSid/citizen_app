class TicketDetails {
  late final int ticketId;
  late final int ticketStatus;
  late final int ticketType;
  late final int stationId;
  late final String createdOn;
  late final int createdBy;
  late final int createdFor;

  TicketDetails({
    required this.ticketId,
    required this.ticketStatus,
    required this.ticketType,
    required this.stationId,
    required this.createdOn,
    required this.createdBy,
    required this.createdFor,
  });

  TicketDetails.fromJson(Map<String, dynamic> json) {
    ticketId = json['ticket_id'] as int;
    ticketStatus = json['ticket_status'] as int;
    ticketType = json['ticket_type'] as int;
    stationId = json['station_id'] as int;
    createdOn = json['created_on'] as String;
    createdBy = json['created_by'] as int;
    createdFor = json['created_for'] as int;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ticket_id'] = ticketId;
    data['ticket_status'] = ticketStatus;
    data['ticket_type'] = ticketType;
    data['station_id'] = stationId;
    data['created_on'] = createdOn;
    data['created_by'] = createdBy;
    data['created_for'] = createdFor;

    return data;
  }
}
