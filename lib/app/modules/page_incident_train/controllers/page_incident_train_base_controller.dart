//import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../data/train_details.dart';
import '../../../data/user.dart';

class PageIncidentTrainBaseController extends GetxController {
  final incidentTrainFormKey = GlobalKey<FormBuilderState>();
  //List<PlatformFile> fileToUpload = [];
  XFile? uploadImages;

  final utcFormat = DateFormat('yyyy-MM-dd hh:mm:ss');
  final dateFormat = DateFormat('yyyy-MM-dd');

  DateTime _dateTime = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    DateTime.now().hour,
    DateTime.now().minute,
    DateTime.now().microsecond,
  );

  TrainDetails? selectedTrain;
  Position? currentLocation;
  late final List<TrainDetails> trainList;
  User? user;
  late final Future<bool> isDataLoaded;
  bool _isUploading = false;

  bool get isUploading => _isUploading;
  set isUploading(bool v) => {_isUploading = v, update()};

  // ignore: unnecessary_getters_setters
  DateTime get dateTime => _dateTime;
  set dateTime(DateTime dateTime) {
    _dateTime = dateTime;
  }
}
