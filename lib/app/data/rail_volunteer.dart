class RailVolunteer {
  int? railVolunteerCategory;
  String? dataFrom;
  String? name;
  int? age;
  String? gender;
  String? mobileNumber;
  String? email;
  int? nearestRailwayStation;
  bool? seasonPassenger;
  int? entrainStation;
  int? detrainStation;
  String? utcTimestamp;

  RailVolunteer({
    required this.railVolunteerCategory,
    required this.dataFrom,
    required this.name,
    required this.age,
    required this.gender,
    required this.mobileNumber,
    this.email,
    required this.nearestRailwayStation,
    this.seasonPassenger,
    this.entrainStation,
    this.detrainStation,
    required this.utcTimestamp,
  });

  RailVolunteer.fromJson(Map<String, dynamic> json) {
    railVolunteerCategory = json['rail_volunteer_category'] as int;
    dataFrom = json['data_from'] as String;
    name = json['name'] as String;
    age = json['age'] as int;
    gender = json['gender'] as String;
    mobileNumber = json['mobile_number'] as String;
    email = json['email'] as String;
    nearestRailwayStation = json['nearest_railway_station'] as int;
    seasonPassenger = json['season_passenger'] as bool;
    entrainStation = json['entrain_station'] as int?;
    detrainStation = json['detrain_station'] as int?;
    utcTimestamp = json['utc_timestamp'] as String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rail_volunteer_category'] = railVolunteerCategory;
    data['data_from'] = dataFrom;
    data['name'] = name;
    data['age'] = age;
    data['gender'] = gender;
    data['mobile_number'] = mobileNumber;
    data['email'] = email;
    data['nearest_railway_station'] = nearestRailwayStation;
    data['season_passenger'] = seasonPassenger;
    data['entrain_station'] = entrainStation;
    data['detrain_station'] = detrainStation;
    data['utc_timestamp'] = utcTimestamp;

    return data;
  }
}
