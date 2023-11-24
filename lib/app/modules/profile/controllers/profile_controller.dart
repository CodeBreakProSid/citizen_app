import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../routes/app_pages.dart';
import '../../../services/auth_services.dart';
import '../../../services/other_services.dart';
import '../../../util/api_helper/api_const.dart';
import '../../../util/global_widgets.dart';
import '../../home/controllers/home_controller.dart';
import 'profile_base_controller.dart';

class ProfileController extends ProfileBaseController {
  @override
  void onInit() {
    isDataLoaded = loadData();
    super.onInit();
  }

  static final box = GetStorage();

  //******************************On Init invoke function***********************
  Future<bool> loadData() async {
    try {
      if (await box.read(ApiConst.Key) != null) {
        user = await userServices.getUser();
        if (user == null) {
          await userServices.saveUser(
            await OtherServices.getUserDetails().then((value) => user = value),
          );
        }

        genderList = await box.read(ApiConst.GENDER_TYPE) == null
            ? await OtherServices.getGenders(isUpdate: true)
            : await OtherServices.getGenders();
        genderList.forEach(
          (key, value) {
            if (user?.genderType == value) {
              gender = key;
              genderValue = value;

              return;
            }
          },
        );

        accountStatus = await box.read(ApiConst.ACCOUNT_STATUS) == null
            ? await OtherServices.getAccountStatus(isUpdate: true)
            : await OtherServices.getAccountStatus();
        if (accountStatus.isNotEmpty) {
          userStatus = accountStatus.entries
              .firstWhere((element) => element.value == user?.accountStatus)
              .key;
        }

        return true;
      } else {
        Get.offAllNamed(Routes.ROOT);
      }

      return false;
    } catch (e) {
      if (kDebugMode) rethrow;

      return false;
    }
  }

  //******************************Load phone captcha****************************
  Future<void> loadPhoneCaptcha() async {
    try {
      captchaId = await OtherServices.getPhoneCaptchaId();
    } catch (e) {
      if (kDebugMode) rethrow;
    }
  }

  //******************************Update profile********************************
  Future<void> updateProfile() async {
    try {
      isSaving = true;
      bool isProfileUpdated = false;
      late final bool apiResponse;
      final Map<String, dynamic> query = {};

      if (profileFormKey.currentState?.saveAndValidate() ?? false) {
        if (profileFormKey.currentState?.value['phone_number'] !=
                '${user?.phoneNumber}' &&
            (profileFormKey.currentState?.value['phone_number'] as String)
                    .trim() !=
                '') {
          isProfileUpdated = true;
          query['phone_number'] =
              profileFormKey.currentState?.value['phone_number'];
        }

        if (profileFormKey.currentState?.value['gender'] !=
            '${user?.genderType}') {
          isProfileUpdated = true;
          query['gender_type'] = profileFormKey.currentState?.value['gender'];
        }

        if (profileFormKey.currentState?.value['email_id'] != user?.emailId &&
            // ignore: avoid_dynamic_calls
            profileFormKey.currentState?.value['email_id'].trim() != '') {
          isProfileUpdated = true;

          query['email_id'] = profileFormKey.currentState?.value['email_id'];
        }

        if (profileFormKey.currentState?.value['full_name'] != user?.fullName &&
            // ignore: avoid_dynamic_calls
            profileFormKey.currentState?.value['full_name'].trim() != '') {
          isProfileUpdated = true;

          query['full_name'] = profileFormKey.currentState?.value['full_name'];
        }

        if (profileFormKey.currentState?.value['address'] != user?.address &&
            // ignore: avoid_dynamic_calls
            profileFormKey.currentState?.value['address'].trim() != '') {
          isProfileUpdated = true;

          query['address'] = profileFormKey.currentState?.value['address'];
        }
        if (isProfileUpdated) {
          apiResponse = await AuthServices.updateProfile(query);
        }

        if (apiResponse) {
          await userServices.saveUser(await OtherServices.getUserDetails());
          user = await userServices.getUser().then(
                (value) => Get.find<HomeController>().user = value,
              );

          showSnackBar(
            type: SnackbarType.success,
            message: 'Profile updated successfully.',
          );

          isSaving = false;
          isEditing = false;
        } else {
          profileFormKey.currentState?.reset();
        }
      } else if (profileFormKey.currentState?.saveAndValidate() == false &&
          isEditing) {
        isEditing = true;
        isSaving = false;
      } else {
        isSaving = false;
        isEditing = false;
      }
    } catch (e) {
      isSaving = false;
      isEditing = false;

      return;
    }
  }

  //******************************Change password*******************************
  Future<void> changePassword() async {
    if (changeFormKey.currentState?.saveAndValidate() ?? false) {
      isPasswordChanging = true;
      isPasswordChanged = await AuthServices.changePassword(
        '${changeFormKey.currentState?.value['new_password']}',
      );
      if (isPasswordChanged) {
        showSnackBar(
          type: SnackbarType.success,
          message: 'Password changed successfully.',
        );
        isPasswordChanged = true;
        AuthServices.logout();
        Get.offAllNamed(Routes.LOGIN);
      } else {
        showSnackBar(
          type: SnackbarType.error,
          message: 'Password changing failed.',
        );
      }
    }
    isPasswordChanging = false;
  }

  //******************************Sent OTP**************************************
  Future<void> sentOtp() async {
    if (phoneVerifyFormKey.currentState?.saveAndValidate() ?? false) {
      isOtpSenting = true;
      otpDetails = await AuthServices.sentOtp(
        '$captchaId',
        '${phoneVerifyFormKey.currentState?.value['captcha']}',
      );
      if (otpDetails != null) {
        isOtpSented = true;
        isOtpSenting = false;

        return;
      } else {
        await loadPhoneCaptcha();
      }
      isOtpSenting = false;
    }
  }

  //******************************Verify OTP************************************
  Future<void> verifyOtp() async {
    isOtpVerifying = true;
    if (phoneVerifyFormKey.currentState?.saveAndValidate() ?? false) {
      final apiResponse = await AuthServices.verifyOtp(
        '${otpDetails?['otp_id']}',
        '${phoneVerifyFormKey.currentState?.value['otp']}',
      );
      if (apiResponse) {
        isOtpVerified = true;
        isOtpVerifying = false;
        showSnackBar(
          type: SnackbarType.success,
          message: 'Phone number verified',
        );
        await userServices.saveUser(await OtherServices.getUserDetails());
        user = await userServices.getUser();
        Get.find<HomeController>().user = user;
        Future.delayed(const Duration(seconds: 1))
            .then((value) => Navigator.of(Get.context!).pop());
        update();
      }
      isOtpVerifying = false;
    }
  }
}
