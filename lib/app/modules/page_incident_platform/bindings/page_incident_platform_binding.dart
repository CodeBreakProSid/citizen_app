import 'package:get/get.dart';

import '../controllers/page_incident_platform_controller.dart';

class PageIncidentPlatformBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PageIncidentPlatformController>(
      () => PageIncidentPlatformController(),
    );
  }
}
