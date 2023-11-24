import 'package:get/get.dart';

import '../controllers/page_incident_train_controller.dart';

class PageIncidentTrainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PageIncidentTrainController>(
      () => PageIncidentTrainController(),
    );
  }
}
