class PoliceStationUsers {
  late final int officerUuid;
  late final String username;
  late final int genderType;
  late final String? fullName;
  late final int phoneNumber;
  late final String? emailId;

  PoliceStationUsers({
    required this.officerUuid,
    required this.username,
    required this.genderType,
    this.fullName,
    required this.phoneNumber,
    this.emailId,
  });

  PoliceStationUsers.fromJson(Map<String, dynamic> json) {
    officerUuid = json['officer_id'] as int;
    username = json['username'] as String;
    genderType = json['gender_type'] as int;
    fullName = json['full_name'] as String?;
    phoneNumber = json['phone_number'] as int;
    emailId = json['email_id'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['officer_id'] = officerUuid;
    data['username'] = username;
    data['gender_type'] = genderType;
    data['full_name'] = fullName;
    data['phone_number'] = phoneNumber;
    data['email_id'] = emailId;

    return data;
  }
}
