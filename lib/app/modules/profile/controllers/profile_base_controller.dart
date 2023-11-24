import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

import '../../../data/user.dart';
import '../../../services/user_services.dart';
import '../../../util/api_urls.dart';

class ProfileBaseController extends GetxController {

  final profileFormKey            = GlobalKey<FormBuilderState>();
  final changeFormKey             = GlobalKey<FormBuilderState>();
  final phoneVerifyFormKey        = GlobalKey<FormBuilderState>();
  final userServices              = UserServices();

  late Future<bool>                 isDataLoaded;
  late String                       userStatus;
  late Map<String, dynamic>         accountStatus;
  late Map<String, dynamic>         genderList;

  User?                             _user;
  bool                              _isLogging            = false;
  bool                              _isSaving             = false;
  bool                              _isEditing            = false;
  bool                              _isPasswordChanging   = false;
  bool                              _isPasswordChanged    = false;
  bool                              _isOtpSenting         = false;
  bool                              _isOtpSented          = false;
  bool                              _isOtpVerified        = false;
  bool                              _isOtpVerifying       = false;

  String?                           _captchaId;
  dynamic                           gender;
  dynamic                           genderValue;

  Map<String, dynamic>?             otpDetails = {};

  String? get captchaId => _captchaId;
  set captchaId(String? v) => {_captchaId = v, update()};

  String get captchaImageUrl => captchaId != null
      ? '${ApiUrls.PHONE_VERIFICATION_CAPTCHA_IMAGE}/${captchaId!}.png'
      : '';

  User? get user => _user;
  set user(User? v) => {_user = v, update()};

  bool get isLogging => _isLogging;
  set isLogging(bool v) => {_isLogging = v, update()};

  bool get isSaving => _isSaving;
  set isSaving(bool v) => {_isSaving = v, update()};

  bool get isEditing => _isEditing;
  set isEditing(bool v) => {_isEditing = v, update()};

  bool get isPasswordChanging => _isPasswordChanging;
  set isPasswordChanging(bool v) => {_isPasswordChanging = v, update()};

  bool get isPasswordChanged => _isPasswordChanged;
  set isPasswordChanged(bool v) => {_isPasswordChanged = v, update()};

  bool get isOtpSenting => _isOtpSenting;
  set isOtpSenting(bool v) => {_isOtpSenting = v, update()};

  bool get isOtpSented => _isOtpSented;
  set isOtpSented(bool v) => {_isOtpSented = v, update()};

  bool get isOtpVerifying => _isOtpVerifying;
  set isOtpVerifying(bool v) => {_isOtpVerifying = v, update()};

  bool get isOtpVerified => _isOtpVerified;
  set isOtpVerified(bool v) => {_isOtpVerified = v, update()};
}
