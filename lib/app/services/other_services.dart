import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_connect/http/src/multipart/form_data.dart';
import 'package:get_storage/get_storage.dart';

import '../data/survey_form.dart';
import '../data/user.dart';
import '../util/api_helper/api_const.dart';
import '../util/api_helper/api_helper.dart';
import '../util/api_urls.dart';

class OtherServices {
  static final apiHelper = ApiHelper();
  static final box = GetStorage();

  //****************************************************************************
  static Future<bool> checkInternetConnection() async {
    // ignore: prefer_final_locals
    var connectivityResult = await Connectivity().checkConnectivity();

    return connectivityResult != ConnectivityResult.none;
  }

  //***********************Get gender*******************************************
  static Future<Map<String, dynamic>> getGenders({
    bool isUpdate = false,
  }) async {
    try {
      if (!isUpdate) {
        return await box.read(ApiConst.GENDER_TYPE) as Map<String, dynamic>;
      }
      final apiResponse = await apiHelper.getData(ApiUrls.GENDER);

      if (apiResponse['success'] as bool) {
        final jsonData = apiResponse['data'] as Map<String, dynamic>;
        await box.write(
          ApiConst.GENDER_TYPE,
          jsonData,
        );

        return jsonData;
      }

      return {};
    } catch (e) {
      if (kDebugMode) rethrow;

      return {};
    }
  }

  //***********************Get current Jurisdiction*****************************
  static Future<Map<String, dynamic>> getJurisdiction(
    Map<String, String> queryParam,
  ) async {
    try {
      final apiResponse = await apiHelper.getData(
        ApiUrls.GET_JURISDICTION_DETAILS,
        query: queryParam,
        accessToken: box.read(ApiConst.Key),
      );

      if (apiResponse['success'] as bool) {
        final jsonData = apiResponse['data'] as Map<String, dynamic>;

        return jsonData;
      }

      return {};
    } catch (e) {
      if (kDebugMode) rethrow;

      return {};
    }
  }

  //***********************Get account status***********************************
  static Future<Map<String, dynamic>> getAccountStatus({
    bool isUpdate = false,
  }) async {
    try {
      if (!isUpdate) {
        return await box.read(ApiConst.ACCOUNT_STATUS) as Map<String, dynamic>;
      }
      final apiResponse = await apiHelper.getData(ApiUrls.ACCOUNT_STATUS);

      if (apiResponse['success'] as bool) {
        final jsonData = apiResponse['data'] as Map<String, dynamic>;

        await box.write(
          ApiConst.ACCOUNT_STATUS,
          jsonData,
        );

        return jsonData;
      }

      return {};
    } catch (e) {
      if (kDebugMode) rethrow;

      return {};
    }
  }

  //***********************Get captchaid for all verification*******************
  static Future<String?> getCaptchaId() async {
    try {
      final apiResponse = await apiHelper.getData(ApiUrls.SIGNUP_CAPTCHA_ID);

      if (apiResponse['success'] as bool) {
        final jsonData = apiResponse['data'] as Map<String, dynamic>;

        return jsonData['captcha_id'] as String;
      }

      return null;
    } catch (e) {
      if (kDebugMode) rethrow;

      return null;
    }
  }

  //***********************Get user details*************************************
  static Future<User?> getUserDetails() async {
    try {
      final apiResponse = await apiHelper.getData(
        ApiUrls.USER_DETAILS,
        accessToken: box.read(ApiConst.Key),
      );

      if (apiResponse['success'] as bool) {
        final jsonData = apiResponse['data'] as Map<String, dynamic>;

        return User.fromJson(jsonData);
      }

      return null;
    } catch (e) {
      if (kDebugMode) rethrow;

      return null;
    }
  }

  //***********************Get ticket status************************************
  static Future<Map<String, dynamic>> getTicketStatus({
    bool isUpdate = false,
  }) async {
    try {
      if (!isUpdate) {
        return await box.read(ApiConst.TICKET_STATUS) as Map<String, dynamic>;
      }
      final apiResponse = await apiHelper.getData(ApiUrls.TICKET_STATUS);

      if (apiResponse['success'] as bool) {
        final jsonData = apiResponse['data'] as Map<String, dynamic>;
        await box.write(
          ApiConst.TICKET_STATUS,
          jsonData,
        );

        return jsonData;
      }

      return {};
    } catch (e) {
      if (kDebugMode) rethrow;

      return {};
    }
  }

  //***********************Get phone verification captcha id********************
  static Future<String?> getPhoneCaptchaId() async {
    try {
      final apiResponse = await apiHelper.getData(
        ApiUrls.PHONE_VERIFICATION_CAPTCHA_ID,
        accessToken: box.read(ApiConst.Key),
      );

      if (apiResponse['success'] as bool) {
        final jsonData = apiResponse['data'] as Map<String, dynamic>;

        return jsonData['captcha_id'] as String;
      }

      return null;
    } catch (e) {
      if (kDebugMode) rethrow;

      return null;
    }
  }

