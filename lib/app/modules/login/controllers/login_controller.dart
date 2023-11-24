import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../data/rail_volunteer.dart';
import '../../../routes/app_pages.dart';
import '../../../services/auth_services.dart';
import '../../../services/other_services.dart';
import '../../../services/rail_services.dart';
import '../../../util/api_helper/api_const.dart';
import '../../../util/global_widgets.dart';
import '../../firebase_service/tocken_establishment.dart';
import 'login_base_controller.dart';

class LoginController extends LoginBaseController {
  @override
  void onInit() {
    super.onInit();
    initServies();
  }

  //******************************On Init invoke function***********************
  Future<void> initServies() async {
    //await requestPermission();
    username = box.read('username');
    password = box.read('password');
    await loadCaptcha();
  }

  //******************************Login function********************************
  Future<void> login() async {
    try {
      isLogging = true;
      if (loginFormKey.currentState?.saveAndValidate() ?? false) {
        final response = await AuthServices.login(
          username:
              (loginFormKey.currentState?.value['username'] ?? '').toString(),
          password:
              (loginFormKey.currentState?.value['password'] ?? '').toString(),
        );

        // if (await box.read(ApiConst.POLICE_STATION) == null) {
        //   await HomeServices.getPoliceStations(isUpdate: true);
        // }
        // if (await box.read(ApiConst.TICKET_STATUS) == null) {
        //   await OtherServices.getTicketStatus(isUpdate: true);
        // }
        // if (await box.read(ApiConst.NOTIFICATION_TYPE) == null) {
        //   await OtherServices.getNotificationType(isUpdate: true);
        // }
        // if (await box.read(ApiConst.MEETING_STATE) == null) {
        //   await OtherServices.getMeetingStatus(isUpdate: true);
        //}

        response.fold(
          (l) async {
            showSnackBar(
              type: SnackbarType.error,
              message: l,
            );
          },
          (r) async {
            if (isChecked) {
              await rememberMe(
                (loginFormKey.currentState?.value['username'] ?? '').toString(),
                (loginFormKey.currentState?.value['password'] ?? '').toString(),
              );
            } else {
              box.write('username', null);
              box.write('password', null);
            }

            //********My code starts***********

            user = await userServices.getUser();
            final Map<String, String> queryParam = {
              'citizen_id': '${user?.citizenId}',
            };
            // registeredRailvolunteerDetails =
            //     (await RailServices.getExistingRailVolunteer(queryParam))
            //         .cast<RailVolunteer>();

            registeredRailvolunteerDetails =
                await box.read(ApiConst.EXISTING_RAIL_VOLUNTEER) == null
                    ? (await RailServices.getExistingRailVolunteer(
                        queryParam,
                        isUpdate: true,
                      ))
                        .cast<RailVolunteer>()
                    : (await RailServices.getExistingRailVolunteer(queryParam))
                        .cast<RailVolunteer>();

            await TockenEstablishment.sendToken();

            //********My code ends***********

            showSnackBar(
              type: SnackbarType.success,
              message: 'Login Successful',
            );

            Get.offAllNamed(Routes.HOME);
          },
        );
      }
      isLogging = false;
    } catch (e) {
      if (kDebugMode) rethrow;

      isLogging = false;
      showSnackBar(
        type: SnackbarType.error,
        message: 'Fail to login, try again',
      );
    }
  }

  //******************************Remember me function**************************
  Future<void> rememberMe(String username, String password) async {
    box.write('username', username);
    box.write('password', password);
  }

  //******************************Load captcha**********************************
  Future<void> loadCaptcha() async {
    try {
      captchaId = await OtherServices.getResetPwrdCaptcha();
    } catch (e) {
      if (kDebugMode) rethrow;
    }
  }

  //******************************Reset password********************************
  Future<void> resetPassword() async {
    try {
      if (resetPasswordFormKey.currentState!.saveAndValidate() &&
          captchaId != null) {
        final apiResponse = await AuthServices.resetPassword(
          captchaId!,
          '${resetPasswordFormKey.currentState?.value['captcha']}',
          '${resetPasswordFormKey.currentState?.value['phone_number']}',
        );
        if (apiResponse) {
          phoneNumber =
              ': ${resetPasswordFormKey.currentState?.value['phone_number']}';
          isResetPassword = true;
        } else {
          await loadCaptcha();
        }
      }
    } catch (e) {
      if (kDebugMode) rethrow;
      showSnackBar(
        type: SnackbarType.error,
        message: 'Something went wrong,try again later',
      );
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
}
