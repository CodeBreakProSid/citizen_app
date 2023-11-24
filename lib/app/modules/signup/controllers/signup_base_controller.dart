import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../util/api_urls.dart';

class SignupBaseController extends GetxController {
  final signupFromKey   = GlobalKey<FormBuilderState>();
  final box             = GetStorage();

  late final Future<bool> isDataLoaded;
  late final Map          genders;
  String?                 _captchaId;
  late Uint8List          image;
  late bool _isLogging    = false;
  

  String? get captchaId => _captchaId;
  set captchaId(String? v) => {_captchaId = v, update()};

  String? get captchaImageUrl => captchaId != null
      ? '${ApiUrls.SIGNUP_CAPTCHA_IMAGE}/${captchaId!}.png'
      : null;

  bool get isLogging => _isLogging;
  set isLogging(bool v) => {_isLogging = v, update()};
}
