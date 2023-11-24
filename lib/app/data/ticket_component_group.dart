class TicketComponentGroup {
  late final int componentId;
  late final int ticketId;
  late final String createdOn;
  late int createdBy;

  TicketComponentGroup({
    required this.componentId,
    required this.ticketId,
    required this.createdOn,
    required this.createdBy,
  });

  TicketComponentGroup.fromJson(Map<String, dynamic> json) {
    componentId = json['component_id'] as int;
    ticketId = json['ticket_id'] as int;
    createdOn = json['created_on'] as String;
    createdBy = json['created_by'] as int;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['component_id'] = componentId;
    data['ticket_id'] = ticketId;
    data['created_on'] = createdOn;
    data['created_by'] = createdBy;

    return data;
  }
}
