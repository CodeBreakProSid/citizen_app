import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/rail_volunteer.dart';
import '../../../data/user.dart';
import '../../../services/user_services.dart';
import '../../../util/api_urls.dart';

class LoginBaseController extends GetxController {
  final loginFormKey = GlobalKey<FormBuilderState>();
  final resetPasswordFormKey = GlobalKey<FormBuilderState>();
  final box = GetStorage();
  final userServices = UserServices();

  User? _user;

  String? username = '';
  String? password = '';

  bool _isLogging = false;
  bool _isChecked = false;
  bool _isResetPassword = false;

  late final List<RailVolunteer> registeredRailvolunteerDetails;

  String? _captchaId;
  String _phoneNumber = '';

  String? get captchaId => _captchaId;
  set captchaId(String? v) => {_captchaId = v, update()};

  String get captchaImageUrl => captchaId != null
      ? '${ApiUrls.RESET_PASSWORD_CAPTCHA_IMAGE}/${captchaId!}.png'
      : '';

  bool get isLogging => _isLogging;
  set isLogging(bool v) => {_isLogging = v, update()};

  bool get isChecked => _isChecked;
  set isChecked(bool v) => {_isChecked = v, update()};

  bool get isResetPassword => _isResetPassword;
  set isResetPassword(bool v) => {_isResetPassword = v, update()};

  String get phoneNumber => _phoneNumber;
  set phoneNumber(String v) => {_phoneNumber = v, update()};

  User? get user => _user;
  set user(User? v) => {_user = v, update()};
}
