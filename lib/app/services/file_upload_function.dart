import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

import '../modules/add_ticket/controllers/add_ticket_controller.dart';
import '../util/global_widgets.dart';

class FileUploadFunction 
{
  static Future<Map<String, dynamic>> fileUplaodFunction(
                      Map<String, dynamic> formData, ) async {

    final controller = Get.find<AddTicketController>();

    if (controller.fileToUpload.isEmpty) {
      showSnackBar(
        type      : SnackbarType.error,
        message   : 'Please select an image',
      );
      controller.isUploading = false;

      return {'error': 'Please select an image'};
    } else {
      for (final element in controller.fileToUpload) {
        const int maxSize = 300 * 1024 * 1024;
        if (element.size >= maxSize) {
          showSnackBar(
            type    : SnackbarType.error,
            message : 'Size of ${element.name} exceed 300 MB',
          );
          controller.isUploading = false;

          return {'error': 'Image size exceeded'};
        }
      }
    }

    await Future.forEach<PlatformFile>(
      controller.fileToUpload,
      (element) async {
        formData.addEntries(
          <String, dynamic>{
            'photo': MultipartFile(element.path, filename: element.name),
          }.entries,
        );
      },
    );

    return formData;
  }
}
