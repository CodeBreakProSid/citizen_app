import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../util/theme_data.dart';

class SosPageMain extends StatelessWidget 
{
  const SosPageMain({super.key});

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
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.sp),
            ),
          ),
          const Expanded(child: SizedBox()),
          Column(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: const Color.fromARGB(255, 126, 14, 6),
                  padding: EdgeInsets.all(80.sp),
                ),
                onPressed: () async {
                  final call = Uri.parse('tel:112');
                  if (await canLaunchUrl(call)) {
                    launchUrl(call);
                  } else {
                    throw 'Could not launch $call';
                  }
                },
                child: const Text(
                  'SOS',
                  style: TextStyle(fontSize: 60),
                ),
              ),
            ],
          ),
          const Expanded(flex: 4, child: SizedBox()),
          Container(
            width: Get.width,
            //decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            child: ElevatedButton(
              onPressed: () {
                //Get.toNamed(Routes.HOME);
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(16.sp),
                backgroundColor: const Color.fromARGB(255, 6, 101, 113),
              ),
              child: Text(
                'CANCEL',
                style: TextStyle(
                  fontSize: 20.sp,
                  color: const Color.fromARGB(255, 255, 250, 250),
                ),
              ),
            ),
          ),
          SizedBox(height: 20.sp),
        ],
      ),
    );
  }
}
