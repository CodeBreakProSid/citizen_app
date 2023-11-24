class ShopDetails {
  int? id;
  int? shopCategory;
  late final String shopCategoryLabel;
  String? dataFrom;
  late final String name;
  String? ownerName;
  String? aadharNumber;
  late final String contactNumber;
  String? licenceNumber;
  int? railwayStation;
  late final String railwayStationLabel;
  late final int platformNumber;
  double? latitude;
  double? longitude;
  String? utcTimestamp;

  ShopDetails({
    this.id,
    this.shopCategory,
    required this.shopCategoryLabel,
    this.dataFrom,
    required this.name,
    this.ownerName,
    this.aadharNumber,
    required this.contactNumber,
    this.licenceNumber,
    this.railwayStation,
    required this.railwayStationLabel,
    required this.platformNumber,
    this.latitude,
    this.longitude,
    this.utcTimestamp,
  });

  ShopDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    shopCategory = json['shop_category'] as int;
    shopCategoryLabel = json['shop_category_label'] as String;
    dataFrom = json['data_from'] as String;
    name = json['name'] as String;
    ownerName = json['owner_name'] as String;
    aadharNumber = json['aadhar_number'] as String?;
    contactNumber = json['contact_number'] as String;
    licenceNumber = json['licence_number'] as String?;
    railwayStation = json['railway_station'] as int;
    railwayStationLabel = json['railway_station_label'] as String;
    platformNumber = json['platform_number'] as int;
    latitude = json['latitude'] as double;
    longitude = json['longitude'] as double;
    utcTimestamp = json['utc_timestamp'] as String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['shop_category'] = shopCategory;
    data['shop_category_label'] = shopCategoryLabel;
    data['data_from'] = dataFrom;
    data['name'] = name;
    data['owner_name'] = ownerName;
    data['aadhar_number'] = aadharNumber;
    data['contact_number'] = contactNumber;
    data['licence_number'] = licenceNumber;
    data['railway_station'] = railwayStation;
    data['railway_station_label'] = railwayStationLabel;
    data['platform_number'] = platformNumber;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['utc_timestamp'] = utcTimestamp;

    return data;
  }
}
