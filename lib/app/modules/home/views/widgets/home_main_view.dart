import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../routes/app_pages.dart';
import '../../../../util/global_widgets.dart';
import '../../../../util/theme_data.dart';
import '../../controllers/home_controller.dart';
import 'call_history_view.dart';
import 'home_station_list.dart';
import 'home_tickets_view.dart';

class HomeMainView extends StatefulWidget {
  const HomeMainView({super.key});

  @override
  State<HomeMainView> createState() => _HomeMainViewState();
}

class _HomeMainViewState extends State<HomeMainView> {
  final controller = Get.find<HomeController>();
  final _decoration = const BoxDecoration(
    color: FORGROUND_COLOR,
    borderRadius: HOME_BOX_BORDER,
    boxShadow: [
      BoxShadow(
        blurRadius: 10,
        spreadRadius: -1,
        offset: Offset(0, 5),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: SizedBox(
        width: Get.size.width,
        child: Padding(
          padding: EdgeInsets.all(3.sp),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(2.sp),
                decoration: _decoration,
                child: Container(
                  padding: SCREEN_PADDING,
                  //padding: EdgeInsets.all(2.sp),
                  decoration: const BoxDecoration(
                    color: COLOREDBOX_COLOR,
                    borderRadius: HOME_BOX_BORDER,
                  ),
                  child: Column(
                    children: [
                      const Row(
                        // mainAxisAlignment : MainAxisAlignment.end,
                        children: [
                          // HomeStationList(),
                          Expanded(
                            child: HomeStationList(),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 45.sp,
                            height: 45.sp,
                            child: OutlinedButton(
                              onPressed: () {
                                controller.selectedPoliceStation != null
                                    ? controller.makePhoneCall(
                                        '${controller.selectedPoliceStation?.stationPhoneNumber}',
                                      )
                                    : showAlertError(
                                        context,
                                        'No phone number assigned',
                                      );
                              },
                              child: const Icon(Icons.call),
                            ),
                          ),
                          SizedBox(width: 30.h),
                          SizedBox(
                            width: 45.sp,
                            height: 45.sp,
                            child: OutlinedButton(
                              onPressed: () {
                                if (controller.policeStationFormKey.currentState
                                        ?.saveAndValidate() ??
                                    false) {
                                  if (controller.selectedPoliceStation !=
                                      null) {
                                    Get.toNamed(
                                      Routes.VEDIO_CALLING,
                                    );
                                  } else {
                                    showAlertError(
                                      context,
                                      'Kindly check after some time',
                                    );
                                  }
                                }
                              },
                              child: const Icon(Icons.video_call),
                            ),
                          ),
                          SizedBox(width: 30.h),
                          SizedBox(
                            width: 45.sp,
                            height: 45.sp,
                            child: OutlinedButton(
                              onPressed: () {
                                controller.policeStationNavigation(
                                  controller.selectedPoliceStation ??
                                      controller.policeStations.first,
                                );
                              },
                              child: const Icon(Icons.location_on_outlined),
                            ),
                          ),
                          SizedBox(width: 30.h),
                          SizedBox(
                            width: 45.sp,
                            height: 45.sp,
                            child: OutlinedButton(
                              onPressed: () {
                                if (controller.user!.isVerified) {
                                  Get.toNamed(Routes.ADD_TICKET);
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Warning'),
                                        content: Text(
                                          'Only verified users can create support tickets, please verify your phone number',
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(fontSize: 16.sp),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Get.toNamed(Routes.PROFILE);
                                            },
                                            child: const Text('Verify'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                              child: const Icon(Icons.add),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              const CallHistoryView(),
              SizedBox(height: 10.h),
              const HomeTicketsView(),
              SizedBox(height: 10.h),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }
}
