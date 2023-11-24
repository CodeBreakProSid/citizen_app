// ignore_for_file: prefer_final_locals

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
import 'page_incident_train_base_controller.dart';

class PageIncidentTrainController extends PageIncidentTrainBaseController {
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
        // final homeController = Get.find<HomeController>();

        // trainList =
        //     homeController.trainList ?? await RailServices.getTrainList();

        trainList = await box.read(ApiConst.TRAIN_LIST) == null
            ? await RailServices.getTrainList(isUpdate: true)
            : await RailServices.getTrainList();

        currentLocation = await getCurrentLocation();
        user = await UserServices().getUser();

        return true;
      }

      await Get.offAllNamed(Routes.LOGIN);

      return false;
    } catch (e) {
      if (kDebugMode) rethrow;

      return false;
    }
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

  //******************************Select files from storage*********************
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

  //******************************Remove files**********************************
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

  //******************************Create incident on train**********************
  Future<void> submitIncidentOnTrain(BuildContext context) async {
    try {
      if (uploadImages == null) {
        showSnackBar(
          type: SnackbarType.error,
          message: 'Please select an image',
        );
      } else {
        isUploading = true;
        incidentTrainFormKey.currentState?.save();

        final String informerName =
            '${incidentTrainFormKey.currentState?.fields['name']?.value}';
        final String informerAge =
            '${incidentTrainFormKey.currentState?.fields['age']?.value}';
        final String informerMobileNo =
            '${incidentTrainFormKey.currentState?.fields['mobileNo']?.value}';
        final int incidentOnTrainId = selectedTrain?.id ?? trainList.first.id;
        final String incidentOnCoachNo =
            '${incidentTrainFormKey.currentState?.fields['coachNo']?.value}';
        final String incidentOnSeatNo =
            '${incidentTrainFormKey.currentState?.fields['seatNo']?.value}';
        final String incidetDetails =
            '${incidentTrainFormKey.currentState?.fields['incident']?.value}';
        double? latitude = currentLocation?.latitude;
        double? longitude = currentLocation?.longitude;

        final Map<String, dynamic> formData = {
          'incident_type': 'Train',
          'data_from': ApiConst.API_CALL_FROM,
          'name': informerName,
          'age': informerAge,
          'mobile_number': informerMobileNo,
          'train': incidentOnTrainId,
          'coach': incidentOnCoachNo,
          'seat': incidentOnSeatNo,
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

  //******************************File upload function**************************
  // static Future<Map<String, dynamic>> fileUplaodFunction(
  //   Map<String, dynamic> formData,
  // ) async {
  //   final controller = Get.find<PageIncidentTrainController>();

  //   if (controller.fileToUpload.isEmpty) {
  //     showSnackBar(
  //       type: SnackbarType.error,
  //       message: 'Please select an image',
  //     );
  //     controller.isUploading = false;

  //     return {'error': 'Please select an image'};
  //   } else {
  //     for (final element in controller.fileToUpload) {
  //       const int maxSize = 300 * 1024 * 1024;
  //       if (element.size >= maxSize) {
  //         showSnackBar(
  //           type: SnackbarType.error,
  //           message: 'Size of ${element.name} exceed 300 MB',
  //         );
  //         controller.isUploading = false;

  //         return {'error': 'Image size exceeded'};
  //       }
  //     }
  //   }

  //   await Future.forEach<PlatformFile>(
  //     controller.fileToUpload,
  //     (element) async {
  //       formData.addEntries(
  //         <String, dynamic>{
  //           'photo': MultipartFile(element.path, filename: element.name),
  //         }.entries,
  //       );
  //     },
  //   );

  //   return formData;
  // }

  //******************************image upload support**************************
  static Future<Map<String, dynamic>> fileUplaodFunction(
    Map<String, dynamic> formData,
  ) async {
    final controller = Get.find<PageIncidentTrainController>();

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
