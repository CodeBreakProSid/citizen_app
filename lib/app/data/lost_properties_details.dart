class LostPropertiesDetails {
  late final int id;
  late final int lostPropertyCategory;
  late final String lostPropertyCategoryLabel;
  late final bool lostPropertyStatus;
  late final int keptInPoliceStation;
  late final String policeStationLabel;
  late final String policeStationNumber;
  late final String description;
  late final String foundIn;
  late final String foundOn;
  late final String utcTimestamp;
  late final String? photo;
  late final String? thumbnails;
  late final int? returnedBy;
  late final String? returnedByLabel;
  late final String? returnRemarks;
  late final String? returnTimestamp;

  LostPropertiesDetails({
    required this.id,
    required this.lostPropertyCategory,
    required this.lostPropertyCategoryLabel,
    required this.lostPropertyStatus,
    required this.keptInPoliceStation,
    required this.policeStationLabel,
    required this.policeStationNumber,
    required this.description,
    required this.foundIn,
    required this.foundOn,
    required this.utcTimestamp,
    this.photo,
    this.thumbnails,
    this.returnedBy,
    this.returnedByLabel,
    this.returnRemarks,
    this.returnTimestamp,
  });

  LostPropertiesDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    lostPropertyCategory = json['lost_property_category'] as int;
    lostPropertyCategoryLabel = json['lost_property_category_label'] as String;
    lostPropertyStatus = json['lost_property_status'] as bool;
    keptInPoliceStation = json['kept_in_police_station'] as int;
    policeStationLabel = json['police_station_label'] as String;
    policeStationNumber = json['police_station_number'] as String;
    description = json['description'] as String;
    foundIn = json['found_in'] as String;
    foundOn = json['found_on'] as String;
    utcTimestamp = json['utc_timestamp'] as String;
    photo = json['photo'] as String?;
    thumbnails = json['thumbnails'] as String?;
    returnedBy = json['returned_by'] as int?;
    returnedByLabel = json['returned_by_label'] as String?;
    returnRemarks = json['return_remarks'] as String?;
    returnTimestamp = json['return_timestamp'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['lost_property_category'] = lostPropertyCategory;
    data['lost_property_category_label'] = lostPropertyCategoryLabel;
    data['lost_property_status'] = lostPropertyStatus;
    data['kept_in_police_station'] = keptInPoliceStation;
    data['police_station_label'] = policeStationLabel;
    data['police_station_number'] = policeStationNumber;
    data['description'] = description;
    data['found_in'] = foundIn;
    data['found_on'] = foundOn;
    data['utc_timestamp'] = utcTimestamp;
    data['photo'] = photo;
    data['thumbnails'] = thumbnails;
    data['returned_by'] = returnedBy;
    data['returned_by_label'] = returnedByLabel;
    data['return_remarks'] = returnRemarks;
    data['return_timestamp'] = returnTimestamp;

    return data;
  }
}
