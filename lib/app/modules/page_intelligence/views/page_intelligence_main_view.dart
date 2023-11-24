// ignore_for_file: prefer_final_locals, unnecessary_statements, avoid_positional_boolean_parameters, use_build_context_synchronously

import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../data/intelligence_type.dart';
import '../../../data/severity_type.dart';
import '../../../util/theme_data.dart';
import '../controllers/page_intelligence_controller.dart';

class PageIntelligenceMainView extends StatefulWidget {
  const PageIntelligenceMainView({super.key});

  @override
  State<PageIntelligenceMainView> createState() =>
      _PageIntelligenceMainViewState();
}

class _PageIntelligenceMainViewState extends State<PageIntelligenceMainView> {
  final controller = Get.find<PageIntelligenceController>();
  TextEditingController textFieldNameController = TextEditingController();
  TextEditingController textFieldMobileController = TextEditingController();
  bool _isChecked = true;
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
    return GetBuilder<PageIntelligenceController>(
      builder: (_) {
        return Container(
          decoration: const BoxDecoration(
            color: FORGROUND_COLOR,
            borderRadius: HOME_BOX_BORDER,
            backgroundBlendMode: BlendMode.multiply,
          ),
          child: FormBuilder(
            key: controller.intelligenceFormKey,
            child: Padding(
              padding: SCREEN_PADDING,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          activeColor: buttonColor,
                          value: _isChecked,
                          side: const BorderSide(width: 2),
                          onChanged: (bool? value) {
                            setState(() {
                              _isChecked = value ?? false;

                              if (_isChecked) {
                                textFieldNameController.text = '';
                                textFieldMobileController.text = '';
                                controller.intelligenceFormKey.currentState
                                    ?.save();
                                controller.update();
                              } else {
                                textFieldNameController.text =
                                    controller.user!.fullName!;
                                textFieldMobileController.text =
                                    '${controller.user!.phoneNumber}';
                                controller.update();
                              }
                            });
                          },
                        ),
                        Text(
                          'Anonymous messenger',
                          style: SMALL_TEXT_LABEL,
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    DropdownSearch<IntelligenceType>(
                      items: controller.intelligenceTypes,
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
                          contentPadding: EdgeInsets.all(16.sp),
                          labelText: 'Select intelligence type',
                          labelStyle: HINT_TEXT_LABEL,
                          border: OutlineInputBorder(
                            borderRadius: HINT_BOARDER_STYLE,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        controller.selectedIntelligenceType = value;
                      },
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null) {
                          return 'Please choose a intelligence type';
                        }

                        return null;
                      },
                    ),
                    SizedBox(height: 8.h),
                    DropdownSearch<SeverityType>(
                      items: controller.severityTypes,
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
                          contentPadding: EdgeInsets.all(16.sp),
                          labelText: 'Select severity range',
                          labelStyle: HINT_TEXT_LABEL,
                          border: OutlineInputBorder(
                            borderRadius: HINT_BOARDER_STYLE,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        controller.selectedSeverityType = value;
                      },
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null) {
                          return 'Please choose a severity type';
                        }

                        return null;
                      },
                    ),
                    SizedBox(height: 8.h),
                    FormBuilderTextField(
                      enabled: !_isChecked,
                      controller: textFieldNameController,
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
                    FormBuilderTextField(
                      enabled: !_isChecked,
                      controller: textFieldMobileController,
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
                      name: 'message',
                      maxLines: 4,
                      maxLength: 250,
                      initialValue: '',
                      decoration: InputDecoration(
                        labelText: 'Information',
                        labelStyle: HINT_TEXT_LABEL,
                        border: OutlineInputBorder(
                          borderRadius: HINT_BOARDER_STYLE,
                        ),
                        helperText: '(It accept max 250 characters)',
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter intelligence information';
                        }

                        return null;
                      },
                    ),
                    SizedBox(height: 8.h),
                    FormBuilderTextField(
                      name: 'remarks',
                      maxLines: 2,
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
                    GetBuilder<PageIntelligenceController>(
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
                        child: GetBuilder<PageIntelligenceController>(
                          builder: (controller) {
                            if (!controller.isUploading) {
                              return ElevatedButton(
                                onPressed: () {
                                  if (_.intelligenceFormKey.currentState!
                                      .validate()) {
                                    controller.saveIntelligenceReport(context);
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
