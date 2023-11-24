import 'package:flutter/foundation.dart';
import 'package:get/get_connect/http/src/multipart/form_data.dart';
import 'package:get_storage/get_storage.dart';

import '../data/ShopLabourDetails.dart';
import '../data/contact_category.dart';
import '../data/district_details.dart';
import '../data/firebase_tocken.dart';
import '../data/incident_report_details.dart';
import '../data/intelligence_report_details.dart';
import '../data/intelligence_type.dart';
import '../data/intruder_alert_details.dart';
import '../data/lonely_passenger_details.dart';
import '../data/lost_property_category.dart';
import '../data/rail_notification.dart';
import '../data/rail_ticket_history_details.dart';
import '../data/rail_volunteer.dart';
import '../data/rail_volunteer_category.dart';
import '../data/railway_policestation_list.dart';
import '../data/railway_station_details.dart';
import '../data/severity_type.dart';
import '../data/shop_category.dart';
import '../data/shop_details.dart';
import '../data/sos_message_details.dart';
import '../data/staff_porter.dart';
import '../data/staff_porter_category.dart';
import '../data/state_list.dart';
import '../data/train_details.dart';
import '../data/train_stop_station_list.dart';
import '../util/api_helper/api_const.dart';
import '../util/api_helper/api_helper.dart';
import '../util/api_urls.dart';
import '../util/global_widgets.dart';

class RailServices {
  static final apiHelper = ApiHelper();
  static final box = GetStorage();

