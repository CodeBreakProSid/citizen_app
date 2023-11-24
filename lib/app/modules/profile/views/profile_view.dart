import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../util/asset_urls.dart';
import '../../../util/theme_data.dart';
import '../../home/views/widgets/home_drawer.dart';
import '../controllers/profile_controller.dart';
import 'widgets/profile_body.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        toolbarHeight: 70,
        title: Row(
          children: [
            const Expanded(
              flex: 2,
              child: SizedBox(),
            ),
            Image.asset(
              AssetUrls.ICON_LOGO,
              scale: HEADER_LOGO_SCALE,
            ),
            SizedBox(width: 4.w),
            Center(
              child: Text(
                'Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Expanded(flex: 4, child: SizedBox()),
          ],
        ),
      ),
      drawer: const HomeDrawer(),
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
                  ? Stack(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                ICON_COLOR,
                                primaryColor,
                                ICON_COLOR,
                              ],
                            ),
                          ),
                          child: const SizedBox(
                            height: double.maxFinite,
                            width: double.maxFinite,
                          ),
                        ),
                        const ProfileBody(),
                      ],
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
