//import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/rail_volunteer_category.dart';
import '../../../data/railway_policestation_list.dart';
import '../../../data/railway_station_details.dart';
import '../../../data/user.dart';

class PageRailVolunteerBaseController extends GetxController {
  final railVolunteerFormKey = GlobalKey<FormBuilderState>();

  //List<PlatformFile> fileToUpload = [];
  XFile? uploadImages;

  late final Map<String, dynamic> genderTypes;
  late final List<RailVolunteerCategory> volunteerCat;
  late final List<RailwayStationDetails> fromTrainStopStation;
  late final List<RailwayStationDetails> toTrainStopStation;
  late final List<RailwayStationDetails> railwayStaionList;
  late final List<RailwayPoliceStationList> railwayPoliceStationList;

  dynamic gender;
  Position? currentLocation;
  RailwayStationDetails? selectedSeasonFromRailwayStation;
  RailwayStationDetails? selectedSeasonToRailwayStation;
  RailwayStationDetails? selectedRailwayStation;
  RailwayPoliceStationList? selectedRailwayPoliceStation;

  bool _isUploading = false;
  bool _railVolunteerStatus = false;
  User? user;

  late final Future<bool> isDataLoaded;

  bool get railVolunteerStatus => _railVolunteerStatus;
  set railVolunteerStatus(bool v) => {_railVolunteerStatus = v, update()};

  bool get isUploading => _isUploading;
  set isUploading(bool v) => {_isUploading = v, update()};
}
