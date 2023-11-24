//import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
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
import 'page_rail_volunteer_base_controller.dart';

class PageRailVolunteerController extends PageRailVolunteerBaseController {
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

        // genderTypes = await OtherServices.getGenders();
        // volunteerCat = homeController.volunteerCat ??
        //     await RailServices.getVolunteerCategory();
        // railwayStaionList = homeController.railwayStaionList ??
        //     await RailServices.getRailwayStationList();
        // fromTrainStopStation = homeController.railwayStaionList ??
        //     await RailServices.getRailwayStationList();
        // toTrainStopStation = homeController.railwayStaionList ??
        //     await RailServices.getRailwayStationList();

        genderTypes = await box.read(ApiConst.GENDER_TYPE) == null
            ? await OtherServices.getGenders(isUpdate: true)
            : await OtherServices.getGenders();
        volunteerCat = await box.read(ApiConst.VOLUNTEER_CATEGORY) == null
            ? await RailServices.getVolunteerCategory(isUpdate: true)
            : await RailServices.getVolunteerCategory();
        railwayStaionList = await box.read(ApiConst.RAILWAY_STN_LIST) == null
            ? await RailServices.getRailwayStationList(isUpdate: true)
            : await RailServices.getRailwayStationList();
        fromTrainStopStation = await box.read(ApiConst.RAILWAY_STN_LIST) == null
            ? await RailServices.getRailwayStationList(isUpdate: true)
            : await RailServices.getRailwayStationList();
        toTrainStopStation = await box.read(ApiConst.RAILWAY_STN_LIST) == null
            ? await RailServices.getRailwayStationList(isUpdate: true)
            : await RailServices.getRailwayStationList();
        railwayPoliceStationList =
            await box.read(ApiConst.POLICE_STN_LIST) == null
                ? await RailServices.getRailwayPoliceStaionList(isUpdate: true)
                : await RailServices.getRailwayPoliceStaionList();

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

  //*********************Save rail volunteer************************************
  // Future<void> saveRailVolunteer(BuildContext context) async {
  Future<void> saveRailVolunteer() async {
    try {
      if (uploadImages == null) {
        showSnackBar(
          type: SnackbarType.error,
          message: 'Please select an image',
        );
      } else {
        isUploading = true;
        railVolunteerFormKey.currentState?.save();

        final String volunteerCategoryId =
            '${railVolunteerFormKey.currentState?.fields['volunteerCategory']?.value}';
        final String volunteerName =
            '${railVolunteerFormKey.currentState?.fields['name']?.value}';
        final String volunteerAge =
            '${railVolunteerFormKey.currentState?.fields['age']?.value}';
        final String volunteerGender =
            '${railVolunteerFormKey.currentState?.fields['genderType']?.value}';
        final String volunteerMobileNo =
            '${railVolunteerFormKey.currentState?.fields['mobile']?.value}';
        final String volunteerEmail =
            '${railVolunteerFormKey.currentState?.fields['email']?.value}';
        final int? railwayStationId =
            selectedRailwayStation?.id ?? railwayStaionList.first.id;
        final int railwayPoliceStationId = selectedRailwayPoliceStation?.id ??
            railwayPoliceStationList.first.id;
        final String volunteerSeasonStatus =
            '${railVolunteerFormKey.currentState?.fields['seasonTicket']?.value}';
        final int? seasonFromRailwayStationId =
            selectedSeasonFromRailwayStation?.id ?? railwayStaionList.first.id;
        final int? seasonToRailwayStationId =
            selectedSeasonToRailwayStation?.id ?? railwayStaionList.first.id;

        final Map<String, dynamic> formData = {
          'rail_volunteer_category': volunteerCategoryId,
          'data_from': ApiConst.API_CALL_FROM,
          'name': volunteerName,
          'age': volunteerAge,
          'gender': GenderTypeConst.GENDER_TYPE[int.parse(volunteerGender) - 1],
          'mobile_number': volunteerMobileNo,
          'email': volunteerEmail,
          'nearest_railway_station': railwayStationId,
          'police_station': railwayPoliceStationId,
          'season_passenger': volunteerSeasonStatus,
          'entrain_station': seasonFromRailwayStationId,
          'detrain_station': seasonToRailwayStationId,
          'utc_timestamp': '${DateTime.now()}',
          'citizen_id': user?.citizenId,
        };

        final Map<String, dynamic> formDataWithFile =
            await fileUplaodFunction(formData);

        await RailServices.createNewRailVolunteer(
          FormData(formDataWithFile),
        ).then((value) {
          if (value != null) {
            showSnackBar(
              type: SnackbarType.success,
              message: 'Rail volunteer created successfully',
            );

            // Navigator.pushReplacementNamed(
            //   context,
            //   Routes.TICKET_HISTORY_DETAILS,
            //   arguments: {'selectedTabIndex': 1},
            // );

            Get.offAllNamed(Routes.HOME);
          } else {
            showSnackBar(
              type: SnackbarType.error,
              message:
                  'Your rail volunteer account feature is masked, Please contact with the admin to enable it.',
              duration: const Duration(seconds: 5),
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

  //******************************image upload support**************************
  static Future<Map<String, dynamic>> fileUplaodFunction(
    Map<String, dynamic> formData,
  ) async {
    final controller = Get.find<PageRailVolunteerController>();

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
