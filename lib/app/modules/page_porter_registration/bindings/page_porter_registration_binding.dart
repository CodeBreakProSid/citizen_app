import 'package:get/get.dart';

import '../controllers/page_porter_registration_controller.dart';

class PagePorterRegistrationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PagePorterRegistrationController>(
      () => PagePorterRegistrationController(),
    );
  }
}
