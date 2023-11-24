import 'package:get/get.dart';

import '../controllers/page_incident_track_controller.dart';

class PageIncidentTrackBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PageIncidentTrackController>(
      () => PageIncidentTrackController(),
    );
  }
}
