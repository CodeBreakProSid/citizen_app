import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import '../../../../util/theme_data.dart';
import '../../controllers/profile_controller.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    final inputTextStyle = TextStyle(
      fontSize: 12.sp,
    );

    return AlertDialog(
      surfaceTintColor: Colors.white,
      contentPadding: SCREEN_PADDING,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      content: Container(
        constraints: BoxConstraints(minWidth: 250.w),
        child: FormBuilder(
          key: controller.changeFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(4.sp),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.key,
                      color: Colors.blue,
                      size: 8.sp,
                    ),
                  ),
                  SizedBox(width: 45.w),
                  Expanded(
                    child: Text(
                      'Change Password',
                      style: TEXT_HEADER,
                    ),
                  ),
                  Container(
                    width: 14.sp,
                    height: 14.sp,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: IconButton(
                      iconSize: 14.sp,
                      splashRadius: 15,
                      color: Colors.white,
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ),
                ],
              ),
              //const Divider(),
              SizedBox(height: 20.h),
              FormBuilderTextField(
                name: 'new_password',
                textInputAction: TextInputAction.next,
                obscureText: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                    errorText: 'Provide a new password',
                  ),
                  FormBuilderValidators.minLength(
                    8,
                    errorText: 'Password must be at least 8 characters',
                  ),
                  FormBuilderValidators.maxLength(
                    64,
                    errorText: 'Password must be at most 64 characters',
                  ),
                  FormBuilderValidators.match(
                    r'^[a-zA-Z0-9!@#$%^&*]*$',
                    errorText:
                        'only characters, digits and (!@#%^&*) is allowed',
                  ),
                ]),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: FORM_CIRCULAR_BORDER,
                  ),
                  hintText: 'New Password',
                ),
                style: inputTextStyle,
              ),
              SizedBox(height: 6.h),
              FormBuilderTextField(
                name: 'confirm_new_password',
                textInputAction: TextInputAction.next,
                obscureText: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: FormBuilderValidators.compose([
                  (value) {
                    if (value !=
                        controller.changeFormKey.currentState
                            ?.fields['new_password']?.value) {
                      return 'New password does not match';
                    }

                    return null;
                  },
                ]),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: FORM_CIRCULAR_BORDER,
                  ),
                  hintText: 'Confirm new Password',
                ),
                style: inputTextStyle,
              ),
              SizedBox(height: 4.h),
              Align(
                child: ElevatedButton(
                  onPressed: () {
                    if (!controller.isPasswordChanged) {
                      //
                      controller.changePassword();
                    }
                  },
                  child: SizedBox(
                    width: 75.w,
                    child: GetBuilder<ProfileController>(
                      builder: (controller) {
                        if (controller.isPasswordChanged) {
                          return const Icon(Icons.check);
                        }

                        return controller.isPasswordChanging
                            ? Align(
                                child: SizedBox(
                                  width: 12.sp,
                                  height: 12.sp,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                'Change',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12.sp,color: Colors.white,),
                              );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
