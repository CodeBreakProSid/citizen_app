import 'package:get/get.dart';

import '../controllers/page_lost_property_controller.dart';

class PageLostPropertyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PageLostPropertyController>(
      () => PageLostPropertyController(),
    );
  }
}
