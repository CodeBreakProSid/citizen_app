import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../util/theme_data.dart';
import '../../controllers/ticket_details_controller.dart';

class TicketDetailsMain extends StatelessWidget {
  const TicketDetailsMain({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TicketDetailsController>();

    return FormBuilder(
      key: controller.ticketDetailsFormKey,
      child: Padding(
        padding: SCREEN_PADDING,
        child: Column(
          children: [
            Container(
              padding: SCREEN_PADDING,
              decoration: const BoxDecoration(
                color: FORGROUND_COLOR,
                borderRadius: HOME_BOX_BORDER,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Message',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  FormBuilderTextField(
                    name: 'message',
                    minLines: 15,
                    maxLines: 15,
                    maxLength: 5120,
                    decoration: InputDecoration(
                      helperText: '(It accept max 5120 characters)',
                      helperStyle: TextStyle(
                        fontSize: 10.sp,
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: CIRCULAR_BORDER,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  GestureDetector(
                    onTap: () {
                      controller.selectFiles();
                    },
                    child: Container(
                      height: 35.h,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(255, 190, 190, 190),
                        ),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            height: 35.h,
                            child: ElevatedButton(
                              child: const Text('Upload file',style: TextStyle(color: Colors.white),),
                              onPressed: () {
                                controller.selectFiles();
                              },
                            ),
                          ),
                          SizedBox(width: 8.w),
                          const Expanded(
                            child: Text(
                              'Select Files',
                              style: TextStyle(color: Colors.black38),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  GetBuilder<TicketDetailsController>(
                    builder: (controller) {
                      if (controller.fileToUpload.isNotEmpty) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.fileToUpload.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        controller.removeFile(
                                          controller.fileToUpload[index],
                                        );
                                      },
                                      child: Container(
                                        width: 30.sp,
                                        height: 30.sp,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.close_rounded,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 4.w),
                                    Expanded(
                                      child: Text(
                                        controller.fileToUpload[index].name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 6.h),
                              ],
                            );
                          },
                        );
                      }

                      return SizedBox(height: 4.h);
                    },
                  ),
                  Align(
                    child: SizedBox(
                      width: 180.w,
                      height: 35.h,
                      child: GetBuilder<TicketDetailsController>(
                        builder: (controller) {
                          if (!controller.isUploading) {
                            return ElevatedButton(
                              onPressed: () {
                                controller.save().then(
                                      (value) => controller.isUploading = false,
                                    );
                              },
                              child: const Text('Save',style: TextStyle(color: Colors.white,),),
                            );
                          }

                          return ColoredBox(
                            color: primaryColor,
                            child: Center(
                              child: SizedBox(
                                height: 16.h,
                                width: 16.h,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            GetBuilder<TicketDetailsController>(
              builder: (controller) {
                return !controller.isComponentsLoading
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.displayData.length,
                        itemBuilder: (context, index) {
                          return Card(
                            color: primaryColor,
                            child: Padding(
                              padding: SCREEN_PADDING,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      // if (controller.componentGroupBuffer[index]
                                      //         .createdBy !=
                                      //     '${controller.user?.citizenId}')
                                      // if (controller.componentGroupBuffer[index]
                                      //         .createdBy ==
                                      //     controller.user?.citizenId)
                                      Text(
                                        '${controller.componentGroupBuffer[index].createdBy}',
                                        style: TextStyle(
                                          color: Colors.yellow,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.sp,
                                        ),
                                      ),

                                      // Text(
                                      //   'Officer',
                                      //   style: TextStyle(
                                      //     color: Colors.yellow,
                                      //     fontWeight: FontWeight.bold,
                                      //     fontSize: 12.sp,
                                      //   ),
                                      // ),
                                      const Expanded(child: SizedBox()),
                                      Text(
                                        DateFormat('dd/MM/yyyy, h:mm a').format(
                                          DateTime.parse(
                                            controller
                                                .componentGroupBuffer[index]
                                                .createdOn,
                                          ),
                                        ),
                                        style: TextStyle(
                                          color: const Color.fromARGB(
                                            255,
                                            190,
                                            190,
                                            190,
                                          ),
                                          fontSize: 10.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(
                                    color: Colors.white,
                                    thickness: 2.0,
                                  ),
                                  SizedBox(height: 4.h),
                                  GetBuilder<TicketDetailsController>(
                                    builder: (controller) {
                                      if (controller
                                              .displayData[index].message !=
                                          null) {
                                        return Text(
                                          controller.displayData[index].message!
                                                  .messageText ??
                                              '',
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.sp,
                                          ),
                                        );
                                      }

                                      return const SizedBox();
                                    },
                                  ),
                                  SizedBox(height: 8.h),
                                  if (controller.displayData[index].meeting !=
                                      null)
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: 30.sp,
                                              height: 30.sp,
                                              decoration: const BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(5),
                                                ),
                                              ),
                                              child: IconButton(
                                                onPressed: () =>
                                                    controller.downloadRecord(
                                                  controller.displayData[index]
                                                      .meeting!,
                                                ),
                                                icon: const Icon(
                                                  Icons.video_file_rounded,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 8.w),
                                            Expanded(
                                              child: Text(
                                                'Meeting ID: ${controller.displayData[index].meeting!.meetingId}',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 11.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8.h),
                                      ],
                                    ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: controller
                                                .displayData[index].resource !=
                                            null
                                        ? controller
                                            .displayData[index].resource?.length
                                        : 0,
                                    itemBuilder: (context, i) {
                                      return Column(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: 30.sp,
                                                height: 30.sp,
                                                decoration: const BoxDecoration(
                                                  color: buttonColor,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(5),
                                                  ),
                                                ),
                                                child: IconButton(
                                                  padding: EdgeInsets.zero,
                                                  onPressed: () {
                                                    controller.downloadResource(
                                                      controller
                                                          .displayData[index]
                                                          .resource![i],
                                                    );
                                                  },
                                                  icon: const Icon(
                                                    Icons.download,
                                                    color: Colors.white,
                                                  ),
                                                  splashRadius: 25,
                                                  iconSize: 18.sp,
                                                ),
                                              ),
                                              SizedBox(width: 8.w),
                                              Expanded(
                                                child: Text(
                                                  // ignore: avoid_dynamic_calls
                                                  controller
                                                      .displayData[index]
                                                      .resource![i]
                                                      .resourceName,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11.sp,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8.h),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : Padding(
                        padding: SCREEN_PADDING,
                        child: const CircularProgressIndicator(),
                      );
              },
            ),
            SizedBox(height: 4.h),
            GetBuilder<TicketDetailsController>(
              builder: (controller) {
                if (controller.isComponentsMoreLoading) {
                  return Center(
                    child: Padding(
                      padding: SCREEN_PADDING,
                      child: SizedBox(
                        height: 30.sp,
                        width: 30.sp,
                        child: const CircularProgressIndicator(),
                      ),
                    ),
                  );
                }
                if (!controller.noMoreGroups) {
                  return ElevatedButton(
                    onPressed: () {
                      controller.isComponentsMoreLoading = true;
                      controller.loadMoreComponentGroups().then(
                            (value) =>
                                controller.isComponentsMoreLoading = false,
                          );
                    },
                    child: SizedBox(
                      width: 150.w,
                      height: 20.h,
                      child: Center(
                        child: Text(
                          'Show More',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 10.sp),
                        ),
                      ),
                    ),
                  );
                }

                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}
