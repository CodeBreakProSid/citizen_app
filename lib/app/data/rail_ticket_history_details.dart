class RailTicketHistoryDetails {
  int? id;
  int? ticketTypeId;
  String? ticketTypeLabel;
  int? status;
  String? statusLabel;
  String? utcTimestamp;

  RailTicketHistoryDetails({
    this.id,
    this.ticketTypeId,
    this.ticketTypeLabel,
    this.status,
    this.statusLabel,
    this.utcTimestamp,
  });

  RailTicketHistoryDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    ticketTypeId = json['ticket_type_id'] as int;
    ticketTypeLabel = json['ticket_type_label'] as String;
    status = json['status'] as int;
    statusLabel = json['status_label'] as String;
    utcTimestamp = json['utc_timestamp'] as String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['ticket_type_id'] = ticketTypeId;
    data['ticket_type_label'] = ticketTypeLabel;
    data['status'] = status;
    data['status_label'] = statusLabel;
    data['utc_timestamp'] = utcTimestamp;

    return data;
  }
}
