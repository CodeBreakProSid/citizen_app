// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../util/theme_data.dart';
import '../controllers/page_shop_labours_controller.dart';
import 'page_register_new_shop_labour.dart';
import 'page_view_existing_shop_labour.dart';

class PageShopLabourSubmenu extends StatelessWidget {
  const PageShopLabourSubmenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PageShopLaboursController>();
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
                    'Register new shop & labour',
                    style: TEXT_HEADER_STYLE,
                  ),
                ),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              const PageRegisterNewShopLabour(),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.add,
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
                    'View existing shops',
                    style: TEXT_HEADER_STYLE,
                  ),
                ),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      controller.selectedRailwayStation = null;
                      controller.selectedShopCategoryType = null;
                      controller.loadShopList();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              const PageViewExistingShopLabour(),
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
