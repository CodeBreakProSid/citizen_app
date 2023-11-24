import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/awareness_class.dart';
import '../../../routes/app_pages.dart';
import '../../../services/other_services.dart';
import '../../../services/rail_services.dart';
import '../../../util/api_helper/api_const.dart';
import 'page_awareness_class_base_controller.dart';

class PageAwarenessClassController extends PageAwarenessClassBaseController {
  @override
  void onInit() {
    isDataLoaded = loadData();
    super.onInit();
  }

  int? awarenessListCount = 0;
  String? next = '';
  List? tempListOfAwarenessList = [];

  static final box = GetStorage();

  //******************************On Init invoke function***********************
  Future<bool> loadData() async {
    try {
      if (await box.read(ApiConst.Key) != null) {
        if (await OtherServices.checkInternetConnection()) {
          await loadAwarenessClassList();
        } else {
          listOfAwarenessClass = [];
        }
        //await loadAwarenessClassList();

        return true;
      }
      await Get.offAllNamed(Routes.LOGIN);

      return false;
    } catch (e) {
      if (kDebugMode) rethrow;

      return false;
    }
  }

  //******************************Get awarenessclass list***********************
  Future<void> loadAwarenessClassList() async {
    try {
      isAwarenessClassListLoading = true;
      const String apiURL = '';
      apiResponse = await RailServices.getAwarenessClassList(
        apiURL,
      );

      awarenessListCount = apiResponse['count'] as int?;
      next = apiResponse['next'] as String?;
      tempListOfAwarenessList = apiResponse['results'] as List?;
      initialListOfAwareness = tempListOfAwarenessList!
          .map(
            (e) => AwarenessClass.fromJson(e as Map<String, dynamic>),
          )
          .toList();

      if (tempListOfAwarenessList!.isNotEmpty) {
        listOfAwareness.clear();
        if (initialListOfAwareness.length > notificationToShow &&
            next != null) {
          for (var i = 0; i < initialListOfAwareness.length; i++) {
            listOfAwareness.add(initialListOfAwareness[i]);
          }
          noMoreAwareness = false;
        } else {
          noMoreAwareness = true;
          listOfAwareness = initialListOfAwareness;
        }
      } else {
        listOfAwareness.clear();
      }

      isAwarenessClassListLoading = false;
    } catch (e) {
      if (kDebugMode) rethrow;
    }
  }

  //******************************Load more awarenessclass**********************
  Future<void> loadMoreAwarenessClassList() async {
    try {
      isMoreAwarenessClassListLoading = true;

      final String apiURL = next ?? '';

      if (next == null || next == '') {
        tempListOfAwarenessList!.clear();
        noMoreAwareness = true;
      } else {
        apiResponse = await RailServices.getAwarenessClassList(
          apiURL,
        );

        awarenessListCount = apiResponse['count'] as int;
        next = apiResponse['next'] as String?;

        final tempListOfAwarenessList = apiResponse['results'] as List;
        moreListOfAwareness = tempListOfAwarenessList
            .map(
              (e) => AwarenessClass.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }

      if (tempListOfAwarenessList!.isNotEmpty) {
        if (moreListOfAwareness.length > notificationToShow) {
          for (var i = 0; i < moreListOfAwareness.length; i++) {
            listOfAwareness.add(moreListOfAwareness[i]);
          }
          noMoreAwareness = false;
        } else {
          listOfAwareness.addAll(moreListOfAwareness);
          noMoreAwareness = true;
        }
      }

      isMoreAwarenessClassListLoading = false;
    } catch (e) {
      if (kDebugMode) rethrow;
      isMoreAwarenessClassListLoading = false;

      return;
    }
  }
}
