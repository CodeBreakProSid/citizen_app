import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../util/asset_urls.dart';
import '../../../util/theme_data.dart';
import '../controllers/call_history_controller.dart';
import 'meeting_main.dart';

class CallHistoryView extends GetView<CallHistoryController> {
  const CallHistoryView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
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
                'Meeting History',
                style: appHeaderStyle,
              ),
            ),
            const Expanded(flex: 3, child: SizedBox()),
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
                return (snapshot.hasData && snapshot.data!)
                    ? const MeetingMain()
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
