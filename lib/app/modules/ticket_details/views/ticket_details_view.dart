import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../util/asset_urls.dart';
import '../../../util/theme_data.dart';
import '../controllers/ticket_details_controller.dart';
import 'widgets/ticket_details_main.dart';

class TicketDetailsView extends GetView<TicketDetailsController> {
  const TicketDetailsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                'Ticket details',
                style: appBarTextStyle,
              ),
            ),
            const Expanded(flex: 4, child: SizedBox()),
          ],
        ),
      ),
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
              {
                return snapshot.hasData && snapshot.data!
                    ? const SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: TicketDetailsMain(),
                      )
                    : const Center(child: CircularProgressIndicator());
              }

            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
