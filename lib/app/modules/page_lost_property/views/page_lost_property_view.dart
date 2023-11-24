// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';

// import '../../../data/lost_property_category.dart';
// import '../../../data/railway_policestation_list.dart';
// import '../../../util/theme_data.dart';
// import '../controllers/page_lost_property_controller.dart';
// import 'page_lost_property_main_view.dart';

// class PageLostPropertyView extends GetView<PageLostPropertyController> {
//   const PageLostPropertyView({super.key});
//   @override
//   Widget build(BuildContext context) {

//     void _showFilterSheet() {
//       showModalBottomSheet(
//         context: context,
//         builder: (context) {
//           return FormBuilder(
//             key: controller.lostPropertyKey,
//             child: Container(
//               color: Colors.white,
//               padding: EdgeInsets.only(top: 16.sp),
//               child: Padding(
//                 padding: SCREEN_PADDING,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Row(
//                       children: [
//                         Container(
//                           padding: EdgeInsets.all(4.sp),
//                           decoration: BoxDecoration(
//                             color: Colors.blue.withOpacity(0.2),
//                             shape: BoxShape.circle,
//                           ),
//                           child: Icon(
//                             Icons.filter_alt_rounded,
//                             color: Colors.blue,
//                             size: 15.sp,
//                           ),
//                         ),
//                         SizedBox(width: 4.w),
//                         const Expanded(
//                           child: Text('Select filtering options'),
//                         ),
//                         Container(
//                           width: 20.sp,
//                           height: 20.sp,
//                           decoration: const BoxDecoration(
//                             color: Colors.red,
//                             borderRadius: BorderRadius.all(Radius.circular(5)),
//                           ),
//                           child: IconButton(
//                             iconSize: 14.sp,
//                             color: Colors.white,
//                             padding: EdgeInsets.zero,
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                             icon: const Icon(Icons.close),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 5.h,
//                     ),
//                     const Divider(
//                       thickness: 2,
//                     ),
//                     SizedBox(
//                       height: 8.h,
//                     ),
//                     Row(
//                       children: [
//                         Expanded(
//                           flex: 2,
//                           child: DropdownSearch<LostPropertyCategory>(
//                             items: controller.lostPropertyCategoryTypes,
//                             popupProps: PopupProps.menu(
//                               //showSearchBox: true,
//                               itemBuilder: (context, item, isSelected) {
//                                 return Container(
//                                   padding: EdgeInsets.all(10.sp),
//                                   child: Text(
//                                     item.name,
//                                     style: TextStyle(fontSize: 10.sp),
//                                   ),
//                                 );
//                               },
//                             ),
//                             itemAsString: (item) => item.name,
//                             dropdownDecoratorProps: DropDownDecoratorProps(
//                               baseStyle: TextStyle(fontSize: 10.sp),
//                               dropdownSearchDecoration: InputDecoration(
//                                 labelText: 'Category',
//                                 contentPadding: EdgeInsets.all(15.sp),
//                                 labelStyle: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 8.sp,
//                                 ),
//                                 border: const OutlineInputBorder(
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(30)),
//                                 ),
//                               ),
//                             ),
//                             onChanged: (value) {
//                               controller.selectedLostPropertyCategory = value;
//                             },
//                           ),
//                         ),
//                         SizedBox(
//                           width: 8.h,
//                         ),
//                         Expanded(
//                           flex: 2,
//                           child: DropdownSearch<RailwayPoliceStationList>(
//                             items: controller.railwayPoliceStationList,
//                             popupProps: PopupProps.menu(
//                               //showSearchBox: true,
//                               itemBuilder: (context, item, isSelected) {
//                                 return Container(
//                                   padding: EdgeInsets.all(10.sp),
//                                   child: Text(
//                                     item.name,
//                                     style: TextStyle(fontSize: 10.sp),
//                                   ),
//                                 );
//                               },
//                             ),
//                             itemAsString: (item) => item.name,
//                             dropdownDecoratorProps: DropDownDecoratorProps(
//                               baseStyle: TextStyle(fontSize: 10.sp),
//                               dropdownSearchDecoration: InputDecoration(
//                                 labelText: 'Station',
//                                 contentPadding: EdgeInsets.all(15.sp),
//                                 //hintText: 'Station',
//                                 labelStyle: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 8.sp,
//                                 ),
//                                 border: const OutlineInputBorder(
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(30)),
//                                 ),
//                               ),
//                             ),
//                             onChanged: (value) {
//                               controller.selectedRailwayPoliceStation = value;
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 8.h,
//                     ),
//                     Row(
//                       children: [
//                         Expanded(
//                           flex: 2,
//                           child: FormBuilderDateTimePicker(
//                             name: 'fromDate',
//                             onChanged: (date) {
//                               print('Nill');
//                             },
//                             //initialDate: DateTime.now(),
//                             //firstDate: DateTime.now(),
//                             lastDate: DateTime.now(),
//                             textInputAction: TextInputAction.next,
//                             inputType: InputType.date,
//                             format: DateFormat('dd/MM/yyyy'),
//                             decoration: InputDecoration(
//                               prefixIcon: const Icon(
//                                 Icons.calendar_today,
//                                 color: Color(0xff129B7F),
//                               ),
//                               labelText: 'From',
//                               contentPadding: EdgeInsets.all(5.sp),
//                               labelStyle: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 8.sp,
//                               ),
//                               //hintText: 'From',
//                               border: const OutlineInputBorder(
//                                 borderRadius: BorderRadius.all(
//                                   Radius.circular(30.0),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           width: 8.h,
//                         ),
//                         Expanded(
//                           flex: 2,
//                           child: FormBuilderDateTimePicker(
//                             name: 'toDate',
//                             onChanged: (date) {
//                               print('Nill');
//                             },
//                             //initialDate: DateTime.now(),
//                             //firstDate: DateTime.now(),
//                             lastDate: DateTime.now(),
//                             textInputAction: TextInputAction.next,
//                             inputType: InputType.date,
//                             format: DateFormat('dd/MM/yyyy'),
//                             decoration: InputDecoration(
//                               prefixIcon: const Icon(
//                                 Icons.calendar_today,
//                                 color: Color(0xff129B7F),
//                               ),
//                               labelText: 'To',
//                               contentPadding: EdgeInsets.all(5.sp),
//                               labelStyle: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 8.sp,
//                               ),
//                               //hintText: 'From',
//                               border: const OutlineInputBorder(
//                                 borderRadius: BorderRadius.all(
//                                   Radius.circular(30.0),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 8.h,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         ElevatedButton(
//                           onPressed: () {
//                             controller.loadLostProperties();
//                             // Navigator.pop(context);
//                           },
//                           child: const Text('Apply'),
//                         ),
//                         SizedBox(
//                           width: 20.w,
//                         ),
//                         ElevatedButton(
//                           onPressed: () {
//                             controller.resetFilter();
//                             // Navigator.pop(context);
//                           },
//                           child: const Text('Reset'),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Lost properties',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 12.sp,
//           ),
//         ),
//         backgroundColor: primaryColor,
//         centerTitle: true,
//         shape: appBarShape,
//         actions: [
//           Row(
//             children: [
//               Stack(
//                 alignment: Alignment.topRight,
//                 children: [
//                   // const Text('Filter'),
//                   IconButton(
//                     iconSize: 20.sp,
//                     padding: EdgeInsets.zero,
//                     splashRadius: 15.sp,
//                     icon: const Icon(
//                       Icons.filter_alt_rounded,
//                       color: Colors.black,
//                     ),
//                     onPressed: () {
//                       _showFilterSheet();
//                     },
//                   ),
//                 ],
//               ),
//               SizedBox(width: 5.w),
//             ],
//           ),
//         ],
//       ),
//       body: FutureBuilder<bool>(
//         future: controller.isDataLoaded,
//         initialData: false,
//         builder: (context, snapshot) {
//           switch (snapshot.connectionState) {
//             case ConnectionState.none:
//             case ConnectionState.waiting:
//             case ConnectionState.active:
//               return const Center(child: CircularProgressIndicator());
//             case ConnectionState.done:
//               {
//                 return snapshot.hasData && snapshot.data!
//                     ? const SingleChildScrollView(
//                         physics: BouncingScrollPhysics(),
//                         child: PageLostPropertyMainView(),
//                       )
//                     : const Center(child: CircularProgressIndicator());
//               }

