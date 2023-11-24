import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../data/meeting_details.dart';
import '../data/meeting_history.dart';
import '../data/notification_channel.dart';
import '../data/police_station.dart';
import '../data/police_station_users.dart';
import '../data/public_services.dart';
import '../data/rail_ticket_details.dart';
import '../data/ticket_details.dart';
import '../data/train.dart';
import '../data/user_notification.dart';
import '../util/api_helper/api_const.dart';
import '../util/api_helper/api_helper.dart';
import '../util/api_urls.dart';
import '../util/global_widgets.dart';

class HomeServices {
  static final apiHelper = ApiHelper();
  static final box = GetStorage();

  //***********************Get police stations**********************************
  static Future<List<PoliceStation>> getPoliceStations({
    bool isUpdate = false,
  }) async {
    try {
      if (!isUpdate) {
        final apiResponse = await box.read(ApiConst.POLICE_STATION) as List;

        return apiResponse
            .map(
              (e) => PoliceStation.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }
      final apiResponse = await apiHelper.getData(ApiUrls.POLICE_STATION);

      if (apiResponse['success'] as bool) {
        final jsonData = apiResponse['data'] as List;
        box.write(ApiConst.POLICE_STATION, jsonData);

        return jsonData
            .map(
              (e) => PoliceStation.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }

      return [];
    } catch (e) {
      if (kDebugMode) rethrow;

      return [];
    }
  }

  //**************************Get police users**********************************
  static Future<List<PoliceStationUsers>> getpoliceStationUsers(
    int? policeStationId,
  ) async {
    try {
      final apiResponse = await apiHelper.getData(
        ApiUrls.POLICE_STATION_USERS,
        query: {'station_id': '$policeStationId'},
      );

      if (apiResponse['success'] as bool) {
        final jsonData = apiResponse['data'] as List;

        return jsonData
            .map(
              (e) => PoliceStationUsers.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }

      return [];
    } catch (e) {
      if (kDebugMode) rethrow;

      return [];
    }
  }

  //**************************Get public services*******************************
  static Future<List<PublicServices>> getPublicServices({
    bool isUpdate = false,
  }) async {
    try {
      if (!isUpdate) {
        final apiResponse = await box.read(ApiConst.PUBLIC_SERVICE) as List;

        return apiResponse
            .map((e) => PublicServices.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      final apiResponse = await apiHelper.getData(ApiUrls.PUBLIC_SERVICES);

      if (apiResponse['success'] as bool) {
        final jsonData = apiResponse['data'] as List;

        await box.write(ApiConst.PUBLIC_SERVICE, jsonData);

        return jsonData
            .map((e) => PublicServices.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      if (kDebugMode) rethrow;

      return [];
    }
  }

  //**************************Get containing police station for user***************
  static Future<PoliceStation?> getContainingPoliceStation(
    Position? currentLocation,
  ) async {
    try {
      final apiResponse = await apiHelper.getData(
        ApiUrls.CONTAINING_POLICE_STATION,
        query: {
          'latitude': '${currentLocation?.latitude}',
          'longitude': '${currentLocation?.longitude}',
        },
        accessToken: box.read(ApiConst.Key),
      );

      if (apiResponse['success'] as bool) {
        final jsonData = apiResponse['data'] as Map<String, dynamic>;

        return PoliceStation.fromJson(jsonData);
      }

      return null;
    } catch (e) {
      if (kDebugMode) rethrow;

      return null;
    }
  }

  //**************************Update citizen location***************************
  static Future<bool> updateMyLocation(
    Position? currentLocation,
  ) async {
    try {
      final apiResponse = await apiHelper.postData(
        ApiUrls.UPDATE_LOCATION,
        formData: FormData({
          'latitude': '${currentLocation?.latitude}',
          'longitude': '${currentLocation?.longitude}',
          'speed': '${currentLocation?.speed}',
          'heading': '${currentLocation?.heading}',
          'timestamp': '${currentLocation?.timestamp.toLocal()}',
        }),
        accessToken: box.read(ApiConst.Key),
      );

      if (apiResponse['success'] as bool) {
        return true;
      }

      return false;
    } catch (e) {
      if (kDebugMode) rethrow;

      return false;
    }
  }

  //**************************Get ticket details********************************
  static Future<List<TicketDetails>> getTicketDetails(
    int ticketId,
    int limit, {
    DateTime? createdBefore,
    DateTime? createdAfter,
  }) async {
    try {
      createdAfter ??= DateTime.utc(1970).toLocal();
      createdBefore ??= DateTime.now().toLocal();

      final apiResponse = await apiHelper.getData(
        ApiUrls.TICKET_CREATED_FOR_ME,
        query: {
          'from_ticket_id': '$ticketId',
          'created_before': '$createdBefore',
          'created_after': '$createdAfter',
          'limit': '$limit',
        },
        accessToken: box.read(ApiConst.Key),
      );

      if (apiResponse['success'] as bool) {
        final jsonData = apiResponse['data'] as List;

        return jsonData
            .map((e) => TicketDetails.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      if (kDebugMode) rethrow;

      return [];
    }
  }

  //**************************Get rail ticket details***************************
  static Future<List<RailTicketDetails>> getRailTicketDetails(
    int ticketId,
    int limit, {
    DateTime? createdBefore,
    DateTime? createdAfter,
  }) async {
    try {
      createdAfter ??= DateTime.utc(1970).toLocal();
      createdBefore ??= DateTime.now().toLocal();

      final apiResponse = await apiHelper.getData(
        ApiUrls.RAIL_TICKET_CREATED_FOR_ME,
        query: {
          'from_ticket_id': '$ticketId',
          'created_before': '$createdBefore',
          'created_after': '$createdAfter',
          'limit': '$limit',
        },
        accessToken: box.read(ApiConst.Key),
      );

      if (apiResponse['success'] as bool) {
        final jsonData = apiResponse['data'] as List;

        return jsonData
            .map((e) => RailTicketDetails.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      if (kDebugMode) rethrow;

      return [];
    }
  }

  //**************************Get uers notification*****************************
  static Future<List<UserNotification>> getUserNotification(
    int limit, {
    int? notificationId,
    DateTime? createdBefore,
    DateTime? createdAfter,
  }) async {
    try {
      notificationId ??= 4294967296;
      createdAfter ??= DateTime.utc(1970).toLocal();
      createdBefore ??= DateTime.now().toLocal();

      final apiResponse = await apiHelper.getData(
        ApiUrls.USER_NOTIFICATION,
        query: {
          'from_notification_id': '$notificationId',
          'created_before': '$createdBefore',
          'created_after': '$createdAfter',
          'limit': '$limit',
        },
        accessToken: box.read(ApiConst.Key),
      );

      if (apiResponse['success'] as bool) {
        final jsonData = apiResponse['data'] as List;

        return jsonData
            .map((e) => UserNotification.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      if (kDebugMode) rethrow;

      return [];
    }
  }

  //**************************Get notification channel**************************
  static Future<NotificationChannel?> notificationJoinChannel() async {
    try {
      final apiResponse = await apiHelper.getData(
        ApiUrls.NOTIFICATION_JOIN_CHANNEL,
        accessToken: box.read(ApiConst.Key),
      );

      if (apiResponse['success'] as bool) {
        final jsonData = apiResponse['data'];

        return NotificationChannel.fromJson(jsonData as Map<String, dynamic>);
      }

      return null;
    } catch (e) {
      if (kDebugMode) rethrow;

      return null;
    }
  }

  //**************************Get meeting history*******************************
  static Future<List<MeetingHistory>> getMeetingHistory(
    int limit, {
    int? meetingId,
    DateTime? createdBefore,
    DateTime? createdAfter,
  }) async {
    try {
      meetingId ??= 429496729600;
      createdAfter ??= DateTime.utc(1970).toLocal();
      createdBefore ??= DateTime.now().toLocal();

      final apiResponse = await apiHelper.getData(
        ApiUrls.MEETING_STARTED_BY_ME,
        query: {
          'from_meeting_id': '$meetingId',
          'created_before': '$createdBefore',
          'created_after': '$createdAfter',
          'limit': '$limit',
        },
        accessToken: box.read(ApiConst.Key),
      );

      if (apiResponse['success'] as bool) {
        final jsonData = apiResponse['data'] as List;

        return jsonData
            .map((e) => MeetingHistory.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      if (kDebugMode) rethrow;

      return [];
    }
  }

  //**************************Get meeting details of officer********************
  static Future<MeetingDetails?> getOfficerMeetingDetails(int officerId) async {
    try {
      final apiResponse = await apiHelper.getData(
        ApiUrls.MEETING_CONNECT_OFFICER,
        query: {
          'officer_id': '$officerId',
        },
        accessToken: box.read(ApiConst.Key),
      );

      if (apiResponse['success'] as bool) {
        final jsonData = MeetingDetails.fromJson(
          apiResponse['data'] as Map<String, dynamic>,
        );

        return jsonData;
      } else {
        showSnackBar(
          type: SnackbarType.warning,
          message: apiResponse['error'] as String,
        );
      }

      return null;
    } catch (e) {
      if (kDebugMode) rethrow;

      return null;
    }
  }

//**************************Get service meeting details*************************
  static Future<MeetingDetails?> getServiceMeetingDetails(
    int? jurisdictionId,
  ) async {
    try {
      final Map<String, dynamic> apiResponse;

      apiResponse = jurisdictionId == null
          ? await apiHelper.postData(
              ApiUrls.MEETING_CONNECT_SERVICE,
              accessToken: box.read(ApiConst.Key),
            )
          : await apiHelper.postData(
              ApiUrls.MEETING_CONNECT_SERVICE,
              formData: FormData({'jurisdiction_id': jurisdictionId}),
              accessToken: box.read(ApiConst.Key),
            );

      if (apiResponse['success'] as bool) {
        final jsonData = MeetingDetails.fromJson(
          apiResponse['data'] as Map<String, dynamic>,
        );

        return jsonData;
      } else {
        showSnackBar(
          type: SnackbarType.warning,
          message: apiResponse['error'] as String,
        );
      }

      return null;
    } catch (e) {
      if (kDebugMode) rethrow;

      return null;
    }
  }

  //**************************Get train details*********************************
  static Future<List<Train>> getTrains({
    bool isUpdate = true,
  }) async {
    try {
      if (!isUpdate) {
        final apiResponse = await box.read(ApiConst.TRAIN) as List;

        return apiResponse
            .map((e) => Train.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      final apiResponse = await apiHelper.getData(ApiUrls.TRAIN);

      if (apiResponse['success'] as bool) {
        final jsonData = apiResponse['data'] as List;
        box.write(ApiConst.TRAIN, jsonData);

        return jsonData
            .map((e) => Train.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      if (kDebugMode) rethrow;

      return [];
    }
  }
}
