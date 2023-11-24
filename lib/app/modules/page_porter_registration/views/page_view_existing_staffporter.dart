// ignore_for_file: avoid_bool_literals_in_conditional_expressions

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/railway_station_details.dart';
import '../../../data/staff_porter_category.dart';
import '../../../util/global_widgets.dart';
import '../../../util/theme_data.dart';
import '../controllers/page_porter_registration_controller.dart';

class PageViewExistingStaffPorter extends StatelessWidget {
  const PageViewExistingStaffPorter({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PagePorterRegistrationController>();
    // final tablePadding = EdgeInsets.only(bottom: 4.sp, top: 4.sp);

    const decoration = BoxDecoration(
      backgroundBlendMode: BlendMode.multiply,
      color: Colors.white,
      borderRadius: HOME_BOX_BORDER,
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          spreadRadius: 1,
          blurRadius: 5,
          offset: Offset(0, 1),
        ),
      ],
    );

    void _showFilterSheet() {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return FormBuilder(
            key: controller.porterFormKey,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.only(top: 16.sp),
              child: Padding(
                padding: SCREEN_PADDING,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(4.sp),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.filter_alt_rounded,
                            color: Colors.blue,
                            size: 15.sp,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        const Expanded(
                          child: Text('Select filtering options'),
                        ),
                        Container(
                          width: 20.sp,
                          height: 20.sp,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: IconButton(
                            iconSize: 14.sp,
                            splashRadius: 25,
                            color: Colors.white,
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.close),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    const Divider(
                      thickness: 2,
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: DropdownSearch<StaffPorterCategory>(
                            items: controller.staffPorterTypes,
                            popupProps: PopupProps.menu(
                              //showSearchBox: true,
                              itemBuilder: (context, item, isSelected) {
                                return Container(
                                  padding: EdgeInsets.all(10.sp),
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
                                labelText: 'Category',
                                contentPadding: EdgeInsets.all(15.sp),
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 8.sp,
                                ),
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              controller.selectedStaffPorterType = value;
                            },
                          ),
                        ),
                        SizedBox(
                          width: 8.h,
                        ),
                        Expanded(
                          flex: 2,
                          child: DropdownSearch<RailwayStationDetails>(
                            items: controller.railwayStaionList,
                            popupProps: PopupProps.menu(
                              showSearchBox: true,
                              itemBuilder: (context, item, isSelected) {
                                return Container(
                                  padding: EdgeInsets.all(10.sp),
                                  child: Text(
                                    '${item.name}',
                                    style: TextStyle(fontSize: 10.sp),
                                  ),
                                );
                              },
                            ),
                            itemAsString: (item) => '${item.name}',
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              baseStyle: TextStyle(fontSize: 10.sp),
                              dropdownSearchDecoration: InputDecoration(
                                labelText: 'Station',
                                contentPadding: EdgeInsets.all(15.sp),
                                //hintText: 'Station',
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 8.sp,
                                ),
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              controller.selectedRailwayStation = value;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            controller.loadStaffPorterList();
                          },
                          child: const Text(
                            'Apply',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            controller.resetFilter();
                          },
                          child: const Text(
                            'Reset',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    return WillPopScope(
      onWillPop: () async {
        controller.selectedRailwayStation = null;
        controller.selectedStaffPorterType = null;
        controller.loadStaffPorterList();

        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: primaryColor,
          shape: appBarShape,
          title: Text(
            'Staff & Porter',
            style: appBarTextStyle,
          ),
          actions: [
            Row(
              children: [
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    IconButton(
                      iconSize: 20.sp,
                      padding: EdgeInsets.zero,
                      splashRadius: 15.sp,
                      icon: const Icon(
                        Icons.filter_alt_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        _showFilterSheet();
                      },
                    ),
                  ],
                ),
                SizedBox(width: 5.w),
              ],
            ),
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    decoration: decoration,
                    child: GetBuilder<PagePorterRegistrationController>(
                      builder: (controller) {
                        if (controller.staffporterListIsLoading) {
                          return Padding(
                            padding: EdgeInsets.all(16.sp),
                            child: processingIndicator(),
                          );
                        }

                        if (controller.staffporterList.isEmpty) {
                          return Text(
                            'NO SHOP FOUND',
                            style: TEXT_WATER_MARK,
                          );
                        }

                        return Column(
                          children: [
                            SizedBox(
                              height: 2.h,
                            ),
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: controller.staffporterList.length,
                              itemBuilder: (context, int index) {
                                final String? staffPorterCategory = controller
                                    .staffporterList[index]
                                    .staffPorterCategoryLabel;
                                final String? staffName =
                                    controller.staffporterList[index].name;
                                final String? staffContactNo = controller
                                    .staffporterList[index].mobileNumber;
                                final String? railwayStation = controller
                                    .staffporterList[index].railwayStationLabel;
                                final String? nativeState = controller
                                    .staffporterList[index].nativeStateLabel;
                                final String? staffGender =
                                    controller.staffporterList[index].gender;
                                final String? railwayPoliceStation = controller
                                    .staffporterList[index]
                                    .railwayPoliceStationLabel;
                                // final image =
                                //     controller.staffporterList[index].photo;
                                // final bool imageLoadingError =
                                //     image != null ? false : true;

                                // Widget assetImage() {
                                //   return Image.asset(
                                //     AssetUrls.PROFILEPIC,
                                //     fit: BoxFit.fill,
                                //     height: 100,
                                //   );
                                // }

                                // Widget urlImage(String image) {
                                //   return Image.network(
                                //     image,
                                //     fit: BoxFit.fill,
                                //     height: 100,
                                //   );
                                // }

                                return MaterialButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () async {
                                    final call =
                                        Uri.parse('tel:$staffContactNo');
                                    if (await canLaunchUrl(call)) {
                                      launchUrl(call);
                                    } else {
                                      throw 'Could not launch $call';
                                    }
                                  },
                                  child: Card(
                                    surfaceTintColor: Colors.white,
                                    margin: const EdgeInsets.all(3.0),
                                    borderOnForeground: false,
                                    elevation: 4.0.sp,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        15.sp,
                                      ),
                                    ),
                                    shadowColor: Colors.black,
                                    color: Colors.white,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        top: 10.sp,
                                        left: 8.sp,
                                        right: 8.sp,
                                        bottom: 8.sp,
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                staffName!,
                                                style: TextStyle(
                                                  color: BACKGROUND_COLOR,
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          // SizedBox(
                                          //   height: 15.h,
                                          // ),
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.phone_android,
                                                      color: Colors.blue,
                                                    ),
                                                    SizedBox(
                                                      width: 8.w,
                                                    ),
                                                    Text(
                                                      staffContactNo!,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12.sp,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    const Icon(
                                                      Icons.category,
                                                      color: Colors.blue,
                                                    ),
                                                    SizedBox(
                                                      width: 8.w,
                                                    ),
                                                    Text(
                                                      staffGender!,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12.sp,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5.w,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                staffPorterCategory!,
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Divider(
                                            thickness: 1.5.sp,
                                            color: primaryColor,
                                          ),
                                          // SizedBox(
                                          //   height: 5.sp,
                                          // ),
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                          Icons
                                                              .directions_railway,
                                                          color: Colors.blue,
                                                        ),
                                                        SizedBox(
                                                          width: 8.w,
                                                        ),
                                                        Text(
                                                          '$railwayStation',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 12.sp,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 8.sp,
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.local_police,
                                                          color: Colors.blue,
                                                        ),
                                                        SizedBox(
                                                          width: 8.w,
                                                        ),
                                                        Text(
                                                          railwayPoliceStation!,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 12.sp,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 8.sp,
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.landscape,
                                                          color: Colors.blue,
                                                        ),
                                                        SizedBox(
                                                          width: 8.w,
                                                        ),
                                                        Text(
                                                          'State : $nativeState',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 12.sp,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                      width: 100.w,
                                                      height: 30.h,
                                                      decoration: BoxDecoration(
                                                        color: primaryColor,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(
                                                            15.sp,
                                                          ),
                                                        ),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Icon(
                                                            Icons.call,
                                                            color: Colors.white,
                                                            size: 25,
                                                          ),
                                                          SizedBox(
                                                            width: 10.w,
                                                          ),
                                                          Text(
                                                            'Call',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 20.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 10.w,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width:10.w,),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 8.sp),
                            GetBuilder<PagePorterRegistrationController>(
                              builder: (_) {
                                if (_.noMoreStaffporter) {
                                  return const SizedBox();
                                }

                                return _.isMoreStaffPorterLoading
                                    ? Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 10.sp,
                                        ),
                                        child: SizedBox(
                                          height: 25.sp,
                                          width: 25.sp,
                                          child:
                                              const CircularProgressIndicator(),
                                        ),
                                      )
                                    : SizedBox(
                                        height: 35.sp,
                                        width: 200.sp,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            _.loadMoreStaffPorter();
                                          },
                                          child: Text(
                                            'Load more',
                                            style: TextStyle(fontSize: 12.sp,color: Colors.white),
                                          ),
                                        ),
                                      );
                              },
                            ),
                            SizedBox(height: 8.sp),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // FormBuilder(
            //   key: controller.porterFormKey,
            //   child: Container(
            //     decoration: const BoxDecoration(
            //       color: FORGROUND_COLOR,
            //       borderRadius:
            //           BorderRadius.vertical(bottom: Radius.circular(5)),
            //       boxShadow: [
            //         BoxShadow(
            //           blurRadius: 8,
            //           spreadRadius: -5,
            //           offset: Offset(0, 5),
            //         ),
            //       ],
            //     ),
            //     child: Padding(
            //       padding: SCREEN_PADDING,
            //       child: Row(
            //         children: [
            //           Expanded(
            //             flex: 3,
            //             child: DropdownSearch<StaffPorterCategory>(
            //               items: controller.staffPorterTypes,
            //               popupProps: PopupProps.menu(
            //                 showSearchBox: true,
            //                 itemBuilder: (context, item, isSelected) {
            //                   return Container(
            //                     padding: EdgeInsets.all(13.sp),
            //                     child: Text(
            //                       item.name,
            //                       style: TextStyle(fontSize: 10.sp),
            //                     ),
            //                   );
            //                 },
            //               ),
            //               itemAsString: (item) => item.name,
            //               dropdownDecoratorProps: DropDownDecoratorProps(
            //                 //baseStyle: TextStyle(fontSize: 10.sp),
            //                 dropdownSearchDecoration: InputDecoration(
            //                   contentPadding: EdgeInsets.all(3.sp),
            //                   hintText: 'Category',
            //                   // border: const OutlineInputBorder(
            //                   //   borderRadius: CIRCULAR_BORDER,
            //                   // ),
            //                 ),
            //               ),
            //               onChanged: (value) {
            //                 controller.selectedStaffPorterType = value;
            //               },
            //             ),
            //           ),
            //           const SizedBox(
            //             width: 5,
            //           ),
            //           Expanded(
            //             flex: 3,
            //             child: DropdownSearch<RailwayStationDetails>(
            //               items: controller.railwayStaionList,
            //               popupProps: PopupProps.menu(
            //                 showSearchBox: true,
            //                 itemBuilder: (context, item, isSelected) {
            //                   return Container(
            //                     padding: EdgeInsets.all(13.sp),
            //                     child: Text(
            //                       '${item.name}',
            //                       style: TextStyle(fontSize: 10.sp),
            //                     ),
            //                   );
            //                 },
            //               ),
            //               itemAsString: (item) => '${item.name}',
            //               dropdownDecoratorProps: DropDownDecoratorProps(
            //                 // baseStyle: TextStyle(fontSize: 10.sp),
            //                 dropdownSearchDecoration: InputDecoration(
            //                   contentPadding: EdgeInsets.all(3.sp),
            //                   hintText: 'Railway Station',
            //                   // border: const OutlineInputBorder(
            //                   //   borderRadius: CIRCULAR_BORDER,
            //                   // ),
            //                 ),
            //               ),
            //               onChanged: (value) {
            //                 controller.selectedRailwayStation = value;
            //               },
            //             ),
            //           ),
            //           const SizedBox(
            //             width: 5,
            //           ),
            //           Expanded(
            //             child: MaterialButton(
            //               padding: EdgeInsets.zero,
            //               color: Colors.grey.shade300,
            //               minWidth: 0,
            //               height: 42.sp,
            //               child: const Icon(Icons.search),
            //               onPressed: () {
            //                 controller.loadStaffPorterList();
            //               },
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
