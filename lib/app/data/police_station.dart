class PoliceStation {
  late final int stationId;
  late final int geometryId;
  late final int stationCode;
  late final int stationPhoneNumber;
  late final String stationName;
  late final double latitude;
  late final double longitude;

  PoliceStation({
    required this.stationId,
    required this.geometryId,
    required this.stationCode,
    required this.stationPhoneNumber,
    required this.stationName,
    required this.latitude,
    required this.longitude,
  });

  PoliceStation.fromJson(Map<String, dynamic> json) {
    stationId = json['station_id'] as int;
    geometryId = json['geometry_id'] as int;
    stationCode = json['station_code'] as int;
    stationPhoneNumber = json['phone_number'] as int;
    stationName = json['station_name'] as String;
    latitude = json['latitude'] as double;
    longitude = json['longitude'] as double;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['station_id'] = stationId;
    data['geometry_id'] = geometryId;
    data['station_code'] = stationCode;
    data['phone_number'] = stationPhoneNumber;
    data['station_name'] = stationName;
    data['latitude'] = latitude;
    data['longitude'] = longitude;

    return data;
  }
}
