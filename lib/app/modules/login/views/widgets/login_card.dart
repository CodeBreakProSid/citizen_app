import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import '../../../../routes/app_pages.dart';
import '../../../../util/asset_urls.dart';
import '../../../../util/global_widgets.dart';
import '../../../../util/theme_data.dart';
import '../../controllers/login_controller.dart';
import 'forgot_password.dart';

class LoginCard extends StatefulWidget {
  const LoginCard({super.key});

  @override
  State<LoginCard> createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard> {
  final controller = Get.find<LoginController>();

  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: AlignmentDirectional.center,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: FormBuilder(
        key: controller.loginFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: ICON_COLOR,
                    blurRadius: 5,
                    blurStyle: BlurStyle.outer,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(16.sp),
                child: Image.asset(
                  AssetUrls.LOGO,
                  width: 200.sp,
                  height: 200.sp,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            // Text(
            //   'CITIZEN LOGIN',
            //   style: TextStyle(
            //     color: Colors.grey,
            //     fontWeight: FontWeight.bold,
            //     fontSize: 24.sp,
            //   ),
            // ),
            SizedBox(height: 16.h),
            FormBuilderTextField(
              name: 'username',
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                prefixIcon: Icon(
                  Icons.person,
                  color: primaryColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: CIRCULAR_BORDER,
                ),
                hintText: 'Username',
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                  errorText: 'Provide your username',
                ),
                FormBuilderValidators.minLength(
                  6,
                  errorText: 'Username must be at least 6 characters',
                ),
              ]),
              initialValue: controller.username,
            ),
            SizedBox(height: 6.h),
            FormBuilderTextField(
              name: 'password',
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.key,
                  color: primaryColor,
                ),
                hintText: 'Password',
                border: const OutlineInputBorder(
                  borderRadius: CIRCULAR_BORDER,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility_off : Icons.visibility,
                    color: primaryColor,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                  splashRadius: 20,
                ),
              ),
              obscureText: !_passwordVisible,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: FormBuilderValidators.required(
                errorText: 'Provide a password',
              ),
              initialValue: controller.password,
            ),
            SizedBox(height: 4.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  activeColor: buttonColor,
                  value: controller.isChecked,
                  side: const BorderSide(width: 2),
                  onChanged: (value) {
                    setState(() {
                      controller.isChecked = value!;
                    });
                  },
                ),
                Text(
                  'Remember me',
                  style: TextStyle(fontSize: 12.sp),
                ),
                const Expanded(child: SizedBox()),
                GestureDetector(
                  onTap: () {
                    controller.isResetPassword = false;
                    showAnimatedDialog(const ForgotPassword(), context);
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            SizedBox(
              width: 180.sp,
              height: 35.sp,
              child: ElevatedButton(
                child: GetBuilder<LoginController>(
                  builder: (controller) {
                    return controller.isLogging
                        ? SizedBox(
                            height: 15.h,
                            width: 15.h,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Login',style: TextStyle(color: Colors.white),);
                  },
                ),
                onPressed: () {
                  controller.login();
                },
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "Don't have an account?",
              style: TextStyle(
                fontSize: 14.sp,
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.toNamed(Routes.SIGNUP);
              },
              child: Text(
                'Sign up',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.blue,
                ),
              ),
            ),
            SizedBox(height: 50.h),
          ],
        ),
      ),
    );
  }
}
