// ignore_for_file: avoid_final_parameters

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../util/api_helper/api_const.dart';
import '../util/api_helper/api_helper.dart';
import '../util/api_urls.dart';
import '../util/global_widgets.dart';
import 'other_services.dart';
import 'user_services.dart';

class AuthServices {
  static final apiHelper = ApiHelper();
  static final box = GetStorage();

//***********************Citizen authentification service***********************

//****************************Signup service************************************
  static Future<Either<String, bool>> signup(
    Map<String, String> query,
  ) async {
    try {
      final apiResponse = await apiHelper.postSignup(
        ApiUrls.SIGNUP,
        FormData(query),
      );

      if (apiResponse['success'] as bool) {
        return const Right(true);
      }

      return Left(apiResponse['error'] as String);
    } catch (e) {
      if (kDebugMode) rethrow;

      return Left(e.toString());
    }
  }

  //****************************Login service***********************************
  static Future<Either<String, bool>> login({
    required final String username,
    required final String password,
  }) async {
    try {
      final formData = {
        'username': username,
        'password': password,
      };

      final Map<String, dynamic> apiResponse = await apiHelper.postData(
        ApiUrls.TOKEN,
        formData: formData,
      );

      if (apiResponse['success'] as bool) {
        final jsonData = apiResponse['data'] as Map<String, dynamic>;
        box.write(
          ApiConst.Key,
          '${ApiConst.TOKEN_TYPE} ${jsonData['access_token'] as String}',
        );
        final user = await OtherServices.getUserDetails();
        if (user != null) {
          await UserServices().saveUser(user);
        }

        return const Right(true);
      }

      return Left(apiResponse['error'] as String);
    } catch (e) {
      if (kDebugMode) rethrow;

      return Left(e.toString());
    }
  }

  //****************************Logout service**********************************
  static Future<bool> logout() async {
    try {
      final apiResponse = await apiHelper.deleteData(
        ApiUrls.SIGNOUT,
        accessToken: box.read(ApiConst.Key),
      );
      if (apiResponse['success'] as bool) {
        await box.write(ApiConst.Key, null);
        await UserServices().removeUser();

        return true;
      }
      await box.write(ApiConst.Key, null);
      await UserServices().removeUser();

      return false;
    } catch (e) {
      if (kDebugMode) rethrow;
      await box.write(ApiConst.Key, null);
      await UserServices().removeUser();

      return false;
    }
  }

  //****************************Check validity**********************************
  static Future<bool> checkValidity() async {
    try {
      final apiResponse = await apiHelper.getData(
        ApiUrls.CHECK_VALIDITY,
        accessToken: box.read(ApiConst.Key),
      );
      if (apiResponse['success'] as bool) {
        return true;
      }
      UserServices().removeUser();

      return false;
    } catch (e) {
      if (kDebugMode) rethrow;

      return false;
    }
  }

  //****************************Reset password**********************************
  static Future<bool> resetPassword(
    String captchaId,
    String captchaCode,
    String phoneNumber,
  ) async {
    try {
      final apiResponse = await apiHelper.postData(
        ApiUrls.RESET_PASSWORD,
        formData: FormData(
          {
            'captcha_id': captchaId,
            'captcha_code': captchaCode,
            'phone_number': phoneNumber,
          },
        ),
      );
      if (apiResponse['success'] as bool) {
        return true;
      } else if (apiResponse['error'] != null) {
        showSnackBar(
          type: SnackbarType.error,
          message: apiResponse['error'] as String,
        );
      }

      return false;
    } catch (e) {
      if (kDebugMode) rethrow;

      return false;
    }
  }

  //****************************Update profile**********************************
  static Future<bool> updateProfile(Map<String, dynamic> query) async {
    try {
      final apiResponse = await apiHelper.putData(
        ApiUrls.UPDATE_PROFILE,
        formData: FormData(query),
        accessToken: '${box.read(ApiConst.Key)}',
      );
      if (apiResponse['success'] as bool) {
        return true;
      } else if (apiResponse['error'] != null) {
        showSnackBar(
          type: SnackbarType.error,
          message: apiResponse['error'] as String,
        );
      }

      return false;
    } catch (e) {
      if (kDebugMode) rethrow;

      return false;
    }
  }

  //****************************Change password*********************************
  static Future<bool> changePassword(String password) async {
    try {
      final apiResponse = await apiHelper.putData(
        ApiUrls.UPDATE_PROFILE,
        formData: FormData(
          {
            'password': password,
          },
        ),
        accessToken: '${box.read(ApiConst.Key)}',
      );

      if (apiResponse['success'] as bool) {
        return true;
      } else {
        showSnackBar(
          type: SnackbarType.error,
          message: apiResponse['error'] as String,
        );
      }

      return false;
    } catch (e) {
      if (kDebugMode) rethrow;

      return false;
    }
  }

//****************************Send otp******************************************
  static Future<Map<String, dynamic>?> sentOtp(
    String captchaId,
    String captchaCode,
  ) async {
    try {
      final Map<String, dynamic> apiResponse = await apiHelper.getData(
        ApiUrls.PHONE_VERIFICATION_SENT_OTP,
        query: {
          'captcha_id': captchaId,
          'captcha_code': captchaCode,
        },
        accessToken: box.read(ApiConst.Key),
      );
      if (apiResponse['success'] as bool) {
        return apiResponse['data'] as Map<String, dynamic>;
      } else if (apiResponse['error'] != null) {
        showSnackBar(
          type: SnackbarType.error,
          message: '${apiResponse['error']}',
        );
      }

      return null;
    } catch (e) {
      if (kDebugMode) rethrow;

      return null;
    }
  }

  //****************************Verify otp**************************************
  static Future<bool> verifyOtp(
    String otpId,
    String otpCode,
  ) async {
    try {
      final Map<String, dynamic> apiResponse = await apiHelper.postData(
        ApiUrls.PHONE_VERIFICATION_VERIFY_OTP,
        formData: FormData(
          {
            'otp_id': otpId,
            'otp_code': otpCode,
          },
        ),
        accessToken: box.read(ApiConst.Key),
      );
      if (apiResponse['success'] as bool) {
        return true;
      } else if (apiResponse['error'] != null) {
        showSnackBar(
          type: SnackbarType.error,
          message: '${apiResponse['error']}',
        );
      }

      return false;
    } catch (e) {
      if (kDebugMode) rethrow;

      return false;
    }
  }

  //****************************Connect Web socket******************************
  static WebSocketChannel? connectWebSocket() {
    try {
      final String accessToken = box.read(ApiConst.Key) as String;
      final String paraData = 'access_token=${accessToken.split(' ')[1]}';
      final String url = '${ApiUrls.SOCKET_URL}$paraData';

      return IOWebSocketChannel.connect(url);
    } catch (e) {
      if (kDebugMode) rethrow;

      return null;
    }
  }
}
