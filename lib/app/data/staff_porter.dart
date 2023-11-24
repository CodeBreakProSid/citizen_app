class StaffPorter {
  int? staffPorterCategory;
  String? staffPorterCategoryLabel;
  String? name;
  int? age;
  String? gender;
  String? jobDetails;
  String? mobileNumber;
  String? aadharNumber;
  String? address;
  String? photo;
  int? railwayStation;
  String? nativePoliceStation;
  String? railwayStationLabel;
  String? railwayPoliceStationLabel;
  int? nativeState;
  String? nativeStateLabel;
  bool? migrantOrNot;
  String? utcTimestamp;
  String? citizenId;

  StaffPorter({
    required this.staffPorterCategory,
    required this.staffPorterCategoryLabel,
    required this.name,
    required this.age,
    required this.gender,
    required this.jobDetails,
    required this.mobileNumber,
    this.aadharNumber,
    required this.address,
    this.photo,
    required this.railwayStation,
    required this.railwayStationLabel,
    required this.railwayPoliceStationLabel,
    this.nativePoliceStation,
    this.nativeState,
    this.nativeStateLabel,
    required this.migrantOrNot,
    required this.utcTimestamp,
    required this.citizenId,
  });

  StaffPorter.fromJson(Map<String, dynamic> json) {
    staffPorterCategory = json['staff_porter_category'] as int?;
    staffPorterCategoryLabel = json['staff_porter_category_label'] as String?;
    name = json['name'] as String?;
    age = json['age'] as int?;
    gender = json['gender'] as String?;
    jobDetails = json['job_details'] as String?;
    mobileNumber = json['mobile_number'] as String?;
    aadharNumber = json['aadhar_number'] as String?;
    address = json['address'] as String?;
    photo = json['photo'] as String?;
    railwayStation = json['railway_station'] as int?;
    railwayStationLabel = json['railway_station_label'] as String?;
    railwayPoliceStationLabel = json['police_station_label'] as String?;
    nativePoliceStation = json['native_police_station'] as String?;
    nativeState = json['native_state'] as int?;
    nativeStateLabel = json['native_state_label'] as String?;
    migrantOrNot = json['migrant_or_not'] as bool?;
    utcTimestamp = json['utc_timestamp'] as String?;
    citizenId = json['citizen_id'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['staff_porter_category'] = staffPorterCategory;
    data['staff_porter_category_label'] = staffPorterCategoryLabel;
    data['name'] = name;
    data['age'] = age;
    data['gender'] = gender;
    data['job_details'] = jobDetails;
    data['mobile_number'] = mobileNumber;
    data['aadhar_number'] = aadharNumber;
    data['address'] = address;
    data['photo'] = photo;
    data['railway_station'] = railwayStation;
    data['railway_station_label'] = railwayStationLabel;
    data['police_station_label'] = railwayPoliceStationLabel;
    data['native_police_station'] = nativePoliceStation;
    data['native_state'] = nativeState;
    data['native_state_label'] = nativeStateLabel;
    data['migrant_or_not'] = migrantOrNot;
    data['utc_timestamp'] = utcTimestamp;
    data['citizen_id'] = citizenId;

    return data;
  }
}
