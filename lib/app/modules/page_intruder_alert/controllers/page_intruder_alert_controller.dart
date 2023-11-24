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
import 'page_intruder_alert_base_controller.dart';

class PageIntruderAlertController extends PageIntruderAlertBaseController {
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
        currentLocation = await getCurrentLocation();
        user = await UserServices().getUser();

        // trainList =
        //     homeController.trainList ?? await RailServices.getTrainList();

        trainList = await box.read(ApiConst.TRAIN_LIST) == null
            ? await RailServices.getTrainList(isUpdate: true)
            : await RailServices.getTrainList();

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

  //******************************Create intruder alert*************************
  Future<void> submitIntruderAlert(BuildContext context) async {
    try {
      isUploading = true;
      intruderFormKey.currentState?.save();

      final String informerName =
          '${intruderFormKey.currentState?.fields['name']?.value ?? ''}';

      final String informerMobileNo =
          '${intruderFormKey.currentState?.fields['mobileNo']?.value ?? ''}';

      final String informerLocation =
          '${intruderFormKey.currentState?.fields['location']?.value}';

      final int intruderTrainId = selectedTrain?.id ?? trainList.first.id;

      final String incidentRemark =
          '${intruderFormKey.currentState?.fields['remarks']?.value}';

      // ignore: prefer_final_locals
      double? latitude = currentLocation?.latitude;
      // ignore: prefer_final_locals
      double? longitude = currentLocation?.longitude;

      final Map<String, dynamic> formData = {
        'data_from': ApiConst.API_CALL_FROM,
        'informer_details': informerName,
        'mobile_number': informerMobileNo,
        'location': informerLocation,
        'train': intruderTrainId,
        'remarks': incidentRemark,
        'latitude': latitude,
        'longitude': longitude,
        'utc_timestamp': '${DateTime.now()}',
        'citizen_id': user?.citizenId,
      };

      final Map<String, dynamic> formDataWithFile =
          await fileUplaodFunction(formData);

      await RailServices.createNewIntruderAlert(
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

  //******************************image upload support**************************
  static Future<Map<String, dynamic>> fileUplaodFunction(
    Map<String, dynamic> formData,
  ) async {
    final controller = Get.find<PageIntruderAlertController>();

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
