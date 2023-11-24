// ignore_for_file: prefer_is_empty

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../data/user.dart';
import '../../services/rail_services.dart';
import '../../services/user_services.dart';
import 'forGroundLocalNotification.dart';

class TockenEstablishment {
  static bool isTokenSend         = false;
  static const String deviceType  = 'android';
  static final userService        = UserServices();

  static Future sendToken() async {
    final User? user              = await userService.getUser();
    try {
      isTokenSend                 = true;
      final String userName       = user != null ? user.fullName ?? 
                                                   user.username : '';
      final fcmToken              = await ForgroundLocalNotification.getFcmToken();
      final citizenId             = user?.citizenId;

      final Map<String, dynamic> formData = {
        'name'            : userName,
        'registration_id' : fcmToken,
        'type'            : deviceType,
        'citizen_id'      : citizenId,
      };

      final apiResponse = await RailServices.getExistingFirebaseToken(
                                                                citizenId!,
                                                                );
      if (apiResponse?.length != 0) {
        await RailServices.putFirebaseToken(
          FormData(formData),
          apiResponse?.first.id,
        );
      } else {
        await RailServices.createFirebaseToken(FormData(formData));
      }
    } catch (e) {
      if (kDebugMode) rethrow;

      isTokenSend = false;
    }
  }
}
