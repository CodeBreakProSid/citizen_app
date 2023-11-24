import 'package:camera/camera.dart' as camera;
import 'package:flutter/foundation.dart';

import 'camera_base_controller.dart';

class CameraController extends CameraBaseController {
  @override
  void onInit() {
    isDataLoaded = loadData();
    super.onInit();
  }

  @override
  void onClose() {
    cameraController.dispose();
    super.onClose();
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  Future<bool> loadData() async {
    try {
      listOfCameras       = await camera.availableCameras();
      if (listOfCameras.isNotEmpty) {
        cameraController  = camera.CameraController(
          listOfCameras.first,
          camera.ResolutionPreset.high,
          enableAudio: false,
          imageFormatGroup: camera.ImageFormatGroup.jpeg,
        );
        await cameraController.initialize();
        await cameraController.lockCaptureOrientation();

        return true;
      }

      return false;
    } catch (e) {
      if (kDebugMode) rethrow;

      return false;
    }
  }

  Future<void> takePhoto() async {
    try {
      isTakingImage = true;
      image = await cameraController.takePicture();
      if (image != null) {
        await cameraController.pausePreview();
        isPhotoTaken = true;
      }

      return;
    } catch (e) {
      if (kDebugMode) rethrow;
    } finally {
      isTakingImage = false;
    }
  }

  Future<void> retake() async {
    try {
      await cameraController.resumePreview();
      isPhotoTaken = false;
    } catch (e) {
      if (kDebugMode) rethrow;
    }
  }
}
