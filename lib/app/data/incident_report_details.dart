class IncidentReportDetails {
  int? id;
  String? incidentType;
  int? status;
  String? statusLabel;
  String? dataFrom;
  String? name;
  int? age;
  String? mobileNumber;
  int? train;
  String? trainName;
  String? trainNumber;
  String? coach;
  int? seat;
  // void? photo;
  String? incidentDateTime;
  int? railwayStation;
  String? railwayStationLabel;
  int? platformNumber;
  String? trackLocation;
  String? incidentDetails;
  // String? remarks;
  // int? assignedToBeat;
  // String? assignedToBeatLabel;
  // String? assignedTimestamp;
  // int? beatOfficerAttended;
  // String? attendedTimestamp;
  // String? beatOfficerLabel;
  double? latitude;
  double? longitude;
  String? utcTimestamp;
  // void? thumbnails;

  IncidentReportDetails({
    this.id,
    this.incidentType,
    this.status,
    this.statusLabel,
    this.dataFrom,
    this.name,
    this.age,
    this.mobileNumber,
    this.train,
    this.trainName,
    this.trainNumber,
    this.coach,
    this.seat,
    // this.photo,
    this.incidentDateTime,
    this.railwayStation,
    this.railwayStationLabel,
    this.platformNumber,
    this.trackLocation,
    this.incidentDetails,
    // this.remarks,
    // this.assignedToBeat,
    // this.assignedToBeatLabel,
    // this.assignedTimestamp,
    // this.beatOfficerAttended,
    // this.attendedTimestamp,
    // this.beatOfficerLabel,
    // this.latitude,
    this.longitude,
    this.utcTimestamp,
    // this.thumbnails,
  });

  IncidentReportDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    incidentType = json['incident_type'] as String;
    status = json['status'] as int;
    statusLabel = json['status_label'] as String;
    dataFrom = json['data_from'] as String;
    name = json['name'] as String;
    age = json['age'] as int;
    mobileNumber = json['mobile_number'] as String;
    train = json['train'] as int?;
    trainName = json['train_name'] as String?;
    trainNumber = json['train_number'] as String?;
    coach = json['coach'] as String?;
    seat = json['seat'] as int?;
    // photo = json['photo'];
    incidentDateTime = json['incident_date_time'] as String;
    railwayStation = json['railway_station'] as int?;
    railwayStationLabel = json['railway_station_label'] as String?;
    platformNumber = json['platform_number'] as int?;
    trackLocation = json['track_location'] as String?;
    incidentDetails = json['incident_details'] as String?;
    // remarks = json['remarks'] as String?;
    // assignedToBeat = json['assigned_to_beat'];
    // assignedToBeatLabel = json['assigned_to_beat_label'];
    // assignedTimestamp = json['assigned_timestamp'];
    // beatOfficerAttended = json['beat_officer_attended'];
    // attendedTimestamp = json['attended_timestamp'];
    // beatOfficerLabel = json['beat_officer_label'];
    latitude = json['latitude'] as double;
    longitude = json['longitude'] as double;
    utcTimestamp = json['utc_timestamp'] as String;
    // thumbnails = json['thumbnails'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['incident_type'] = incidentType;
    data['status'] = status;
    data['status_label'] = statusLabel;
    data['data_from'] = dataFrom;
    data['name'] = name;
    data['age'] = age;
    data['mobile_number'] = mobileNumber;
    data['train'] = train;
    data['train_name'] = trainName;
    data['train_number'] = trainNumber;
    data['coach'] = coach;
    data['seat'] = seat;
    // data['photo'] = photo;
    data['incident_date_time'] = incidentDateTime;
    data['railway_station'] = railwayStation;
    data['railway_station_label'] = railwayStationLabel;
    data['platform_number'] = platformNumber;
    data['track_location'] = trackLocation;
    data['incident_details'] = incidentDetails;
    // data['remarks'] = remarks;
    // data['assigned_to_beat'] = assignedToBeat;
    // data['assigned_to_beat_label'] = assignedToBeatLabel;
    // data['assigned_timestamp'] = assignedTimestamp;
    // data['beat_officer_attended'] = beatOfficerAttended;
    // data['attended_timestamp'] = attendedTimestamp;
    // data['beat_officer_label'] = beatOfficerLabel;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['utc_timestamp'] = utcTimestamp;
    // data['thumbnails'] = thumbnails;

    return data;
  }
}
