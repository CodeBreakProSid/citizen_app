import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../data/resource_component_details.dart';
import '../../../data/ticket_component_group.dart';
import '../../../data/ticket_component_group_details.dart';
import '../../../routes/app_pages.dart';
import '../../../services/auth_services.dart';
import '../../../services/ticket_services.dart';
import '../../../services/user_services.dart';
import '../../../util/api_helper/api_const.dart';
import '../../../util/general_utils.dart';
import '../../../util/global_widgets.dart';
import 'ticket_base_details_controller.dart';

class TicketDetailsController extends TicketBaseDetailsController {
  final ReceivePort _port = ReceivePort();

  @override
  void onInit() {
    isDataLoaded = loadData();
    super.onInit();

    IsolateNameServer.registerPortWithName(
      _port.sendPort,
      'downloader_send_port',
    );
    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  //******************************On Init invoke function***********************
  Future<bool> loadData() async {
    try {
      if (await AuthServices.checkValidity()) {
        token = box.read(ApiConst.Key) as String;
        user = await UserServices().getUser();
        isComponentsLoading = true;
        isComponentsLoading = !await loadMoreComponentGroups();

        return true;
      }
      showSnackBar(
        type: SnackbarType.warning,
        message: 'Please login again',
      );
      Get.offAllNamed(Routes.LOGIN);

      return false;
    } catch (e) {
      if (kDebugMode) rethrow;

      return false;
    }
  }

  //******************************Load more component group*********************
  Future<bool> loadMoreComponentGroups() async {
    try {
      noMoreGroups = true;

      if (isDataSaved) {
        fromGroupCompId = maxInt;

        //Reset the data in the controller
        componentGroupBuffer.clear();
        displayData.clear();
        fileToUpload.clear();
        ticketDetailsFormKey.currentState?.reset();

        isDataSaved = false;
      }

      final List<TicketComponentGroup> componentGroups =
          await TicketServices.getTicketComponentGroup(
        ticketDetails['ticket_id'] as int,
        fromGroupCompId,
        noOfGroupsToLoad + 1,
      );

      if (componentGroups.isNotEmpty) {
        noMoreGroups = componentGroups.length <= noOfGroupsToDisplay;
        fromGroupCompId =
            noMoreGroups ? maxInt : componentGroups.last.componentId;
        noOfGroupsToDisplayNow =
            noMoreGroups ? componentGroups.length : noOfGroupsToDisplay;

        for (int index = 0; index < noOfGroupsToDisplayNow; index++) {
          final TicketComponentGroupDetails? components =
              await TicketServices.getTicketComponentGroupDetails(
            componentGroups[index].componentId,
          );

          if (components != null) {
            componentGroupBuffer.add(componentGroups[index]);
            displayData.add(components);
          }
        }
      }

      return true;
    } catch (e) {
      if (kDebugMode) rethrow;

      return false;
    }
  }

  //******************************File picker function**************************
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
      } else {
        await openAppSettings();
      }
    } catch (e) {
      Get.reload();
    }
  }

  //******************************File remove function**************************
  Future<void> removeFile(PlatformFile file) async {
    fileToUpload.remove(file);
    update();
  }

  //******************************Save function*********************************
  Future<void> save() async {
    try {
      isUploading = true;
      ticketDetailsFormKey.currentState?.saveAndValidate();
      final String message =
          ticketDetailsFormKey.currentState?.value['message'] != null
              ? ticketDetailsFormKey.currentState?.value['message'] as String
              : '';

      if (message.trim() == '' && fileToUpload.isEmpty) {
        showSnackBar(
          type: SnackbarType.error,
          message: 'Please enter a message or upload a file',
        );
        isUploading = false;

        return;
      }

      for (final element in fileToUpload) {
        if (element.size > 300 * 1024 * 1024) {
          showSnackBar(
            type: SnackbarType.error,
            message: 'Size of ${element.name} exceed 300 MB',
            duration: const Duration(seconds: 5),
          );
          isUploading = false;

          return;
        }
      }
      final Map<String, dynamic> formData = {
        'ticket_id': '${ticketDetails['ticket_id'] as int}',
      };

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
      ).then((value) async {
        if (value != null) {
          showSnackBar(
            type: SnackbarType.success,
            message: 'Saved',
          );
          isDataSaved = true;
          await loadMoreComponentGroups();
        }
      });
    } catch (e) {
      if (kDebugMode) rethrow;

      return;
    }
  }

  //******************************Download resource*****************************
  Future<void> downloadResource(ResourceComponentDetails component) async {
    try {
      final String fileName = component.resourceName;

      if (await Permission.storage.isDenied) {
        return;
      }

      final Directory directory = await getDownloadDirectory();

      if (await directory.exists()) {
        await downloadFile(
          '${component.resourceId}',
          directory: directory,
          fileName: fileName,
          accessToken: token,
        );
      } else {
        await downloadFile(
          '${component.resourceId}',
          directory: await getExternalStorageDirectory(),
          fileName: fileName,
          accessToken: token,
        );
      }
    } catch (e) {
      if (kDebugMode) rethrow;

      return;
    }
  }

  //******************************Download record*******************************
  Future<void> downloadRecord(Meeting meeting) async {
    try {
      final String fileName = '${meeting.meetingId}';

      if (await Permission.storage.isDenied) {
        return;
      }

      final Directory directory = await getDownloadDirectory();

      if (await directory.exists()) {
        await downloadRecording(
          '${meeting.meetingId}',
          directory: directory,
          fileName: fileName,
          accessToken: token,
        );
      } else {
        await downloadRecording(
          '${meeting.meetingId}',
          directory: await getExternalStorageDirectory(),
          fileName: fileName,
          accessToken: token,
        );
      }
    } catch (e) {
      if (kDebugMode) rethrow;

      return;
    }
  }

  //******************************Download call back****************************
  static void downloadCallback(
    String id,
    //DownloadTaskStatus status,
    int status,
    int progress,
  ) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }
}
