// ignore_for_file: cast_nullable_to_non_nullable

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../../../data/lost_properties_details.dart';
import '../../../routes/app_pages.dart';
import '../../../services/other_services.dart';
import '../../../services/rail_services.dart';
import '../../../util/api_helper/api_const.dart';
import 'page_lost_property_base_controller .dart';

class PageLostPropertyController extends PageLostPropertyBaseController {
  @override
  void onInit() {
    isDataLoaded = loadData();
    super.onInit();
  }

  int? lostPropertyCount = 0;
  String? next = '';
  String? previous = '';
  List? tempListOfLostProperty = [];

  // String selectedRPS = '';
  // String selectedLPC = '';
  // String foundDateFrom = '';
  // String foundDateTo = '';

  static final box = GetStorage();

  //******************************On Init invoke function***********************
  Future<bool> loadData() async {
    try {
      if (await box.read(ApiConst.Key) != null) {
        lostPropertyCategoryTypes =
            await box.read(ApiConst.LOST_PROPERTY_CATEGORY_LIST) == null
                ? await RailServices.getLostPropertyCategoryType(isUpdate: true)
                : await RailServices.getLostPropertyCategoryType();

        for (final element in lostPropertyCategoryTypes) {
          lostCategory.add(
            DropdownMenuItem<String>(
              value: '${element.id}',
              child: Text(
                element.name,
                style: TextStyle(
                  fontSize: 12.sp,
                ),
              ),
            ),
          );
        }

        railwayPoliceStationList =
            await box.read(ApiConst.POLICE_STN_LIST) == null
                ? await RailServices.getRailwayPoliceStaionList(isUpdate: true)
                : await RailServices.getRailwayPoliceStaionList();

        //await loadLostProperties();
        //listOfLostProperties
        if (await OtherServices.checkInternetConnection()) {
          await loadLostProperties();
        } else {
          listOfLostProperties = [];
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

  //******************************Load lost properties**************************
  Future<void> loadLostProperties() async {
    try {
      isLostPropertiesLoading = true;

      final String selectedLPC = selectedLostPropertyCategory == null
          ? ''
          : '$selectedLostPropertyCategory';

      final String selectedRPS = selectedRailwayPoliceStation == null
          ? ''
          : '$selectedRailwayPoliceStation';

      // final String selectedLPC = selectedLostPropertyCategory == null
      //     ? ''
      //     : '${selectedLostPropertyCategory?.id}';

      // final String selectedRPS = selectedRailwayPoliceStation == null
      //     ? ''
      //     : '${selectedRailwayPoliceStation?.id}';

      final String foundDateFrom = selectedFromDate == null
          ? ''
          : DateFormat('yyyy-MM-dd').format(
              selectedFromDate as DateTime,
            );

      final String foundDateTo = selectedToDate == null
          ? ''
          : DateFormat('yyyy-MM-dd').format(
              selectedToDate as DateTime,
            );

      // final String foundDateFrom =
      //     lostPropertyKey.currentState?.fields['fromDate']?.value == null
      //         ? ''
      //         : DateFormat('yyyy-MM-dd').format(
      //             lostPropertyKey.currentState?.fields['fromDate']?.value
      //                 as DateTime,
      //           );

      // final String foundDateTo =
      //     lostPropertyKey.currentState?.fields['toDate']?.value == null
      //         ? ''
      //         : DateFormat('yyyy-MM-dd').format(
      //             lostPropertyKey.currentState?.fields['toDate']?.value
      //                 as DateTime,
      //           );

      final Map<String, String> queryParam = {
        'kept_in_police_station': selectedRPS,
        'lost_property_category': selectedLPC,
        'found_on__gte': foundDateFrom,
        'found_on__lte': foundDateTo,
        'lost_property_status': 'false',
      };

      const String apiURL = '';

      apiResponse = await RailServices.getLostPropertiesList(
        queryParam,
        apiURL,
      );

      lostPropertyCount = apiResponse['count'] as int?;
      next = apiResponse['next'] as String?;
      tempListOfLostProperty = apiResponse['results'] as List?;
      initialListOfLostPropery = tempListOfLostProperty!
          .map(
            (e) => LostPropertiesDetails.fromJson(e as Map<String, dynamic>),
          )
          .toList();

      if (tempListOfLostProperty!.isNotEmpty) {
        listOfLostProperties.clear();
        if (initialListOfLostPropery.length > notificationToShow &&
            next != null) {
          for (var i = 0; i < initialListOfLostPropery.length; i++) {
            listOfLostProperties.add(initialListOfLostPropery[i]);
          }
          noMoreLostProperty = false;
        } else {
          noMoreLostProperty = true;
          listOfLostProperties = initialListOfLostPropery;
        }
      } else {
        listOfLostProperties.clear();
      }

      selectedLostPropertyCategory = null;
      selectedRailwayPoliceStation = null;
      selectedFromDate = null;
      selectedToDate = null;
      isLostPropertiesLoading = false;
    } catch (e) {
      if (kDebugMode) rethrow;
    }
  }

  //******************************Load more lost properties*********************
  Future<void> loadMoreLostProperty() async {
    try {
      isMoreLostPropertiesLoading = true;

      // final String selectedLPC = selectedLostPropertyCategory == null
      //     ? ''
      //     : '${selectedLostPropertyCategory?.id}';

      // final String selectedRPS = selectedRailwayPoliceStation == null
      //     ? ''
      //     : '${selectedRailwayPoliceStation?.id}';

      final String foundDateFrom =
          lostPropertyKey.currentState?.fields['fromDate']?.value == null
              ? ''
              : DateFormat('yyyy-MM-dd').format(
                  lostPropertyKey.currentState?.fields['fromDate']?.value
                      as DateTime,
                );
      final String foundDateTo =
          lostPropertyKey.currentState?.fields['toDate']?.value == null
              ? ''
              : DateFormat('yyyy-MM-dd').format(
                  lostPropertyKey.currentState?.fields['toDate']?.value
                      as DateTime,
                );

      final Map<String, String> queryParam = {
        // 'kept_in_police_station': selectedRPS,
        // 'lost_property_category': selectedLPC,
        'lost_property_category': '',
        'kept_in_police_station': '',
        'found_on__gte': foundDateFrom,
        'found_on__lte': foundDateTo,
        'lost_property_status': 'false',
      };
      final String apiURL = next ?? '';

      if (next == null || next == '') {
        tempListOfLostProperty!.clear();
        noMoreLostProperty = true;
      } else {
        apiResponse = await RailServices.getLostPropertiesList(
          queryParam,
          apiURL,
        );

        lostPropertyCount = apiResponse['count'] as int;
        next = apiResponse['next'] as String?;

        final tempListOfLostProperty = apiResponse['results'] as List;
        moreListOfLostPropery = tempListOfLostProperty
            .map(
              (e) => LostPropertiesDetails.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }

      if (tempListOfLostProperty!.isNotEmpty) {
        if (moreListOfLostPropery.length > notificationToShow) {
          for (var i = 0; i < moreListOfLostPropery.length; i++) {
            listOfLostProperties.add(moreListOfLostPropery[i]);
          }
          noMoreLostProperty = false;
        } else {
          listOfLostProperties.addAll(moreListOfLostPropery);
          noMoreLostProperty = true;
        }
      }

      isMoreLostPropertiesLoading = false;
    } catch (e) {
      if (kDebugMode) rethrow;
      isMoreLostPropertiesLoading = false;

      return;
    }
  }

  //******************************Reset filter**********************************
  Future<void> resetFilter() async {
    try {
      isLostPropertiesLoading = true;

      const String resetSelectedRPS = '';
      const String resetSelectedLPC = '';
      const String resetFoundDateFrom = '';
      const String resetFoundDateTo = '';

      final Map<String, String> queryParam = {
        'kept_in_police_station': resetSelectedRPS,
        'lost_property_category': resetSelectedLPC,
        'found_on__gt': resetFoundDateFrom,
        'found_on__lt': resetFoundDateTo,
        'lost_property_status': 'false',
      };

      const String apiURL = '';

      apiResponse = await RailServices.getLostPropertiesList(
        queryParam,
        apiURL,
      );

      lostPropertyCount = apiResponse['count'] as int?;
      next = apiResponse['next'] as String?;
      tempListOfLostProperty = apiResponse['results'] as List?;
      initialListOfLostPropery = tempListOfLostProperty!
          .map(
            (e) => LostPropertiesDetails.fromJson(e as Map<String, dynamic>),
          )
          .toList();

      if (tempListOfLostProperty!.isNotEmpty) {
        listOfLostProperties.clear();
        if (initialListOfLostPropery.length > notificationToShow &&
            next != null) {
          for (var i = 0; i < initialListOfLostPropery.length; i++) {
            listOfLostProperties.add(initialListOfLostPropery[i]);
          }
          noMoreLostProperty = false;
        } else {
          noMoreLostProperty = true;
          listOfLostProperties = initialListOfLostPropery;
        }
      } else {
        listOfLostProperties.clear();
      }

      isLostPropertiesLoading = false;
    } catch (e) {
      if (kDebugMode) rethrow;
    }
  }
}
