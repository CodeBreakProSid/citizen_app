import 'package:get/get.dart';

import '../controllers/page_safety_tip_controller.dart';

class PageSafetyTipBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PageSafetyTipController>(
      () => PageSafetyTipController(),
    );
  }
}
