// ignore_for_file: avoid_dynamic_calls

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../services/auth_services.dart';
import '../../../services/other_services.dart';
import '../../../util/global_widgets.dart';
import 'signup_base_controller.dart';

class SignupController extends SignupBaseController {
  @override
  void onInit() {
    isDataLoaded = loadData();
    super.onInit();
  }

  //******************************On Init invoke function***********************
  Future<bool> loadData() async {
    try {
      genders = await OtherServices.getGenders(isUpdate: true);
      await loadCaptcha();

      return true;
    } catch (e) {
      if (kDebugMode) rethrow;

      return false;
    }
  }

  //******************************Load caotcha**********************************
  Future<void> loadCaptcha() async {
    try {
      captchaId = null;
      captchaId = await OtherServices.getCaptchaId();
      update();
    } catch (e) {
      if (kDebugMode) rethrow;
    }
  }

  //******************************Signup function*******************************
  Future<void> signup() async {
    try {
      isLogging = true;
      if (signupFromKey.currentState?.saveAndValidate() ?? false) {
        final String captchaCode  = signupFromKey.
                  currentState?.value['captcha_code'] as String? ?? '';
        final String genderType   = '${signupFromKey.
                  currentState?.fields['gender_type_id']?.value}';
        final String userName     = signupFromKey.
                  currentState?.fields['username']?.value as String? ?? '';
        final String password     = signupFromKey.
                  currentState?.fields['password']?.value as String? ?? '';
        final String phoneNumber  = signupFromKey.
                  currentState?.fields['private_phone']?.value as String? ?? '';

        final Map<String, String> query = {
          'captcha_id'    : captchaId ?? '',
          'captcha_code'  : captchaCode,
          'phone_number'  : phoneNumber,
          'gender_type'   : genderType,
          'username'      : userName,
          'password'      : password,
        };

        if ((signupFromKey.
              currentState?.value['private_email_id'] as String?) != null &&
            (signupFromKey.
              currentState?.value['private_email_id'] as String).trim() != '') 
        {
          query['email_id'] = signupFromKey
                  .currentState?.value['private_email_id'] as String? ?? '';
        }
        if ((signupFromKey.
              currentState?.value['aadhaar_number'] as String?) != null &&
            (signupFromKey.
              currentState?.value['aadhaar_number'] as String).trim() != '') 
        {
          query['aadhaar_number'] = signupFromKey.
              currentState?.value['aadhaar_number'] as String? ?? '';
        }

        final response = await AuthServices.signup(query);

        response.fold(
          (l) async {
            showSnackBar(
              type    : SnackbarType.error,
              message : l,
            );
            captchaId = '';
            await loadCaptcha();
            update();
          },
          (r) {
            showSnackBar(
              type    : SnackbarType.success,
              message : 'SignIn Successfully',
            );
            Get.offAllNamed(Routes.LOGIN);
          },
        );
      }
      isLogging = false;
    } catch (e) {
      if (kDebugMode) rethrow;
      showSnackBar(
        type    : SnackbarType.error, 
        message : e.toString(),);

      isLogging = false;
    }
  }
}
