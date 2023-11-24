class SosMessagedetails {
  int? id;
  String? dataFrom;
  String? citizenId;
  String? utcTimestamp;
  String? sosMessage;
  double? latitude;
  double? longitude;
  int? status;
  String? statusLabel;

  SosMessagedetails({
    this.id,
    this.dataFrom,
    this.citizenId,
    this.utcTimestamp,
    this.sosMessage,
    this.latitude,
    this.longitude,
    this.status,
    this.statusLabel,
  });

  SosMessagedetails.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    citizenId = json['citizen_id'] as String;
    dataFrom = json['data_from'] as String;
    utcTimestamp = json['utc_timestamp'] as String;
    sosMessage = json['sos_message'] as String;
    latitude = json['latitude'] as double;
    longitude = json['longitude'] as double;
    status = json['status'] as int;
    statusLabel = json['status_label'] as String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['data_from'] = dataFrom;
    data['citizen_id'] = citizenId;
    data['utc_timestamp'] = utcTimestamp;
    data['sos_message'] = sosMessage;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['status'] = status;
    data['status_label'] = statusLabel;

    return data;
  }
}
