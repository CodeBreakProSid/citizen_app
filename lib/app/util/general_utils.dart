import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart' hide Key;
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../services/home_services.dart';
import '../services/other_services.dart';
import '../services/rail_services.dart';
import '../services/ticket_services.dart';
import '../services/user_services.dart';
import 'api_helper/api_const.dart';
import 'api_urls.dart';
import 'global_widgets.dart';

Future<void> initializeApp() async {
  //WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize();

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse payload) {
      debugPrint('notification payload: $payload');
    },
  );

  await GetStorage.init();
  await Get.putAsync(() async => UserServices().init());
  await Get.putAsync(() async => initializeApi());
}

Future<bool> initializeApi() async {
  const bool isUpdate = true;

  //Janamaithri cache service
  await OtherServices.getAccountStatus(isUpdate: isUpdate);
  await OtherServices.getGenders(isUpdate: isUpdate);
  await OtherServices.getTicketStatus(isUpdate: isUpdate);
  await OtherServices.getMeetingStatus(isUpdate: isUpdate);
  await OtherServices.getNotificationType(isUpdate: isUpdate);
  await HomeServices.getPoliceStations(isUpdate: isUpdate);
  await TicketServices.getTicketTypes(isUpdate: isUpdate);

  //Railmaithri cache services
  await RailServices.getDistrictList(isUpdate: isUpdate);
  await RailServices.getRailwayStationList(isUpdate: isUpdate);
  await RailServices.getRailwayPoliceStaionList(isUpdate: isUpdate);
  await RailServices.getVolunteerCategory(isUpdate: isUpdate);
  await RailServices.getTrainList(isUpdate: isUpdate);
  await RailServices.getIntelligenceType(isUpdate: isUpdate);
  await RailServices.getSeverityType(isUpdate: isUpdate);
  await RailServices.getStaffPorterCategoryType(isUpdate: isUpdate);
  await RailServices.getStateList(isUpdate: isUpdate);
  await RailServices.getShopCategoryType(isUpdate: isUpdate);
  await RailServices.getContactCategoryType(isUpdate: isUpdate);
  await RailServices.getLostPropertyCategoryType(isUpdate: isUpdate);
  await RailServices.getRailwayPoliceStaionList(isUpdate: isUpdate);

  return true;
}

String durationToString(int minutes) {
  final d = Duration(minutes: minutes);
  final List<String> parts = d.toString().split(':');

  return '${parts.first.padLeft(2, '0')} Hr ${parts[1].padLeft(2, '0')} Min';
}

Future<void> downloadFile(
  String componentId, {
  Directory? directory,
  String? fileName,
  String? accessToken,
}) async {
  final String authToken = accessToken ?? '';

  await FlutterDownloader.enqueue(
    url: '${ApiUrls.GET_RESOURCE_COMPONENT}component_id=$componentId',
    savedDir: '${directory?.path}',
    fileName: fileName,
    headers: {
      'Accept': 'application/json',
      'Authorization': authToken,
    },
    saveInPublicStorage: true,
  );
}

Future<String?> downloadRecording(
  String meetingId, {
  Directory? directory,
  String? fileName,
  String? accessToken,
}) async {
  final String authToken = accessToken ?? '';

  return FlutterDownloader.enqueue(
    url: '${ApiUrls.MEETING_RECORDING}meeting_id=$meetingId',
    savedDir: '${directory?.path}',
    fileName: fileName,
    headers: {
      'Accept': 'application/json',
      'Authorization': authToken,
    },
    saveInPublicStorage: true,
  );
}

Future<Directory> getDownloadDirectory() async {
  final path = await getExternalStorageDirectory();
  final String? downloadPath =
      path?.path.split('/Android/data/org.keltron.janamaithri/files').first;
  final Directory downloadDirectory = Directory('${downloadPath!}/Download');

  return downloadDirectory;
}

Color getTicketStatusColor(String ticketStatus) {
  switch (ticketStatus) {
    case TicketStatusConst.TICKET_STATUS_1:
      return Colors.green;

    case TicketStatusConst.TICKET_STATUS_2:
      return Colors.red;

    case TicketStatusConst.TICKET_STATUS_3:
      return Colors.redAccent;

    case TicketStatusConst.TICKET_STATUS_4:
      return Colors.red;

    default:
      return Colors.white;
  }
}

Color getRailTicketStatusColor(String ticketStatus) {
  switch (ticketStatus) {
    case RailTicketStatusTypeConst.TICKET_TYPE_1:
      return Colors.orange;

    case RailTicketStatusTypeConst.TICKET_TYPE_2:
      return Colors.yellow;

    case RailTicketStatusTypeConst.TICKET_TYPE_3:
      return Colors.red;

    case RailTicketStatusTypeConst.TICKET_TYPE_4:
      return Colors.blue;

    case RailTicketStatusTypeConst.TICKET_TYPE_5:
      return Colors.green;

    default:
      return Colors.white;
  }
}

Color getMeetingColor(String meetingType) {
  switch (meetingType) {
    case MeetingTypeConst.MEETING_TYPE_1:
      return Colors.green;

    case MeetingTypeConst.MEETING_TYPE_2:
      return Colors.green;

    case MeetingTypeConst.MEETING_TYPE_3:
      return Colors.blue;

    case MeetingTypeConst.MEETING_TYPE_4:
      return Colors.blue;

    default:
      return Colors.white;
  }
}

//******************************Permission request function*******************
Future<void> requestPermission() async {
  try {
    if (!await Permission.location.isGranted ||
        !await Permission.storage.isGranted) {
      final Map<Permission, PermissionStatus> statuses = await [
        Permission.location,
        Permission.storage,
        Permission.notification,
        Permission.photos,
        Permission.mediaLibrary,
      ].request();
      if (statuses[Permission.location] != PermissionStatus.granted) {
        showSnackBar(
          type: SnackbarType.warning,
          message:
              'Go to Mobile Settings > Apps -> Officer -> Permission -> Allow location permission ',
        );
      }
      if (statuses[Permission.storage] != PermissionStatus.granted) {
        showSnackBar(
          type: SnackbarType.warning,
          message:
              'Go to Mobile Settings > Apps -> Officer -> Permission -> Allow storage permission ',
        );
      }
      if (statuses[Permission.notification] != PermissionStatus.granted) {
        showSnackBar(
          type: SnackbarType.warning,
          message:
              'Go to Mobile Settings > Apps -> Officer -> Permission -> Allow notification permission ',
        );
      }
      if (statuses[Permission.photos] != PermissionStatus.granted) {
        showSnackBar(
          type: SnackbarType.warning,
          message:
              'Go to Mobile Settings > Apps -> Officer -> Permission -> Allow photos permission ',
        );
      }
      if (statuses[Permission.mediaLibrary] != PermissionStatus.granted) {
        showSnackBar(
          type: SnackbarType.warning,
          message:
              'Go to Mobile Settings > Apps -> Officer -> Permission -> Allow mediaLibrary permission ',
        );
      }
    }
  } catch (e) {
    debugPrint('$e');
  }
}
