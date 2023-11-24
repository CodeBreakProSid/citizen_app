class LonelyPassengerDetails {
  int? id;
  String? name;
  int? age;
  String? gender;
  String? dateOfJourney;
  int? train;
  String? trainName;
  String? trainNumber;
  String? trainLabel;
  String? coach;
  int? seat;
  int? entrainStation;
  String? entrainStationLabel;
  int? detrainStation;
  String? detrainStationLabel;
  String? pnrNumber;
  String? mobileNumber;
  String? dressCode;
  String? remarks;
  int? ticketTypeId;
  late String ticketTypeLabel;
  int? status;
  late String statusLabel;
  late String utcTimestamp;

  LonelyPassengerDetails({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.dateOfJourney,
    required this.train,
    this.trainName,
    this.trainNumber,
    this.trainLabel,
    required this.coach,
    this.seat,
    required this.entrainStation,
    this.entrainStationLabel,
    required this.detrainStation,
    this.detrainStationLabel,
    this.pnrNumber,
    required this.mobileNumber,
    this.dressCode,
    required this.remarks,
    this.ticketTypeId,
    required this.ticketTypeLabel,
    required this.status,
    required this.statusLabel,
    required this.utcTimestamp,
  });

  LonelyPassengerDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    name = json['name'] as String;
    age = json['age'] as int;
    gender = json['gender'] as String;
    dateOfJourney = json['date_of_journey'] as String;
    train = json['train'] as int;
    trainName = json['train_name'] as String;
    trainNumber = json['train_number'] as String;
    trainLabel = json['train_label'] as String;
    coach = json['coach'] as String;
    seat = json['seat'] as int?;
    entrainStation = json['entrain_station'] as int;
    entrainStationLabel = json['entrain_station_label'] as String;
    detrainStation = json['detrain_station'] as int;
    detrainStationLabel = json['detrain_station_label'] as String;
    pnrNumber = json['pnr_number'] as String?;
    mobileNumber = json['mobile_number'] as String;
    dressCode = json['dress_code'] as String?;
    remarks = json['remarks'] as String;
    ticketTypeId = json['ticket_type_id'] as int;
    ticketTypeLabel = json['ticket_type_label'] as String;
    status = json['status'] as int;
    statusLabel = json['status_label'] as String;
    utcTimestamp = json['utc_timestamp'] as String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['age'] = age;
    data['gender'] = gender;
    data['date_of_journey'] = dateOfJourney;
    data['train'] = train;
    data['train_name'] = trainName;
    data['train_number'] = trainNumber;
    data['train_label'] = trainLabel;
    data['coach'] = coach;
    data['seat'] = seat;
    data['entrain_station'] = entrainStation;
    data['entrain_station_label'] = entrainStationLabel;
    data['detrain_station'] = detrainStation;
    data['detrain_station_label'] = detrainStationLabel;
    data['pnr_number'] = pnrNumber;
    data['mobile_number'] = mobileNumber;
    data['dress_code'] = dressCode;
    data['remarks'] = remarks;
    data['status'] = status;
    data['ticket_type_id'] = ticketTypeId;
    data['ticket_type_label'] = ticketTypeLabel;
    data['status_label'] = statusLabel;
    data['utc_timestamp'] = utcTimestamp;

    return data;
  }
}
