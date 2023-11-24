import 'package:get/get.dart';

import '../controllers/page_contact_details_controller.dart';

class PageContactDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PageContactDetailsController>(
      () => PageContactDetailsController(),
    );
  }
}
