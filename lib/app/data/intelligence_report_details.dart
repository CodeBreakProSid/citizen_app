class IntelligenceReportDetails {
  int? id;
  int? status;
  String? statusLabel;
  String? intelligenceType;
  String? dataFrom;
  String? severity;
  String? mobileNumber;
  // Null? photo;
  // Null? thumbnails;
  String? information;
  String? remarks;
  //int? informer;
  //String? informerLabel;
  String? informerDetails;
  // Null? assignedToBeat;
  // Null? assignedTimestamp;
  // Null? beatOfficerAttended;
  // Null? attendedTimestamp;
  late double latitude;
  late double longitude;
  String? utcTimestamp;

  IntelligenceReportDetails({
    this.id,
    this.status,
    this.statusLabel,
    required this.intelligenceType,
    required this.dataFrom,
    this.severity,
    required this.mobileNumber,
    required this.information,
    required this.remarks,
    //this.informer,
    //this.informerLabel,
    required this.informerDetails,
    required this.latitude,
    required this.longitude,
    required this.utcTimestamp,
  });

  IntelligenceReportDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    status = json['status'] as int;
    statusLabel = json['status_label'] as String;
    intelligenceType = json['intelligence_type'] as String;
    dataFrom = json['data_from'] as String;
    severity = json['severity'] as String;
    mobileNumber = json['mobile_number'] as String;
    information = json['information'] as String;
    remarks = json['remarks'] as String;
    //informer = json['informer'] as int;
    //informerLabel = json['informer_label'] as String;
    informerDetails = json['informer_details'] as String;
    latitude = json['latitude'] as double;
    longitude = json['longitude'] as double;
    utcTimestamp = json['utc_timestamp'] as String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status;
    data['status_label'] = statusLabel;
    data['intelligence_type'] = intelligenceType;
    data['data_from'] = dataFrom;
    data['severity'] = severity;
    data['mobile_number'] = mobileNumber;
    data['information'] = information;
    data['remarks'] = remarks;
    //data['informer'] = informer;
    //data['informer_label'] = informerLabel;
    data['informer_details'] = informerDetails;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['utc_timestamp'] = utcTimestamp;

    return data;
  }
}
