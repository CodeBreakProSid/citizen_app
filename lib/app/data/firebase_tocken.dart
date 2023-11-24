class FirebaseTocken {
  int? id;
  String? name;
  bool? active;
  String? dateCreated;
  String? deviceId;
  String? registrationId;
  String? type;
  String? citizenId;
  String? dataFrom;

  FirebaseTocken({
    this.id,
    required this.name,
    this.active,
    this.dateCreated,
    this.deviceId,
    required this.registrationId,
    required this.type,
    required this.citizenId,
    this.dataFrom,
  });

  FirebaseTocken.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    name = json['name'] as String;
    active = json['active'] as bool?;
    dateCreated = json['date_created'] as String?;
    deviceId = json['device_id'] as String?;
    registrationId = json['registration_id'] as String;
    type = json['type'] as String;
    citizenId = json['citizen_id'] as String;
    dataFrom = json['data_from'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['active'] = active;
    data['date_created'] = dateCreated;
    data['device_id'] = deviceId;
    data['registration_id'] = registrationId;
    data['type'] = type;
    data['citizen_id'] = citizenId;
    data['data_from'] = dataFrom;

    return data;
  }
}
