import 'package:get/get.dart';

import '../controllers/sos_page_controller.dart';

class SosPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SosPageController>(
      () => SosPageController(),
    );
  }
}
