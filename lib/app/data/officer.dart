class Officer {
  late final String officerUuid;
  late final String username;
  late final int genderType;
  late final String? fullName;
  late final String phoneNumber;
  late final String? emailId;

  Officer({
    required this.officerUuid,
    required this.username,
    required this.genderType,
    this.fullName,
    required this.phoneNumber,
    this.emailId,
  });

  Officer.fromJson(Map<String, dynamic> json) {
    officerUuid = json['officer_uuid'] as String;
    username = json['username'] as String;
    genderType = json['gender_type'] as int;
    fullName = json['full_name'] as String?;
    phoneNumber = json['phone_number'] as String;
    emailId = json['email_id'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['officer_uuid'] = officerUuid;
    data['username'] = username;
    data['gender_type'] = genderType;
    data['full_name'] = fullName;
    data['phone_number'] = phoneNumber;
    data['email_id'] = emailId;

    return data;
  }
}
