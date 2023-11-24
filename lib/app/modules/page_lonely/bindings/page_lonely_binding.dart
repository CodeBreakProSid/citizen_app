import 'package:get/get.dart';

import '../controllers/page_lonely_controller.dart';

class PageLonelyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PageLonelyController>(
      () => PageLonelyController(),
    );
  }
}
