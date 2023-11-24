import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../util/asset_urls.dart';
import '../../../util/theme_data.dart';
import '../controllers/add_ticket_controller.dart';
import 'widgets/add_ticket_main.dart';

class AddTicketView extends GetView<AddTicketController> {
  const AddTicketView({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddTicketController>();

    return Scaffold(
      appBar: AppBar(
        //backgroundColor: const Color(0xFF008585).withOpacity(0.8),
        backgroundColor: primaryColor,
        centerTitle: true,
        shape: appBarShape,
        title: Row(
          children: [
            const Expanded(flex: 2, child: SizedBox()),
            Image.asset(
              AssetUrls.ICON_LOGO,
              scale: HEADER_LOGO_SCALE,
            ),
            SizedBox(width: 4.w),
            Center(
              child: Text(
                'Janamaithri Ticket',
                style: appBarTextStyle,
              ),
            ),
            const Expanded(flex: 4, child: SizedBox()),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: Get.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.elliptical(30, 25),
                  topRight: Radius.elliptical(30, 25),
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: FutureBuilder<bool>(
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
                                    child: AddTicketMain(),
                                  )
                                : const Center(
                                    child: CircularProgressIndicator(),
                                  );

                          default:
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
