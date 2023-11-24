import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../routes/app_pages.dart';
import '../../../services/auth_services.dart';
import '../../../services/other_services.dart';
import '../../../services/user_services.dart';
// ignore: unused_import
import '../../../util/global_widgets.dart';
// ignore: unused_import
import '../../home/controllers/home_controller.dart';
import '../../home/views/widgets/notification_main_view.dart';
import 'root_base_controller.dart';

class RootController extends RootBaseController {
  late Timer timer;

  Future<void> setupInteractedMessage() async {
    final RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessageOpenTerminated(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenBackground);
  }

  @override
  void onInit() {
    super.onInit();
    requestPermission();
    setupInteractedMessage();
  }

  void _handleMessageOpen(RemoteMessage message) {
    // ignore: avoid_print
    print(message);
    Get.put(HomeController());
    Get.to(const NotificationMainView());
  }

  void _handleMessageOpenTerminated(RemoteMessage message) {
    _handleMessageOpen(message);
  }

  void _handleMessageOpenBackground(RemoteMessage message) {
    _handleMessageOpen(message);
  }

  Future<void> initServices() async {
    isLoading = true;

    if (await InternetConnectionChecker().hasConnection) {
      isConnection = true;
      if (await AuthServices.checkValidity()) {
        await UserServices().saveUser(await OtherServices.getUserDetails());
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.offAllNamed(Routes.LOGIN);
      }
    } else {
      isConnection = false;
    }
    isLoading = false;
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
}
