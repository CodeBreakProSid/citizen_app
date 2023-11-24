// ignore_for_file: cancel_subscriptions

import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../data/contact_category.dart';
import '../../../data/district_details.dart';
import '../../../data/firebase_tocken.dart';
import '../../../data/intelligence_type.dart';
import '../../../data/lonely_passenger_details.dart';
import '../../../data/meeting_history.dart';
import '../../../data/police_station.dart';
import '../../../data/police_station_users.dart';
import '../../../data/public_services.dart';
import '../../../data/rail_notification.dart';
import '../../../data/rail_volunteer.dart';
import '../../../data/rail_volunteer_category.dart';
import '../../../data/railway_station_details.dart';
import '../../../data/severity_type.dart';
import '../../../data/shop_category.dart';
import '../../../data/staff_porter_category.dart';
import '../../../data/state_list.dart';
import '../../../data/ticket_details.dart';
import '../../../data/train_details.dart';
import '../../../data/train_stop_station_list.dart';
import '../../../data/user.dart';
import '../../../data/user_notification.dart';
import '../../../services/user_services.dart';

class HomeBaseController extends GetxController {
  final policeStationFormKey = GlobalKey<FormBuilderState>();
  final emergencyServiceFormKey = GlobalKey<FormBuilderState>();
  final notificationFormKey = GlobalKey<FormBuilderState>();
  final sosMessageFormKey = GlobalKey<FormBuilderState>();
  final userServices = UserServices();
  final int maxInt = 4294967296;

  late final List<RailVolunteer> registeredRailvolunteerDetails;

  late StreamSubscription<Position> positionStream;
  late LocationSettings locationSettings;
  late final Future<bool> isDataLoaded;
  late final List<PoliceStation> policeStations;
  late final List<PublicServices> publicServices;
  late final Map<String, dynamic> ticketStatus;
  late Map<String, dynamic> notificationType;
  late String userName;
  TabController? tabController;

  final utcFormat = DateFormat('yyyy-MM-dd hh:mm:ss');

  bool isInternetAvailable = false;

  //Test
  List<IntelligenceType>? intelligenceTypes;
  List<SeverityType>? severityTypes;
  List<StaffPorterCategory>? staffPorterTypes;
  List<ShopCategory>? shopCategoryTypes;
  List<ContactCategory>? contactCategoryTypes;
  List<RailVolunteerCategory>? volunteerCat;
  List<DistrictDetails>? districtList;
  List<StateList>? stateList;
  List<RailwayStationDetails>? railwayStaionList;
  List<TrainDetails>? trainList;
  List<TrainStopStationList>? fromTrainStopStation;
  List<TrainStopStationList>? toTrainStopStation;
  late final Map<String, dynamic>? genderTypes;
  late final Map<String, dynamic> ticketTypes;

  List railTicketStatus = [
    'Open',
    'Assigned',
    'Rejected',
    'Closed',
    'Attended',
  ];
  List railTicketCategory = [
    'Lonely',
    'Intruder Alert',
    'Intelligence Report',
    'Incident on Train',
    'Incident on Platform',
    'Incident on Track',
  ];

  List<XFile> fileToUpload = [];

  late List<TicketDetails> tickets;
  late List<MeetingHistory> meetings;
  late Map<String, dynamic> meetingState;

  late Position? currentLocation;
  DistrictDetails? selectedDistrict;
  PoliceStation? nearestStaion;
  PoliceStation? selectedPoliceStation;
  List<TicketDetails> ticketsToDisplay = [];
  FirebaseTocken? firebaseTokenApiResponse;

  List<PoliceStationUsers> _policeStationUsers = [];
  List<UserNotification> _userNotification = [];

  List<RailNotification> _railNotification = [];
  bool _railNotificationIsLoading = false;
  List<LonelyPassengerDetails> _initialListOfRailNotification = [];

  List<String> emergencyServiceList = ['Police Control Room'];

  User? _user;
  bool _isDataLoading = false;
  bool forwardButton = false;
  bool _backwardButton = false;
  bool _isTicketLoading = false;
  bool _isCallHistoryLoading = false;
  bool _notificationIsLoading = false;
  bool _loggingout = false;
  bool _noMoreNotification = true;
  bool _isMoreNotificationLoading = false;

  int startingTicketId = 4294967296;
  int notificationStartId = 4294967296;
  int notificationToShow = 10;

  String policeStationName = '';

  User? get user => _user;
  set user(User? v) => {_user = v, userName = user?.username ?? '', update()};

  bool get isDataLoading => _isDataLoading;
  set isDataLoading(bool v) => {_isDataLoading = v, update()};

  bool get backwardButton => _backwardButton;
  set backwardButton(bool v) => {_backwardButton = v, update()};

  List<PoliceStationUsers> get policeStationUsers => _policeStationUsers;
  set policeStationUsers(List<PoliceStationUsers> v) =>
      {_policeStationUsers = v, update()};

  bool get isTicketLoading => _isTicketLoading;
  set isTicketLoading(bool v) => {_isTicketLoading = v, update()};

  bool get isCallHistoryLoading => _isCallHistoryLoading;
  set isCallHistoryLoading(bool v) => {_isCallHistoryLoading = v, update()};

  bool get loggingout => _loggingout;
  set loggingout(bool v) => {_loggingout = v, update()};

  bool get noMoreNotification => _noMoreNotification;
  set noMoreNotification(bool v) => {_noMoreNotification = v, update()};

  bool get notificationIsLoading => _notificationIsLoading;
  set notificationIsLoading(bool v) => {_notificationIsLoading = v, update()};

  bool get isMoreNotificationLoading => _isMoreNotificationLoading;
  set isMoreNotificationLoading(bool v) =>
      {_isMoreNotificationLoading = v, update()};

  List<UserNotification> get userNotification => _userNotification;
  set userNotification(List<UserNotification> v) =>
      {_userNotification = v, update()};

  List<RailNotification> get railNotification => _railNotification;
  set railNotification(List<RailNotification> v) =>
      {_railNotification = v, update()};

  List<LonelyPassengerDetails> get initialListOfRailNotification =>
      _initialListOfRailNotification;
  set initialListOfRailNotification(List<LonelyPassengerDetails> v) =>
      {_initialListOfRailNotification = v, update()};

  bool get railNotificationIsLoading => _railNotificationIsLoading;
  set railNotificationIsLoading(bool v) =>
      {_railNotificationIsLoading = v, update()};
}
