import 'package:get/get.dart';

import '../controllers/ticket_history_controller.dart';

class TicketHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TicketHistoryController>(
      () => TicketHistoryController(),
    );
  }
}
