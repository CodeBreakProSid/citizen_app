import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../util/theme_data.dart';
import '../../controllers/signup_controller.dart';

class SignupCard extends StatefulWidget {
  const SignupCard({super.key});

  @override
  State<SignupCard> createState() => _SignupCardState();
}

class _SignupCardState extends State<SignupCard> {
  final controller = Get.find<SignupController>();

  @override
  Widget build(BuildContext context) {
    late final List<DropdownMenuItem<String>> genderList = [];
    controller.genders.forEach((key, value) {
      genderList
          .add(DropdownMenuItem<String>(value: '$value', child: Text('$key')));
    });

    return FormBuilder(
      key: controller.signupFromKey,
      child: Padding(
        padding: SCREEN_PADDING,
        child: Column(
          children: [
            FormBuilderTextField(
              name: 'username',
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: FORM_CIRCULAR_BORDER,
                ),
                hintText: 'Username',
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                  errorText: 'Provide a username',
                ),
                FormBuilderValidators.minLength(
                  6,
                  errorText: 'Username must be at least 6 characters',
                ),
                FormBuilderValidators.maxLength(
                  64,
                  errorText: 'Username must be at most 64 characters',
                ),
                FormBuilderValidators.match(
                  r'^[a-zA-Z0-9_]*$',
                  errorText:
                      'only characters, digits and underscores is allowed',
                ),
              ]),
            ),
            SizedBox(height: 4.h),
            FormBuilderTextField(
              name: 'password',
              textInputAction: TextInputAction.next,
              obscureText: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                  errorText: 'Provide a password',
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
                  errorText: 'only characters, digits and (!@#%^&*) is allowed',
                ),
              ]),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.key_rounded),
                border: OutlineInputBorder(
                  borderRadius: FORM_CIRCULAR_BORDER,
                ),
                hintText: 'Password',
              ),
            ),
            SizedBox(height: 4.h),
            FormBuilderTextField(
              name: 'retype',
              textInputAction: TextInputAction.next,
              obscureText: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: FormBuilderValidators.compose([
                (value) {
                  if (value !=
                      controller.signupFromKey.currentState?.fields['password']
                          ?.value) {
                    return 'Password does not match';
                  }

                  return null;
                },
              ]),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.restart_alt_rounded),
                border: OutlineInputBorder(
                  borderRadius: FORM_CIRCULAR_BORDER,
                ),
                hintText: 'Re-type password',
              ),
            ),
            SizedBox(height: 4.h),
            FormBuilderTextField(
              name: 'private_phone',
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                  errorText: 'Provide a valid phone number',
                ),
                FormBuilderValidators.minLength(
                  4,
                  errorText: 'Phone number must be at least 4 characters',
                ),
                FormBuilderValidators.maxLength(
                  15,
                  errorText: 'Phone number must be at most 15 characters',
                ),
                FormBuilderValidators.match(
                  r'^[0-9]*$',
                  errorText:
                      'only digits is allowed,No need of country codes or spaces',
                ),
              ]),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.call),
                border: OutlineInputBorder(
                  borderRadius: FORM_CIRCULAR_BORDER,
                ),
                hintText: 'Phone number',
              ),
            ),
            SizedBox(height: 4.h),
            FormBuilderTextField(
              name: 'private_email_id',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.email(
                  errorText: 'Provide a valid email address',
                ),
              ]),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email_rounded),
                border: OutlineInputBorder(
                  borderRadius: FORM_CIRCULAR_BORDER,
                ),
                hintText: 'Email',
              ),
            ),
            SizedBox(height: 4.h),
            FormBuilderDropdown<String>(
              name: 'gender_type_id',
              borderRadius: FORM_CIRCULAR_BORDER,
              decoration: InputDecoration(
                hintText: 'Select gender',
                border: const OutlineInputBorder(
                  borderRadius: FORM_CIRCULAR_BORDER,
                ),
                contentPadding: EdgeInsetsDirectional.all(10.sp),
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null) {
                  return 'Please select';
                }

                return null;
              },
              items: genderList,
              initialValue: genderList.first.value,
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Expanded(
                  child: FormBuilderTextField(
                    name: 'captcha_code',
                    keyboardType: TextInputType.number,
                    validator: FormBuilderValidators.compose(
                      [
                        FormBuilderValidators.required(
                          errorText: 'Provide a valid captcha',
                        ),
                        FormBuilderValidators.numeric(
                          errorText: 'Provide a valid captcha',
                        ),
                      ],
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      labelText: 'Captcha',
                      border: const OutlineInputBorder(
                        borderRadius: FORM_CIRCULAR_BORDER,
                      ),
                      contentPadding: EdgeInsets.all(10.sp),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    await controller.loadCaptcha();
                  },
                  icon: const Icon(Icons.refresh_rounded),
                  splashRadius: 20,
                ),
                GetBuilder<SignupController>(
                  builder: (controller) {
                    return controller.captchaId == null
                        ? Expanded(
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                height: 50.sp,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : Expanded(
                            child: SizedBox(
                              height: 50.sp,
                              child: Image.network(
                                controller.captchaImageUrl!,
                                fit: BoxFit.fill,
                              ),
                            ),
                          );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
