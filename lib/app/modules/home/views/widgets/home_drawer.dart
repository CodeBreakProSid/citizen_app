import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../routes/app_pages.dart';
import '../../../../util/asset_urls.dart';
import '../../../../util/theme_data.dart';
import '../../controllers/home_controller.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key});

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  final controller = Get.find<HomeController>();
  late final String _userContactInfo =
      controller.user?.emailId ?? '${controller.user?.phoneNumber}';
  late final String? _userName =
      controller.user?.fullName ?? controller.user?.username;

  @override
  Widget build(BuildContext context) {
    final EdgeInsetsGeometry padding = EdgeInsets.only(left: 5.w);

    return Drawer(
      backgroundColor: primaryColor,
      width: 190.w,
      child: Column(
        children: [
          ListView(
            shrinkWrap: true,
            children: [
              DrawerHeader(
                padding: EdgeInsets.zero,
                margin: EdgeInsets.zero,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black, ICON_COLOR.withAlpha(200)],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20.sp),
                  child: Image.asset(
                    AssetUrls.LOGO,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              ListTile(
                enabled: Get.currentRoute != Routes.HOME,
                title: Padding(
                  padding: padding,
                  child: Text(
                    'Home',
                    style: TEXT_DRAWER_STYLE,
                  ),
                ),
                leading: const Icon(
                  Icons.home,
                  color: ICON_COLOR,
                ),
                onTap: () {
                  Get.offAllNamed(Routes.HOME);
                },
              ),
              ListTile(
                enabled: Get.currentRoute != Routes.PROFILE,
                title: Padding(
                  padding: padding,
                  child: Text(
                    'Profile',
                    style: TEXT_DRAWER_STYLE,
                  ),
                ),
                leading: const Icon(
                  Icons.person,
                  color: ICON_COLOR,
                ),
                onTap: () {
                  Get.toNamed(Routes.PROFILE);
                },
              ),
              ListTile(
                title: Padding(
                  padding: padding,
                  child: Text(
                    'Tickets',
                    style: TEXT_DRAWER_STYLE,
                  ),
                ),
                leading: const Icon(
                  Icons.notes,
                  color: ICON_COLOR,
                ),
                onTap: () {
                  Get.toNamed(Routes.TICKET_HISTORY_DETAILS);
                },
              ),
              ListTile(
                title: Padding(
                  padding: padding,
                  child: Text(
                    'Railmaithri',
                    style: TEXT_DRAWER_STYLE,
                  ),
                ),
                leading: const Icon(
                  Icons.train_rounded,
                  color: ICON_COLOR,
                ),
                onTap: () {
                  //Get.toNamed(Routes.HOME);
                  DefaultTabController.of(context)!.animateTo(1);
                },
              ),
              ListTile(
                title: Padding(
                  padding: padding,
                  child: Text(
                    'Janamaithri',
                    style: TEXT_DRAWER_STYLE,
                  ),
                ),
                leading: const Icon(
                  Icons.local_police_rounded,
                  color: ICON_COLOR,
                ),
                onTap: () {
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
                              onPressed: () => Navigator.pop(context),
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
              ),
              ListTile(
                title: Padding(
                  padding: padding,
                  child: Text(
                    'SOS',
                    style: TEXT_DRAWER_STYLE,
                  ),
                ),
                leading: const Icon(
                  Icons.sos,
                  color: Colors.black,
                ),
                onTap: () {
                  Get.toNamed(Routes.SOS_PAGE);
                },
              ),
              // ListTile(
              //   title: Padding(
              //     padding: padding,
              //     child: Text(
              //       'User Manual',
              //       style: TEXT_DRAWER_STYLE,
              //     ),
              //   ),
              //   // leading: GetBuilder<HomeController>(
              //   //   builder: (_) {
              //   //     if (controller.loggingout) {
              //   //       return SizedBox(
              //   //         width: 18.sp,
              //   //         height: 18.sp,
              //   //         child: CircularProgressIndicator(
              //   //           color: ICON_COLOR,
              //   //           strokeWidth: 2.sp,
              //   //         ),
              //   //       );
              //   //     }
              //
              //   //     return const Icon(
              //   //       Icons.integration_instructions_rounded,
              //   //       color: ICON_COLOR,
              //   //     );
              //   //   },
              //   // ),
              //   leading: const Icon(
              //     Icons.integration_instructions_rounded,
              //     color: ICON_COLOR,
              //   ),
              //   onTap: () {
              //     // Get.find<HomeController>().logout();
              //   },
              // ),
              ListTile(
                title: Padding(
                  padding: padding,
                  child: Text(
                    'logout',
                    style: TEXT_DRAWER_STYLE,
                  ),
                ),
                leading: GetBuilder<HomeController>(
                  builder: (_) {
                    if (controller.loggingout) {
                      return SizedBox(
                        width: 18.sp,
                        height: 18.sp,
                        child: CircularProgressIndicator(
                          color: ICON_COLOR,
                          strokeWidth: 2.sp,
                        ),
                      );
                    }

                    return const Icon(
                      Icons.exit_to_app,
                      color: ICON_COLOR,
                    );
                  },
                ),
                onTap: () {
                  Get.find<HomeController>().logout();
                },
              ),
            ],
          ),
          if (controller.user != null)
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5.h),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                  ),
                  child: ListTile(
                    title: Text(
                      '$_userName',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                      ),
                    ),
                    subtitle: Text(
                      _userContactInfo,
                      style: TextStyle(
                        // color: Colors.grey.shade400,
                        color: Colors.black,
                        fontSize: 10.sp,
                      ),
                    ),
                    leading: Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children: [
                        const CircleAvatar(
                          backgroundColor: primaryColor,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                        ),
                        Container(
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
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
