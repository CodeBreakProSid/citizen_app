import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../util/theme_data.dart';
import '../../home/views/widgets/exit_popup_view.dart';
import '../controllers/login_controller.dart';
import 'widgets/login_card.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showExitPopup(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'KERALA POLICE',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          toolbarHeight: 100,
          toolbarOpacity: 0.8,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(40),
              bottomLeft: Radius.circular(40),
            ),
          ),
          elevation: 5.0,
          backgroundColor: primaryColor,
        ),
        body: Container(
          alignment: Get.size.shortestSide < 420
              ? Alignment.center
              : Alignment.topCenter,
          constraints: BoxConstraints(maxWidth: 400.sp),
          child: SingleChildScrollView(
            reverse: true,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 2.w),
            child: const LoginCard(),
          ),
        ),
      ),
    );
  }
}
