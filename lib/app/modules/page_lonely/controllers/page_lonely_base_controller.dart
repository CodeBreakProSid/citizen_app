import 'package:dropdown_search/dropdown_search.dart';
//import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../data/railway_station_details.dart';
import '../../../data/train_details.dart';
import '../../../data/train_stop_station_list.dart';
import '../../../data/user.dart';

class PageLonelyBaseController extends GetxController {
  final lonelyPassengerFormKey = GlobalKey<FormBuilderState>();
  final testKey = GlobalKey<DropdownSearchState>();

  late final List<TrainDetails> trainList;
  late List<TrainStopStationList> fromTrainStopStation;
  late final List<TrainStopStationList> toTrainStopStation;
  late final List<RailwayStationDetails> railwayStaionList;

  // List<PlatformFile> fileToUpload = [];
  XFile? uploadImages;
  final dateFormat = DateFormat('yyyy-MM-dd');

  late final Map<String, dynamic> genderTypes;

  dynamic gender;

  TrainDetails? selectedTrain;
  TrainStopStationList? selectedFromTrainStopStation;
  TrainStopStationList? selectedToTrainStopStation;
  User? user;

  late final Future<bool> isDataLoaded;
  //double progress = 0.0;

  bool _showProgress = false;
  bool _isUploading = false;

  bool get isUploading => _isUploading;
  set isUploading(bool v) => {_isUploading = v, update()};

  bool get showProgress => _showProgress;
  set showProgress(bool v) => {_showProgress = v, update()};
}
