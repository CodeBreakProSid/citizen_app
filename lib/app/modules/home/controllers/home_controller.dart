// ignore_for_file: avoid_print, prefer_final_locals, join_return_with_assignment

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/police_station.dart';
import '../../../data/rail_notification.dart';
import '../../../data/rail_volunteer.dart';
import '../../../routes/app_pages.dart';
import '../../../services/auth_services.dart';
import '../../../services/home_services.dart';
import '../../../services/other_services.dart';
import '../../../services/rail_services.dart';
import '../../../util/api_helper/api_const.dart';
import '../../../util/global_widgets.dart';
import 'home_base_controller.dart';

class HomeController extends HomeBaseController {
  @override
  void onInit() {
    super.onInit();
    isDataLoaded = loadData();
  }

  // @override
  // void onReady() {
  //   onReadyFunction();
  //   super.onReady();
  // }

  //******************Local variables*******************************************
  List<RailNotification> tempListOfRailNotification = [];
  int contactsCount = 0;
  String? next = '';
  static final box = GetStorage();

  //******************************On Init invoke function***********************
  Future<bool> loadData() async {
    try {
      if (await box.read(ApiConst.Key) != null) {
        user = await userServices.getUser();
        userName = user != null ? user!.fullName ?? user!.username : '';

        policeStations = await box.read(ApiConst.POLICE_STATION) == null
            ? await HomeServices.getPoliceStations(isUpdate: true)
            : await HomeServices.getPoliceStations();

        ticketStatus = await box.read(ApiConst.TICKET_STATUS) == null
            ? await OtherServices.getTicketStatus(isUpdate: true)
            : await OtherServices.getTicketStatus();

        //My Code Start
        final Map<String, String> queryParam = {
          'citizen_id': '${user?.citizenId}',
        };

        // registeredRailvolunteerDetails =
        //     (await RailServices.getExistingRailVolunteer(queryParam))
        //         .cast<RailVolunteer>();
        //My Code End

        // await TockenEstablishment.sendToken();

        registeredRailvolunteerDetails =
            (await RailServices.getExistingRailVolunteer(
          queryParam,
          isUpdate: true,
        ))
                .cast<RailVolunteer>();

        // registeredRailvolunteerDetails =
        //     await box.read(ApiConst.EXISTING_RAIL_VOLUNTEER) == null
        //         ? (await RailServices.getExistingRailVolunteer(
        //             queryParam,
        //             isUpdate: true,
        //           ))
        //             .cast<RailVolunteer>()
        //         : (await RailServices.getExistingRailVolunteer(queryParam))
        //             .cast<RailVolunteer>();



        //await getNearestPoliceStation();

        currentLocation = await getCurrentLocation();
        //print(currentLocation);
        if (currentLocation != null) {
          nearestStaion = await HomeServices.getContainingPoliceStation(
            currentLocation,
          );
          selectedPoliceStation = nearestStaion;
        } else {
          nearestStaion = null;
          selectedPoliceStation = policeStations.first;
        }

        //await updateLiveLocation();
        await loadNotification();
        await loadRailNotification();

        await loadCallHistory();
        await loadTickets(startingTicketId);

        return true;
      }
      showSnackBar(
        type: SnackbarType.warning,
        message: 'Please login again',
      );
      await Get.offAllNamed(Routes.LOGIN);

      return false;
    } catch (e) {
      if (kDebugMode) rethrow;
      Get.offAllNamed(Routes.ROOT);

      return false;
    }
  }

  // //******************************Fetch nearest police station******************
  // Future<PoliceStation?> getNearestPoliceStation() async {
  //   try {
  //     currentLocation = await getCurrentLocation();
  //     if (currentLocation != null) {
  //       nearestStaion = await HomeServices.getContainingPoliceStation(
  //         currentLocation,
  //       );
  //
  //       return nearestStaion;
  //     }else {
  //       nearestStaion = null;
  //       return policeStations.first;
  //     }
  //   } catch (e) {
  //       await Geolocator.openLocationSettings();
  //       return null;
  //   }
  // }

  //******************************Send SOS function*****************************
  Future<void> submitSosMessage() async {
    try {
      currentLocation = await getCurrentLocation();
      sosMessageFormKey.currentState?.save();

      final String sosMessage =
          '${sosMessageFormKey.currentState?.fields['sosMessage']?.value}';

      double? latitude = currentLocation?.latitude;

      double? longitude = currentLocation?.longitude;

      final Map<String, dynamic> formData = {
        'data_from': ApiConst.API_CALL_FROM,
        'sos_message': sosMessage,
        'latitude': latitude,
        'longitude': longitude,
        'utc_timestamp': utcFormat.format(
          DateTime.parse(
            '${DateTime.now()}',
          ),
        ),
        'citizen_id': user?.citizenId,
      };

      await RailServices.sendSOSMessage(
        FormData(formData),
      ).then((value) {
        if (value != null) {
          Get.offAllNamed(Routes.HOME);
          showSnackBar(
            type: SnackbarType.success,
            message: 'SOS message send successfully',
          );
        }
      });
    } catch (e) {
      if (kDebugMode) rethrow;
    }
  }