  //***************************Get volunteer category***************************
  static Future<List<RailVolunteerCategory>> getVolunteerCategory({
    bool isUpdate = false,
  }) async {
    try {
      if (!isUpdate) {
        final apiResponse = await box.read(ApiConst.VOLUNTEER_CATEGORY) as List;

        return apiResponse
            .map(
              (e) => RailVolunteerCategory.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }
      final apiResponse = await apiHelper.getData(ApiUrls.VOLUNTEER_CATEGORY);

      if (apiResponse['success'] as bool) {
        final jsonData = apiResponse['data'] as List;

        await box.write(ApiConst.VOLUNTEER_CATEGORY, jsonData);

        return jsonData
            .map(
              (e) => RailVolunteerCategory.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }

      return [];
    } catch (e) {
      if (kDebugMode) rethrow;

      return [];
    }
  }

  //***************************Get district list********************************
  static Future<List<DistrictDetails>> getDistrictList({
    bool isUpdate = false,
  }) async {
    try {
      if (!isUpdate) {
        final apiResponse = await box.read(ApiConst.DISTRICT_LIST) as List;

        return apiResponse
            .map(
              (e) => DistrictDetails.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }
      final apiResponse = await apiHelper.getData(ApiUrls.DISTRICT_LIST);

      if (apiResponse['success'] as bool) {
        final jsonData = apiResponse['data'] as List;

        await box.write(ApiConst.DISTRICT_LIST, jsonData);

        return jsonData
            .map((e) => DistrictDetails.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      if (kDebugMode) rethrow;

      return [];
    }
  }

  //******************************Get train list********************************
  static Future<List<TrainDetails>> getTrainList({
    bool isUpdate = false,
  }) async {
    try {
      if (!isUpdate) {
        final apiResponse = await box.read(ApiConst.TRAIN_LIST) as List;

        return apiResponse
            .map(
              (e) => TrainDetails.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }
      final apiResponse = await apiHelper.getData(ApiUrls.TRAIN_LIST);

      if (apiResponse['success'] as bool) {
        final jsonData = apiResponse['data'] as List;

        await box.write(ApiConst.TRAIN_LIST, jsonData);

        return jsonData
            .map((e) => TrainDetails.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      if (kDebugMode) rethrow;

      return [];
    }
  }

  // //******************************Get train stop station list*******************
  // static Future<List<TrainStopStationList>> getTrainStopStationList({
  //                         bool isUpdate = false,}) async {
  //   try {
  //     if (!isUpdate) {
  //       final apiResponse =
  //           await box.read(ApiConst.TRAIN_STOP_STATION_LIST) as List;

  //       return apiResponse
  //           .map(
  //             (e) => TrainStopStationList.fromJson(e as Map<String, dynamic>),
  //           )
  //           .toList();
  //     }
  //     final apiResponse =
  //         await apiHelper.getData(ApiUrls.TRAIN_STOP_STATION_LIST);

  //     if (apiResponse['success'] as bool) {
  //       final jsonData = apiResponse['data'] as List;

  //       await box.write(ApiConst.TRAIN_STOP_STATION_LIST, jsonData);

  //       return jsonData
  //           .map(
  //             (e) => TrainStopStationList.fromJson(e as Map<String, dynamic>),
  //           )
  //           .toList();
  //     }

  //     return [];
  //   } catch (e) {
  //     if (kDebugMode) rethrow;

  //     return [];
  //   }
  // }

  //******************************Get train stop station list*******************
  static Future<List<TrainStopStationList>> getTrainStopStationList(
    int? trainId,
  ) async {
    try {
      final apiResponse = await apiHelper.getData(
        '${ApiUrls.TRAIN_STOP_STATION_LIST}?train=$trainId',
      );

      if (apiResponse['success'] as bool) {
        final jsonData = apiResponse['data'] as List;

        await box.write(ApiConst.TRAIN_STOP_STATION_LIST, jsonData);

        return jsonData
            .map(
              (e) => TrainStopStationList.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }

      return [];
    } catch (e) {
      if (kDebugMode) rethrow;

      return [];
    }
  }

  //******************************Get railway station list**********************
  static Future<List<RailwayStationDetails>> getRailwayStationList({
    bool isUpdate = false,
  }) async {
    try {
      if (!isUpdate) {
        final apiResponse = await box.read(ApiConst.RAILWAY_STN_LIST) as List;

        return apiResponse
            .map(
              (e) => RailwayStationDetails.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }
      final apiResponse = await apiHelper.getData(ApiUrls.RAILWAY_STN_LIST);

      if (apiResponse['success'] as bool) {
        final jsonData = apiResponse['data'] as List;

        await box.write(ApiConst.RAILWAY_STN_LIST, jsonData);

        return jsonData
            .map(
              (e) => RailwayStationDetails.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }

      return [];
    } catch (e) {
      if (kDebugMode) rethrow;

      return [];
    }
  }

  //******************************Get lost property list************************
  static Future<Map<String, dynamic>> getLostPropertiesList(
    Map<String, String> queryParam,
    String apiUrl,
  ) async {
    try {
      final Map<String, dynamic> apiResponse;
      apiResponse = apiUrl == ''
          ? await apiHelper.getData(
              ApiUrls.LOST_PROPERTY_LIST,
              query: queryParam,
              accessToken: box.read(ApiConst.Key),
            )
          : await apiHelper.getData(
              apiUrl,
              accessToken: box.read(ApiConst.Key),
            );

      if (apiResponse['success'] as bool) {
        final jsonData1 = apiResponse['data'];

        return jsonData1 as Map<String, dynamic>;
      }

      return {};
    } catch (e) {
      if (kDebugMode) rethrow;

      return {};
    }
  }

  //******************************Get contact list******************************
  static Future<Map<String, dynamic>> getContactList(
    Map<String, String> queryParam,
    String apiUrl,
  ) async {
    try {
      final Map<String, dynamic> apiResponse;
      apiResponse = apiUrl == ''
          ? await apiHelper.getData(
              ApiUrls.CONTACT_LIST,
              query: queryParam,
              accessToken: box.read(ApiConst.Key),
            )
          : await apiHelper.getData(
              apiUrl,
              accessToken: box.read(ApiConst.Key),
            );

      if (apiResponse['success'] as bool) {
        final jsonData1 = apiResponse['data'];

        return jsonData1 as Map<String, dynamic>;
      }

      return {};
    } catch (e) {
      if (kDebugMode) rethrow;

      return {};
    }
  }

  //******************************Get emergency contact list********************
  static Future<Map<String, dynamic>> getEmergencyContactList(
    Map<String, String> queryParam,
    String apiUrl,
  ) async {
    try {
      final Map<String, dynamic> apiResponse;
      apiResponse = apiUrl == ''
          ? await apiHelper.getData(
              ApiUrls.EMR_CONTACT_LIST,
              query: queryParam,
              accessToken: box.read(ApiConst.Key),
            )
          : await apiHelper.getData(
              apiUrl,
              accessToken: box.read(ApiConst.Key),
            );

      if (apiResponse['success'] as bool) {
        final jsonData1 = apiResponse['data'];

        return jsonData1 as Map<String, dynamic>;
      }

      return {};
    } catch (e) {
      if (kDebugMode) rethrow;

      return {};
    }
  }

  //******************************Get shop list*********************************
  static Future<Map<String, dynamic>> getShopList(
    Map<String, String> queryParam,
    String apiUrl,
  ) async {
    try {
      final Map<String, dynamic> apiResponse;
      apiResponse = apiUrl == ''
          ? await apiHelper.getData(
              ApiUrls.CREATE_SHOP_LABOUR,
              query: queryParam,
              accessToken: box.read(ApiConst.Key),
            )
          : await apiHelper.getData(
              apiUrl,
              accessToken: box.read(ApiConst.Key),
            );

      if (apiResponse['success'] as bool) {
        final jsonData1 = apiResponse['data'];

        return jsonData1 as Map<String, dynamic>;
      }

      return {};
    } catch (e) {
      if (kDebugMode) rethrow;

      return {};
    }
  }

  //******************************Get staff porter list*********************************
  static Future<Map<String, dynamic>> getStaffPorterList(
    Map<String, String> queryParam,
    String apiUrl,
  ) async {
    try {
      final Map<String, dynamic> apiResponse;
      apiResponse = apiUrl == ''
          ? await apiHelper.getData(
              ApiUrls.CREATE_STAFF_PORTER,
              query: queryParam,
              accessToken: box.read(ApiConst.Key),
            )
          : await apiHelper.getData(
              apiUrl,
              accessToken: box.read(ApiConst.Key),
            );

      if (apiResponse['success'] as bool) {
        final jsonData1 = apiResponse['data'];

        return jsonData1 as Map<String, dynamic>;
      }

      return {};
    } catch (e) {
      if (kDebugMode) rethrow;

      return {};
    }
  }

  //******************************Get all tickets*******************************
  static Future<List<RailTicketHistoryDetails>> getRailTicketStatus(
    Map<String, String> queryParam,
  ) async {
    try {
      final List<RailTicketHistoryDetails> apiResponse1,
          // ignore: avoid_multiple_declarations_per_line
          apiResponse2,
          apiResponse3,
          apiResponse4,
          apiResponse5,
          apiResponse6,
          finalList;

      apiResponse1 = await getLonelyTicketsStatus(queryParam);
      apiResponse2 = await getIntruderTicketStatus(queryParam);
      apiResponse3 = await getIntelligenceTicketStatus(queryParam);
      final Map<String, String> other = {'incident_type': 'Platform'};
      queryParam.addAll(other);
      apiResponse4 = await getIncidentTicketStatus(queryParam);
      final Map<String, String> other1 = {'incident_type': 'Train'};
      queryParam.addAll(other1);
      apiResponse5 = await getIncidentTicketStatus(queryParam);
      final Map<String, String> other2 = {'incident_type': 'Track'};
      queryParam.addAll(other2);
      apiResponse6 = await getIncidentTicketStatus(queryParam);

      // ignore: join_return_with_assignment
      finalList = [
        ...apiResponse1,
        ...apiResponse2,
        ...apiResponse3,
        ...apiResponse4,
        ...apiResponse5,
        ...apiResponse6,
      ];

      return finalList;
    } catch (e) {
      if (kDebugMode) rethrow;

      return [];
    }
  }

  //******************************Get lonely ticket status**********************
  static Future<List<RailTicketHistoryDetails>> getLonelyTicketsStatus(
    Map<String, String> queryParam,
  ) async {
    try {
      final apiResponse = await apiHelper.getData(
        ApiUrls.CREATE_LONELY_PASSENGER,
        query: queryParam,
        accessToken: box.read(ApiConst.Key),
      );

      if (apiResponse['success'] as bool) {
        final jsonData1 = apiResponse['data'];

        // ignore: avoid_dynamic_calls
        final jsonData = jsonData1['results'] as List;

        return jsonData
            .map(
              (e) =>
                  RailTicketHistoryDetails.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }

      return [];
    } catch (e) {
      if (kDebugMode) rethrow;

      return [];
    }
  }

//******************************Get intruder ticket status**********************
  static Future<List<RailTicketHistoryDetails>> getIntruderTicketStatus(
    Map<String, String> queryParam,
  ) async {
    try {
      final apiResponse = await apiHelper.getData(
        ApiUrls.CREATE_NEW_INTRUDER_ALERT,
        query: queryParam,
        accessToken: box.read(ApiConst.Key),
      );

      if (apiResponse['success'] as bool) {
        final jsonData1 = apiResponse['data'];
        // ignore: avoid_dynamic_calls
        final jsonData = jsonData1['results'] as List;

        return jsonData
            .map(
              (e) =>
                  RailTicketHistoryDetails.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }

      return [];
    } catch (e) {
      if (kDebugMode) rethrow;

      return [];
    }
  }

  //************************Get intelligence ticket status**********************
  static Future<List<RailTicketHistoryDetails>> getIntelligenceTicketStatus(
    Map<String, String> queryParam,
  ) async {
    try {
      final apiResponse = await apiHelper.getData(
        ApiUrls.CREATE_INTELLIGENCE_REPORT,
        query: queryParam,
        accessToken: box.read(ApiConst.Key),
      );

      if (apiResponse['success'] as bool) {
        final jsonData1 = apiResponse['data'];
        // ignore: avoid_dynamic_calls
        final jsonData = jsonData1['results'] as List;

        return jsonData
            .map(
              (e) =>
                  RailTicketHistoryDetails.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }

      return [];
    } catch (e) {
      if (kDebugMode) rethrow;

      return [];
    }
  }

  //************************Get railticket history details**********************
  static Future<List<RailTicketHistoryDetails>> getIncidentTicketStatus(
    Map<String, String> queryParam,
  ) async {
    try {
      final apiResponse = await apiHelper.getData(
        ApiUrls.CREATE_NEW_INCIDENT_REPORT,
        query: queryParam,
        accessToken: box.read(ApiConst.Key),
      );

      if (apiResponse['success'] as bool) {
        final jsonData1 = apiResponse['data'];
        // ignore: avoid_dynamic_calls
        final jsonData = jsonData1['results'] as List;

        return jsonData
            .map(
              (e) =>
                  RailTicketHistoryDetails.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }

      return [];
    } catch (e) {
      if (kDebugMode) rethrow;

      return [];
    }
  }

  //************************Get awareness class list****************************
  static Future<Map<String, dynamic>> getAwarenessClassList(
    String apiUrl,
  ) async {
    try {
      final Map<String, dynamic> apiResponse;
      apiResponse = apiUrl == ''
          ? await apiHelper.getData(
              ApiUrls.AWARENESS_CLASS_LIST,
              accessToken: box.read(ApiConst.Key),
            )
          : await apiHelper.getData(
              apiUrl,
              accessToken: box.read(ApiConst.Key),
            );

      if (apiResponse['success'] as bool) {
        final jsonData = apiResponse['data'];

        return jsonData as Map<String, dynamic>;
      }

      return {'Error': 'Bug'};
    } catch (e) {
      if (kDebugMode) rethrow;

      return {'Error': 'Bug'};
    }
  }

  //************************Get rail notificatiom*******************************
  static Future<List<RailNotification>> getRailNotification(
    Map<String, String> queryParam,
  ) async {
    try {
      queryParam.addAll({'ordering': '-date'});
      final apiResponse = await apiHelper.getData(
        ApiUrls.RAIL_NOTIFICATION,
        accessToken: box.read(ApiConst.Key),
        query: queryParam,
      );

      if (apiResponse['success'] as bool) {
        final jsonData = apiResponse['data'] as List;

        return jsonData
            .map(
              (e) => RailNotification.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }

      return [];
    } catch (e) {
      if (kDebugMode) rethrow;

      return [];
    }
  }

  //************************Get safetytip list**********************************
  static Future<Map<String, dynamic>> getSafetyTipList(
    String apiUrl,
  ) async {
    try {
      final Map<String, dynamic> apiResponse;
      apiResponse = apiUrl == ''
          ? await apiHelper.getData(
              ApiUrls.SAFETY_TIP,
              accessToken: box.read(ApiConst.Key),
            )
          : await apiHelper.getData(
              apiUrl,
              accessToken: box.read(ApiConst.Key),
            );
      if (apiResponse['success'] as bool) {
        final jsonData = apiResponse['data'];

        return jsonData as Map<String, dynamic>;
      }

      return {};
    } catch (e) {
      if (kDebugMode) rethrow;

      return {};
    }
  }

  //************************Get inteligence type********************************
  static Future<List<IntelligenceType>> getIntelligenceType({
    bool isUpdate = false,
  }) async {
    try {
      if (!isUpdate) {
        final apiResponse = await box.read(ApiConst.INTELLIGENCE_TYPE) as List;

        return apiResponse
            .map(
              (e) => IntelligenceType.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }
      final apiResponse = await apiHelper.getData(ApiUrls.INTELLIGENCE_TYPE);

      if (apiResponse['success'] as bool) {
        final jsonData = apiResponse['data'] as List;
        box.write(ApiConst.INTELLIGENCE_TYPE, jsonData);

        return jsonData
            .map(
              (e) => IntelligenceType.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }

      return [];
    } catch (e) {
      if (kDebugMode) rethrow;

      return [];
    }
  }

  //************************Get severity type***********************************
  static Future<List<SeverityType>> getSeverityType({
    bool isUpdate = false,
  }) async {
    try {
      if (!isUpdate) {
        final apiResponse = await box.read(ApiConst.SEVERITY_TYPE) as List;

        return apiResponse
            .map(
              (e) => SeverityType.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }
      final apiResponse = await apiHelper.getData(ApiUrls.SEVERITY_TYPE);

      if (apiResponse['success'] as bool) {
        final jsonData = apiResponse['data'] as List;
        box.write(ApiConst.SEVERITY_TYPE, jsonData);

        return jsonData
            .map(
              (e) => SeverityType.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }

      return [];
    } catch (e) {
      if (kDebugMode) rethrow;

      return [];
    }
  }

  //************************Get porter category*********************************
  static Future<List<StaffPorterCategory>> getStaffPorterCategoryType({
    bool isUpdate = false,
  }) async {
    try {
      if (!isUpdate) {
        final apiResponse = await box.read(ApiConst.STAFF_PORTER_TYPE) as List;

        return apiResponse
            .map(
              (e) => StaffPorterCategory.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }
      final apiResponse = await apiHelper.getData(ApiUrls.STAFF_PORTER_TYPE);

      if (apiResponse['success'] as bool) {
        final jsonData = apiResponse['data'] as List;
        box.write(ApiConst.STAFF_PORTER_TYPE, jsonData);

        return jsonData
            .map(
              (e) => StaffPorterCategory.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }

      return [];
    } catch (e) {
      if (kDebugMode) rethrow;

      return [];
    }
  }

  //************************Get shop category***********************************
  static Future<List<ShopCategory>> getShopCategoryType({
    bool isUpdate = false,
  }) async {
    try {
      if (!isUpdate) {
        final apiResponse = await box.read(ApiConst.SHOP_CATEGORY_TYPE) as List;

        return apiResponse
            .map(
              (e) => ShopCategory.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }
      final apiResponse = await apiHelper.getData(ApiUrls.SHOP_CATEGORY_TYPE);

      if (apiResponse['success'] as bool) {
        final jsonData = apiResponse['data'] as List;
        box.write(ApiConst.SHOP_CATEGORY_TYPE, jsonData);

        return jsonData
            .map(
              (e) => ShopCategory.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }

      return [];
    } catch (e) {
      if (kDebugMode) rethrow;

      return [];
    }
  }

  //************************Get contacts category*******************************
  static Future<List<ContactCategory>> getContactCategoryType({
    bool isUpdate = false,
  }) async {
    try {
      if (!isUpdate) {
        final apiResponse =
            await box.read(ApiConst.CONTACT_CATEGORY_LIST) as List;

        return apiResponse
            .map(
              (e) => ContactCategory.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }
      final apiResponse =
          await apiHelper.getData(ApiUrls.CONTACT_CATEGORY_LIST);

      if (apiResponse['success'] as bool) {
        final jsonData = apiResponse['data'] as List;
        box.write(ApiConst.CONTACT_CATEGORY_LIST, jsonData);

        return jsonData
            .map(
              (e) => ContactCategory.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }

      return [];
    } catch (e) {
      if (kDebugMode) rethrow;

      return [];
    }
  }

  //************************Get Lost Property category*******************************
  static Future<List<LostPropertyCategory>> getLostPropertyCategoryType({
    bool isUpdate = false,
  }) async {
    try {
      if (!isUpdate) {
        final apiResponse =
            await box.read(ApiConst.LOST_PROPERTY_CATEGORY_LIST) as List;

        return apiResponse
            .map(
              (e) => LostPropertyCategory.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }
      final apiResponse =
          await apiHelper.getData(ApiUrls.LOST_PROPERTY_CATEGORY_LIST);

      if (apiResponse['success'] as bool) {
        final jsonData = apiResponse['data'] as List;
        box.write(ApiConst.LOST_PROPERTY_CATEGORY_LIST, jsonData);

        return jsonData
            .map(
              (e) => LostPropertyCategory.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }

      return [];
    } catch (e) {
      if (kDebugMode) rethrow;

      return [];
    }
  }

  //************************Get Railway Police Station List*******************************
  static Future<List<RailwayPoliceStationList>> getRailwayPoliceStaionList({
    bool isUpdate = false,
  }) async {
    try {
      if (!isUpdate) {
        final apiResponse = await box.read(ApiConst.POLICE_STN_LIST) as List;

        return apiResponse
            .map(
              (e) =>
                  RailwayPoliceStationList.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }
      final apiResponse = await apiHelper.getData(ApiUrls.POLICE_STN_LIST);

      if (apiResponse['success'] as bool) {
        final jsonData = apiResponse['data'] as List;
        box.write(ApiConst.POLICE_STN_LIST, jsonData);

        return jsonData
            .map(
              (e) =>
                  RailwayPoliceStationList.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }

      return [];
    } catch (e) {
      if (kDebugMode) rethrow;

      return [];
    }
  }

  //************************Get contacts category*******************************
  static Future<List<StateList>> getStateList({
    bool isUpdate = false,
  }) async {
    try {
      if (!isUpdate) {
        final apiResponse = await box.read(ApiConst.STATE_LIST) as List;

        return apiResponse
            .map(
              (e) => StateList.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }
      final apiResponse = await apiHelper.getData(ApiUrls.STATE_LIST);

      if (apiResponse['success'] as bool) {
        final jsonData = apiResponse['data'] as List;
        box.write(ApiConst.STATE_LIST, jsonData);

        return jsonData
            .map(
              (e) => StateList.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }

      return [];
    } catch (e) {
      if (kDebugMode) rethrow;

      return [];
    }
  }

  //************************Create firebase token*******************************
  static Future<FirebaseTocken?> createFirebaseToken(
    FormData formData,
  ) async {
    try {
      final apiResponse = await apiHelper.postData(
        ApiUrls.SEND_FIREBASE_TOCKEN,
        accessToken: box.read(ApiConst.Key),
        formData: formData,
      );

      if (apiResponse['success'] as bool) {
        final jsonData = apiResponse['data'] as Map<String, dynamic>;

        return FirebaseTocken.fromJson(jsonData);
      } else {
        showSnackBar(
          type: SnackbarType.error,
          message: apiResponse['error'] as String,
        );
      }

      return null;
    } catch (e) {
      if (kDebugMode) rethrow;

      return null;
    }
  }

  //************************Create firebase token*******************************
  static Future<List<FirebaseTocken>?> getExistingFirebaseToken(
    int citizenId,
  ) async {
    try {
      final apiResponse = await apiHelper.getData(
        '${ApiUrls.SEND_FIREBASE_TOCKEN}?citizen_id=$citizenId',
        accessToken: box.read(ApiConst.Key),
      );
      if (apiResponse['success'] as bool) {
        final jsonData = apiResponse['data'] as List;

        return jsonData
            .map(
              (e) => FirebaseTocken.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      if (kDebugMode) rethrow;

      return [];
    }
  }

  //************************Update firebase token*******************************
  static Future<FirebaseTocken?> putFirebaseToken(
    FormData formData,
    int? rowId,
  ) async {
    try {
      final apiResponse = await apiHelper.putData(
        '${ApiUrls.SEND_FIREBASE_TOCKEN}$rowId/',
        accessToken: box.read(ApiConst.Key),
        formData: formData,
      );
      if (apiResponse['success'] as bool) {
        final jsonData = apiResponse['data'] as Map<String, dynamic>;

        return FirebaseTocken.fromJson(jsonData);
      } else {
        showSnackBar(
          type: SnackbarType.error,
          message: apiResponse['error'] as String,
        );
      }

      return null;
    } catch (e) {
      if (kDebugMode) rethrow;

      return null;
    }
  }

  //************************Create rsil volunteer*******************************
  static Future<RailVolunteer?> createNewRailVolunteer(
    FormData formData,
  ) async {
    try {
      final apiResponse = await apiHelper.postData(
        ApiUrls.CREATE_RAIL_VOLUNTEER,
        accessToken: box.read(ApiConst.Key),
        formData: formData,
      );
      if (apiResponse['success'] as bool) {
        final jsonData = apiResponse['data'] as Map<String, dynamic>;

        return RailVolunteer.fromJson(jsonData);
      } else {
        showSnackBar(
          type: SnackbarType.error,
          message: apiResponse['error'] as String,
        );
      }

      return null;
    } catch (e) {
      if (kDebugMode) rethrow;

      return null;
    }
  }

  //************************Get existing rail volunteer*************************
  static Future<List<RailVolunteer?>> getExistingRailVolunteer(
    Map<String, String> queryParam, {
    bool isUpdate = false,
  }) async {
    try {
      if (!isUpdate) {
        final apiResponse =
            await box.read(ApiConst.EXISTING_RAIL_VOLUNTEER) as List;

        return apiResponse
            .map(
              (e) => RailVolunteer.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }
      final apiResponse = await apiHelper.getData(
        ApiUrls.CREATE_RAIL_VOLUNTEER,
        query: queryParam,
        accessToken: box.read(ApiConst.Key),
      );

      if (apiResponse['success'] as bool) {
        final jsonData1 = apiResponse['data'];
        // ignore: avoid_dynamic_calls
        final jsonData = jsonData1['results'] as List;
        box.write(ApiConst.EXISTING_RAIL_VOLUNTEER, jsonData);

        return jsonData
            .map(
              (e) => RailVolunteer.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }
      // else {
      //   showSnackBar(
      //     type: SnackbarType.error,
      //     message: apiResponse['error'] as String,
      //   );
      // }

      return [];
    } catch (e) {
      if (kDebugMode) rethrow;

      return [];
    }
  }

  //************************Create shop*****************************************
  static Future<ShopDetails?> createShop(
    FormData formData,
  ) async {
    try {
      final apiResponse = await apiHelper.postData(
        ApiUrls.CREATE_SHOP_LABOUR,
        accessToken: box.read(ApiConst.Key),
        formData: formData,
      );

      if (apiResponse['success'] as bool) {
        final jsonData = apiResponse['data'] as Map<String, dynamic>;

        return ShopDetails.fromJson(jsonData);
      } else {
        showSnackBar(
          type: SnackbarType.error,
          message: apiResponse['error'] as String,
        );
      }

      return null;
    } catch (e) {
      if (kDebugMode) rethrow;

      return null;
    }
  }

  //************************Create Labour***************************************
  static Future<ShopLabourDetails?> createLabour(
    FormData formData,
  ) async {
    try {
      final apiResponse = await apiHelper.postData(
        ApiUrls.SHOP_LABOUR,
        accessToken: box.read(ApiConst.Key),
        formData: formData,
      );
      if (apiResponse['success'] as bool) {
        final jsonData = apiResponse['data'] as Map<String, dynamic>;

        return ShopLabourDetails.fromJson(jsonData);
      } else {
        showSnackBar(
          type: SnackbarType.error,
          message: apiResponse['error'] as String,
        );
      }

      return null;
    } catch (e) {
      if (kDebugMode) rethrow;

      return null;
    }
  }

  //************************Create new staff porter*****************************
  static Future<StaffPorter?> createNewStaffPorter(
    FormData formData,
  ) async {
    try {
      final apiResponse = await apiHelper.postData(
        ApiUrls.CREATE_STAFF_PORTER,
        accessToken: box.read(ApiConst.Key),
        formData: formData,
      );

      if (apiResponse['success'] as bool) {
        final jsonData = apiResponse['data'] as Map<String, dynamic>;

        return StaffPorter.fromJson(jsonData);
      } else {
        showSnackBar(
          type: SnackbarType.error,
          message: apiResponse['error'] as String,
        );
      }

      return null;
    } catch (e) {
      if (kDebugMode) rethrow;

      return null;
    }
  }

  //************************Create new lonely passenger*************************
  static Future<LonelyPassengerDetails?> createNewLonelyPassenger(
    FormData formData,
  ) async {
    try {
      final apiResponse = await apiHelper.postData(
        ApiUrls.CREATE_LONELY_PASSENGER,
        accessToken: box.read(ApiConst.Key),
        formData: formData,
      );

      if (apiResponse['success'] as bool) {
        final jsonData = apiResponse['data'] as Map<String, dynamic>;

        return LonelyPassengerDetails.fromJson(jsonData);
      } else {
        showSnackBar(
          type: SnackbarType.error,
          message: apiResponse['error'] as String,
        );
      }

      return null;
    } catch (e) {
      if (kDebugMode) rethrow;

      return null;
    }
  }

  //************************Create new intelligence*****************************
  static Future<IntelligenceReportDetails?> createNewIntelligenceReport(
    FormData formData,
  ) async {
    try {
      final apiResponse = await apiHelper.postData(
        ApiUrls.CREATE_INTELLIGENCE_REPORT,
        accessToken: box.read(ApiConst.Key),
        formData: formData,
      );
      if (apiResponse['success'] as bool) {
        final jsonData = apiResponse['data'] as Map<String, dynamic>;

        return IntelligenceReportDetails.fromJson(jsonData);
      } else {
        showSnackBar(
          type: SnackbarType.error,
          message: apiResponse['error'] as String,
        );
      }

      return null;
    } catch (e) {
      if (kDebugMode) rethrow;

      return null;
    }
  }

  //************************Create SOS alert************************************
  static Future<SosMessagedetails?> sendSOSMessage(
    FormData formData,
  ) async {
    try {
      final apiResponse = await apiHelper.postData(
        ApiUrls.CREATE_NEW_SOS_MSG,
        accessToken: box.read(ApiConst.Key),
        formData: formData,
      );
      if (apiResponse['success'] as bool) {
        final jsonData = apiResponse['data'] as Map<String, dynamic>;

        return SosMessagedetails.fromJson(jsonData);
      } else {
        showSnackBar(
          type: SnackbarType.error,
          message: apiResponse['error'] as String,
        );
      }

      return null;
    } catch (e) {
      if (kDebugMode) rethrow;

      return null;
    }
  }

  //************************Create new incident*********************************
  static Future<IncidentReportDetails?> createNewIncidentReport(
    FormData formData,
  ) async {
    try {
      final apiResponse = await apiHelper.postData(
        ApiUrls.CREATE_NEW_INCIDENT_REPORT,
        accessToken: box.read(ApiConst.Key),
        formData: formData,
      );
      if (apiResponse['success'] as bool) {
        final jsonData = apiResponse['data'] as Map<String, dynamic>;

        return IncidentReportDetails.fromJson(jsonData);
      } else {
        showSnackBar(
          type: SnackbarType.error,
          message: apiResponse['error'] as String,
        );
      }

      return null;
    } catch (e) {
      if (kDebugMode) rethrow;

      return null;
    }
  }

  //************************Create intruder alert*******************************
  static Future<IntruderAlertDetails?> createNewIntruderAlert(
    FormData formData,
  ) async {
    try {
      final apiResponse = await apiHelper.postData(
        ApiUrls.CREATE_NEW_INTRUDER_ALERT,
        accessToken: box.read(ApiConst.Key),
        formData: formData,
      );
      if (apiResponse['success'] as bool) {
        final jsonData = apiResponse['data'] as Map<String, dynamic>;

        return IntruderAlertDetails.fromJson(jsonData);
      } else {
        showSnackBar(
          type: SnackbarType.error,
          message: apiResponse['error'] as String,
        );
      }

      return null;
    } catch (e) {
      if (kDebugMode) rethrow;

      return null;
    }
  }
}
