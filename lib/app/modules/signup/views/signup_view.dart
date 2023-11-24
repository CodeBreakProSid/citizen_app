import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../util/theme_data.dart';
import '../controllers/signup_controller.dart';
import 'widgets/signup_card_view.dart';

class SignupView extends GetView<SignupController> {
  // SystemChrome.setEnabledSystemUIMode([SystemUiOverlay.bottom]);
  const SignupView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SignUp',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        toolbarHeight: 70,
        toolbarOpacity: 0.8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(40),
            bottomLeft: Radius.circular(40),
          ),
        ),
        elevation: 5.0,
        backgroundColor: primaryColor,
      ),
      body: FutureBuilder<bool>(
        future: controller.isDataLoaded,
        initialData: false,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              return snapshot.hasData && snapshot.data!
                  ? Align(
                      alignment: Get.size.shortestSide < 420
                          ? Alignment.center
                          : Alignment.topCenter,
                      child: const SignupCardView(),
                    )
                  : const Center(child: CircularProgressIndicator());

            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
