import 'package:get/get.dart';

import '../controllers/page_rail_volunteer_controller.dart';

class PageRailVolunteerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PageRailVolunteerController>(
      () => PageRailVolunteerController(),
    );
  }
}
