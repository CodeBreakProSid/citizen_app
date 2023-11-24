import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/vedio_calling_controller.dart';
import 'widgets/demo.dart';

class VedioCallingView extends GetView<VedioCallingController> {
  const VedioCallingView({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VedioCallingController>();

    final Widget connecting = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.call,
            color: Colors.grey,
            size: 100.sp,
          ),
          SizedBox(height: 4.sp),
          Text(
            '  connecting...',
            style: TextStyle(color: Colors.grey, fontSize: 24.sp),
          ),
        ],
      ),
    );

    return WillPopScope(
      onWillPop: () async {
        controller.exitMeeting();
        Get.back(closeOverlays: true);

        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black87,
        body: FutureBuilder<bool>(
          future: controller.isDataLoaded,
          initialData: false,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
                return connecting;
              case ConnectionState.done:
                {
                  return (snapshot.hasData && snapshot.data!)
                      // ignore: use_colored_box
                      ? Container(
                          color: Colors.black,
                          child: const Demo(),
                        )
                      : connecting;
                }

              default:
                return connecting;
            }
          },
        ),
      ),
    );
  }
}
