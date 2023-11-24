import 'package:get/get.dart';

import '../controllers/page_awareness_class_controller.dart';

class PageAwarenessClassBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PageAwarenessClassController>(
      () => PageAwarenessClassController(),
    );
  }
}
