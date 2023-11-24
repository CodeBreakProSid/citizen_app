class IntruderAlertDetails {
  int? id;
  int? status;
  String? statusLabel;
  String? dataFrom;
  int? train;
  String? trainLabel;
  String? mobileNumber;
  String? location;
  String? remarks;
  String? informerDetails;
  String? utcTimestamp;
  int? ticketTypeId;
  late String ticketTypeLabel;
  double? latitude;
  double? longitude;

  IntruderAlertDetails({
    this.id,
    this.status,
    this.statusLabel,
    this.dataFrom,
    this.train,
    this.trainLabel,
    this.mobileNumber,
    this.location,
    this.remarks,
    this.informerDetails,
    this.utcTimestamp,
    this.ticketTypeId,
    required this.ticketTypeLabel,
    this.latitude,
    this.longitude,
  });

  IntruderAlertDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    status = json['status'] as int;
    statusLabel = json['status_label'] as String;
    dataFrom = json['data_from'] as String;
    train = json['train'] as int;
    trainLabel = json['train_label'] as String;
    mobileNumber = json['mobile_number'] as String;
    location = json['location'] as String;
    remarks = json['remarks'] as String;
    informerDetails = json['informer_details'] as String;
    utcTimestamp = json['utc_timestamp'] as String;
    ticketTypeId = json['ticket_type_id'] as int;
    ticketTypeLabel = json['ticket_type_label'] as String;
    latitude = json['latitude'] as double;
    longitude = json['longitude'] as double;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status;
    data['status_label'] = statusLabel;
    data['data_from'] = dataFrom;
    data['train'] = train;
    data['train_label'] = trainLabel;
    data['mobile_number'] = mobileNumber;
    data['location'] = location;
    data['remarks'] = remarks;
    data['informer_details'] = informerDetails;
    data['utc_timestamp'] = utcTimestamp;
    data['ticket_type_id'] = ticketTypeId;
    data['ticket_type_label'] = ticketTypeLabel;
    data['latitude'] = latitude;
    data['longitude'] = longitude;

    return data;
  }
}
