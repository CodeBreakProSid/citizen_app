// ignore_for_file: prefer_final_locals, prefer_final_in_for_each

// import 'dart:io';
//import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../routes/app_pages.dart';
import '../../../services/other_services.dart';
import '../../../services/rail_services.dart';
import '../../../services/user_services.dart';
import '../../../util/api_helper/api_const.dart';
import '../../../util/global_widgets.dart';
import 'page_lonely_base_controller.dart';

class PageLonelyController extends PageLonelyBaseController {
  @override
  void onInit() {
    isDataLoaded = loadData();
    super.onInit();
  }

  static final box = GetStorage();
  //static double progress = 0.0;

  //******************************On Init invoke function***********************
  Future<bool> loadData() async {
    try {
      if (await box.read(ApiConst.Key) != null) {
        // final homeController = Get.find<HomeController>();

        // railwayStaionList = homeController.railwayStaionList ??
        //     await RailServices.getRailwayStationList();

        railwayStaionList = await box.read(ApiConst.RAILWAY_STN_LIST) == null
            ? await RailServices.getRailwayStationList(isUpdate: true)
            : await RailServices.getRailwayStationList();

        // trainList =
        //     homeController.trainList ?? await RailServices.getTrainList();

        trainList = await box.read(ApiConst.TRAIN_LIST) == null
            ? await RailServices.getTrainList(isUpdate: true)
            : await RailServices.getTrainList();

        // genderTypes =
        //     homeController.genderTypes ?? await OtherServices.getGenders();

        genderTypes = await box.read(ApiConst.GENDER_TYPE) == null
            ? await OtherServices.getGenders(isUpdate: true)
            : await OtherServices.getGenders();

        user = await UserServices().getUser();

        //Get user gender
        genderTypes.forEach(
          (key, value) {
            if (user?.genderType == value) {
              gender = value;

              return;
            }
          },
        );

        return true;
      }

      await Get.offAllNamed(Routes.LOGIN);

      return false;
    } catch (e) {
      if (kDebugMode) rethrow;

      return false;
    }
  }

  //******************************Train stops finder function*******************

  Future<void> trainStops() async {
    fromTrainStopStation =
        await RailServices.getTrainStopStationList(selectedTrain?.id);
  }

  // //******************************Select files function*************************
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

  // //******************************Remove files function*************************
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

  //******************************Create lonely passenger***********************
  Future<void> saveLonelyPassenger(BuildContext context) async {
    try {
      isUploading = true;
      lonelyPassengerFormKey.currentState?.save();

      final String passengerName =
          '${lonelyPassengerFormKey.currentState?.fields['name']?.value}';

      final String passengerAge =
          '${lonelyPassengerFormKey.currentState?.fields['age']?.value}';

      final String passengerGender =
          '${lonelyPassengerFormKey.currentState?.fields['genderType']?.value}';

      final String passengerDOJ =
          '${lonelyPassengerFormKey.currentState?.fields['doj']?.value}';

      final int passengerTravellingTrainId =
          selectedTrain?.id ?? trainList.first.id;

      final String passengerCoachNo =
          '${lonelyPassengerFormKey.currentState?.fields['coachNo']?.value}';

      final String passengerSeatNo =
          '${lonelyPassengerFormKey.currentState?.fields['seatNo']?.value}';

      final int? passengerSourceRailwayStationId =
          selectedFromTrainStopStation?.id ?? fromTrainStopStation.first.id;

      final int? passengerDestinationRailwayStationId =
          selectedToTrainStopStation?.id ?? fromTrainStopStation.first.id;

      final String trainPNRNo =
          '${lonelyPassengerFormKey.currentState?.fields['pnr']?.value}';

      final String passengerMobileNo =
          '${lonelyPassengerFormKey.currentState?.fields['mobileNo']?.value}';

      final String passengerDressCode =
          '${lonelyPassengerFormKey.currentState?.fields['dressCode']?.value}';

      final String passengerRemarks =
          '${lonelyPassengerFormKey.currentState?.fields['message']?.value}';

      Map<String, dynamic> formData = {
        'name': passengerName,
        'age': passengerAge,
        'gender': GenderTypeConst.GENDER_TYPE[int.parse(passengerGender) - 1],
        'date_of_journey': dateFormat.format(DateTime.parse(passengerDOJ)),
        'train': passengerTravellingTrainId,
        'coach': passengerCoachNo,
        'seat': passengerSeatNo,
        'entrain_station': passengerSourceRailwayStationId,
        'detrain_station': passengerDestinationRailwayStationId,
        'pnr_number': trainPNRNo,
        'mobile_number': passengerMobileNo,
        'dress_code': passengerDressCode,
        'remarks': passengerRemarks,
        'utc_timestamp': '${DateTime.now()}',
        'citizen_id': user?.citizenId,
      };

      Map<String, dynamic> tempFormData = Map.from(formData);

      for (var entry in tempFormData.entries) {
        if (entry.value.toString() == 'null' || entry.value.toString() == '') {
          formData.remove(entry.key);
        }
      }

      final Map<String, dynamic> formDataWithFile =
          await fileUplaodFunction(formData);

      await RailServices.createNewLonelyPassenger(
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
    } catch (e) {
      if (kDebugMode) rethrow;

      isUploading = false;
    }
  }

  //******************************File upload **********************************
  static Future<Map<String, dynamic>> fileUplaodFunction(
    Map<String, dynamic> formData,
  ) async {
    final controller = Get.find<PageLonelyController>();

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