  //***********************Get reset password captcha id************************
  static Future<String?> getResetPwrdCaptcha() async {
    try {
      final apiResponse =
          await apiHelper.getData(ApiUrls.RESET_PASSWORD_CAPTCHA_ID);

      if (apiResponse['success'] as bool) {
        final jsonData = apiResponse['data'] as Map<String, dynamic>;

        return jsonData['captcha_id'] as String;
      }

      return null;
    } catch (e) {
      if (kDebugMode) rethrow;

      return null;
    }
  }

  //***********************Get meeting status***********************************
  static Future<Map<String, dynamic>> getMeetingStatus({
    bool isUpdate = false,
  }) async {
    try {
      if (!isUpdate) {
        return await box.read(ApiConst.MEETING_STATE) as Map<String, dynamic>;
      }
      final apiResponse = await apiHelper.getData(ApiUrls.MEETING_STATE);

      if (apiResponse['success'] as bool) {
        final jsonData = apiResponse['data'] as Map<String, dynamic>;
        await box.write(ApiConst.MEETING_STATE, jsonData);

        return jsonData;
      }

      return {};
    } catch (e) {
      if (kDebugMode) rethrow;

      return {};
    }
  }

  //***********************Get notification type********************************
  static Future<Map<String, dynamic>> getNotificationType({
    bool isUpdate = false,
  }) async {
    try {
      if (!isUpdate) {
        return await box.read(ApiConst.NOTIFICATION_TYPE)
            as Map<String, dynamic>;
      }
      final apiResponse = await apiHelper.getData(ApiUrls.NOTIFICATION_TYPE);

      if (apiResponse['success'] as bool) {
        final jsonData = apiResponse['data'] as Map<String, dynamic>;
        await box.write(ApiConst.NOTIFICATION_TYPE, jsonData);

        return jsonData;
      }

      return {};
    } catch (e) {
      if (kDebugMode) rethrow;

      return {};
    }
  }

  //***********************Get survey form**************************************
  static Future<List<SurveyForm>> getSurveyForms({
    bool isUpdate = false,
  }) async {
    try {
      if (!isUpdate) {
        final apiResponse = box.read(SurveyFormConst.SURVEY_FORMS) as List;

        return apiResponse as List<SurveyForm>;
      }
      final apiResponse = await apiHelper.getData(
        ApiUrls.SURVEY_FORMS,
        accessToken: box.read(ApiConst.Key),
      );

      if (apiResponse['success'] as bool) {
        final jsonData = apiResponse['data'] as List;
        final apiResponse0 = jsonData
            .map(
              (e) => SurveyForm.fromJson(e as Map<String, dynamic>),
            )
            .toList();
        box.write(SurveyFormConst.SURVEY_FORMS, apiResponse0);

        return apiResponse0;
      }

      return [];
    } catch (e) {
      if (kDebugMode) rethrow;

      return [];
    }
  }

  //***********************Get survey form data*********************************
  static Future<Map<String, dynamic>> getSurveyFormData(
    int formId, {
    bool isUpdate = true,
  }) async {
    try {
      if (isUpdate) {
        final apiResponse = await apiHelper.getData(
          ApiUrls.SURVEY_FORMS_DATA,
          accessToken: box.read(ApiConst.Key),
          query: {
            'form_id': '$formId',
          },
        );

        if (apiResponse['success'] as bool) {
          return apiResponse['data'] as Map<String, dynamic>;
        }

        return {};
      } else {
        return box.read('${SurveyFormConst.SURVEY_ID_TYPE}_$formId')
            as Map<String, dynamic>;
      }
    } catch (e) {
      if (kDebugMode) rethrow;

      return {};
    }
  }

  //***********************Generate ticket**************************************
  static Future<Map<String, dynamic>> ticketgeneration(
    String trainNo,
    DateTime todate,
  ) async {
    try {
      final apiResponse = await apiHelper.postData(
        ApiUrls.RAILWAY_TICKET,
        formData: FormData({
          'train_id': trainNo,
          'journey_on': todate,
        }),
        accessToken: box.read(ApiConst.Key),
      );

      if (apiResponse['success'] as bool) {
        return apiResponse['data'] as Map<String, dynamic>;
      }

      return {};
    } catch (e) {
      if (kDebugMode) rethrow;

      return {};
    }
  }

  //***********************Save ticket******************************************
  static Future<Map<String, dynamic>> ticketsave(
    String ticketId,
    int formId,
    Map<String, String> query,
  ) async {
    try {
      final apiResponse = await apiHelper.postData(
        ApiUrls.SRUVEY_SAVE,
        formData: FormData({
          'ticket_id': ticketId,
          'form_id': formId,
          'form_data': json.encode(query),
        }),
        accessToken: box.read(ApiConst.Key),
      );

      if (apiResponse['success'] as bool) {
        return apiResponse['data'] as Map<String, dynamic>;
      }

      return {};
    } catch (e) {
      if (kDebugMode) rethrow;

      return {};
    }
  }
}
