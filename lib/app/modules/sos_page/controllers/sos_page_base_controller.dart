import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class SosPageBaseController extends GetxController {

  final sosPhonecall = GlobalKey<FormBuilderState>();

  late final Future<bool> isDataLoaded;
}
