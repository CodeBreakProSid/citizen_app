//import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../data/staff_porter.dart';
import '../../../routes/app_pages.dart';
import '../../../services/other_services.dart';
import '../../../services/rail_services.dart';
import '../../../services/user_services.dart';
import '../../../util/api_helper/api_const.dart';
import '../../../util/global_widgets.dart';
import 'page_porter_registration_base_controller.dart';

class PagePorterRegistrationController
    extends PagePorterRegistrationBaseController {
  @override
  void onInit() {
    isDataLoaded = loadData();
    super.onInit();
  }

  static final box = GetStorage();
  int? staffporterCount = 0;
  String? next = '';
  List? tempListOfStaffPorter = [];

  //******************************On Init invoke function***********************
  Future<bool> loadData() async {
    try {
      if (await box.read(ApiConst.Key) != null) {
        // final homeController = Get.find<HomeController>();

        // genderTypes =
        //     homeController.genderTypes ?? await OtherServices.getGenders();
        // staffPorterTypes = homeController.staffPorterTypes ??
        //     await RailServices.getStaffPorterCategoryType();
        // stateList =
        //     homeController.stateList ?? await RailServices.getStateList();
        // railwayStaionList = homeController.railwayStaionList ??
        //     await RailServices.getRailwayStationList();

        genderTypes = await box.read(ApiConst.GENDER_TYPE) == null
            ? await OtherServices.getGenders(isUpdate: true)
            : await OtherServices.getGenders();
        staffPorterTypes = await box.read(ApiConst.STAFF_PORTER_TYPE) == null
            ? await RailServices.getStaffPorterCategoryType(isUpdate: true)
            : await RailServices.getStaffPorterCategoryType();
        stateList = await box.read(ApiConst.STATE_LIST) == null
            ? await RailServices.getStateList(isUpdate: true)
            : await RailServices.getStateList();
        railwayStaionList = await box.read(ApiConst.RAILWAY_STN_LIST) == null
            ? await RailServices.getRailwayStationList(isUpdate: true)
            : await RailServices.getRailwayStationList();

        user = await UserServices().getUser();
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

  //******************************Create staff porter***************************
  Future<void> submitStaffPorter() async {
    try {
      if (uploadImages == null) {
        showSnackBar(
          type: SnackbarType.error,
          message: 'Please select an image',
        );
      } else {
        isUploading = true;
        porterFormKey.currentState?.save();

        final int staffPorterCategoryId =
            selectedStaffPorterType?.id ?? staffPorterTypes.first.id;
        final String staffName =
            '${porterFormKey.currentState?.fields['name']?.value}';
        final String staffAge =
            '${porterFormKey.currentState?.fields['age']?.value}';
        final String staffGender =
            '${porterFormKey.currentState?.fields['genderType']?.value}';
        final String staffJob =
            '${porterFormKey.currentState?.fields['jobDetail']?.value}';
        final String staffMobileNo =
            '${porterFormKey.currentState?.fields['mobile']?.value}';
        final String staffAddress =
            '${porterFormKey.currentState?.fields['address']?.value}';
        final int? railwayStationId =
            selectedRailwayStation?.id ?? railwayStaionList.first.id;
        final int stateId = selectedState?.id ?? stateList.first.id;
        final String staffNativePoliceStation =
            '${porterFormKey.currentState?.fields['policeStation']?.value}';
        final String migrantStatus =
            '${porterFormKey.currentState?.fields['migrantOrNot']?.value}';
        final String migrantAadhaarNo =
            '${porterFormKey.currentState?.fields['aadhaarNo']?.value ?? ''}';

        final Map<String, dynamic> formData = {
          'staff_porter_category': staffPorterCategoryId,
          'name': staffName,
          'age': staffAge,
          'gender': GenderTypeConst.GENDER_TYPE[int.parse(staffGender) - 1],
          'job_details': staffJob,
          'mobile_number': staffMobileNo,
          'native_state': stateId,
          'native_police_station': staffNativePoliceStation,
          'address': staffAddress,
          'railway_station': railwayStationId,
          'migrant_or_not': migrantStatus,
          'aadhar_number': migrantAadhaarNo,
          'utc_timestamp': '${DateTime.now()}',
          'citizen_id': user?.citizenId,
        };

        final Map<String, dynamic> formDataWithFile =
            await fileUplaodFunction(formData);

        await RailServices.createNewStaffPorter(
          FormData(formDataWithFile),
        ).then((value) {
          if (value != null) {
            showSnackBar(
              type: SnackbarType.success,
              message: 'Ticket created successfully',
            );
            Get.offAllNamed(Routes.HOME);
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
    final controller = Get.find<PagePorterRegistrationController>();

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

  //***********************Load staff porter list*******************************
  Future<void> loadStaffPorterList() async {
    try {
      staffporterListIsLoading = true;

      final String selectedSPC = selectedStaffPorterType == null
          ? ''
          : '${selectedStaffPorterType?.id}';
      final String selectedRS =
          selectedRailwayStation == null ? '' : '${selectedRailwayStation?.id}';

      final Map<String, String> queryParam = {
        'staff_porter_category': selectedSPC,
        'railway_station': selectedRS,
      };

      const String apiURL = '';

      apiResponse = await RailServices.getStaffPorterList(
        queryParam,
        apiURL,
      );

      staffporterCount = apiResponse['count'] as int;
      next = apiResponse['next'] as String?;
      tempListOfStaffPorter = apiResponse['results'] as List;
      initialListOfStaffPorter = tempListOfStaffPorter!
          .map(
            (e) => StaffPorter.fromJson(e as Map<String, dynamic>),
          )
          .toList();

      if (tempListOfStaffPorter!.isNotEmpty) {
        staffporterList.clear();
        if (initialListOfStaffPorter.length > notificationToShow &&
            next != null) {
          for (var i = 0; i < initialListOfStaffPorter.length; i++) {
            staffporterList.add(initialListOfStaffPorter[i]);
          }
          noMoreStaffporter = false;
        } else {
          noMoreStaffporter = true;
          staffporterList = initialListOfStaffPorter;
        }
      } else {
        staffporterList.clear();
      }

      staffporterListIsLoading = false;
    } catch (e) {
      if (kDebugMode) rethrow;
      staffporterListIsLoading = false;

      return;
    }
  }

  //***********************Load more staff porter list**************************
  Future<void> loadMoreStaffPorter() async {
    try {
      isMoreStaffPorterLoading = true;

      final String selectedSPC = selectedStaffPorterType == null
          ? ''
          : '${selectedStaffPorterType?.id}';
      final String selectedRS =
          selectedRailwayStation == null ? '' : '${selectedRailwayStation?.id}';

      final Map<String, String> queryParam = {
        'staff_porter_category': selectedSPC,
        'railway_station': selectedRS,
      };
      final String apiURL = next ?? '';

      if (next == null || next == '') {
        tempListOfStaffPorter!.clear();
        noMoreStaffporter = true;
      } else {
        apiResponse = await RailServices.getStaffPorterList(
          queryParam,
          apiURL,
        );

        staffporterCount = apiResponse['count'] as int;
        next = apiResponse['next'] as String?;

        final tempListOfStaffPorter = apiResponse['results'] as List;
        moreStaffporterList = tempListOfStaffPorter
            .map(
              (e) => StaffPorter.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }

      if (tempListOfStaffPorter!.isNotEmpty) {
        if (moreStaffporterList.length > notificationToShow) {
          for (var i = 0; i < moreStaffporterList.length; i++) {
            staffporterList.add(moreStaffporterList[i]);
          }
          noMoreStaffporter = false;
        } else {
          staffporterList.addAll(moreStaffporterList);
          noMoreStaffporter = true;
        }
      }

      isMoreStaffPorterLoading = false;
    } catch (e) {
      if (kDebugMode) rethrow;
      isMoreStaffPorterLoading = false;

      return;
    }
  }

  //******************************Reset filter**********************************
  Future<void> resetFilter() async {
    try {
      const String selectedSPC = '';
      const String selectedRS = '';

      final Map<String, String> queryParam = {
        'staff_porter_category': selectedSPC,
        'railway_station': selectedRS,
      };

      const String apiURL = '';

      apiResponse = await RailServices.getStaffPorterList(
        queryParam,
        apiURL,
      );

      staffporterCount = apiResponse['count'] as int;
      next = apiResponse['next'] as String?;
      tempListOfStaffPorter = apiResponse['results'] as List;
      initialListOfStaffPorter = tempListOfStaffPorter!
          .map(
            (e) => StaffPorter.fromJson(e as Map<String, dynamic>),
          )
          .toList();

      if (tempListOfStaffPorter!.isNotEmpty) {
        staffporterList.clear();
        if (initialListOfStaffPorter.length > notificationToShow &&
            next != null) {
          for (var i = 0; i < initialListOfStaffPorter.length; i++) {
            staffporterList.add(initialListOfStaffPorter[i]);
          }
          noMoreStaffporter = false;
        } else {
          noMoreStaffporter = true;
          staffporterList = initialListOfStaffPorter;
        }
      } else {
        staffporterList.clear();
      }

      staffporterListIsLoading = false;
    } catch (e) {
      if (kDebugMode) rethrow;
      staffporterListIsLoading = false;

      return;
    }
  }

  //***********************Load staff porter list*******************************
  // Future<void> loadStaffPorterList() async {
  //   try {
  //     //My code starts
  //     staffporterListIsLoading = true;

  //     if (selectedRailwayStation == null && selectedStaffPorterType == null) {
  //       final Map<String, String> queryParam = {
  //         'railway_station': '',
  //         'staff_porter_category': '',
  //       };
  //       const String apiURL = '';
  //       apiResponse = await RailServices.getStaffPorterList(
  //         queryParam,
  //         apiURL,
  //       );
  //       staffporterCount = apiResponse['count'] as int?;
  //       next = apiResponse['next'] as String?;
  //       tempListOfStaffPorter = apiResponse['results'] as List;
  //       initialListOfStaffPorter = tempListOfStaffPorter!
  //           .map(
  //             (e) => StaffPorter.fromJson(e as Map<String, dynamic>),
  //           )
  //           .toList();
  //       staffporterListIsLoading = false;
  //     } else if (selectedRailwayStation != null &&
  //         selectedStaffPorterType == null) {
  //       final Map<String, String> queryParam = {
  //         'railway_station': '${selectedRailwayStation?.id}',
  //         'staff_porter_category': '',
  //       };
  //       const String apiURL = '';
  //       apiResponse = await RailServices.getStaffPorterList(
  //         queryParam,
  //         apiURL,
  //       );
  //       staffporterCount = apiResponse['count'] as int;
  //       next = apiResponse['next'] as String?;
  //       tempListOfStaffPorter = apiResponse['results'] as List;
  //       initialListOfStaffPorter = tempListOfStaffPorter!
  //           .map(
  //             (e) => StaffPorter.fromJson(e as Map<String, dynamic>),
  //           )
  //           .toList();
  //       staffporterListIsLoading = false;
  //     } else if (selectedRailwayStation == null &&
  //         selectedStaffPorterType != null) {
  //       final Map<String, String> queryParam = {
  //         'railway_station': '',
  //         'staff_porter_category': '${selectedStaffPorterType?.id}',
  //       };
  //       const String apiURL = '';
  //       apiResponse = await RailServices.getStaffPorterList(
  //         queryParam,
  //         apiURL,
  //       );
  //       staffporterCount = apiResponse['count'] as int;
  //       next = apiResponse['next'] as String?;
  //       tempListOfStaffPorter = apiResponse['results'] as List;
  //       initialListOfStaffPorter = tempListOfStaffPorter!
  //           .map(
  //             (e) => StaffPorter.fromJson(e as Map<String, dynamic>),
  //           )
  //           .toList();
  //       staffporterListIsLoading = false;
  //     } else {
  //       final Map<String, String> queryParam = {
  //         'railway_station': '${selectedRailwayStation?.id}',
  //         'staff_porter_category': '${selectedStaffPorterType?.id}',
  //       };
  //       const String apiURL = '';
  //       apiResponse = await RailServices.getStaffPorterList(
  //         queryParam,
  //         apiURL,
  //       );
  //       staffporterCount = apiResponse['count'] as int;
  //       next = apiResponse['next'] as String?;
  //       tempListOfStaffPorter = apiResponse['results'] as List;
  //       initialListOfStaffPorter = tempListOfStaffPorter!
  //           .map(
  //             (e) => StaffPorter.fromJson(e as Map<String, dynamic>),
  //           )
  //           .toList();
  //       staffporterListIsLoading = false;
  //     }

  //     if (tempListOfStaffPorter!.isNotEmpty) {
  //       staffporterList.clear();
  //       if (initialListOfStaffPorter.length > notificationToShow &&
  //           next != null) {
  //         for (var i = 0; i < initialListOfStaffPorter.length; i++) {
  //           staffporterList.add(initialListOfStaffPorter[i]);
  //         }
  //         noMoreStaffporter = false;
  //       } else {
  //         noMoreStaffporter = true;
  //         staffporterList = initialListOfStaffPorter;
  //       }
  //     } else {
  //       staffporterList.clear();
  //     }
  //     //My code end

  //     staffporterListIsLoading = false;

  //     // return true;
  //   } catch (e) {
  //     if (kDebugMode) rethrow;
  //     staffporterListIsLoading = false;

  //     // return false;
  //     return;
  //   }
  // }
}
