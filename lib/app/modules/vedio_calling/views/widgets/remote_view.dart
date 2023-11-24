import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RemoteView extends StatefulWidget {
  const RemoteView({super.key});

  @override
  State<RemoteView> createState() => _RemoteViewState();
}

class _RemoteViewState extends State<RemoteView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: Get.size.height / 2 - 35.h,
      width: Get.size.width,
      child: AndroidView(
        viewType: 'TSTRemoteVideoView',
        onPlatformViewCreated: (id) => debugPrint('Id of video view $id'),
        hitTestBehavior: PlatformViewHitTestBehavior.translucent,
      ),
    );
  }
}
