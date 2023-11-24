import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../util/asset_urls.dart';
import '../../../util/theme_data.dart';
import '../../firebase_service/forGroundLocalNotification.dart';
import '../controllers/root_controller.dart';

class RootView extends GetView<RootController> {
  const RootView({super.key});

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = MediaQuery.platformBrightnessOf(context);
    final controller = Get.find<RootController>();

    ForgroundLocalNotification.initialize();
    // For forground State
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      ForgroundLocalNotification.showNotification(message);
    });

    return Scaffold(
      backgroundColor:
          brightness == Brightness.dark ? darkModeBlack : Colors.white,
      body: Align(
        alignment: Get.size.shortestSide < 420
            ? Alignment.center
            : Alignment.topCenter,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: Get.size.longestSide * 0.5,
          ),
          child: FutureBuilder(
            future: controller.initServices(),
            builder: (context, sanpshot) {
              return Center(
                child: GetBuilder<RootController>(
                  builder: (controller) {
                    return controller.isConnection
                        ? Center(
                            child: Image.asset(AssetUrls.LOGO),
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Oops...',
                                  style: TextStyle(
                                    color: brightness == Brightness.dark
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                  textScaleFactor: 1,
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  'There is a connection error.Please check your internet and try again.',
                                  style: TextStyle(color: Colors.grey),
                                  textScaleFactor: 1,
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: 150,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Future.delayed(
                                        const Duration(milliseconds: 50),
                                      ).then(
                                        (value) => controller.initServices(),
                                      );
                                    },
                                    child: GetBuilder<RootController>(
                                      builder: (controller) {
                                        return controller.isLoading
                                            ? const SizedBox(
                                                height: 15,
                                                width: 15,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 1,
                                                ),
                                              )
                                            : const Text(
                                                'Try again',
                                                textScaleFactor: 1,
                                              );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
