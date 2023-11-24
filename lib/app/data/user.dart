// class User {
//   late final int citizenUuid;
//   late final String username;
//   late final int accountStatus;
//   late final String userCreatedOn;
//   late final int genderType;
//   late final String? fullName;
//   late final String? address;
//   late final int phoneNumber;
//   late final String? emailId;
//   late final bool isVerified;

//   User({
//     required this.citizenUuid,
//     required this.username,
//     required this.accountStatus,
//     required this.userCreatedOn,
//     required this.genderType,
//     this.fullName,
//     this.address,
//     required this.phoneNumber,
//     this.emailId,
//     required this.isVerified,
//   });

//   User.fromJson(Map<String, dynamic> json) {
//     citizenUuid = json['citizen_id'] as int;
//     username = json['username'] as String;
//     accountStatus = json['account_status'] as int;
//     userCreatedOn = json['user_created_on'] as String;
//     genderType = json['gender_type'] as int;
//     fullName = json['full_name'] as String?;
//     address = json['address'] as String?;
//     phoneNumber = json['phone_number'] as int;
//     emailId = json['email_id'] as String?;
//     isVerified = json['is_verified'] as bool;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['citizen_id'] = citizenUuid;
//     data['username'] = username;
//     data['account_status'] = accountStatus;
//     data['user_created_on'] = userCreatedOn;
//     data['gender_type'] = genderType;
//     data['full_name'] = fullName;
//     data['address'] = address;
//     data['phone_number'] = phoneNumber;
//     data['email_id'] = emailId;
//     data['is_verified'] = isVerified;

//     return data;
//   }
// }

class User {
  late final int citizenId;
  late final String username;
  late final int accountStatus;
  late final String createdOn;
  late final int genderType;
  late final String? fullName;
  late final String? address;
  late final int phoneNumber;
  late final String? emailId;
  late final bool isVerified;

  User({
    required this.citizenId,
    required this.username,
    required this.accountStatus,
    required this.createdOn,
    required this.genderType,
    this.fullName,
    this.address,
    required this.phoneNumber,
    this.emailId,
    required this.isVerified,
  });

  User.fromJson(Map<String, dynamic> json) {
    citizenId = json['citizen_id'] as int;
    username = json['username'] as String;
    accountStatus = json['account_status'] as int;
    createdOn = json['created_on'] as String;
    genderType = json['gender_type'] as int;
    fullName = json['full_name'] as String?;
    address = json['address'] as String?;
    phoneNumber = json['phone_number'] as int;
    emailId = json['email_id'] as String?;
    isVerified = json['is_verified'] as bool;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['citizen_id'] = citizenId;
    data['username'] = username;
    data['account_status'] = accountStatus;
    data['created_on'] = createdOn;
    data['gender_type'] = genderType;
    data['full_name'] = fullName;
    data['address'] = address;
    data['phone_number'] = phoneNumber;
    data['email_id'] = emailId;
    data['is_verified'] = isVerified;

    return data;
  }
}