//             default:
//               return const Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//     );
//   }
// }

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../data/lost_property_category.dart';
import '../../../data/railway_policestation_list.dart';
import '../../../util/theme_data.dart';
import '../controllers/page_lost_property_controller.dart';
import 'page_lost_property_main_view.dart';

class PageLostPropertyView extends StatefulWidget {
  const PageLostPropertyView({super.key});

  @override
  State<PageLostPropertyView> createState() => _PageLostProperyViewState();
}

class _PageLostProperyViewState extends State<PageLostPropertyView> {
  @override
  Widget build(BuildContext context) {
    // final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final GlobalKey<FormBuilderState> fbKey = GlobalKey<FormBuilderState>();
    final controller = Get.find<PageLostPropertyController>();

    void _showFilterSheet(BuildContext context) {
      showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return FormBuilder(
                key: fbKey,
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(top: 16.sp),
                  child: Padding(
                    padding: SCREEN_PADDING,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                              ),
                              child: IconButton(
                                iconSize: 14.sp,
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
                              child: DropdownSearch<LostPropertyCategory>(
                                key: controller.dropdownCategoryKey,
                                items: controller.lostPropertyCategoryTypes,
                                popupProps: PopupProps.menu(
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
                                  setModalState(
                                    () {
                                      controller.selectedLostPropertyCategory =
                                          '${value?.id}';
                                    },
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              width: 8.h,
                            ),
                            Expanded(
                              flex: 2,
                              child: DropdownSearch<RailwayPoliceStationList>(
                                key: controller.dropdownStationKey,
                                items: controller.railwayPoliceStationList,
                                popupProps: PopupProps.menu(
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
                                    labelText: 'Station',
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
                                  setModalState(
                                    () {
                                      controller.selectedRailwayPoliceStation =
                                          '${value?.id}';
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: FormBuilderDateTimePicker(
                                key: const Key(
                                  'fomDatePickerKey',
                                ),
                                name: 'fromDate',
                                onChanged: (DateTime? value) {
                                  setModalState(() {
                                    controller.selectedFromDate = value;
                                  });
                                },
                                lastDate: DateTime.now(),
                                textInputAction: TextInputAction.next,
                                inputType: InputType.date,
                                format: DateFormat('dd/MM/yyyy'),
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.calendar_today,
                                    color: Color(0xff129B7F),
                                  ),
                                  labelText: 'From',
                                  contentPadding: EdgeInsets.all(5.sp),
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 8.sp,
                                  ),
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8.h,
                            ),
                            Expanded(
                              flex: 2,
                              child: FormBuilderDateTimePicker(
                                key: const Key(
                                  'toDatePickerKey',
                                ),
                                name: 'toDate',
                                onChanged: (DateTime? value) {
                                  setModalState(() {
                                    controller.selectedToDate = value;
                                  });
                                },
                                lastDate: DateTime.now(),
                                textInputAction: TextInputAction.next,
                                inputType: InputType.date,
                                format: DateFormat('dd/MM/yyyy'),
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.calendar_today,
                                    color: Color(0xff129B7F),
                                  ),
                                  labelText: 'To',
                                  contentPadding: EdgeInsets.all(5.sp),
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 8.sp,
                                  ),
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30.0),
                                    ),
                                  ),
                                ),
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
                                controller.loadLostProperties();
                                setModalState(
                                  () {
                                    // fbKey.currentState?.reset();
                                    // controller.dropdownCategoryKey.currentState
                                    //     ?.clear();
                                    // controller.dropdownCategoryKey.currentState
                                    //     ?.changeSelectedItem(null);
                                  },
                                );
                                Navigator.pop(context);
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
                                // _fbKey.currentState?.reset();
                                Navigator.pop(context);
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
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lost properties',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.sp,
          ),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
        shape: appBarShape,
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
                      color: Colors.black,
                    ),
                    onPressed: () {
                      _showFilterSheet(context);
                    },
                  ),
                ],
              ),
              SizedBox(width: 5.w),
            ],
          ),
        ],
      ),
      body: FutureBuilder<bool>(
        future: controller.isDataLoaded,
        initialData: false,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              {
                return snapshot.hasData && snapshot.data!
                    ? const SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: PageLostPropertyMainView(),
                      )
                    : const Center(child: CircularProgressIndicator());
              }

            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      // bottomSheet: const Text('Hai'),
    );
  }
}
