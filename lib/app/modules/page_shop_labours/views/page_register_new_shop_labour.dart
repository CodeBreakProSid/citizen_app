import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../data/railway_station_details.dart';
import '../../../data/shop_category.dart';
import '../../../util/theme_data.dart';
import '../controllers/page_shop_labours_controller.dart';

class PageRegisterNewShopLabour extends StatelessWidget {
  const PageRegisterNewShopLabour({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PageShopLaboursController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Register new shops & labour',
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
              GetBuilder<PageShopLaboursController>(
                builder: (_) {
                  return FormBuilder(
                    key: controller.shopFormKey,
                    child: Padding(
                      padding: SCREEN_PADDING,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            DropdownSearch<ShopCategory>(
                              items: controller.shopCategoryTypes,
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
                                  labelText: 'Select shop category',
                                  labelStyle: HINT_TEXT_LABEL,
                                  border: OutlineInputBorder(
                                    borderRadius: HINT_BOARDER_STYLE,
                                  ),
                                ),
                              ),
                              onChanged: (value) {
                                controller.selectedShopCategoryType = value;
                              },
                              autoValidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select a category';
                                }

                                return null;
                              },
                            ),
                            SizedBox(height: 8.h),
                            FormBuilderTextField(
                              name: 'shopName',
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: HINT_BOARDER_STYLE,
                                ),
                                labelText: 'Shop name',
                                labelStyle: HINT_TEXT_LABEL,
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Shop name is required';
                                }

                                return null;
                              },
                            ),
                            SizedBox(height: 8.h),
                            FormBuilderTextField(
                              name: 'ownerName',
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: HINT_BOARDER_STYLE,
                                ),
                                labelText: 'Owner name',
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
                              name: 'aadhaarNo',
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: HINT_BOARDER_STYLE,
                                ),
                                labelText: 'Aadhaar No',
                                labelStyle: HINT_TEXT_LABEL,
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value != null && value != '') {
                                  if (!RegExp(
                                    r'^[1-9]{1}[0-9]{3}[0-9]{4}[0-9]{4}$',
                                  ).hasMatch(value)) {
                                    return 'Please enter proper Aadhaar No';
                                  } else if (int.tryParse(value)!.isNegative) {
                                    return 'Negative number not allowed';
                                  }
                                  // else if (value[0] != '2') {
                                  //   return 'Aadhaar starts with digit 2';
                                  // }
                                }

                                return null;
                              },
                            ),
                            SizedBox(height: 8.h),
                            FormBuilderTextField(
                              name: 'mobileNo',
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: HINT_BOARDER_STYLE,
                                ),
                                labelText: 'Mobile number',
                                labelStyle: HINT_TEXT_LABEL,
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
                            FormBuilderTextField(
                              name: 'LicenseNo',
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: HINT_BOARDER_STYLE,
                                ),
                                labelText: 'License No',
                                labelStyle: HINT_TEXT_LABEL,
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value != null && value != '') {
                                  if (value.length > 20) {
                                    return 'License number should be less than 20 character';
                                  }
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
                                      Icons.train_rounded,
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
                              autoValidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null) {
                                  return 'Please choose railway station';
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
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter platform number';
                                } else if (!RegExp(r'^[1-8]+$')
                                    .hasMatch(value)) {
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
                            SizedBox(height: 25.sp),
                            Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    'Add your employees to shop ',
                                    style: TextStyle(),
                                  ),
                                ),
                                Container(
                                  width: 40.sp,
                                  height: 30.sp,
                                  decoration: BoxDecoration(
                                    color: Colors.teal,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: const [
                                      BoxShadow(
                                        blurRadius: 4,
                                        spreadRadius: -5,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: RawMaterialButton(
                                    onPressed: () =>
                                        controller.showEmployeeView(
                                      context,
                                      () => controller.addEmployee(),
                                    ),
                                    child: const Icon(Icons.person_add),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.sp),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 8.sp),
              GetBuilder<PageShopLaboursController>(
                builder: (controller) {
                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: controller.listOfEmployees.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 4.sp),
                    itemBuilder: (context, index) {
                      return SizedBox(
                        height: 35.sp,
                        width: Get.width,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 35.sp,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: const [
                                    BoxShadow(
                                      blurRadius: 4,
                                      spreadRadius: -5,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(width: 4.sp),
                                    Icon(
                                      Icons.person,
                                      color: const Color.fromARGB(
                                        255,
                                        0,
                                        79,
                                        144,
                                      ),
                                      size: 25.sp,
                                    ),
                                    SizedBox(width: 8.sp),
                                    Expanded(
                                      child: Text(
                                        controller.listOfEmployees[index]
                                                ['empName']
                                            .toString(),
                                        style: TextStyle(
                                          color: const Color.fromARGB(
                                            255,
                                            0,
                                            79,
                                            144,
                                          ),
                                          fontSize: 18.sp,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 4.sp),
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      iconSize: 22.sp,
                                      icon: Icon(
                                        Icons.remove_red_eye_rounded,
                                        size: 22.sp,
                                      ),
                                      color: const Color.fromARGB(
                                        255,
                                        0,
                                        79,
                                        144,
                                      ),
                                      onPressed: () => controller.viewEmployes(
                                        index,
                                        context,
                                      ),
                                      splashRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              iconSize: 22.sp,
                              icon: Icon(
                                Icons.delete,
                                size: 22.sp,
                              ),
                              color: Colors.red,
                              onPressed: () => controller.deleteEmploye(index),
                              splashRadius: 18.sp,
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 30.sp),
              Align(
                child: SizedBox(
                  width: 150.w,
                  height: 40.sp,
                  child: GetBuilder<PageShopLaboursController>(
                    builder: (controller) {
                      if (!controller.isUploading) {
                        return ElevatedButton(
                          onPressed: () {
                            if (controller.shopFormKey.currentState!
                                .validate()) {
                              controller.saveShopsLabour();
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
              SizedBox(height: 30.sp),
            ],
          ),
        ),
      ),
    );
  }
}
