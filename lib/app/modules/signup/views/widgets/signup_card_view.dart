import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../routes/app_pages.dart';
import '../../../../util/asset_urls.dart';
import '../../controllers/signup_controller.dart';
import 'signup_card.dart';

class SignupCardView extends StatelessWidget {
  const SignupCardView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SignupController>();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.all(2.sp),
      child: Padding(
        padding: EdgeInsets.all(8.sp),
        child: Column(
          children: [
            SizedBox(height: 8.h),
            Image.asset(
              AssetUrls.LOGO,
              width: 200.sp,
              height: 180.sp,
              fit: BoxFit.fill,
            ),
            // SizedBox(height: 8.h),
            // Text(
            //   'SIGN UP',
            //   style: TextStyle(
            //     fontWeight: FontWeight.bold,
            //     color: Colors.blueGrey[500],
            //     fontSize: 30.sp,
            //   ),
            // ),
            SizedBox(height: 8.h),
            const SignupCard(),
            SizedBox(height: 8.h),
            SizedBox(
              width: 180.sp,
              height: 35.sp,
              child: ElevatedButton(
                onPressed: controller.signup,
                child: GetBuilder<SignupController>(
                  builder: (controller) {
                    return controller.isLogging
                        ? SizedBox(
                            width: 15.h,
                            height: 15.h,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Signup',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          );
                  },
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(child: SizedBox()),
                Text(
                  'Already have an account? ',
                  style: TextStyle(fontSize: 12.sp),
                ),
                GestureDetector(
                  onTap: () => Get.offAllNamed(Routes.LOGIN),
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.blue, fontSize: 12.sp),
                  ),
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}
