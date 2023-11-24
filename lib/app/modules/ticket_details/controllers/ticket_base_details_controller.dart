import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/ticket_component_group.dart';
import '../../../data/ticket_component_group_details.dart';
import '../../../data/user.dart';

class TicketBaseDetailsController extends GetxController {
  final ticketDetailsFormKey = GlobalKey<FormBuilderState>();
  final box                  = GetStorage();

  final Map<String, dynamic> ticketDetails =
      Get.arguments as Map<String, dynamic>; 

  late String                 token;
  late Future<bool>           isDataLoaded;
  late User?                  user;
  late int                    noOfGroupsToDisplayNow;
  late bool                   noMoreGroups;

  List<TicketComponentGroup> componentGroups      = [];
  List<TicketComponentGroup> componentGroupBuffer = [];
  List<TicketComponentGroupDetails> _displayData  = [];
  List cratedTime                                 = [];
  List<PlatformFile> fileToUpload                 = [];

  int noOfGroupsToDisplay                         = 10;
  int fromGroupCompId                             = 4294967296;
  final int maxInt                                = 4294967296;
  String message                                  = '';

  bool _isDataLoading                             = false;
  bool _isUploading                               = false;
  bool _isComponentsLoading                       = false;
  bool _isComponentsMoreLoading                   = false;
  bool _isDataSaved                               = false;
  bool apiMessageResponse                         = true;
  bool apiResourceResponse                        = true;

  

  int get noOfGroupsToLoad => noOfGroupsToDisplay + 1;

  bool get isDataLoading => _isDataLoading;
  set isDataLoading(bool v) => {_isDataLoading = v, update()};

  bool get isUploading => _isUploading;
  set isUploading(bool v) => {_isUploading = v, update()};

  bool get isComponentsLoading => _isComponentsLoading;
  set isComponentsLoading(bool v) => {_isComponentsLoading = v, update()};

  bool get isComponentsMoreLoading => _isComponentsMoreLoading;
  set isComponentsMoreLoading(bool v) =>
      {_isComponentsMoreLoading = v, update()};

  List<TicketComponentGroupDetails> get displayData => _displayData;
  set displayData(List<TicketComponentGroupDetails> v) =>
      {_displayData = v, update()};

  bool get isDataSaved => _isDataSaved;
  set isDataSaved(bool v) => {_isDataSaved = v, update()};
}
