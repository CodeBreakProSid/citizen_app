// ignore_for_file: avoid_bool_literals_in_conditional_expressions

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../util/asset_urls.dart';
import '../../../util/theme_data.dart';
import '../controllers/page_rail_volunteer_controller.dart';

class RailVolunteerConfirmPage extends StatelessWidget {
  const RailVolunteerConfirmPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PageRailVolunteerController>();
    String genderRole = '';
    String? railwayStation = '';
    String? railwayPoliceSation = '';
    String volCategory = '';
    bool imageStatus;
    String? fromRailwayStation = '';
    String? toRailwayStation = '';

    imageStatus = controller.uploadImages != null ? true : false;

    String imagePath = AssetUrls.PROFILEPIC;
    ImageProvider<Object> imageProvider = AssetImage(imagePath);

    for (final element in controller.volunteerCat) {
      if ('${element.id}' ==
          '${controller.railVolunteerFormKey.currentState?.fields['volunteerCategory']?.value}') {
        volCategory = element.name;
      }
    }

    for (final element in controller.genderTypes.entries) {
      if ('${element.value}' ==
          '${controller.railVolunteerFormKey.currentState?.fields['genderType']?.value}') {
        genderRole = element.key;
      }
    }

    for (final element in controller.railwayStaionList) {
      if ('${element.id}' == '${controller.selectedRailwayStation?.id}') {
        railwayStation = element.name;
      }
    }

    for (final element in controller.railwayPoliceStationList) {
      if ('${element.id}' == '${controller.selectedRailwayPoliceStation?.id}') {
        railwayPoliceSation = element.name;
      }
    }

    for (final element in controller.railwayStaionList) {
      if ('${element.id}' ==
          '${controller.selectedSeasonFromRailwayStation?.id}') {
        fromRailwayStation = element.name;
      }
    }

    for (final element in controller.railwayStaionList) {
      if ('${element.id}' ==
          '${controller.selectedSeasonToRailwayStation?.id}') {
        toRailwayStation = element.name;
      }
    }

    return AlertDialog(
      surfaceTintColor: Colors.white,
      content: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Column(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 50.w,
                      ),
                      Expanded(
                        flex: 5,
                        child: Text(
                          'Confirmation',
                          style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.sp),
                        ),
                      ),
                      Expanded(
                        child: Container(
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
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CircleAvatar(
                radius: 60,
                backgroundImage: imageStatus
                    ? FileImage(File(controller.uploadImages!.path))
                    : imageProvider,
              ),
              const SizedBox(height: 16),
              Text(
                '${controller.railVolunteerFormKey.currentState?.fields['name']?.value}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                volCategory,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                genderRole,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${controller.railVolunteerFormKey.currentState?.fields['age']?.value ?? 'No age entered'}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${controller.railVolunteerFormKey.currentState?.fields['mobile']?.value}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${controller.railVolunteerFormKey.currentState?.fields['email']?.value}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$railwayStation',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$railwayPoliceSation',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'Are you a season passenger : ${controller.railVolunteerFormKey.currentState?.fields['seasonTicket']?.value == 'true' ? 'Yes' : 'No'} ',
              ),
              const SizedBox(height: 8),
              Text(
                '$fromRailwayStation',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$toRailwayStation',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 15.h),
              SizedBox(
                width: 180.w,
                height: 35.h,
                child: ElevatedButton(
                  onPressed: () {
                    controller.saveRailVolunteer();
                  },
                  child: const Text(
                    'Confirm',
                    style: TextStyle(color: Colors.white),
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
