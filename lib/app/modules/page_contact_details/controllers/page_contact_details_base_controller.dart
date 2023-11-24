// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

import '../../../data/contact_category.dart';
import '../../../data/contact_details.dart';
import '../../../data/railway_station_details.dart';

class PageContactDetailsBaseController extends GetxController {
  final contactFormKey = GlobalKey<FormBuilderState>();
  final emergencyContactFormKey = GlobalKey<FormBuilderState>();
  late final Future<bool> isDataLoaded;

  bool _isContactListLoading = false;
  bool _isMoreContactLoading = false;
  bool _noMoreContacts = false; //true

  bool _isEMRContactListLoading = false;
  bool _noMoreEMRContacts = false;
  bool _isMoreEMRContactLoading = false;

  TabController? tabController;

  int startingTicketId = 4294967296;
  int notificationStartId = 4294967296;
  int notificationToShow = 24;

  final int maxInt = 4294967296;
  late Map<String, dynamic> apiResponse;

  List<ContactDetails> _listOfContacts = [];
  List<ContactDetails> _listOfEmergencyContacts = [];
  List<ContactDetails> _moreListOfContacts = [];
  List<ContactDetails> _moreListOfEMRContacts = [];
  List<ContactDetails> _initialListOfContacts = [];
  List<ContactDetails> _initialListOfEMRContacts = [];

  ContactCategory? selectedContactCategoryType;
  RailwayStationDetails? selectedRailwayStation;
  late List<ContactCategory> contactCategoryTypes;
  late List<RailwayStationDetails> railwayStaionList;

  bool get isContactListLoading => _isContactListLoading;
  set isContactListLoading(bool v) => {_isContactListLoading = v, update()};

  bool get isEMRContactListLoading => _isEMRContactListLoading;
  set isEMRContactListLoading(bool v) =>
      {_isEMRContactListLoading = v, update()};

  bool get noMoreContacts => _noMoreContacts;
  set noMoreContacts(bool v) => {_noMoreContacts = v, update()};

  bool get noMoreEMRContacts => _noMoreEMRContacts;
  set noMoreEMRContacts(bool v) => {_noMoreEMRContacts = v, update()};

  bool get isMoreContactLoading => _isMoreContactLoading;
  set isMoreContactLoading(bool v) => {_isMoreContactLoading = v, update()};

  bool get isMoreEMRContactLoading => _isMoreEMRContactLoading;
  set isMoreEMRContactLoading(bool v) =>
      {_isMoreEMRContactLoading = v, update()};

  List<ContactDetails> get listOfContacts => _listOfContacts;
  set listOfContacts(List<ContactDetails> v) => {_listOfContacts = v, update()};

  List<ContactDetails> get listOfEmergencyContacts => _listOfEmergencyContacts;
  set listOfEmergencyContacts(List<ContactDetails> v) =>
      {_listOfEmergencyContacts = v, update()};

  List<ContactDetails> get moreListOfContacts => _moreListOfContacts;
  set moreListOfContacts(List<ContactDetails> v) =>
      {_moreListOfContacts = v, update()};

  List<ContactDetails> get moreListOfEMRContacts => _moreListOfEMRContacts;
  set moreListOfEMRContacts(List<ContactDetails> v) =>
      {_moreListOfEMRContacts = v, update()};

  List<ContactDetails> get initialListOfContacts => _initialListOfContacts;
  set initialListOfContacts(List<ContactDetails> v) =>
      {_initialListOfContacts = v, update()};
  List<ContactDetails> get initialListOfEMRContacts =>
      _initialListOfEMRContacts;
  set initialListOfEMRContacts(List<ContactDetails> v) =>
      {_initialListOfEMRContacts = v, update()};
}
