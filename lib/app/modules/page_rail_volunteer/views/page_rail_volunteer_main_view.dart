// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../data/railway_policestation_list.dart';
import '../../../data/railway_station_details.dart';
import '../../../util/global_widgets.dart';
import '../../../util/theme_data.dart';
import '../controllers/page_rail_volunteer_controller.dart';
import 'rail_volunteer_confirm_page.dart';

class PageRailVolunteerMainView extends StatefulWidget {
  const PageRailVolunteerMainView({super.key});

  @override
  State<PageRailVolunteerMainView> createState() =>
      _PageRailVolunteerMainViewState();
}

class _PageRailVolunteerMainViewState extends State<PageRailVolunteerMainView> {
  final controller = Get.find<PageRailVolunteerController>();
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
    int? sourceStationId;

    final controller = Get.find<PageRailVolunteerController>();

    late final List<DropdownMenuItem<String>> genderType = [];
    final List<DropdownMenuItem<String>> volCat = [];

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

    for (final element in controller.volunteerCat) {
      volCat.add(
        DropdownMenuItem<String>(
          value: '${element.id}',
          child: Text(
            element.name,
            style: const TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 117, 112, 112),
            ),
          ),
        ),
      );
    }

    return GetBuilder<PageRailVolunteerController>(
      builder: (_) {
        return Container(
          decoration: const BoxDecoration(
            color: FORGROUND_COLOR,
            borderRadius: HOME_BOX_BORDER,
            backgroundBlendMode: BlendMode.multiply,
          ),
          child: FormBuilder(
            key: controller.railVolunteerFormKey,
            child: Padding(
              padding: SCREEN_PADDING,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    FormBuilderDropdown<String>(
                      name: 'volunteerCategory',
                      borderRadius: CIRCULAR_BORDER,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: CIRCULAR_BORDER,
                        ),
                        hintText: 'Select Voluteer Category',
                      ),
                      items: volCat,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
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
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: CIRCULAR_BORDER,
                        ),
                        hintText: 'Name',
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
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: CIRCULAR_BORDER,
                        ),
                        hintText: 'Age',
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
                    FormBuilderDropdown<String>(
                      enabled: false,
                      name: 'genderType',
                      initialValue: '${controller.gender}',
                      borderRadius: CIRCULAR_BORDER,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: CIRCULAR_BORDER,
                        ),
                        hintText: 'Select Gender',
                      ),
                      items: genderType,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select an option';
                        }

                        return null;
                      },
                    ),
                    SizedBox(height: 8.h),
                    FormBuilderTextField(
                      readOnly: true,
                      name: 'mobile',
                      initialValue: '${_.user!.phoneNumber}',
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: CIRCULAR_BORDER,
                        ),
                        hintText: 'Mobile Number',
                        prefixText: '+91 ',
                        counterText: '',
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
                    FormBuilderTextField(
                      enabled: false,
                      name: 'email',
                      initialValue: _.user!.emailId,
                      keyboardType: TextInputType.emailAddress,
                      maxLength: 100,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: CIRCULAR_BORDER,
                        ),
                        hintText: 'Email',
                        counterText: '',
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email id';
                        } else if (!RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                        ).hasMatch(value)) {
                          return 'Please enter a valid email id';
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
                              Icons.train,
                            ),
                          ),
                          contentPadding: EdgeInsets.all(16.sp),
                          labelText: 'Select Nearest Railway Station',
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
                          return 'Please select your nearest railway station';
                        }

                        return null;
                      },
                    ),
                    SizedBox(height: 8.h),
                    DropdownSearch<RailwayPoliceStationList>(
                      items: controller.railwayPoliceStationList,
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
                              Icons.local_police,
                            ),
                          ),
                          contentPadding: EdgeInsets.all(16.sp),
                          labelText: 'Select railway police station',
                          labelStyle: HINT_TEXT_LABEL,
                          border: OutlineInputBorder(
                            borderRadius: HINT_BOARDER_STYLE,
                          ),
                        ),
                      ),
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      onChanged: (value) {
                        controller.selectedRailwayPoliceStation = value;
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select your nearest railway police station';
                        }

                        return null;
                      },
                    ),
                    SizedBox(height: 8.h),
                    FormBuilderRadioGroup(
                      name: 'seasonTicket',
                      decoration: InputDecoration(
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        labelText: 'Are you a season passenger',
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      options: const [
                        FormBuilderFieldOption(
                          value: 'true',
                          child: Text('Yes'),
                        ),
                        FormBuilderFieldOption(
                          value: 'false',
                          child: Text('No'),
                        ),
                      ],
                      onChanged: (value) {
                        controller.railVolunteerFormKey.currentState?.save();
                        controller.update();
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select an option';
                        }

                        return null;
                      },
                    ),
                    GetBuilder<PageRailVolunteerController>(
                      builder: (_) {
                        if (_.railVolunteerFormKey.currentState
                                ?.value['seasonTicket'] ==
                            'true') {
                          return Column(
                            children: [
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
                                      padding: EdgeInsetsDirectional.only(
                                        start: 12.0,
                                      ),
                                      child: Icon(
                                        Icons.start_rounded,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.all(16.sp),
                                    hintText: 'From Station',
                                    border: const OutlineInputBorder(
                                      borderRadius: CIRCULAR_BORDER,
                                    ),
                                  ),
                                ),
                                onChanged: (value) {
                                  controller.selectedSeasonFromRailwayStation =
                                      value;
                                  sourceStationId = value?.id;
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select source railway staion';
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
                                      padding: EdgeInsetsDirectional.only(
                                        start: 12.0,
                                      ),
                                      child: Icon(
                                        Icons.start_rounded,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.all(16.sp),
                                    hintText: 'To Station',
                                    border: const OutlineInputBorder(
                                      borderRadius: CIRCULAR_BORDER,
                                    ),
                                  ),
                                ),
                                onChanged: (value) {
                                  controller.selectedSeasonToRailwayStation =
                                      value;
                                },
                                autoValidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select a destination railway station';
                                  } else if (value.id == sourceStationId) {
                                    return 'Source and destination railway stations are same';
                                  }

                                  return null;
                                },
                              ),
                            ],
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
                    GetBuilder<PageRailVolunteerController>(
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
                        child: GetBuilder<PageRailVolunteerController>(
                          builder: (controller) {
                            if (!controller.isUploading) {
                              return ElevatedButton(
                                onPressed: () {
                                  if (_.railVolunteerFormKey.currentState!
                                      .validate()) {
                                    showAnimatedDialog(
                                      const RailVolunteerConfirmPage(),
                                      context,
                                    );
                                  }
                                },
                                child: const Text('I Agree',style: TextStyle(color: Colors.white),),
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
                    SizedBox(
                      height: 25.h,
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
