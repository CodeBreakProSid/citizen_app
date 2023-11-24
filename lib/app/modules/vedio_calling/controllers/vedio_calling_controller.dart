import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:web_socket_channel/status.dart' as status;

import '../../../data/meeting_details.dart';
import '../../../routes/app_pages.dart';
import '../../../services/auth_services.dart';
import '../../../services/home_services.dart';
import '../../../util/global_widgets.dart';
import 'vedio_calling_base_controller.dart';

class VedioCallingController extends VedioCallingBaseController {
  @override
  void onInit() {
    super.onInit();
    isDataLoaded = initServices();
  }

  @override
  void dispose() {
    super.dispose();
    streamSubscription.cancel();
    videostreamSubscription.cancel();
    micstreamSubscription.cancel();
    joinmeetingstreamSubscription.cancel();
  }

  //******************************On Init invoke function***********************
  Future<bool> initServices() async {
    try {
      if (await AuthServices.checkValidity()) {
        applicationchannel = const MethodChannel('tst.vconsol/methodchannel');
        exitbuttonclickevent = const EventChannel('tst.vconsol/onExited');
        videobuttonstatusevent = const EventChannel('tst.vconsol/videoStatus');
        micbuttonstatusevent = const EventChannel('tst.vconsol/micStatus');
        joinmeetingstatusevent = const EventChannel('tst.vconsol/joinMeeting');
        exitstatusevent = const EventChannel('tst.vconsol/onExited');

        late final MeetingDetails? data;

        //********Replace the below code with existing data variable************
        // currentLocation = await getCurrentLocation();

        // final Map<String, String> queryParam = {
        //   'latitude': '${currentLocation?.latitude}',
        //   'longitude': '${currentLocation?.longitude}',
        // };

        // final Map<String, dynamic> jurisdictionDetails =
        //     await OtherServices.getJurisdiction(queryParam);

        // data = jurisdictionDetails.isEmpty
        //     ? await HomeServices.getServiceMeetingDetails(1032)
        //     : await HomeServices.getServiceMeetingDetails(
        //         jurisdictionDetails['jurisdiction_id'] as int,
        //         //1032,
        //       );
        //********Replace the below code with existing data variable************

        data = await HomeServices.getServiceMeetingDetails(1032);

        if (data != null) {
          await joinMeeting(data);
          listenMeeingEvents();

          return true;
        }
        Future.delayed(const Duration(seconds: 3))
            .then((value) => Get.back(closeOverlays: true));

        return false;
      }

      return false;
    } catch (e) {
      if (kDebugMode) rethrow;
      Get.offAllNamed(Routes.HOME);

      return false;
    }
  }

  //***********************Get device current location**************************
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

  //*********Listen Meeting Events of Vedio,audio,exit,camera etc***************
  void listenMeeingEvents() {
    streamSubscription =
        exitbuttonclickevent.receiveBroadcastStream().listen((event) {
      Get.back(closeOverlays: true);
    });
    videostreamSubscription =
        videobuttonstatusevent.receiveBroadcastStream().listen((event) {
      isVedioMuted = !isVedioMuted;
      debugPrint('join meeting status:  $event');
    });
    micstreamSubscription =
        micbuttonstatusevent.receiveBroadcastStream().listen((event) {
      isAudioMuted = !isAudioMuted;
      debugPrint('join meeting status:  $event');
    });
    joinmeetingstreamSubscription =
        joinmeetingstatusevent.receiveBroadcastStream().listen((event) {
      if (event as bool) {
        isVedioStreaming = true;
      } else {
        showSnackBar(
          type: SnackbarType.warning,
          message: 'Something went wrong, try again!',
        );
        Get.offAllNamed(Routes.HOME);
      }
      debugPrint('join meeting status:  $event');
    });
  }

  //***********************Listen WebSocket Events******************************
  Future<void> openWebSocket() async {
    try {
      websocket?.stream.listen(
        (event) {
          final response = jsonDecode('$event') as Map<String, dynamic>;
          debugPrint('$response');
          if (response['detail'] == 'SUCCESS') {
            final meetingDetails = MeetingDetails.fromJson(
              response['meeting'] as Map<String, dynamic>,
            );
            joinMeeting(meetingDetails);
            listenMeeingEvents();
          }
        },
        onDone: () async {
          await closeWebSocket();
          printInfo(info: 'Socket closed abnormally !!');
          Get.back(closeOverlays: true);
        },
        onError: (event) async {
          await closeWebSocket();
          debugPrint('$event');
          Get.back(closeOverlays: true);
        },
        cancelOnError: true,
      );
    } catch (e) {
      if (kDebugMode) rethrow;
      debugPrint('$e');
    }
  }

  //***********************Join meeting using meeting details*******************
  Future<void> joinMeeting(
    MeetingDetails meetingDetails,
  ) async {
    try {
      final arguments = {
        'token': meetingDetails.token,
        'expiryInSec': '${meetingDetails.expiryInSec}',
        'meetingID': meetingDetails.meetingID,
        'title': meetingDetails.title,
        'role': meetingDetails.role,
        'type': meetingDetails.type,
      };
      await applicationchannel.invokeMethod('joinMeeting', arguments);
    } catch (e) {
      if (kDebugMode) rethrow;
      showSnackBar(
        type: SnackbarType.warning,
        message: 'Something went wrong, try again!',
      );
      Get.offAllNamed(Routes.HOME);

      return;
    }
  }

  //***********************Disable camera video*********************************
  Future<void> videoMute() async {
    try {
      await applicationchannel.invokeMethod('videoMuteUnmute');
    } catch (e) {
      return;
    }
    await applicationchannel.invokeMethod('videoMuteUnmute');
  }

  //***********************Mute mic*********************************************
  Future<void> micMute() async {
    try {
      await applicationchannel.invokeMethod('micMuteUnmute');
    } catch (e) {
      return;
    }
  }

  //***********************Exit from meeting************************************
  Future<void> exitMeeting() async {
    try {
      final arguments = {'exitcode': '0'};
      await applicationchannel.invokeMethod('exitMeeting', arguments);
    } catch (e) {
      return;
    }
  }

  //***********************Toggle camera****************************************
  Future<void> toggleCamera() async {
    try {
      await applicationchannel.invokeMethod('toggleCamera');
      istoggleCamera = !istoggleCamera;
    } catch (e) {
      return;
    }
  }

  //***********************Close web socket connection**************************
  Future<void> closeWebSocket() async {
    try {
      await websocket?.sink.close(status.goingAway);

      return;
    } catch (e) {
      if (kDebugMode) rethrow;

      return;
    }
  }
}
