import 'package:get/get.dart';

import '../controllers/vedio_calling_controller.dart';

class VedioCallingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VedioCallingController>(
      () => VedioCallingController(),
    );
  }
}
