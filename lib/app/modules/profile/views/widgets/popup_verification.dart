import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../util/theme_data.dart';
import '../../controllers/profile_controller.dart';

class PopupVerification extends StatefulWidget {
  const PopupVerification({super.key});

  @override
  State<PopupVerification> createState() => _PopupVerificationState();
}

class _PopupVerificationState extends State<PopupVerification> {
  final controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: SCREEN_PADDING,
      content: FutureBuilder(
        future: controller.loadPhoneCaptcha(),
        builder: (context, snapshot) {
          return FormBuilder(
            key: controller.phoneVerifyFormKey,
            child: Container(
              constraints: BoxConstraints(minWidth: 250.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Verify Phone Number : ${controller.user!.phoneNumber}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                      Container(
                        width: 14.sp,
                        height: 14.sp,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: IconButton(
                          iconSize: 14.sp,
                          splashRadius: 15,
                          color: Colors.white,
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            controller.isOtpSented = false;
                            controller.isOtpVerified = false;
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      GetBuilder<ProfileController>(
                        builder: (controller) {
                          if (controller.captchaId != null) {
                            return Expanded(
                              child: Image(
                                width: 200.w,
                                height: 60.h,
                                image: NetworkImage(controller.captchaImageUrl),
                              ),
                            );
                          }

                          return Expanded(
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                width: 200.w,
                                height: 60.h,
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        splashRadius: 15,
                        onPressed: () async {
                          controller.captchaId = null;
                          await controller.loadPhoneCaptcha();
                          controller.update();
                        },
                        icon: const Icon(
                          Icons.restart_alt_rounded,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Padding(
                    padding: SCREEN_PADDING,
                    child: FormBuilderTextField(
                      name: 'captcha',
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Captcha',
                        border: const OutlineInputBorder(
                          borderRadius: CIRCULAR_BORDER,
                        ),
                        suffixIcon: Container(
                          height: 20.h,
                          padding: EdgeInsets.symmetric(
                            vertical: 4.sp,
                            horizontal: 8.sp,
                          ),
                          decoration: const BoxDecoration(
                            borderRadius: CIRCULAR_BORDER,
                          ),
                          child: ElevatedButton(
                            onPressed: () async {
                              await controller.sentOtp();
                            },
                            child: Container(
                              width: 60.w,
                              alignment: Alignment.center,
                              child: GetBuilder<ProfileController>(
                                builder: (controller) {
                                  if (controller.isOtpSenting) {
                                    return SizedBox(
                                      width: 12.sp,
                                      height: 12.sp,
                                      child: const CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    );
                                  }

                                  return controller.isOtpSented
                                      ? const Icon(Icons.check)
                                      : Text(
                                          'Sent OTP',
                                          style: TextStyle(fontSize: 12.sp),
                                        );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      validator: FormBuilderValidators.compose(
                        [FormBuilderValidators.required()],
                      ),
                    ),
                  ),
                  GetBuilder<ProfileController>(
                    builder: (controller) {
                      return controller.isOtpSented
                          ? Padding(
                              padding: SCREEN_PADDING,
                              child: FormBuilderTextField(
                                name: 'otp',
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Otp',
                                  border: const OutlineInputBorder(
                                    borderRadius: CIRCULAR_BORDER,
                                  ),
                                  suffixIcon: Container(
                                    height: 20.h,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 4.sp,
                                      horizontal: 8.sp,
                                    ),
                                    decoration: const BoxDecoration(
                                      borderRadius: CIRCULAR_BORDER,
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        await controller.verifyOtp();
                                      },
                                      child: Container(
                                        width: 50.w,
                                        alignment: Alignment.center,
                                        child: GetBuilder<ProfileController>(
                                          builder: (controller) {
                                            if (controller.isOtpVerifying) {
                                              return SizedBox(
                                                width: 12.sp,
                                                height: 12.sp,
                                                child:
                                                    const CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 2,
                                                ),
                                              );
                                            }

                                            return controller.isOtpVerified
                                                ? const Icon(Icons.check)
                                                : const Text(
                                                    'Verify OTP',
                                                  );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                validator: FormBuilderValidators.compose(
                                  [FormBuilderValidators.required()],
                                ),
                              ),
                            )
                          : const SizedBox();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
