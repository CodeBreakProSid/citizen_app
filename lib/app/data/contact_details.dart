class ContactDetails {
  late final int id;
  late final int policeStation;
  late final String policeStationLabel;
  late final int district;
  late final String districtLabel;
  late final int railwayStation;
  late final String railwayStationLabel;
  late final int contactsCategory;
  late final String contactsCategoryLabel;
  late final String name;
  late final String contactNumber;
  late final String? contactEmail;
  late final String remarks;
  late final double? latitude;
  late final double? longitude;
  late final String utcTimestamp;
  late final int addedBy;
  late final bool? isEmergency;

  ContactDetails({
    required this.id,
    required this.policeStation,
    required this.policeStationLabel,
    required this.district,
    required this.districtLabel,
    required this.railwayStation,
    required this.railwayStationLabel,
    required this.contactsCategory,
    required this.contactsCategoryLabel,
    required this.name,
    required this.contactNumber,
    required this.contactEmail,
    required this.remarks,
    this.latitude,
    this.longitude,
    required this.utcTimestamp,
    required this.addedBy,
    required this.isEmergency,
  });

  ContactDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    policeStation = json['police_station'] as int;
    policeStationLabel = json['police_station_label'] as String;
    district = json['district'] as int;
    districtLabel = json['district_label'] as String;
    railwayStation = json['railway_station'] as int;
    railwayStationLabel = json['railway_station_label'] as String;
    contactsCategory = json['contacts_category'] as int;
    contactsCategoryLabel = json['contacts_category_label'] as String;
    name = json['name'] as String;
    contactNumber = json['contact_number'] as String;
    contactEmail = json['email'] as String?;
    remarks = json['remarks'] as String;
    latitude = json['latitude'] as double?;
    longitude = json['longitude'] as double?;
    utcTimestamp = json['utc_timestamp'] as String;
    addedBy = json['added_by'] as int;
    isEmergency = json['is_emergency'] as bool;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['police_station'] = policeStation;
    data['police_station_label'] = policeStationLabel;
    data['district'] = district;
    data['district_label'] = districtLabel;
    data['railway_station'] = railwayStation;
    data['railway_station_label'] = railwayStationLabel;
    data['contacts_category'] = contactsCategory;
    data['contacts_category_label'] = contactsCategoryLabel;
    data['name'] = name;
    data['contact_number'] = contactNumber;
    data['email'] = contactEmail;
    data['remarks'] = remarks;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['utc_timestamp'] = utcTimestamp;
    data['added_by'] = addedBy;
    data['is_emergency'] = isEmergency;

    return data;
  }
}
