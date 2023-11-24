// ignore_for_file: unnecessary_getters_setters

//import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../data/railway_station_details.dart';
import '../../../data/user.dart';

class PageIncidentPlatformBaseController extends GetxController {
  final incidentPlatformFormKey = GlobalKey<FormBuilderState>();

  late final List<RailwayStationDetails> railwayStaionList;
  late final Future<bool> isDataLoaded;

  //List<PlatformFile> fileToUpload         = [];
  XFile? uploadImages;

  final utcFormat = DateFormat('yyyy-MM-dd hh:mm:ss');
  final dateFormat = DateFormat('yyyy-MM-dd');

  Position? currentLocation;
  User? user;
  bool _isUploading = false;
  RailwayStationDetails? selectedRailwayStation;

  DateTime _dateTime = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    DateTime.now().hour,
    DateTime.now().minute,
    DateTime.now().microsecond,
  );

  DateTime get dateTime => _dateTime;
  set dateTime(DateTime dateTime) {
    _dateTime = dateTime;
  }

  bool get isUploading => _isUploading;
  set isUploading(bool v) => {_isUploading = v, update()};
}
