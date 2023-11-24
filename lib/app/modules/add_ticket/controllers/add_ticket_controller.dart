import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../data/ticket_details.dart';
import '../../../routes/app_pages.dart';
import '../../../services/home_services.dart';
import '../../../services/other_services.dart';
import '../../../services/ticket_services.dart';
import '../../../services/user_services.dart';
import '../../../util/api_helper/api_const.dart';
import '../../../util/global_widgets.dart';
import 'add_ticket_base_controller.dart';

class AddTicketController extends AddTicketBaseController {
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
        policeStations = await box.read(ApiConst.POLICE_STATION) == null
            ? await HomeServices.getPoliceStations(isUpdate: true)
            : await HomeServices.getPoliceStations();
        ticketTypes = await box.read(ApiConst.TICKET_TYPE) == null
            ? await TicketServices.getTicketTypes(isUpdate: true)
            : await TicketServices.getTicketTypes();
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

        currentLocation = await getCurrentLocation();

        if (currentLocation != null) {
          nearestStaion = await HomeServices.getContainingPoliceStation(
            currentLocation,
          );
          selectedPoliceStation = nearestStaion;
        } else {
          nearestStaion = null;
        }

        return true;
      }
      await Get.offAllNamed(Routes.LOGIN);

      return false;
    } catch (e) {
      if (kDebugMode) rethrow;

      return false;
    }
  }

  //******************************Select file from storage**********************
  Future<void> selectFiles() async {
    try {
      if (await Permission.manageExternalStorage.isGranted
          || await Permission.audio.isGranted
          || await Permission.photos.isGranted
          || await Permission.storage.isGranted) {
        final FilePickerResult? result =
            await FilePicker.platform.pickFiles(allowMultiple: true);

        if (result != null) {
          fileToUpload.addAll(result.files);
          update();
        }
      }
      else if (await Permission.storage.isDenied ||
          await Permission.photos.isDenied ||
          await Permission.storage.isPermanentlyDenied) {
        await openAppSettings();
      }
    } catch (e) {
      showSnackBar(
        type: SnackbarType.warning,
        message:
            'Go to Mobile Settings > Apps -> Janamaithri -> Permission -> Allow files and media permission ',
        duration: const Duration(seconds: 5),
      );
    }
  }

  //******************************Remove file from app**************************
  Future<void> removeFile(PlatformFile file) async {
    fileToUpload.remove(file);
    update();
  }

  //******************************Save janamaithri ticket***********************
  Future<void> save() async {
    try {
      isUploading = true;
      addTicketFormKey.currentState?.save();
      final String ticketTypeId =
          '${addTicketFormKey.currentState?.fields['ticket_type']?.value}';
      final int stationId =
          selectedPoliceStation?.stationId ?? policeStations.first.stationId;
      final String message =
          addTicketFormKey.currentState?.value['message'] as String;

      if (message.trim() == '' && fileToUpload.isEmpty) {
        showSnackBar(
          type: SnackbarType.error,
          message: 'Please enter a message or upload a file',
        );
        isUploading = false;

        return;
      }

      for (final element in fileToUpload) {
        const int maxSize = 300 * 1024 * 1024;
        if (element.size >= maxSize) {
          showSnackBar(
            type: SnackbarType.error,
            message: 'Size of ${element.name} exceed 300 MB',
          );
          isUploading = false;

          return;
        }
      }

      final TicketDetails? ticketDetails = await TicketServices.createNewTicket(
        ticketTypeId,
        stationId,
      );

      if (ticketDetails != null) {
        final Map<String, dynamic> formData = {
          'ticket_id': '${ticketDetails.ticketId}',
        };
        if (meetingId != null) {
          formData
              .addEntries(<String, dynamic>{'meeting_id': meetingId}.entries);
        }

        if (message.trim() != '') {
          formData.addEntries(<String, dynamic>{'message': message}.entries);
        }

        await Future.forEach<PlatformFile>(fileToUpload, (element) async {
          formData.addEntries(
            <String, dynamic>{
              'files': MultipartFile(element.path, filename: element.name),
            }.entries,
          );
        });

        await TicketServices.createNewComponentGroup(
          FormData(formData),
        ).then((value) {
          if (value != null) {
            showSnackBar(
              type: SnackbarType.success,
              message: 'Ticket created successfully',
            );
            Get.offAllNamed(Routes.HOME);
          }
        });
      } else {
        showSnackBar(
          type: SnackbarType.error,
          message: 'Fail to create the ticket',
        );
      }
      isUploading = false;
    } catch (e) {
      if (kDebugMode) rethrow;

      isUploading = false;
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
}
