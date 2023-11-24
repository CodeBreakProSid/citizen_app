// ignore_for_file: prefer_final_locals

//import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../routes/app_pages.dart';
import '../../../services/rail_services.dart';
import '../../../services/user_services.dart';
import '../../../util/api_helper/api_const.dart';
import '../../../util/global_widgets.dart';
import 'page_incident_track_base_controller.dart';

class PageIncidentTrackController extends PageIncidentTrackBaseController {
  @override
  void onInit() {
    isDataLoaded = loadData();
    super.onInit();
  }

  static final box = GetStorage();

  //******************************On Init invoke function***********************
  Future<bool> loadData() async {
    try {
      if (await box.read(ApiConst.Key) != null) {
        user = await UserServices().getUser();
        currentLocation = await getCurrentLocation();

        return true;
      }
      await Get.offAllNamed(Routes.LOGIN);

      return false;
    } catch (e) {
      if (kDebugMode) rethrow;

      return false;
    }
  }

  // //******************************Select files from storage*********************
  // Future<void> selectFiles() async {
  //   try {
  //     if (await Permission.storage.isGranted ||
  //         await Permission.photos.isGranted) {
  //       final FilePickerResult? result =
  //           await FilePicker.platform.pickFiles(allowMultiple: true);

  //       if (result != null) {
  //         fileToUpload.addAll(result.files);
  //         update();
  //       }
  //     } else if (await Permission.storage.isDenied ||
  //         await Permission.storage.isPermanentlyDenied) {
  //       await openAppSettings();
  //     }
  //   } catch (e) {
  //     showSnackBar(
  //       type: SnackbarType.warning,
  //       message:
  //           'Go to Mobile Settings > Apps -> Janamaithri -> Permission -> Allow files and media permission ',
  //       duration: const Duration(seconds: 5),
  //     );
  //   }
  // }

  // //******************************Remove files**********************************
  // Future<void> removeFile(PlatformFile file) async {
  //   fileToUpload.remove(file);
  //   update();
  // }

  //******************************Upload image function*************************
  Future<void> uploadImage(ImageSource source) async {
    try {
      if (await Permission.camera.isGranted ||
          await Permission.storage.isGranted ||
          await Permission.photos.isGranted) {
        final picker = ImagePicker();
        final pickedImage = await picker.pickImage(source: source);
        if (pickedImage != null) {
          uploadImages = pickedImage;
          update();
        }
      } else if (await Permission.camera.isGranted ||
          await Permission.storage.isDenied ||
          await Permission.storage.isPermanentlyDenied) {
        await openAppSettings();
      }
    } catch (e) {
      showSnackBar(
        type: SnackbarType.warning,
        message:
            'Go to Mobile Settings > Apps -> Janamaithri -> Permission -> Allow camera and media permission ',
        duration: const Duration(seconds: 5),
      );
    }
  }

  //******************************Remove files function*************************
  Future<void> removeImage() async {
    uploadImages = null;
    update();
  }

  //******************************Get current location**************************
  Future<Position?> getCurrentLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!await Permission.location.isGranted) {
        return null;
      }
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
      }

      return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      return null;
    }
  }

  //******************************Create incident on train**********************
  Future<void> submitIncidentOnTrack(BuildContext context) async {
    try {
      if (uploadImages == null) {
        showSnackBar(
          type: SnackbarType.error,
          message: 'Please select an image',
        );
      } else {
        isUploading = true;
        incidentTrackFormKey.currentState?.save();

        final String informerName =
            '${incidentTrackFormKey.currentState?.fields['name']?.value}';
        final String informerAge =
            '${incidentTrackFormKey.currentState?.fields['age']?.value}';
        final String informerMobileNo =
            '${incidentTrackFormKey.currentState?.fields['mobileNo']?.value}';
        final String incidentOnTrackLocation =
            '${incidentTrackFormKey.currentState?.fields['trackLocation']?.value}';
        final String incidetDetails =
            '${incidentTrackFormKey.currentState?.fields['incident']?.value}';
        double? latitude = currentLocation?.latitude;
        double? longitude = currentLocation?.longitude;

        final Map<String, dynamic> formData = {
          'incident_type': 'Track',
          'data_from': ApiConst.API_CALL_FROM,
          'name': informerName,
          'age': informerAge,
          'mobile_number': informerMobileNo,
          'track_location': incidentOnTrackLocation,
          'incident_details': incidetDetails,
          'latitude': latitude,
          'longitude': longitude,
          'incident_date_time': utcFormat.format(DateTime.parse('$dateTime')),
          'utc_timestamp': '${DateTime.now()}',
          'citizen_id': user?.citizenId,
        };

        final Map<String, dynamic> formDataWithFile =
            await fileUplaodFunction(formData);

        await RailServices.createNewIncidentReport(
          FormData(formDataWithFile),
        ).then((value) {
          if (value != null) {
            showSnackBar(
              type: SnackbarType.success,
              message: 'Ticket created successfully',
            );
            Navigator.pushReplacementNamed(
              context,
              Routes.TICKET_HISTORY_DETAILS,
              arguments: {'selectedTabIndex': 1},
            );
          }
        });

        isUploading = false;
      }
    } catch (e) {
      if (kDebugMode) rethrow;

      isUploading = false;
    }
  }

//******************************File upload **********************************
  static Future<Map<String, dynamic>> fileUplaodFunction(
    Map<String, dynamic> formData,
  ) async {
    final controller = Get.find<PageIncidentTrackController>();

    if (controller.uploadImages == null) {
      return formData;
    } else {
      controller.isUploading = false;
    }

    formData.addIf(
      controller.uploadImages != null,
      'photo',
      MultipartFile(
        controller.uploadImages!.path,
        filename: controller.uploadImages!.name,
      ),
    );

    return formData;
  }
}
