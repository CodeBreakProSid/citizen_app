// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../util/theme_data.dart';

class SosPageView extends StatelessWidget {
  const SosPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: SCREEN_PADDING,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Expanded(flex: 2, child: SizedBox()),
          Align(
            child: Text(
              'Are you in Emergency?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 20.sp),
          Align(
            child: Text(
              'Press the button below and help will reach you soon.',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 18.sp),
            ),
          ),
          const Expanded(child: SizedBox()),
          ElevatedButton(
            onPressed: () {
              print('info');
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              backgroundColor: buttonColor,
              padding: EdgeInsets.all(16.sp),
            ),
            child: Icon(
              Icons.sos,
              color: Colors.white,
              size: 150.sp,
            ),
          ),
          const Expanded(flex: 4, child: SizedBox()),
          Container(
            width: Get.width,
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            child: ElevatedButton(
              onPressed: () {
                print('info');
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(16.sp),
                backgroundColor: Colors.white,
              ),
              child: Text(
                'CANCEL',
                style: TextStyle(fontSize: 20.sp, color: Colors.grey),
              ),
            ),
          ),
          SizedBox(height: 20.sp),
        ],
      ),
    );
  }
}