  //******************************Load ticket function**************************
  Future<void> loadTickets(int fromTicketId) async {
    isTicketLoading = true;
    //await Future.delayed(const Duration(seconds: 1));
    isInternetAvailable = await OtherServices.checkInternetConnection();
    // tickets = await HomeServices.getTicketDetails(
    //   fromTicketId,
    //   10,
    // );
    tickets = isInternetAvailable
        ? await HomeServices.getTicketDetails(
            fromTicketId,
            10,
          )
        : [];
    isTicketLoading = false;
  }

  //******************************make phonecall function***********************
  Future<void> makePhoneCall(String number) async {
    final url = Uri.parse('tel:$number');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  //******************************SOS phonecall function************************
  Future<void> sosPhonecall(String number) async {
    final url = Uri.parse('tel:$number');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  //******************************Load call history function********************
  Future<void> loadCallHistory() async {
    isCallHistoryLoading = true;
    //await Future.delayed(const Duration(seconds: 1));
    isInternetAvailable = await OtherServices.checkInternetConnection();
    meetingState = await box.read(ApiConst.MEETING_STATE) == null
        ? await OtherServices.getMeetingStatus(isUpdate: true)
        : await OtherServices.getMeetingStatus();
    meetings =
        isInternetAvailable ? await HomeServices.getMeetingHistory(10) : [];

    isCallHistoryLoading = false;
  }

  //*********************Nearest police station google map route****************
  Future<void> policeStationNavigation(PoliceStation? policeStation) async {
    final url = Uri.parse(
      'https://maps.google.com/?q=${policeStation?.latitude},${policeStation?.longitude}',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalNonBrowserApplication);
    } else {
      showSnackBar(
        type: SnackbarType.error,
        message: 'location service not found, try agian.',
      );
    }
  }

  //**************************Get current location******************************
  Future<Position?> getCurrentLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!await Permission.location.isGranted) {
        return null;
      }
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
      }

      return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      return null;
    }
  }

  //*******************************Logout function******************************
  Future<void> logout() async {
    loggingout = true;
    await AuthServices.logout();
    await Get.offAllNamed(Routes.LOGIN);
    loggingout = false;
  }

  //*******************************Load rail notification***********************
  Future<bool> loadRailNotification() async {
    railNotificationIsLoading = true;
    try {
      final Map<String, String> queryParam = {
        'citizen_id': '${user?.citizenId}',
      };
      final List<RailNotification> apiResponse =
          await RailServices.getRailNotification(
        queryParam,
      );

      tempListOfRailNotification = apiResponse;

      if (tempListOfRailNotification.isNotEmpty) {
        if (tempListOfRailNotification.length > notificationToShow) {
          for (var i = 0; i < tempListOfRailNotification.length; i++) {
            railNotification.add(tempListOfRailNotification[i]);
          }
          noMoreNotification = false;
        } else {
          noMoreNotification = true;
          railNotification = tempListOfRailNotification;
        }
      } else {
        railNotification.clear();
      }

      railNotificationIsLoading = false;

      return true;
    } catch (e) {
      if (kDebugMode) rethrow;
      railNotification = [];
      railNotificationIsLoading = false;

      return false;
    }
  }

  //*******************************Load more rail notification******************
  Future<void> loadMoreRailNotification() async {
    try {
      isMoreNotificationLoading = true;
      notificationFormKey.currentState?.save();
      final apiResponse = await HomeServices.getUserNotification(
        notificationToShow,
        createdAfter: notificationFormKey
            .currentState?.fields['from_date']?.value as DateTime?,
        createdBefore: notificationFormKey
            .currentState?.fields['to_date']?.value as DateTime?,
        notificationId: notificationStartId,
      );

      if (apiResponse.isNotEmpty) {
        if (apiResponse.length > notificationToShow) {
          for (var i = 0; i < apiResponse.length - 1; i++) {
            userNotification.add(apiResponse[i]);
          }
          notificationStartId = apiResponse.last.notificationId;
          noMoreNotification = false;
        } else {
          noMoreNotification = true;
          userNotification.addAll(apiResponse);
          notificationStartId = maxInt;
        }
      }
      isMoreNotificationLoading = false;
    } catch (e) {
      if (kDebugMode) rethrow;
      isMoreNotificationLoading = false;

      return;
    }
  }

  //*******************************Load notification function*******************
  Future<bool> loadNotification({
    DateTime? createdBefore,
    DateTime? createdAfter,
  }) async {
    notificationIsLoading = true;
    try {
      final apiResponse = await HomeServices.getUserNotification(
        notificationToShow + 1,
        createdBefore: createdBefore,
        createdAfter: createdAfter,
      );
      if (apiResponse.isNotEmpty) {
        notificationType = await OtherServices.getNotificationType();
        if (apiResponse.length > notificationToShow) {
          for (var i = 0; i < apiResponse.length - 1; i++) {
            userNotification.add(apiResponse[i]);
          }
          notificationStartId = apiResponse.last.notificationId;
          noMoreNotification = false;
        } else {
          noMoreNotification = true;
          userNotification = apiResponse;
          notificationStartId = maxInt;
        }
      }
      notificationIsLoading = false;

      return true;
    } catch (e) {
      if (kDebugMode) rethrow;
      userNotification = [];
      notificationIsLoading = false;

      return false;
    }
  }

  //**************************Load more notification function*******************
  Future<void> loadMoreNotification() async {
    try {
      isMoreNotificationLoading = true;
      notificationFormKey.currentState?.save();
      final apiResponse = await HomeServices.getUserNotification(
        notificationToShow,
        createdAfter: notificationFormKey
            .currentState?.fields['from_date']?.value as DateTime?,
        createdBefore: notificationFormKey
            .currentState?.fields['to_date']?.value as DateTime?,
        notificationId: notificationStartId,
      );

      if (apiResponse.isNotEmpty) {
        if (apiResponse.length > notificationToShow) {
          for (var i = 0; i < apiResponse.length - 1; i++) {
            userNotification.add(apiResponse[i]);
          }
          notificationStartId = apiResponse.last.notificationId;
          noMoreNotification = false;
        } else {
          noMoreNotification = true;
          userNotification.addAll(apiResponse);
          notificationStartId = maxInt;
        }
      }
      isMoreNotificationLoading = false;
    } catch (e) {
      if (kDebugMode) rethrow;
      isMoreNotificationLoading = false;

      return;
    }
  }

  //**************************Live location update function*********************
  Future<void> updateLiveLocation() async {
    if (GetPlatform.isAndroid) {
      locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1,
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationTitle: 'Janamaithri Live Location',
          notificationText: 'Location sharing in progress',
          enableWakeLock: true,
        ),
      );
    } else if (GetPlatform.isIOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.fitness,
        distanceFilter: 1,
        pauseLocationUpdatesAutomatically: true,
      );
    } else {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1,
      );
    }

    if (await Geolocator.isLocationServiceEnabled()) {
      positionStream =
          Geolocator.getPositionStream(locationSettings: locationSettings)
              .listen(
        (event) {
          HomeServices.updateMyLocation(event);
        },
        onDone: () async {
          await positionStream.cancel();
          await showLocationErrorMessage();
          debugPrint('Live location stopped');
        },
        onError: (event) async {
          await positionStream.cancel();
          await showLocationErrorMessage();
          debugPrint('$event');
        },
        cancelOnError: true,
      );
    } else {
      await Geolocator.openLocationSettings();
      await updateLiveLocation();
    }
  }

  //**************************Location error function***************************
  Future<void> showLocationErrorMessage() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'live_location',
      'LiveLocation',
      onlyAlertOnce: true,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Janamaithri Live Location',
      'Location sharing stopped',
      platformChannelSpecifics,
    );
  }

  // //******************************Fetch nearest police station******************
  // Future<PoliceStation?> getNearestPoliceStation() async {
  //   try {
  //     currentLocation = await getCurrentLocation();
  //     if (currentLocation != null) {
  //       nearestStaion =  await HomeServices.getContainingPoliceStation(
  //         currentLocation,
  //       );
  //
  //       selectedPoliceStation = nearestStaion;
  //
  //       return nearestStaion;
  //     }else {
  //       nearestStaion = null;
  //       selectedPoliceStation = policeStations.first;
  //       return null;
  //     }
  //   } catch (e) {
  //     await Geolocator.openLocationSettings();
  //     return null;
  //   }
  // }

  //**************************On ready function*********************************
  // Future<void> onReadyFunction() async {
  //   try {
  //     intelligenceTypes = await RailServices.getIntelligenceType();
  //     severityTypes = await RailServices.getSeverityType();
  //     staffPorterTypes = await RailServices.getStaffPorterCategoryType();
  //     shopCategoryTypes = await RailServices.getShopCategoryType();
  //     contactCategoryTypes = await RailServices.getContactCategoryType();
  //     volunteerCat = await RailServices.getVolunteerCategory();
  //     districtList = await RailServices.getDistrictList();
  //     stateList = await RailServices.getStateList();
  //     railwayStaionList = await RailServices.getRailwayStationList();
  //     trainList = await RailServices.getTrainList();
  //     genderTypes = await OtherServices.getGenders();
  //     ticketTypes = await TicketServices.getTicketTypes();
  //     // fromTrainStopStation = await RailServices.getTrainStopStationList();
  //     // toTrainStopStation = await RailServices.getTrainStopStationList();
  //   } catch (e) {
  //     print('No data on cache !..................');
  //   }
  // }
}
