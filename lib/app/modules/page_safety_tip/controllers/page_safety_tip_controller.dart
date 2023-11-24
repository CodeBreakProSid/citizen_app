import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/safety_tip.dart';
import '../../../routes/app_pages.dart';
import '../../../services/other_services.dart';
import '../../../services/rail_services.dart';
import '../../../util/api_helper/api_const.dart';
import 'page_safety_tip_base_controller.dart';

class PageSafetyTipController extends PageSafetyTipBaseController {
  @override
  void onInit() {
    isDataLoaded = loadData();
    super.onInit();
  }

  int? safetyListCount = 0;
  String? next = '';
  List? tempListOfSafetyList = [];
  static final box = GetStorage();

  //******************************On Init invoke function***********************
  Future<bool> loadData() async {
    try {
      if (await box.read(ApiConst.Key) != null) {
        //await loadSafetyTipList();

        if (await OtherServices.checkInternetConnection()) {
          await loadSafetyTipList();
        } else {
          listOfSafetyTip = [];
        }

        return true;
      }
      await Get.offAllNamed(Routes.LOGIN);

      return false;
    } catch (e) {
      if (kDebugMode) rethrow;

      return false;
    }
  }

  //******************************Get safety tip list***************************
  Future<void> loadSafetyTipList() async {
    try {
      isSafetyTipListLoading = true;
      const String apiURL = '';
      apiResponse = await RailServices.getSafetyTipList(
        apiURL,
      );

      safetyListCount = apiResponse['count'] as int?;
      next = apiResponse['next'] as String?;
      tempListOfSafetyList = apiResponse['results'] as List?;
      initialListOfSafety = tempListOfSafetyList!
          .map(
            (e) => SafetyTip.fromJson(e as Map<String, dynamic>),
          )
          .toList();

      if (tempListOfSafetyList!.isNotEmpty) {
        listOfSafetyTip.clear();
        if (initialListOfSafety.length > notificationToShow && next != null) {
          for (var i = 0; i < initialListOfSafety.length; i++) {
            listOfSafetyTip.add(initialListOfSafety[i]);
          }
          noMoreSafety = false;
        } else {
          noMoreSafety = true;
          listOfSafetyTip = initialListOfSafety;
        }
      } else {
        listOfSafetyTip.clear();
      }

      isSafetyTipListLoading = false;
    } catch (e) {
      if (kDebugMode) rethrow;
    }
  }

  //******************************Load more awarenessclass**********************
  Future<void> loadMoreAwarenessClassList() async {
    try {
      isMoreSafetyTipListLoading = true;

      final String apiURL = next ?? '';

      if (next == null || next == '') {
        tempListOfSafetyList!.clear();
        noMoreSafety = true;
      } else {
        apiResponse = await RailServices.getSafetyTipList(
          apiURL,
        );

        safetyListCount = apiResponse['count'] as int;
        next = apiResponse['next'] as String?;

        final tempListOfSafetyList = apiResponse['results'] as List;
        moreListOfSafety = tempListOfSafetyList
            .map(
              (e) => SafetyTip.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }

      if (tempListOfSafetyList!.isNotEmpty) {
        if (moreListOfSafety.length > notificationToShow) {
          for (var i = 0; i < moreListOfSafety.length; i++) {
            listOfSafetyTip.add(moreListOfSafety[i]);
          }
          noMoreSafety = false;
        } else {
          listOfSafetyTip.addAll(moreListOfSafety);
          noMoreSafety = true;
        }
      }

      isMoreSafetyTipListLoading = false;
    } catch (e) {
      if (kDebugMode) rethrow;
      isMoreSafetyTipListLoading = false;

      return;
    }
  }
}
