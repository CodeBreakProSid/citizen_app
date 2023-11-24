// ignore_for_file: file_names

class ShopLabourDetails {
  int? id;
  int? shop;
  String? shopLabel;
  String? name;
  String? gender;
  String? mobileNumber;
  String? aadharNumber;
  String? address;
  String? nativePoliceStation;
  int? nativeState;
  String? nativeStateLabel;
  bool? migrantOrNot;
  String? utcTimestamp;

  ShopLabourDetails({
    this.id,
    this.shop,
    this.shopLabel,
    this.name,
    this.gender,
    this.mobileNumber,
    this.aadharNumber,
    this.address,
    this.nativePoliceStation,
    this.nativeState,
    this.nativeStateLabel,
    this.migrantOrNot,
    this.utcTimestamp,
  });

  ShopLabourDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    shop = json['shop'] as int;
    shopLabel = json['shop_label'] as String;
    name = json['name'] as String;
    gender = json['gender'] as String;
    mobileNumber = json['mobile_number'] as String;
    aadharNumber = json['aadhar_number'] as String?;
    address = json['address'] as String;
    nativePoliceStation = json['native_police_station'] as String;
    nativeState = json['native_state'] as int;
    nativeStateLabel = json['native_state_label'] as String;
    migrantOrNot = json['migrant_or_not'] as bool;
    utcTimestamp = json['utc_timestamp'] as String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['shop'] = shop;
    data['shop_label'] = shopLabel;
    data['name'] = name;
    data['gender'] = gender;
    data['mobile_number'] = mobileNumber;
    data['aadhar_number'] = aadharNumber;
    data['address'] = address;
    data['native_police_station'] = nativePoliceStation;
    data['native_state'] = nativeState;
    data['native_state_label'] = nativeStateLabel;
    data['migrant_or_not'] = migrantOrNot;
    data['utc_timestamp'] = utcTimestamp;

    return data;
  }
}
