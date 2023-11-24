// ignore_for_file: avoid_dynamic_calls

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../util/api_helper/api_const.dart';
import '../util/api_helper/api_helper.dart';
import '../util/api_urls.dart';
import 'other_services.dart';

class NonSyncServices {
  static final apiHelper = ApiHelper();
  static final box = GetStorage();
  //
  static Future<bool> loadSuveyFroms() async {
    try {
      final listOfServeyForms = await OtherServices.getSurveyForms();
      for (final item in listOfServeyForms) {
        box.write(
          '${SurveyFormConst.SURVEY_ID_TYPE}_${item.formId}',
          await OtherServices.getSurveyFormData(item.formId),
        );
      }

      return true;
    } catch (e) {
      if (kDebugMode) rethrow;
      debugPrint('$e');

      return false;
    }
  }

  static Future<bool> saveSuveyFormData(
    FormData formData,
  ) async {
    try {
      final apiResponse = await apiHelper.postData(
        ApiUrls.SRUVEY_SAVE,
        formData: formData,
        accessToken: box.read(ApiConst.Key),
      );

      if (apiResponse['success'] as bool) {
        // final jsonData = apiResponse['data'] as Map<String, dynamic>;

        return true;
      }

      return false;
    } catch (e) {
      if (kDebugMode) rethrow;

      return false;
    }
  }

  Future<bool> storeNonSynData(Map<String, dynamic> data) async {
    try {
      if (box.read(SurveyFormConst.SURVEY_NONSYNC_LIST) == null) {
        await box.write(SurveyFormConst.SURVEY_NONSYNC_LIST, [data]);

        return true;
      }
      // ignore: cast_nullable_to_non_nullable
      final listOfData = box.read(
        SurveyFormConst.SURVEY_NONSYNC_LIST,
      ) as List;
      listOfData.add(data);
      await box.write(
        SurveyFormConst.SURVEY_NONSYNC_LIST,
        listOfData,
      );

      return true;
    } catch (e) {
      if (kDebugMode) rethrow;
      debugPrint('$e');

      return false;
    }
  }

  Future<List> loadNonSyncData() async {
    try {
      return box.read(
        SurveyFormConst.SURVEY_NONSYNC_LIST,
      ) as List;
    } catch (e) {
      return [];
    }
  }

  Future<void> clearNonSyncData() async {
    try {
      box.write(SurveyFormConst.SURVEY_NONSYNC_LIST, null);
    } catch (e) {
      if (kDebugMode) rethrow;
    }
  }
}
