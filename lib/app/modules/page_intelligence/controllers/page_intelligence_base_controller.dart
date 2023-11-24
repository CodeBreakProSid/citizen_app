//import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../data/intelligence_type.dart';
import '../../../data/severity_type.dart';
import '../../../data/user.dart';

class PageIntelligenceBaseController extends GetxController {
  final intelligenceFormKey = GlobalKey<FormBuilderState>();
  //List<PlatformFile> fileToUpload = [];
  XFile? uploadImages;

  late final List<IntelligenceType> intelligenceTypes;
  late final List<SeverityType> severityTypes;

  IntelligenceType? selectedIntelligenceType;
  SeverityType? selectedSeverityType;
  Position? currentLocation;

  bool _isChecked = false;
  String? tempName = '';
  String? tempMobile = '';

  final utcFormat = DateFormat('yyyy-MM-dd hh:mm:ss');
  bool _isUploading = false;
  late final Future<bool> isDataLoaded;
  User? user;

  bool get isUploading => _isUploading;
  set isUploading(bool v) => {_isUploading = v, update()};

  bool get isChecked => _isChecked;
  set isChecked(bool v) => {_isChecked = v, update()};
}
