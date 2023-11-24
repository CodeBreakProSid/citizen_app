import 'package:camera/camera.dart';
import 'package:get/get.dart';

class CameraBaseController extends GetxController {
  late Future<bool> isDataLoaded;
  late List<CameraDescription>  listOfCameras;
  late CameraController         cameraController;
  XFile?                        image;

  bool _isPhotoTaken          = false;
  bool _isTakingImage         = false;

  bool get isPhotoTaken => _isPhotoTaken;
  set isPhotoTaken(bool v) => {_isPhotoTaken = v, update()};

  bool get isTakingImage => _isTakingImage;
  set isTakingImage(bool v) => {_isTakingImage = v, update()};
}
