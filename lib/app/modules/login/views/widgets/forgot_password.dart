import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../util/theme_data.dart';
import '../../controllers/login_controller.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoginController>();

    return AlertDialog(
      surfaceTintColor: Colors.white,
      content: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 16.sp,
                      height: 16.sp,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: IconButton(
                        iconSize: 16.sp,
                        splashRadius: 15,
                        color: Colors.white,
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ),
                  ],
                ),
                //const Divider(),
              ],
            ),
            SizedBox(
              width: Get.size.width * 0.75,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.sp),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Forgot Password?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    SizedBox(
                      width: 200.w,
                      child: Text(
                        'Enter the phone number associated with your account.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    FormBuilder(
                      key: controller.resetPasswordFormKey,
                      child: Column(
                        children: [
                          FormBuilderTextField(
                            name: 'phone_number',
                            keyboardType: TextInputType.phone,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.phone_android,
                                color: primaryColor,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: CIRCULAR_BORDER,
                              ),
                              hintText: 'Phone number',
                            ),
                          ),
                          SizedBox(height: 4.h),
                          FormBuilderTextField(
                            name: 'captcha',
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.key,
                                color: primaryColor,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: CIRCULAR_BORDER,
                              ),
                              hintText: 'Captcha',
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: SizedBox(
                                  child: GetBuilder<LoginController>(
                                    builder: (controller) {
                                      if (controller.captchaId != null) {
                                        return Image(
                                          width: 180.w,
                                          height: 50.h,
                                          image: NetworkImage(
                                            controller.captchaImageUrl,
                                          ),
                                        );
                                      }

                                      return Shimmer.fromColors(
                                        baseColor: Colors.grey.shade300,
                                        highlightColor: Colors.grey.shade100,
                                        child: Container(
                                          width: 180.w,
                                          height: 50.h,
                                          color: Colors.white,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                width: 50.w,
                                height: 50.h,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: const BorderRadius.horizontal(
                                    right: Radius.circular(10),
                                  ),
                                ),
                                child: IconButton(
                                  splashRadius: 15,
                                  onPressed: () async {
                                    controller.captchaId = null;
                                    await controller.loadCaptcha();
                                    controller.update();
                                  },
                                  icon: const Icon(
                                    Icons.restart_alt_rounded,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.sp),
                    SizedBox(
                      width: 180.w,
                      height: 35.h,
                      child: ElevatedButton(
                        onPressed: () {
                          controller.resetPassword();
                        },
                        child: const Text('Verify',style: TextStyle(color: Colors.white,),),
                      ),
                    ),
                    GetBuilder<LoginController>(
                      builder: (controller) {
                        if (controller.isResetPassword) {
                          return Padding(
                            padding: EdgeInsets.only(top: 16.sp),
                            child: Container(
                              padding: EdgeInsets.all(14.sp),
                              decoration: BoxDecoration(
                                color: Colors.greenAccent.shade100,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Text(
                                'We have sent the new password to the phone number ${controller.phoneNumber}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }

                        return const SizedBox();
                      },
                    ),
                    SizedBox(height: 14.sp),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
