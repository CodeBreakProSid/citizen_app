// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../util/api_helper/api_const.dart';
import '../../controllers/home_controller.dart';

class JanamaithriNotification extends StatelessWidget {
  const JanamaithriNotification({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return WillPopScope(
      onWillPop: () async {
        controller.userNotification.clear();
        controller.loadNotification();
        Get.back();

        return true;
      },
      child: GetBuilder<HomeController>(
        builder: (controller) {
          if (controller.notificationIsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (controller.userNotification.isEmpty) {
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
                  itemCount: controller.userNotification.length,
                  itemBuilder: (context, index) {
                    late final Icon notificationIcon;
                    late final String notificationType;
                    final String notificationCreatedon =
                        DateFormat('dd/MM/yyyy, h:mm a').format(
                      DateTime.parse(
                        controller.userNotification[index].createdOn,
                      ),
                    );

                    final String ticketStatusType =
                        controller.notificationType.entries
                            .firstWhere(
                              (element) =>
                                  element.value ==
                                  controller
                                      .userNotification[index].notificationType,
                            )
                            .key;
                    switch (ticketStatusType) {
                      case NotificationTypeConst.NOTIFICATION_TYPE_1:
                        notificationIcon = Icon(
                          FontAwesomeIcons.ticket,
                          size: 30.sp,
                        );
                        notificationType = 'New Ticket';
                        break;

                      case NotificationTypeConst.NOTIFICATION_TYPE_2:
                        notificationIcon = Icon(
                          Icons.check_circle,
                          size: 30.sp,
                        );
                        notificationType = 'Ticket Closed';
                        break;

                      case NotificationTypeConst.NOTIFICATION_TYPE_3:
                        notificationIcon = Icon(
                          FontAwesomeIcons.message,
                          size: 30.sp,
                        );
                        notificationType = 'Message in ticket';
                        break;

                      default:
                        notificationIcon = Icon(
                          FontAwesomeIcons.ticket,
                          size: 30.sp,
                        );
                        notificationType = 'Message';
                        break;
                    }

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
                                  notificationIcon,
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
                                        SizedBox(height: 2.sp),
                                        Text(
                                          'Ticket Id: ${controller.userNotification[index].notification.ticketId}',
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.grey.shade700,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: 2.sp),
                                        Text(
                                          'on: $notificationCreatedon',
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.grey.shade700,
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
                GetBuilder<HomeController>(
                  builder: (_) {
                    if (_.noMoreNotification) {
                      return const SizedBox();
                    }

                    return _.isMoreNotificationLoading
                        ? Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.sp),
                            child: SizedBox(
                              height: 25.sp,
                              width: 25.sp,
                              child: const CircularProgressIndicator(),
                            ),
                          )
                        : SizedBox(
                            height: 35.sp,
                            width: 200.sp,
                            child: ElevatedButton(
                              onPressed: () {
                                _.loadMoreNotification();
                              },
                              child: Text(
                                'Load more',
                                style: TextStyle(fontSize: 12.sp,color: Colors.white),
                              ),
                            ),
                          );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
