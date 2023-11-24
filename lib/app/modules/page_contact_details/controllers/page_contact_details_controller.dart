import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/contact_details.dart';
import '../../../routes/app_pages.dart';
import '../../../services/other_services.dart';
import '../../../services/rail_services.dart';
import '../../../util/api_helper/api_const.dart';
import 'page_contact_details_base_controller.dart';

class PageContactDetailsController extends PageContactDetailsBaseController {
  @override
  void onInit() {
    isDataLoaded = loadData();
    super.onInit();
  }

  int? contactsCount = 0;
  String? next = '';
  String? previous = '';
  List? tempListOfContacts = [];

  int? emrContactsCount = 0;
  String? emrNext = '';
  String? emrPrevious = '';
  List? tempListOfEMRContacts = [];
  static final box = GetStorage();

  //******************************On Init invoke function***********************
  Future<bool> loadData() async {
    try {
      if (await box.read(ApiConst.Key) != null) {
        // final homeController = Get.find<HomeController>();
        // contactCategoryTypes = homeController.contactCategoryTypes ??
        //     await RailServices.getContactCategoryType();
        // railwayStaionList = homeController.railwayStaionList ??
        //     await RailServices.getRailwayStationList();

        contactCategoryTypes =
            await box.read(ApiConst.CONTACT_CATEGORY_LIST) == null
                ? await RailServices.getContactCategoryType(isUpdate: true)
                : await RailServices.getContactCategoryType();
        railwayStaionList = await box.read(ApiConst.RAILWAY_STN_LIST) == null
            ? await RailServices.getRailwayStationList(isUpdate: true)
            : await RailServices.getRailwayStationList();

        if (await OtherServices.checkInternetConnection()) {
          await loadContactList();
          await loadEMRContactList();
        } else {
          listOfContacts = [];
          listOfEmergencyContacts = [];
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

  //******************************Load contact list*****************************
  Future<void> loadContactList() async {
    try {
      isContactListLoading = true;

      final String selectedCC = selectedContactCategoryType == null
          ? ''
          : '${selectedContactCategoryType?.id}';
      final String selectedRS =
          selectedRailwayStation == null ? '' : '${selectedRailwayStation?.id}';

      final Map<String, String> queryParam = {
        'railway_station': selectedRS,
        'contacts_category': selectedCC,
      };
      const String apiURL = '';

      apiResponse = await RailServices.getContactList(
        queryParam,
        apiURL,
      );

      contactsCount = apiResponse['count'] as int?;
      next = apiResponse['next'] as String?;
      tempListOfContacts = apiResponse['results'] as List?;
      initialListOfContacts = tempListOfContacts!
          .map(
            (e) => ContactDetails.fromJson(e as Map<String, dynamic>),
          )
          .toList();

      if (tempListOfContacts!.isNotEmpty) {
        listOfContacts.clear();
        if (initialListOfContacts.length > notificationToShow && next != null) {
          for (var i = 0; i < initialListOfContacts.length; i++) {
            listOfContacts.add(initialListOfContacts[i]);
          }
          noMoreContacts = false;
        } else {
          noMoreContacts = true;
          listOfContacts = initialListOfContacts;
        }
      } else {
        listOfContacts.clear();
      }

      isContactListLoading = false;
    } catch (e) {
      if (kDebugMode) rethrow;
      isContactListLoading = false;

      return;
    }
  }

  //******************************Load more contact list************************
  Future<void> loadMoreContacts() async {
    try {
      isMoreContactLoading = true;

      //**My code starts

      final String selectedCC = selectedContactCategoryType == null
          ? ''
          : '${selectedContactCategoryType?.id}';
      final String selectedRS =
          selectedRailwayStation == null ? '' : '${selectedRailwayStation?.id}';

      final Map<String, String> queryParam = {
        'railway_station': selectedRS,
        'contacts_category': selectedCC,
      };
      final String apiURL = next ?? '';

      if (next == null || next == '') {
        tempListOfContacts!.clear();
        noMoreContacts = true;
      } else {
        apiResponse = await RailServices.getContactList(
          queryParam,
          apiURL,
        );

        contactsCount = apiResponse['count'] as int;
        next = apiResponse['next'] as String?;

        final tempListOfContacts = apiResponse['results'] as List;
        moreListOfContacts = tempListOfContacts
            .map(
              (e) => ContactDetails.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }

      //**My code ends

      if (tempListOfContacts!.isNotEmpty) {
        if (moreListOfContacts.length > notificationToShow) {
          for (var i = 0; i < moreListOfContacts.length; i++) {
            listOfContacts.add(moreListOfContacts[i]);
          }
          noMoreContacts = false;
        } else {
          listOfContacts.addAll(moreListOfContacts);
          noMoreContacts = true;
        }
      }

      isMoreContactLoading = false;
    } catch (e) {
      if (kDebugMode) rethrow;
      isMoreContactLoading = false;

      return;
    }
  }

  //******************************Load EMR contact list*************************
  Future<void> loadEMRContactList() async {
    try {
      isEMRContactListLoading = true;

      final Map<String, String> queryParam = {
        'is_emergency': 'true',
      };

      const String apiURL = '';

      apiResponse = await RailServices.getEmergencyContactList(
        queryParam,
        apiURL,
      );

      emrContactsCount = apiResponse['count'] as int?;
      emrNext = apiResponse['next'] as String?;
      tempListOfEMRContacts = apiResponse['results'] as List?;
      initialListOfEMRContacts = tempListOfEMRContacts!
          .map(
            (e) => ContactDetails.fromJson(e as Map<String, dynamic>),
          )
          .toList();

      if (tempListOfEMRContacts!.isNotEmpty) {
        listOfEmergencyContacts.clear();
        if (initialListOfEMRContacts.length > notificationToShow &&
            emrNext != null) {
          for (var i = 0; i < initialListOfEMRContacts.length; i++) {
            listOfEmergencyContacts.add(initialListOfEMRContacts[i]);
          }
          noMoreEMRContacts = false;
        } else {
          noMoreEMRContacts = true;
          listOfEmergencyContacts = initialListOfEMRContacts;
        }
      } else {
        listOfEmergencyContacts.clear();
      }

      isEMRContactListLoading = false;
    } catch (e) {
      if (kDebugMode) rethrow;
      isEMRContactListLoading = false;

      return;
    }
  }

  //******************************Load More EMR contact list********************
  Future<void> loadMoreEMRContacts() async {
    try {
      isMoreEMRContactLoading = true;

      final Map<String, String> queryParam = {
        'is_emergency': 'true',
      };
      final String apiURL = emrNext ?? '';

      if (emrNext == null || emrNext == '') {
        tempListOfEMRContacts!.clear();
        noMoreEMRContacts = true;
      } else {
        apiResponse = await RailServices.getContactList(
          queryParam,
          apiURL,
        );

        emrContactsCount = apiResponse['count'] as int;
        emrNext = apiResponse['next'] as String?;

        final tempListOfEMRContacts = apiResponse['results'] as List;
        moreListOfEMRContacts = tempListOfEMRContacts
            .map(
              (e) => ContactDetails.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }

      if (tempListOfEMRContacts!.isNotEmpty) {
        if (moreListOfEMRContacts.length > notificationToShow) {
          for (var i = 0; i < moreListOfEMRContacts.length; i++) {
            listOfEmergencyContacts.add(moreListOfEMRContacts[i]);
          }
          noMoreEMRContacts = false;
        } else {
          listOfEmergencyContacts.addAll(moreListOfEMRContacts);
          noMoreEMRContacts = true;
        }
      }

      isMoreEMRContactLoading = false;
    } catch (e) {
      if (kDebugMode) rethrow;
      isMoreEMRContactLoading = false;

      return;
    }
  }

  //******************************Filter reset function*************************
  Future<void> resetFilter() async {
    try {
      isContactListLoading = true;

      const String selectedCC = '';
      const String selectedRS = '';

      final Map<String, String> queryParam = {
        'railway_station': selectedRS,
        'contacts_category': selectedCC,
      };

      const String apiURL = '';

      apiResponse = await RailServices.getContactList(
        queryParam,
        apiURL,
      );

      contactsCount = apiResponse['count'] as int?;
      next = apiResponse['next'] as String?;
      tempListOfContacts = apiResponse['results'] as List?;
      initialListOfContacts = tempListOfContacts!
          .map(
            (e) => ContactDetails.fromJson(e as Map<String, dynamic>),
          )
          .toList();

      if (tempListOfContacts!.isNotEmpty) {
        listOfContacts.clear();
        listOfEmergencyContacts.clear();
        if (initialListOfContacts.length > notificationToShow && next != null) {
          for (var i = 0; i < initialListOfContacts.length; i++) {
            if (initialListOfContacts[i].isEmergency == true) {
              listOfEmergencyContacts.add(initialListOfContacts[i]);
            }
            listOfContacts.add(initialListOfContacts[i]);
          }
          noMoreContacts = false;
        } else {
          noMoreContacts = true;
          for (var i = 0; i < initialListOfContacts.length; i++) {
            if (initialListOfContacts[i].isEmergency == true) {
              listOfEmergencyContacts.add(initialListOfContacts[i]);
            }
          }
          listOfContacts = initialListOfContacts;
        }
      } else {
        listOfContacts.clear();
        listOfEmergencyContacts.clear();
      }

      isContactListLoading = false;
    } catch (e) {
      if (kDebugMode) rethrow;
      isContactListLoading = false;

      return;
    }
  }
}
