import 'package:get/get.dart';

import '../controllers/page_shop_labours_controller.dart';

class PageShopLaboursBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PageShopLaboursController>(
      () => PageShopLaboursController(),
    );
  }
}
