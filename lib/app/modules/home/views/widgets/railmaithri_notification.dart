// ignore_for_file: cast_nullable_to_non_nullable, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/home_controller.dart';

class RailmaithriNotification extends StatelessWidget {
  const RailmaithriNotification({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return WillPopScope(
      onWillPop: () async {
        controller.railNotification.clear();
        controller.loadRailNotification();
        Get.back();

        return true;
      },
      child: GetBuilder<HomeController>(
        builder: (controller) {
          if (controller.railNotificationIsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (controller.railNotification.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_off_rounded,
                  size: 80.sp,
                  color: Colors.grey.withOpacity(0.5),
                ),
                SizedBox(height: 8.sp),
                Text(
                  'No notification',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey.withOpacity(0.5),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.railNotification.length,
                  itemBuilder: (context, index) {
                    late final String notificationType;
                    late final String notificationMessage;
                    final String notificationCreatedon =
                        DateFormat('dd/MM/yyyy, h:mm a').format(
                      DateTime.parse(
                        controller.railNotification[index].date as String,
                      ),
                    );

                    notificationType = controller
                        .railNotification[index].notificationType as String;

                    notificationMessage = controller
                        .railNotification[index].notificationMessage as String;

                    return MaterialButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        print('');
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(3)),
                        ),
                        constraints: BoxConstraints(maxWidth: Get.size.width),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.sp,
                                vertical: 10.sp,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.notifications,
                                    size: 30.sp,
                                  ),
                                  SizedBox(width: 8.sp),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          notificationType,
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(width: 8.sp),
                                        Text(
                                          'Message : $notificationMessage',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(width: 8.sp),
                                        Text(
                                          'Notification Id: ${controller.railNotification[index].id}',
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.grey.shade700,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(width: 8.sp),
                                        Text(
                                          notificationCreatedon,
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.grey.shade700,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 1),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 8.sp),
              ],
            ),
          );
        },
      ),
    );
  }
}
