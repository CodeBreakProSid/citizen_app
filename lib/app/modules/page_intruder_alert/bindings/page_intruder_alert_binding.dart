import 'package:get/get.dart';

import '../controllers/page_intruder_alert_controller.dart';

class PageIntruderAlertBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PageIntruderAlertController>(
      () => PageIntruderAlertController(),
    );
  }
}
