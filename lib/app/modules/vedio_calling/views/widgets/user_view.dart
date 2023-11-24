import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class UserView extends StatefulWidget {
  const UserView({super.key});

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: Get.size.height / 2 - 35.h,
      width: Get.size.width,
      child: AndroidView(
        viewType: 'TSTVideoView',
        onPlatformViewCreated: (id) => debugPrint('Id of video view $id'),
        hitTestBehavior: PlatformViewHitTestBehavior.translucent,
      ),
    );
  }
}
