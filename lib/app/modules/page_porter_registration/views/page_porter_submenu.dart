// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../util/theme_data.dart';
import '../controllers/page_porter_registration_controller.dart';
import 'page_porter_registration_main_view.dart';
import 'page_view_existing_staffporter.dart';

class PagePorterSubmenu extends StatelessWidget {
  const PagePorterSubmenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PagePorterRegistrationController>();
    final tablePadding = EdgeInsets.only(bottom: 4.sp, top: 4.sp);
    const decoration = BoxDecoration(
      color: FORGROUND_COLOR,
      borderRadius: HOME_BOX_BORDER,
      backgroundBlendMode: BlendMode.multiply,
    );

    return Container(
      padding: SCREEN_PADDING,
      decoration: decoration,
      child: Column(
        children: [
          Container(
            height: 60.sp,
            padding: SCREEN_PADDING,
            decoration: const BoxDecoration(
              color: COLOREDBOX_COLOR,
              borderRadius: HOME_BOX_BORDER,
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  spreadRadius: -2,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Register as new staff or porter',
                    style: SUB_HEADER_STYLE,
                  ),
                ),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              const PagePorterRegistrationMainView(),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.emoji_people,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 25.sp,
          ),
          Container(
            height: 60.sp,
            padding: SCREEN_PADDING,
            decoration: const BoxDecoration(
              color: COLOREDBOX_COLOR,
              borderRadius: HOME_BOX_BORDER,
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  spreadRadius: -2,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'View existing staff or porter',
                    style: SUB_HEADER_STYLE,
                  ),
                ),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      controller.selectedRailwayStation = null;
                      controller.selectedStaffPorterType = null;
                      controller.loadStaffPorterList();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              const PageViewExistingStaffPorter(),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.remove_red_eye_sharp,
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
