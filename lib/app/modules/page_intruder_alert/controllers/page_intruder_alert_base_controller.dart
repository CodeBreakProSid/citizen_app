//import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../data/train_details.dart';
import '../../../data/user.dart';

class PageIntruderAlertBaseController extends GetxController {
  final intruderFormKey = GlobalKey<FormBuilderState>();
  //List<PlatformFile> fileToUpload = [];
  XFile? uploadImages;
  late final List<TrainDetails> trainList;
  Position? currentLocation;
  final utcFormat = DateFormat('yyyy-MM-dd hh:mm:ss');
  bool _isUploading = false;
  late final Future<bool> isDataLoaded;
  User? user;
  TrainDetails? selectedTrain;

  bool get isUploading => _isUploading;
  set isUploading(bool v) => {_isUploading = v, update()};
}
