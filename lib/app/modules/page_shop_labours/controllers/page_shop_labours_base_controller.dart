import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../../data/railway_station_details.dart';
import '../../../data/shop_category.dart';
import '../../../data/shop_details.dart';
import '../../../data/staff_porter_category.dart';
import '../../../data/state_list.dart';
import '../../../data/user.dart';

class PageShopLaboursBaseController extends GetxController {
  final shopFormKey = GlobalKey<FormBuilderState>();
  final emplFormKey = GlobalKey<FormBuilderState>();

  late List<ShopCategory> shopCategoryTypes;
  late List<RailwayStationDetails> railwayStaionList;
  late final List<StaffPorterCategory> staffPorterTypes;
  late final Map<String, dynamic> genderTypes;
  late final List<StateList> stateList;

  List<ShopDetails> _shopList = [];
  List<ShopDetails> _moreListOfShops = [];
  List<ShopDetails> _initialListOfShops = [];

  bool _shopListIsLoading = false;
  bool _noMoreShops = false;

  bool _isMoreShopsLoading = false;

  int notificationToShow = 24;

  late Map<String, dynamic> apiResponse;

  bool _isUploading = false;

  dynamic gender;

  late final Future<bool> isDataLoaded;

  late final User? user;

  RailwayStationDetails? selectedRailwayStation;
  ShopCategory? selectedShopCategoryType;
  Position? currentLocation;

  List<Map<String, dynamic>> _listOfEmployees = [];
  List<Map<String, dynamic>> get listOfEmployees => _listOfEmployees;
  set listOfEmployees(List<Map<String, dynamic>> v) =>
      {_listOfEmployees = v, update()};

  bool get isUploading => _isUploading;
  set isUploading(bool v) => {_isUploading = v, update()};

  List<ShopDetails> get shopList => _shopList;
  set shopList(List<ShopDetails> v) => {_shopList = v, update()};

  bool get shopListIsLoading => _shopListIsLoading;
  set shopListIsLoading(bool v) => {_shopListIsLoading = v, update()};

  List<ShopDetails> get initialListOfShops => _initialListOfShops;
  set initialListOfShops(List<ShopDetails> v) =>
      {_initialListOfShops = v, update()};

  bool get noMoreShops => _noMoreShops;
  set noMoreShops(bool v) => {_noMoreShops = v, update()};

  bool get isMoreShopsLoading => _isMoreShopsLoading;
  set isMoreShopsLoading(bool v) => {_isMoreShopsLoading = v, update()};

  List<ShopDetails> get moreListOfShops => _moreListOfShops;
  set moreListOfShops(List<ShopDetails> v) => {_moreListOfShops = v, update()};
}
