// ignore_for_file: unnecessary_getters_setters

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../data/awareness_class.dart';
import '../../../data/contact_category.dart';
import '../../../data/contact_details.dart';
import '../../../data/district_details.dart';
import '../../../data/intelligence_type.dart';
import '../../../data/lost_properties_details.dart';
import '../../../data/police_station.dart';
import '../../../data/rail_form.dart';
import '../../../data/rail_volunteer_category.dart';
import '../../../data/railway_station_details.dart';
import '../../../data/safety_tip.dart';
import '../../../data/severity_type.dart';
import '../../../data/shop_category.dart';
import '../../../data/staff_porter_category.dart';
import '../../../data/state_list.dart';
import '../../../data/train_details.dart';
import '../../../data/train_stop_station_list.dart';
import '../../../data/user.dart';

class AddTicketBaseController extends GetxController {
  final addTicketFormKey                        = GlobalKey<FormBuilderState>();
  final addTicketSubFormKey                     = GlobalKey<FormBuilderState>();
  final emplFormKey                             = GlobalKey<FormBuilderState>();
  final int? meetingId                          = Get.arguments as int?;
  TabController?                                  tabController;

  List<Map<String, dynamic>> _listOfEmployees   = [];
  List<Map<String, dynamic>> get listOfEmployees => _listOfEmployees;
  set listOfEmployees(List<Map<String, dynamic>> v) =>
      {_listOfEmployees = v, update()};

  List<RailForm> railforms                      = [];
  late final List<PoliceStation>                  policeStations;
  late final List<DistrictDetails>                districtList;
  late final List<StateList>                      stateList;
  late final List<TrainDetails>                   trainList;
  late final List<TrainStopStationList>           fromTrainStopStation;
  late final List<TrainStopStationList>           toTrainStopStation;
  late final List<RailwayStationDetails>          railwayStaionList;
  late final List<RailVolunteerCategory>          volunteerCat;
  late final List<LostPropertiesDetails>          listOfLostProperties;
  late List<ContactDetails>                       listOfContacts;
  late final List<AwarenessClass>                 listOfAwarenessClass;
  late final List<SafetyTip>                      listOfSafetyTip;
  late final Map<String, dynamic>                 ticketTypes;
  late final Map<String, dynamic>                 genderTypes;
  late final Map<String, dynamic>                 newGenderTypes = {};
  late final Future<bool>                         isDataLoaded;
  late final User?                                user;

  //Rail variables
  late final List<IntelligenceType>               intelligenceTypes;
  late final List<SeverityType>                   severityTypes;
  late final List<StaffPorterCategory>            staffPorterTypes;
  late final List<ShopCategory>                   shopCategoryTypes;
  late final List<ContactCategory>                contactCategoryTypes;
  final utcFormat                               = DateFormat('yyyy-MM-dd hh:mm:ss');
  final dateFormat                              = DateFormat('yyyy-MM-dd');
  final List<String> incidentType               = ['Train', 'Platform', 'Track'];
  dynamic gender;

  Position?               currentLocation;
  PoliceStation?          nearestStaion;
  PoliceStation?          selectedPoliceStation;
  RailwayStationDetails?  selectedRailwayStation;
  RailwayStationDetails?  selectedSeasonFromRailwayStation;
  RailwayStationDetails?  selectedSeasonToRailwayStation;
  TrainStopStationList?   selectedFromTrainStopStation;
  TrainStopStationList?   selectedToTrainStopStation;
  DistrictDetails?        selectedDistrict;
  StateList?              selectedState;
  TrainDetails?           selectedTrain;
  IntelligenceType?       selectedIntelligenceType;
  ContactCategory?        selectedContactCategoryType;
  SeverityType?           selectedSeverityType;
  StaffPorterCategory?    selectedStaffPorterType;
  ShopCategory?           selectedShopCategoryType;
  RailVolunteerCategory?  selectedVolunteerCat;
  List<File> files        = [];
  List<PlatformFile>      fileToUpload = [];

  bool _isLogging                   = false;
  bool _isUploading                 = false;
  bool _isLostPropertiesLoading     = false;
  bool _isContactListLoading        = false;
  bool _isAwarenessClassListLoading = false;
  bool _isSafetyTipListLoading      = false;

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

  bool get isSafetyTipListLoading => _isSafetyTipListLoading;
  set isSafetyTipListLoading(bool v) => {_isSafetyTipListLoading = v, update()};

  bool get isAwarenessClassListLoading => _isAwarenessClassListLoading;
  set isAwarenessClassListLoading(bool v) =>
      {_isAwarenessClassListLoading = v, update()};

  bool get isLostPropertiesLoading => _isLostPropertiesLoading;
  set isLostPropertiesLoading(bool v) =>
      {_isLostPropertiesLoading = v, update()};

  bool get isContactListLoading => _isContactListLoading;
  set isContactListLoading(bool v) => {_isContactListLoading = v, update()};

  bool get isLogging => _isLogging;
  set isLogging(bool v) => {_isLogging = v, update()};

  bool get isUploading => _isUploading;
  set isUploading(bool v) => {_isUploading = v, update()};
}
