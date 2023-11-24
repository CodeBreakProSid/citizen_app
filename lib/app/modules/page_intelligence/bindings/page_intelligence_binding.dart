import 'package:get/get.dart';

import '../controllers/page_intelligence_controller.dart';

class PageIntelligenceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PageIntelligenceController>(
      () => PageIntelligenceController(),
    );
  }
}
