// ignore_for_file: no_wildcard_variable_uses, unnecessary_null_comparison, use_build_context_synchronously

import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../data/railway_station_details.dart';
import '../../../util/theme_data.dart';
import '../controllers/page_incident_platform_controller.dart';

class PageIncidentPlatformMainView extends StatefulWidget {
  const PageIncidentPlatformMainView({super.key});

  @override
  State<PageIncidentPlatformMainView> createState() =>
      _PageIncidentPlatformMainViewState();
}

class _PageIncidentPlatformMainViewState
    extends State<PageIncidentPlatformMainView> {
  final controller = Get.find<PageIncidentPlatformController>();
  double progress = 0.0;
  bool showProgress = false;
  bool displayDelayedWidget = false;
  late Timer _timer;
  late XFile? image;

  Future<void> _showModalBottomSheet() async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Take a Photo'),
                onTap: () async {
                  await controller.uploadImage(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Choose from Gallery'),
                onTap: () async {
                  await controller.uploadImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> pickFile() async {
    if (controller.uploadImages != null) {
      setState(() {
        showProgress = true;
        _timer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
          setState(() {
            progress += 0.167;
            if (progress >= 0.9) {
              _timer.cancel();
            }
          });
        });
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            displayDelayedWidget = true;
          });
        });
      });
    } else {
      setState(() {
        showProgress = false;
        displayDelayedWidget = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //final controller = Get.find<PageIncidentPlatformController>();

    Future<DateTime?> pickDate() => showDatePicker(
          context: context,
          initialDate: controller.dateTime,
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );

    Future<TimeOfDay?> pickTime() => showTimePicker(
          context: context,
          initialTime: TimeOfDay(
            hour: controller.dateTime.hour,
            minute: controller.dateTime.minute,
          ),
        );

    Future pickDateTime() async {
      final DateTime? date = await pickDate();
      if (date == null) return;

      final TimeOfDay? time = await pickTime();
      if (time == null) return;

      final dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );

      controller.dateTime = dateTime;
      controller.incidentPlatformFormKey.currentState?.save();
      controller.update();
    }

    return GetBuilder<PageIncidentPlatformController>(
      builder: (_) {
        return Container(
          decoration: const BoxDecoration(
            color: FORGROUND_COLOR,
            borderRadius: HOME_BOX_BORDER,
          ),
          child: FormBuilder(
            key: controller.incidentPlatformFormKey,
            child: Padding(
              padding: SCREEN_PADDING,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 8.h),
                    FormBuilderTextField(
                      readOnly: true,
                      name: 'name',
                      initialValue: controller.user?.fullName,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: HINT_BOARDER_STYLE,
                        ),
                        labelText: 'Name',
                        labelStyle: HINT_TEXT_LABEL,
                      ),
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
                    SizedBox(height: 8.h),
                    FormBuilderTextField(
                      keyboardType: TextInputType.number,
                      name: 'age',
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: HINT_BOARDER_STYLE,
                        ),
                        labelText: 'Age',
                        labelStyle: HINT_TEXT_LABEL,
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Age is required.';
                        } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                          return 'Special characters are not allowed';
                        } else if (int.tryParse(value)! < 18) {
                          return 'Enter age in between 18 and 100';
                        } else if (int.tryParse(value)!.isNegative ||
                            int.tryParse(value)! > 100) {
                          return 'Enter age in between 18 and 100';
                        }

                        return null;
                      },
                    ),
                    SizedBox(height: 8.h),
                    FormBuilderTextField(
                      readOnly: true,
                      keyboardType: TextInputType.number,
                      name: 'mobileNo',
                      initialValue: '${_.user!.phoneNumber}',
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: HINT_BOARDER_STYLE,
                        ),
                        labelText: 'Mobile',
                        prefixText: '+91 ',
                        // counterText: '',
                        labelStyle: HINT_TEXT_LABEL,
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your mobile number';
                        } else if (!RegExp(r'(^(?:[+0]9)?[0-9]{10}$)')
                            .hasMatch(value)) {
                          return 'Please enter valid mobile number';
                        }

                        return null;
                      },
                    ),
                    SizedBox(height: 8.h),
                    DropdownSearch<RailwayStationDetails>(
                      items: controller.railwayStaionList,
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        itemBuilder: (context, item, isSelected) {
                          return Container(
                            padding: EdgeInsets.all(15.sp),
                            child: Text(
                              '${item.name}',
                              style: TextStyle(fontSize: 14.sp),
                            ),
                          );
                        },
                      ),
                      itemAsString: (item) => '${item.name}',
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        baseStyle: TextStyle(fontSize: 18.sp),
                        dropdownSearchDecoration: InputDecoration(
                          prefixIcon: const Padding(
                            padding: EdgeInsetsDirectional.only(start: 12.0),
                            child: Icon(
                              Icons.railway_alert_rounded,
                            ),
                          ),
                          contentPadding: EdgeInsets.all(16.sp),
                          labelText: 'Select Railway Station',
                          labelStyle: HINT_TEXT_LABEL,
                          border: OutlineInputBorder(
                            borderRadius: HINT_BOARDER_STYLE,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        controller.selectedRailwayStation = value;
                      },
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null) {
                          return 'Please select railway station';
                        }

                        return null;
                      },
                    ),
                    SizedBox(height: 8.h),
                    FormBuilderTextField(
                      keyboardType: TextInputType.number,
                      name: 'platformNo',
                      maxLength: 1,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: HINT_BOARDER_STYLE,
                        ),
                        labelText: 'Platform',
                        labelStyle: HINT_TEXT_LABEL,
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter platform number';
                        } else if (!RegExp(r'^[1-8]+$').hasMatch(value)) {
                          return 'Enter platform in between 1 to 8';
                        } else if (int.tryParse(value)!.isNegative) {
                          return 'Enter platform in between 1 to 8';
                        } else if (int.tryParse(value)! < 1) {
                          return 'Enter platform in between 1 to 8';
                        } else if (int.tryParse(value)! > 8) {
                          return 'Enter platform in between 1 to 8';
                        }

                        return null;
                      },
                    ),
                    SizedBox(height: 15.h),
                    Row(
                      children: [
                        Text(
                          'Select incident date & time',
                          style: SMALL_TEXT_LABEL,
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        ElevatedButton(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_month,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8.w),
                              const Text('Select',style: TextStyle(color: Colors.white),),
                            ],
                          ),
                          onPressed: () {
                            pickDateTime();
                          },
                        ),
                        SizedBox(width: 20.w),
                        GetBuilder<PageIncidentPlatformController>(
                          builder: (controller) {
                            return _.dateTime == null
                                ? Text('${controller.dateTime}')
                                : Text(
                                    DateFormat('yyyy-MM-dd –')
                                            .format(controller.dateTime) +
                                        DateFormat(' hh:mm a')
                                            .format(controller.dateTime),
                                  );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    FormBuilderTextField(
                      name: 'incident',
                      maxLines: 3,
                      maxLength: 150,
                      initialValue: '',
                      decoration: InputDecoration(
                        labelText: 'Details of incident',
                        labelStyle: HINT_TEXT_LABEL,
                        border: OutlineInputBorder(
                          borderRadius: HINT_BOARDER_STYLE,
                        ),
                        helperText: '(It accept max 150 characters)',
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some incident information';
                        }

                        return null;
                      },
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          showProgress = false;
                          progress = 0.0;
                          controller.uploadImages = null;
                          displayDelayedWidget = false;
                        });
                        await _showModalBottomSheet();
                        Future.delayed(const Duration(milliseconds: 300), () {
                          pickFile();
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_rounded,
                                  size: 50.sp,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                            SizedBox(width: 8.w),
                            const Expanded(
                              child: Text(
                                'Upload Image',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    if (showProgress && controller.uploadImages != null)
                      LinearPercentIndicator(
                        animation: true,
                        animationDuration: 1000,
                        lineHeight: 25,
                        percent: 1,
                        center: Text(
                          '${(progress * 100).toStringAsFixed(0)}%',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        progressColor: Colors.blue,
                        backgroundColor: Colors.blueGrey.shade200,
                      )
                    else
                      const SizedBox(),
                    SizedBox(height: 20.h),
                    GetBuilder<PageIncidentPlatformController>(
                      builder: (controller) {
                        if (controller.uploadImages != null &&
                            displayDelayedWidget) {
                          return Column(
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      controller.removeImage();
                                      showProgress = false;
                                      displayDelayedWidget = false;
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
                                      // controller.fileToUpload[index].name,
                                      controller.uploadImages!.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.h),
                            ],
                          );
                        }

                        return SizedBox(height: 8.h);
                      },
                    ),
                    Align(
                      child: SizedBox(
                        width: 150.w,
                        height: 40.sp,
                        child: GetBuilder<PageIncidentPlatformController>(
                          builder: (controller) {
                            if (!controller.isUploading) {
                              return ElevatedButton(
                                onPressed: () {
                                  if (controller
                                      .incidentPlatformFormKey.currentState!
                                      .validate()) {
                                    controller
                                        .submitIncidentOnPlatform(context);
                                  }
                                },
                                child: const Text('Submit',style: TextStyle(color: Colors.white),),
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
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
