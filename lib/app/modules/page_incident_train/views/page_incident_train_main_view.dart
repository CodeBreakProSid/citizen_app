// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously

import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../data/train_details.dart';
import '../../../util/theme_data.dart';
import '../controllers/page_incident_train_controller.dart';

class PageIncidentTrainMainView extends StatefulWidget {
  const PageIncidentTrainMainView({super.key});

  @override
  State<PageIncidentTrainMainView> createState() =>
      _PageIncidentTrainMainViewState();
}

class _PageIncidentTrainMainViewState extends State<PageIncidentTrainMainView> {
  final controller = Get.find<PageIncidentTrainController>();
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
    final controller = Get.find<PageIncidentTrainController>();

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
      controller.incidentTrainFormKey.currentState?.save();
      controller.update();
    }

    return GetBuilder<PageIncidentTrainController>(
      builder: (_) {
        return Container(
          decoration: const BoxDecoration(
            color: FORGROUND_COLOR,
            borderRadius: HOME_BOX_BORDER,
            backgroundBlendMode: BlendMode.multiply,
          ),
          child: FormBuilder(
            key: controller.incidentTrainFormKey,
            child: Padding(
              padding: FIT_SCREEN_PADDING,
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
                      maxLength: 3,
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
                        labelStyle: HINT_TEXT_LABEL,
                        prefixText: '+91',
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
                    DropdownSearch<TrainDetails>(
                      items: controller.trainList,
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        itemBuilder: (context, item, isSelected) {
                          return Container(
                            padding: EdgeInsets.all(15.sp),
                            child: Text(
                              item.name,
                              style: TextStyle(fontSize: 10.sp),
                            ),
                          );
                        },
                      ),
                      itemAsString: (item) => item.name,
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        baseStyle: TextStyle(fontSize: 10.sp),
                        dropdownSearchDecoration: InputDecoration(
                          contentPadding: EdgeInsets.all(16.sp),
                          labelText: 'Select Train',
                          labelStyle: HINT_TEXT_LABEL,
                          border: OutlineInputBorder(
                            borderRadius: HINT_BOARDER_STYLE,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        controller.selectedTrain = value;
                      },
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null) {
                          return 'Please select train';
                        }

                        return null;
                      },
                    ),
                    SizedBox(height: 8.h),
                    FormBuilderTextField(
                      maxLength: 3,
                      name: 'coachNo',
                      decoration: InputDecoration(
                        helperText: '3 characters maximum',
                        border: OutlineInputBorder(
                          borderRadius: HINT_BOARDER_STYLE,
                        ),
                        labelText: 'Coach No',
                        labelStyle: HINT_TEXT_LABEL,
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your coach number';
                        } else if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
                          return 'Special characters are not allowed';
                        } else if (value.length > 3) {
                          return 'Coach number should be less than 3 character';
                        }

                        return null;
                      },
                    ),
                    SizedBox(height: 15.h),
                    FormBuilderTextField(
                      maxLength: 3,
                      keyboardType: TextInputType.number,
                      name: 'seatNo',
                      decoration: InputDecoration(
                        helperText: '3 characters maximum',
                        border: OutlineInputBorder(
                          borderRadius: HINT_BOARDER_STYLE,
                        ),
                        labelText: 'Seat No',
                        labelStyle: HINT_TEXT_LABEL,
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value != null && value != '') {
                          if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                            return 'Special characters are not allowed';
                          }
                          if (int.parse(value) > 106) {
                            return 'Select seat number between 1 and 106';
                          }
                          if (int.parse(value) < 1) {
                            return 'Select seat number between 1 and 106';
                          }
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
                    SizedBox(height: 10.h),
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
                        GetBuilder<PageIncidentTrainController>(
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
                    SizedBox(height: 8.h),
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
                          return 'Please enter incident details';
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
                    GetBuilder<PageIncidentTrainController>(
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
                    SizedBox(height: 8.h),
                    Align(
                      child: SizedBox(
                        width: 150.w,
                        height: 40.sp,
                        child: GetBuilder<PageIncidentTrainController>(
                          builder: (controller) {
                            if (!controller.isUploading) {
                              return ElevatedButton(
                                onPressed: () {
                                  if (controller
                                      .incidentTrainFormKey.currentState!
                                      .validate()) {
                                    controller.submitIncidentOnTrain(context);
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
