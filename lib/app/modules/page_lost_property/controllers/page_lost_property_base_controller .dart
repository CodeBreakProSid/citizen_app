// ignore_for_file: file_names

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../data/lost_properties_details.dart';
import '../../../data/lost_property_category.dart';
import '../../../data/railway_policestation_list.dart';

class PageLostPropertyBaseController extends GetxController {
  final lostPropertyKey = GlobalKey<FormBuilderState>();
  final GlobalKey<DropdownSearchState<String>> dropdownCategoryKey =
      GlobalKey<DropdownSearchState<String>>();
  final GlobalKey<DropdownSearchState<String>> dropdownStationKey =
      GlobalKey<DropdownSearchState<String>>();

  List<LostPropertiesDetails> _listOfLostProperties = [];

  int notificationToShow = 24;
  bool _noMoreLostProperty = false;

  final dateFormat = DateFormat('yyyy-MM-dd');

  List<LostPropertiesDetails> _initialListOfLostPropery = [];
  List<LostPropertiesDetails> _moreListOfLostPropery = [];

  bool _isLostPropertiesLoading = false;

  bool _isMoreLostPropertiesLoading = false;

  late final Future<bool> isDataLoaded;

  late final List<DropdownMenuItem<String>> lostCategory = [];

  late List<LostPropertyCategory> lostPropertyCategoryTypes;
  late List<RailwayPoliceStationList> railwayPoliceStationList;

  // LostPropertyCategory? selectedLostPropertyCategory;
  // RailwayPoliceStationList? selectedRailwayPoliceStation;
  DateTime? selectedFromDate;
  DateTime? selectedToDate;

  String? selectedLostPropertyCategory;
  String? selectedRailwayPoliceStation;

  late Map<String, dynamic> apiResponse;

  bool get isLostPropertiesLoading => _isLostPropertiesLoading;
  set isLostPropertiesLoading(bool v) =>
      {_isLostPropertiesLoading = v, update()};

  bool get isMoreLostPropertiesLoading => _isMoreLostPropertiesLoading;
  set isMoreLostPropertiesLoading(bool v) =>
      {_isMoreLostPropertiesLoading = v, update()};

  List<LostPropertiesDetails> get initialListOfLostPropery =>
      _initialListOfLostPropery;
  set initialListOfLostPropery(List<LostPropertiesDetails> v) =>
      {_initialListOfLostPropery = v, update()};

  List<LostPropertiesDetails> get moreListOfLostPropery =>
      _moreListOfLostPropery;
  set moreListOfLostPropery(List<LostPropertiesDetails> v) =>
      {_moreListOfLostPropery = v, update()};

  bool get noMoreLostProperty => _noMoreLostProperty;
  set noMoreLostProperty(bool v) => {_noMoreLostProperty = v, update()};

  List<LostPropertiesDetails> get listOfLostProperties => _listOfLostProperties;
  set listOfLostProperties(List<LostPropertiesDetails> v) =>
      {_listOfLostProperties = v, update()};
}
