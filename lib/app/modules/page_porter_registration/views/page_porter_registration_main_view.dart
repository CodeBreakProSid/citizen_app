// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../data/railway_station_details.dart';
import '../../../data/staff_porter_category.dart';
import '../../../data/state_list.dart';
import '../../../util/theme_data.dart';
import '../controllers/page_porter_registration_controller.dart';

class PagePorterRegistrationMainView extends StatefulWidget {
  const PagePorterRegistrationMainView({super.key});

  @override
  State<PagePorterRegistrationMainView> createState() =>
      _PagePorterRegistrationMainViewState();
}

class _PagePorterRegistrationMainViewState
    extends State<PagePorterRegistrationMainView> {
  final controller = Get.find<PagePorterRegistrationController>();
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
    final controller = Get.find<PagePorterRegistrationController>();

    final List<DropdownMenuItem<String>> genderType = [];

    for (final element in controller.genderTypes.entries) {
      genderType.add(
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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Register as new staff',
          style: appBarTextStyle,
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
        shape: appBarShape,
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: FORGROUND_COLOR,
          borderRadius: HOME_BOX_BORDER,
          backgroundBlendMode: BlendMode.multiply,
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              GetBuilder<PagePorterRegistrationController>(
                builder: (_) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: FORGROUND_COLOR,
                      borderRadius: HOME_BOX_BORDER,
                    ),
                    child: FormBuilder(
                      key: controller.porterFormKey,
                      child: Padding(
                        padding: SCREEN_PADDING,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(height: 8.h),
                              DropdownSearch<StaffPorterCategory>(
                                items: controller.staffPorterTypes,
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
                                    labelText: 'Select staff category',
                                    labelStyle: HINT_TEXT_LABEL,
                                    border: OutlineInputBorder(
                                      borderRadius: HINT_BOARDER_STYLE,
                                    ),
                                  ),
                                ),
                                onChanged: (value) {
                                  controller.selectedStaffPorterType = value;
                                },
                                autoValidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please choose a category';
                                  }

                                  return null;
                                },
                              ),
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
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter correct name';
                                  } else if (!RegExp(r'^[a-z A-Z]+$')
                                      .hasMatch(value)) {
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
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Age is required.';
                                  } else if (!RegExp(r'^[0-9]+$')
                                      .hasMatch(value)) {
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
                              FormBuilderDropdown<String>(
                                enabled: false,
                                name: 'genderType',
                                initialValue: '${_.user!.genderType}',
                                borderRadius: CIRCULAR_BORDER,
                                decoration: InputDecoration(
                                  labelText: 'Select gender',
                                  labelStyle: HINT_TEXT_LABEL,
                                  border: OutlineInputBorder(
                                    borderRadius: HINT_BOARDER_STYLE,
                                  ),
                                ),
                                items: genderType,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select an option';
                                  }

                                  return null;
                                },
                              ),
                              SizedBox(height: 8.h),
                              FormBuilderTextField(
                                maxLength: 150,
                                maxLines: 3,
                                name: 'jobDetail',
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: HINT_BOARDER_STYLE,
                                  ),
                                  labelText: 'Job detail',
                                  labelStyle: HINT_TEXT_LABEL,
                                  helperText: '(It accept max 150 characters)',
                                ),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter job details';
                                  }

                                  return null;
                                },
                              ),
                              SizedBox(height: 15.h),
                              FormBuilderTextField(
                                readOnly: true,
                                name: 'mobile',
                                initialValue: '${_.user!.phoneNumber}',
                                keyboardType: TextInputType.phone,
                                //maxLength: 10,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: HINT_BOARDER_STYLE,
                                  ),
                                  labelText: 'Mobile',
                                  labelStyle: HINT_TEXT_LABEL,
                                  prefixText: '+91 ',
                                  // counterText: '',
                                ),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your mobile number';
                                  } else if (!RegExp(
                                    r'(^(?:[+0]9)?[0-9]{10}$)',
                                  ).hasMatch(value)) {
                                    return 'Please enter valid mobile number';
                                  }

                                  return null;
                                },
                              ),
                              SizedBox(height: 8.h),
                              DropdownSearch<StateList>(
                                items: controller.stateList,
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
                                    labelText: 'Select state',
                                    labelStyle: HINT_TEXT_LABEL,
                                    border: OutlineInputBorder(
                                      borderRadius: HINT_BOARDER_STYLE,
                                    ),
                                  ),
                                ),
                                onChanged: (value) {
                                  controller.selectedState = value;
                                },
                                autoValidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select state';
                                  }

                                  return null;
                                },
                              ),
                              SizedBox(height: 8.h),
                              FormBuilderTextField(
                                name: 'policeStation',
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: HINT_BOARDER_STYLE,
                                  ),
                                  labelText: 'Native police station',
                                  labelStyle: HINT_TEXT_LABEL,
                                ),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter police station name';
                                  } else if (!RegExp(r'^[a-z A-Z]+$')
                                      .hasMatch(value)) {
                                    return 'Allow upper and lower case alphabets and space';
                                  }

                                  return null;
                                },
                              ),
                              SizedBox(height: 8.h),
                              FormBuilderTextField(
                                name: 'address',
                                maxLines: 3,
                                maxLength: 150,
                                initialValue: '',
                                decoration: InputDecoration(
                                  labelText: 'Address',
                                  labelStyle: HINT_TEXT_LABEL,
                                  border: OutlineInputBorder(
                                    borderRadius: HINT_BOARDER_STYLE,
                                  ),
                                  helperText: '(It accept max 150 characters)',
                                ),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your address';
                                  }

                                  return null;
                                },
                              ),
                              SizedBox(height: 15.h),
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
                                autoValidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select railway station';
                                  }

                                  return null;
                                },
                              ),
                              SizedBox(height: 8.h),
                              FormBuilderRadioGroup(
                                name: 'migrantOrNot',
                                decoration: InputDecoration(
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  labelText: 'Are you a migrant ?',
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  fillColor: Colors.red,
                                  focusColor: Colors.blue,
                                  hoverColor: Colors.yellow,
                                ),
                                options: const [
                                  FormBuilderFieldOption(value: 'Yes'),
                                  FormBuilderFieldOption(value: 'No'),
                                ],
                                onChanged: (value) {
                                  controller.porterFormKey.currentState?.save();
                                  controller.update();
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select an option';
                                  }

                                  return null;
                                },
                              ),
                              SizedBox(height: 8.h),
                              GetBuilder<PagePorterRegistrationController>(
                                builder: (_) {
                                  if (_.porterFormKey.currentState
                                          ?.value['migrantOrNot'] ==
                                      'Yes') {
                                    return FormBuilderTextField(
                                      name: 'aadhaarNo',
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(15.0),
                                          ),
                                        ),
                                        hintText: 'Aadhaar No',
                                      ),
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Aadhaar No is required.';
                                        } else if (!RegExp(
                                          r'^[1-9]{1}[0-9]{3}[0-9]{4}[0-9]{4}$',
                                        ).hasMatch(value)) {
                                          return 'Please enter proper Aadhaar No';
                                        } else if (int.tryParse(value)!
                                            .isNegative) {
                                          return 'Negative number not allowed';
                                        }
                                        // else if (value[0] != '2') {
                                        //   return 'Aadhaar starts with digit 2';
                                        // }

                                        return null;
                                      },
                                    );
                                  }

                                  return const SizedBox();
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
                                  Future.delayed(
                                      const Duration(milliseconds: 300), () {
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                              if (showProgress &&
                                  controller.uploadImages != null)
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
                              GetBuilder<PagePorterRegistrationController>(
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
                                                      BorderRadius.circular(
                                                    10.0,
                                                  ),
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
                                  child: GetBuilder<
                                      PagePorterRegistrationController>(
                                    builder: (controller) {
                                      if (!controller.isUploading) {
                                        return ElevatedButton(
                                          onPressed: () {
                                            if (_.porterFormKey.currentState!
                                                .validate()) {
                                              controller.submitStaffPorter();
                                            }
                                          },
                                          child: const Text('Submit',style: TextStyle(color: Colors.white,),),
                                        );
                                      }

                                      return ColoredBox(
                                        color: primaryColor,
                                        child: Center(
                                          child: SizedBox(
                                            height: 20.sp,
                                            width: 20.sp,
                                            child:
                                                const CircularProgressIndicator(
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
                              SizedBox(
                                height: 25.sp,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
