import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../data/police_station.dart';
import '../../../../util/theme_data.dart';
import '../../controllers/add_ticket_controller.dart';

class AddTicketMain extends StatelessWidget {
  const AddTicketMain({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddTicketController>();

    late final List<DropdownMenuItem<String>> ticketType = [];
    for (final element in controller.ticketTypes.entries) {
      ticketType.add(
        DropdownMenuItem<String>(
          value: '${element.value}',
          child: Text(
            element.key,
            style: TextStyle(
              fontSize: 12.sp,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: SCREEN_PADDING,
      child: Container(
        padding: SCREEN_PADDING,
        decoration: const BoxDecoration(
          color: FORGROUND_COLOR,
          borderRadius: HOME_BOX_BORDER,
        ),
        child: FormBuilder(
          key: controller.addTicketFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ticket Type',
                style: TEXT_HEADER,
              ),
              SizedBox(height: 8.h),
              FormBuilderDropdown<String>(
                name: 'ticket_type',
                borderRadius: CIRCULAR_BORDER,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: CIRCULAR_BORDER,
                  ),
                ),
                items: ticketType,
                initialValue: ticketType.first.value,
              ),
              SizedBox(height: 8.h),
              Text(
                'Police Station',
                style: TEXT_HEADER,
              ),
              SizedBox(height: 8.h),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: CIRCULAR_BORDER,
                ),
                child: DropdownSearch<PoliceStation>(
                  items: controller.policeStations,
                  popupProps: PopupProps.menu(
                    showSearchBox: true,
                    itemBuilder: (context, item, isSelected) {
                      return Container(
                        padding: EdgeInsets.all(15.sp),
                        child: Text(
                          item.stationName,
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      );
                    },
                  ),
                  itemAsString: (item) => item.stationName,
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    baseStyle: TextStyle(fontSize: 18.sp),
                    dropdownSearchDecoration: InputDecoration(
                      contentPadding: EdgeInsets.all(16.sp),
                      hintText: 'Select Police Station',
                      border: const OutlineInputBorder(
                        borderRadius: CIRCULAR_BORDER,
                      ),
                    ),
                  ),
                  dropdownBuilder: (context, selectedItem) {
                    return Text(
                      selectedItem!.stationName,
                      style: TextStyle(fontSize: 14.sp),
                    );
                  },
                  onChanged: (value) {
                    controller.selectedPoliceStation = value;
                  },
                  selectedItem: controller.nearestStaion ??
                      controller.policeStations.first,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Message',
                style: TEXT_HEADER,
              ),
              SizedBox(height: 8.h),
              FormBuilderTextField(
                name: 'message',
                maxLines: 8,
                maxLength: 5120,
                initialValue: '',
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: CIRCULAR_BORDER,
                  ),
                  helperText: '(It accept max 5120 characters)',
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
                          child: const Text(
                            'Upload file',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
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
              if (controller.meetingId != null)
                Column(
                  children: [
                    Row(
                      children: [
                        InkWell(
                          child: Container(
                            width: 30.sp,
                            height: 30.sp,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.video_file_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            'Meeting ID: ${controller.meetingId}',
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
                ),
              GetBuilder<AddTicketController>(
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
                                      borderRadius: BorderRadius.circular(10.0),
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
                            SizedBox(height: 4.h),
                          ],
                        );
                      },
                    );
                  }

                  return SizedBox(height: 8.h);
                },
              ),
              Align(
                child: SizedBox(
                  width: 180.w,
                  height: 30.sp,
                  child: GetBuilder<AddTicketController>(
                    builder: (controller) {
                      if (!controller.isUploading) {
                        return ElevatedButton(
                          onPressed: () {
                            controller.save();
                          },
                          child: const Text(
                            'Save',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        );
                      }

                      return ColoredBox(
                        color: primaryColor,
                        child: Center(
                          child: SizedBox(
                            height: 20.sp,
                            width: 20.sp,
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
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
