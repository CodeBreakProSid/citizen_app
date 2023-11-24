import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../util/theme_data.dart';
import '../../controllers/home_controller.dart';
import 'janamaithri_notification.dart';
import 'railmaithri_notification.dart';

class NotificationMainView extends GetView<HomeController> {
  const NotificationMainView({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.userNotification.clear();
          controller.railNotification.clear();
          controller.loadRailNotification();
          controller.loadNotification();
        },
        child: Icon(
          Icons.sync_outlined,
          size: 20.sp,
        ),
      ),
      appBar: AppBar(
        //backgroundColor: const Color(0xFF008585).withOpacity(0.8),
        backgroundColor:primaryColor,
        // title: Row(
        //   children: [
        //     const Expanded(flex: 2, child: SizedBox()),
        //     // Image.asset(
        //     //   AssetUrls.ICON_LOGO,
        //     //   scale: HEADER_LOGO_SCALE,
        //     // ),
        //     SizedBox(width: 4.w),
        //     Center(
        //       child: Text(
        //         'Notification',
        //         style: TextStyle(color: Colors.white,fontSize: 14.sp),
        //       ),
        //     ),
        //     //const Expanded(flex: 4, child: SizedBox()),
        //   ],
        // ),
        centerTitle: true,
        title: Text(
          'Notification',
          style: TextStyle(color: Colors.white, fontSize: 14.sp),
        ),
      ),
      body: Stack(
        children: [
          DefaultTabController(
            length: 2,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: Get.width,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 35.h,
                          color: primaryColor,
                          child: TabBar(
                            dividerColor: Colors.transparent,
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.black,
                            controller: controller.tabController,
                            indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: const Color(0xFF008586),
                            ),
                            tabs: [
                              Tab(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.local_police,
                                      color: Colors.blue,
                                    ),
                                    SizedBox(
                                      width: 15.h,
                                    ),
                                    const Text('Janamaithri'),
                                  ],
                                ),
                              ),
                              Tab(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.train, //local_police
                                      color: Colors.orange,
                                    ),
                                    SizedBox(
                                      width: 15.h,
                                    ),
                                    const Text('Railmaithri'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: controller.tabController,
                            physics: const BouncingScrollPhysics(),
                            children: [
                              FutureBuilder<bool>(
                                future: controller.isDataLoaded,
                                initialData: false,
                                builder: (context, snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.none:
                                    case ConnectionState.waiting:
                                    case ConnectionState.active:
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    case ConnectionState.done:
                                      return snapshot.hasData && snapshot.data!
                                          ? const JanamaithriNotification()
                                          : const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );

                                    default:
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                  }
                                },
                              ),
                              FutureBuilder<bool>(
                                future: controller.isDataLoaded,
                                initialData: false,
                                builder: (context, snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.none:
                                    case ConnectionState.waiting:
                                    case ConnectionState.active:
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    case ConnectionState.done:
                                      return snapshot.hasData && snapshot.data!
                                          ? const SingleChildScrollView(
                                              physics: BouncingScrollPhysics(),
                                              child: RailmaithriNotification(),
                                            )
                                          : const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );

                                    default:
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
