import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import '../../../../util/global_widgets.dart';
import '../../../../util/theme_data.dart';
import '../../controllers/profile_controller.dart';
import 'change_password.dart';
import 'popup_verification.dart';

class ProfileBody extends StatefulWidget {
  const ProfileBody({super.key});

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    late final List<DropdownMenuItem<String>> genderLists = [];
    controller.genderList.forEach((key, value) {
      genderLists
          .add(DropdownMenuItem<String>(value: '$value', child: Text(key)));
    });

    final inputTextStyle = TextStyle(
      fontSize: 12.sp,
    );

    final genderTextStyle = TextStyle(
      fontSize: 10.sp,
      color:Colors.black,
    );

    InputDecoration getFormDecoration(String labelText) {
      return InputDecoration(
        labelText: labelText,
        floatingLabelStyle: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
        border: const OutlineInputBorder(
          borderRadius: CIRCULAR_BORDER,
        ),
      );
    }

    return FormBuilder(
      key: controller.profileFormKey,
      child: SingleChildScrollView(
        //physics: const BouncingScrollPhysics(),
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 8.h),
            Text(
              controller.userStatus,
              textScaleFactor: 1,
              style: TextStyle(
                color: PROFILE_TEXT_COLOR,
                fontSize: 12.sp,
              ),
            ),
            SizedBox(height: 6.h),
            Container(
              alignment: Alignment.topCenter,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 5,
                    spreadRadius: 0.2,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: CircleAvatar(
                  radius: 80.sp,
                  backgroundColor: Colors.teal,
                  child: Icon(
                    Icons.person,
                    color: Colors.grey,
                    size: 100.sp,
                  ),
                ),
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              controller.user!.fullName ?? controller.user!.username,
              style: TextStyle(
                color: PROFILE_TEXT_COLOR,
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
              ),
            ),
            SizedBox(height: 6.h),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 15.sp),
              child: GetBuilder<ProfileController>(
                builder: (controller) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 40.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: FormBuilderTextField(
                              name: 'phone_number',
                              enabled: controller.isEditing,
                              keyboardType: TextInputType.phone,
                              style: inputTextStyle,
                              decoration: getFormDecoration('Phone number'),
                              initialValue: '${controller.user?.phoneNumber}',
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your mobile number';
                                } else if (!RegExp(
                                  r'(^(?:[+0]9)?[0-9]{10}$)',
                                ).hasMatch(value)) {
                                  return 'Please enter valid mobile number';
                                }

                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: 8.w),
                          SizedBox(
                            height: 38.sp,
                            child: GetBuilder<ProfileController>(
                              builder: (controller) {
                                return ElevatedButton(
                                  onPressed: controller.user!.isVerified
                                      ? null
                                      : () {
                                          showAnimatedDialog(
                                            const PopupVerification(),
                                            context,
                                          );
                                        },
                                  child: Text(
                                    'Verify',
                                    style: TextStyle(fontSize: 10.sp),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      FormBuilderTextField(
                        name: 'full_name',
                        enabled: controller.isEditing,
                        style: inputTextStyle,
                        decoration: getFormDecoration('Full name'),
                        initialValue: controller.user?.fullName,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter correct name';
                          } else if (!RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                            return 'Allow upper and lower case alphabets and space';
                          }

                          return null;
                        },
                      ),
                      SizedBox(height: 12.h),
                      FormBuilderTextField(
                        name: 'email_id',
                        enabled: controller.isEditing,
                        style: inputTextStyle,
                        decoration: getFormDecoration('Email'),
                        initialValue: controller.user?.emailId,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: FormBuilderValidators.compose([
                          (value) {
                            if (!RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                            ).hasMatch(value!)) {
                              return 'Please enter a valid email id';
                            }

                            return null;
                          },
                        ]),
                      ),
                      SizedBox(height: 12.h),
                      FormBuilderDropdown<String>(
                        name: 'gender',
                        style: genderTextStyle,
                        items: genderLists,
                        initialValue: '${controller.genderValue}',
                        decoration: getFormDecoration('Gender'),
                        enabled: controller.isEditing,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select an option';
                          }

                          return null;
                        },
                        
                      ),
                      SizedBox(height: 12.h),
                      FormBuilderTextField(
                        name: 'address',
                        enabled: controller.isEditing,
                        maxLines: 4,
                        style: inputTextStyle,
                        decoration: getFormDecoration('Address'),
                        initialValue: controller.user?.address,
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              child: Text(
                                'Change password',
                                style: TextStyle(fontSize: 10.sp,color: Colors.white,),
                              ),
                              onPressed: () {
                                controller.isPasswordChanged = false;
                                showAnimatedDialog(
                                  const ChangePassword(),
                                  context,
                                );
                              },
                            ),
                          ),
                          SizedBox(width: 4.w),
                          GetBuilder<ProfileController>(
                            builder: (controller) {
                              if (controller.isEditing) {
                                return Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      controller.updateProfile();
                                    },
                                    child: GetBuilder<ProfileController>(
                                      builder: (controller) {
                                        return (!controller.isSaving)
                                            ? Text(
                                                'Save',
                                                style: TextStyle(
                                                  fontSize: 10.sp,color: Colors.white,
                                                ),
                                              )
                                            : SizedBox(
                                                height: 12.sp,
                                                //width: 12.sp,
                                                child:
                                                    const CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: Colors.white,
                                                ),
                                              );
                                      },
                                    ),
                                  ),
                                );
                              }

                              return Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    controller.isEditing = true;
                                  },
                                  child: Text(
                                    'Edit',
                                    style: TextStyle(fontSize: 10.sp,color: Colors.white,),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 40.h),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(),
          ],
        ),
      ),
    );
  }
}
