import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../util/theme_data.dart';
import '../../controllers/vedio_calling_controller.dart';
import 'remote_view.dart';
import 'user_view.dart';

class Demo extends StatefulWidget {
  const Demo({super.key});

  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        GetBuilder<VedioCallingController>(
          builder: (_) {
            if (!_.isVedioStreaming) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return SizedBox(
              height: Get.size.height - 70.h,
              child: Column(
                children: const [
                  Expanded(child: UserView()),
                  Expanded(child: RemoteView()),
                ],
              ),
            );
          },
        ),
        Column(
          children: [
            SizedBox(height: Get.size.height - 70.h),
            Container(
              width: Get.size.width,
              height: 70.h,
              decoration: const BoxDecoration(
                color: darkModeBlack,
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              ),
              child: GetBuilder<VedioCallingController>(
                builder: (controller) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Expanded(child: SizedBox()),
                      MaterialButton(
                        shape: const CircleBorder(),
                        color: controller.isVedioMuted
                            ? Colors.grey
                            : Colors.green,
                        padding: EdgeInsets.all(10.sp),
                        onPressed: () {
                          controller.videoMute();
                        },
                        child: Icon(
                          controller.isVedioMuted
                              ? Icons.videocam_off
                              : Icons.videocam,
                          // size: 20,
                          color: Colors.white,
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      MaterialButton(
                        shape: const CircleBorder(),
                        color: controller.isAudioMuted
                            ? Colors.grey
                            : Colors.green,
                        padding: EdgeInsets.all(10.sp),
                        onPressed: () {
                          controller.micMute();
                        },
                        child: Icon(
                          controller.isAudioMuted ? Icons.mic_off : Icons.mic,
                          color: Colors.white,
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      MaterialButton(
                        shape: const CircleBorder(),
                        color: controller.istoggleCamera
                            ? Colors.blue
                            : Colors.green,
                        padding: EdgeInsets.all(10.sp),
                        onPressed: () {
                          controller.toggleCamera();
                        },
                        child: const Icon(
                          Icons.cameraswitch_rounded,
                          color: Colors.white,
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      MaterialButton(
                        shape: const CircleBorder(),
                        color: Colors.redAccent,
                        padding: EdgeInsets.all(10.sp),
                        onPressed: () {
                          controller.exitMeeting();
                        },
                        child: const Icon(
                          Icons.call_end,
                          color: Colors.white,
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
