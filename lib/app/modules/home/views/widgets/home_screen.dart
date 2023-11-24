import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../util/global_widgets.dart';
import '../../../../util/theme_data.dart';
import '../../controllers/home_controller.dart';
import 'home_drawer.dart';
import 'home_main_view.dart';
import 'notification_main_view.dart';
import 'railmaithri_home.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: const HomeDrawer(),
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: primaryColor,
            statusBarBrightness:
                Brightness.light,
            systemNavigationBarColor: primaryColor,
            systemNavigationBarDividerColor:
                Colors.grey,
            systemNavigationBarIconBrightness:
                Brightness.light,
          ),
          //titleSpacing: 0.0,
          centerTitle: true,
          toolbarHeight: 60.2,
          toolbarOpacity: 0.8,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
          ),
          //elevation: 5.0,
          backgroundColor: primaryColor,
          actions: [
            Row(
              children: [
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      splashRadius: 15.sp,
                      icon: const Icon(
                        Icons.notifications,
                        color: ICON_COLOR,
                      ),
                      onPressed: () =>
                          Get.to(() => const NotificationMainView()),
                    ),
                    GetBuilder<HomeController>(
                      builder: (_) {
                        if (controller.userNotification.isEmpty) {
                          return const SizedBox();
                        }

                        return Padding(
                          padding: EdgeInsets.all(8.sp),
                          child: Container(
                            padding: EdgeInsets.all(1.sp),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green.withGreen(255),
                              border: Border.all(color: Colors.white),
                            ),
                            child: SizedBox(
                              width: 6.sp,
                              height: 6.sp,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(width: 5.w),
              ],
            ),
          ],
          title: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black,
            controller: controller.tabController,
            dividerColor: Colors.transparent,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: const Color(0xFF008586),
            ),
            tabs: [
              Tab(
                child: Row(
                  children: [
                    const Icon(
                      Icons.local_police,
                      color: Colors.blue,
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(
                      'Janamaithri',
                      style: TextStyle(fontSize: 10.sp),
                    ),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  children: [
                    const Icon(
                      Icons.train,
                      color: Colors.deepOrange, //deepOrange
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(
                      'Railmaithri',
                      style: TextStyle(fontSize: 10.sp),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Janamaithri(),
            Railmaithri(), //
          ],
        ),
      ),
    );
  }
}

class Railmaithri extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return FutureBuilder<bool>(
      future: controller.isDataLoaded,
      initialData: false,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return const Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            {
              return snapshot.hasData && snapshot.data!
                  ? const SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: RailmaithriHome(),
                    )
                  : const Center(child: CircularProgressIndicator());
            }

          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class Janamaithri extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return FutureBuilder<bool>(
      future: controller.isDataLoaded,
      initialData: false,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return Center(child: shimmerLoaderHome());
          case ConnectionState.done:
            {
              return (snapshot.hasData && snapshot.data!)
                  ? const HomeMainView()
                  : Center(child: shimmerLoaderHome());
            }

          default:
            return Center(child: shimmerLoaderHome());
        }
      },
    );
  }
}
