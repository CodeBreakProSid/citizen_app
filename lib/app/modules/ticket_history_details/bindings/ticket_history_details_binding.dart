import 'package:get/get.dart';

import '../controllers/ticket_history_details_controller.dart';

class TicketHistoryDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TicketHistoryDetailsController>(
      () => TicketHistoryDetailsController(),
    );
  }
}
