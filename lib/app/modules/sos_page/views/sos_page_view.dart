import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/sos_page_controller.dart';
import 'widgets/sos_page_main.dart';

class SosPageView extends GetView<SosPageController> {
  const SosPageView({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SosPageMain(),
    );
  }
}
