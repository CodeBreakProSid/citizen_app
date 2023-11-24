//import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../data/railway_station_details.dart';
import '../../../data/staff_porter.dart';
import '../../../data/staff_porter_category.dart';
import '../../../data/state_list.dart';
import '../../../data/user.dart';

class PagePorterRegistrationBaseController extends GetxController {
  final porterFormKey = GlobalKey<FormBuilderState>();

  late final Future<bool> isDataLoaded;

  late Map<String, dynamic> apiResponse;

  List<StaffPorter> _staffporterList = [];
  List<StaffPorter> _moreStaffporterList = [];

  bool _isMoreStaffPorterLoading = false;

  List<StaffPorter> _initialListOfStaffPorter = [];

  bool _noMoreStaffporter = false;

  User? user;

  int notificationToShow = 24;

  late final List<StaffPorterCategory> staffPorterTypes;
  late final List<StateList> stateList;
  late final List<RailwayStationDetails> railwayStaionList;
  Position? currentLocation;
  StaffPorterCategory? selectedStaffPorterType;
  RailwayStationDetails? selectedRailwayStation;
  StateList? selectedState;

  final utcFormat = DateFormat('yyyy-MM-dd hh:mm:ss');

  // List<PlatformFile> fileToUpload = [];
  XFile? uploadImages;

  bool _isUploading = false;

  bool _staffporterListIsLoading = false;

  dynamic gender;

  late final Map<String, dynamic> genderTypes;

  bool get isUploading => _isUploading;
  set isUploading(bool v) => {_isUploading = v, update()};

  bool get staffporterListIsLoading => _staffporterListIsLoading;
  set staffporterListIsLoading(bool v) =>
      {_staffporterListIsLoading = v, update()};

  List<StaffPorter> get initialListOfStaffPorter => _initialListOfStaffPorter;
  set initialListOfStaffPorter(List<StaffPorter> v) =>
      {_initialListOfStaffPorter = v, update()};

  List<StaffPorter> get staffporterList => _staffporterList;
  set staffporterList(List<StaffPorter> v) => {_staffporterList = v, update()};

  List<StaffPorter> get moreStaffporterList => _moreStaffporterList;
  set moreStaffporterList(List<StaffPorter> v) =>
      {_moreStaffporterList = v, update()};

  bool get noMoreStaffporter => _noMoreStaffporter;
  set noMoreStaffporter(bool v) => {_noMoreStaffporter = v, update()};

  bool get isMoreStaffPorterLoading => _isMoreStaffPorterLoading;
  set isMoreStaffPorterLoading(bool v) =>
      {_isMoreStaffPorterLoading = v, update()};
}
