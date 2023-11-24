// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../data/train_details.dart';
import '../../../util/theme_data.dart';
import '../controllers/page_intruder_alert_controller.dart';

class PageIntruderAlertMainView extends StatefulWidget {
  const PageIntruderAlertMainView({super.key});

  @override
  State<PageIntruderAlertMainView> createState() =>
      _PageIntruderAlertMainViewState();
}

class _PageIntruderAlertMainViewState extends State<PageIntruderAlertMainView> {
  final controller = Get.find<PageIntruderAlertController>();
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
    final controller = Get.find<PageIntruderAlertController>();

    return GetBuilder<PageIntruderAlertController>(
      builder: (_) {
        return Container(
          decoration: const BoxDecoration(
            color: FORGROUND_COLOR,
            borderRadius: HOME_BOX_BORDER,
            backgroundBlendMode: BlendMode.multiply,
          ),
          child: FormBuilder(
            key: controller.intruderFormKey,
            child: Padding(
              padding: SCREEN_PADDING,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 8.h),
                    FormBuilderTextField(
                      name: 'name',
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: HINT_BOARDER_STYLE,
                        ),
                        labelText: 'Name',
                        labelStyle: HINT_TEXT_LABEL,
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value != null && value != '') {
                          if (!RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                            return 'Allow upper and lower case alphabets and space';
                          }
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
                              style: TextStyle(fontSize: 14.sp),
                            ),
                          );
                        },
                      ),
                      itemAsString: (item) => item.name,
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        baseStyle: TextStyle(fontSize: 18.sp),
                        dropdownSearchDecoration: InputDecoration(
                          prefixIcon: const Padding(
                            padding: EdgeInsetsDirectional.only(start: 12.0),
                            child: Icon(
                              Icons.train_rounded,
                            ),
                          ),
                          contentPadding: EdgeInsets.all(16.sp),
                          labelText: 'Select Train',
                          labelStyle: HINT_TEXT_LABEL,
                          border: OutlineInputBorder(
                            borderRadius: HINT_BOARDER_STYLE,
                          ),
                        ),
                      ),
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      onChanged: (value) {
                        controller.selectedTrain = value;
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select train';
                        }

                        return null;
                      },
                    ),
                    SizedBox(height: 8.h),
                    FormBuilderTextField(
                      keyboardType: TextInputType.number,
                      name: 'mobileNo',
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: HINT_BOARDER_STYLE,
                        ),
                        labelText: 'Mobile Number',
                        labelStyle: HINT_TEXT_LABEL,
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value != null && value != '') {
                          if (!RegExp(r'(^(?:[+0]9)?[0-9]{10}$)')
                              .hasMatch(value)) {
                            return 'Please enter valid mobile number';
                          }
                        }

                        return null;
                      },
                    ),
                    SizedBox(height: 8.h),
                    FormBuilderTextField(
                      maxLines: 3,
                      maxLength: 150,
                      name: 'location',
                      decoration: InputDecoration(
                        helperText: '(It accept max 150 characters)',
                        border: OutlineInputBorder(
                          borderRadius: HINT_BOARDER_STYLE,
                        ),
                        labelText: 'Location hint',
                        labelStyle: HINT_TEXT_LABEL,
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please input a location hint';
                        }

                        return null;
                      },
                    ),
                    SizedBox(height: 15.h),
                    FormBuilderTextField(
                      name: 'remarks',
                      maxLines: 3,
                      maxLength: 150,
                      initialValue: '',
                      decoration: InputDecoration(
                        labelText: 'Remarks',
                        labelStyle: HINT_TEXT_LABEL,
                        border: OutlineInputBorder(
                          borderRadius: HINT_BOARDER_STYLE,
                        ),
                        helperText: '(It accept max 150 characters)',
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some remarks';
                        }

                        return null;
                      },
                    ),
                    SizedBox(height: 15.h),
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
                    GetBuilder<PageIntruderAlertController>(
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
                    SizedBox(
                      height: 8.h,
                    ),
                    Align(
                      child: SizedBox(
                        width: 150.w,
                        height: 40.sp,
                        child: GetBuilder<PageIntruderAlertController>(
                          builder: (controller) {
                            if (!controller.isUploading) {
                              return ElevatedButton(
                                onPressed: () {
                                  if (_.intruderFormKey.currentState!
                                      .validate()) {
                                    controller.submitIntruderAlert(context);
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
