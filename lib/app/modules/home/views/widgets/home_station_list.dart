import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../data/police_station.dart';
import '../../../../util/theme_data.dart';
import '../../controllers/home_controller.dart';

class HomeStationList extends StatefulWidget {
  const HomeStationList({super.key});

  @override
  State<HomeStationList> createState() => _HomeStationListState();
}

class _HomeStationListState extends State<HomeStationList> {
  final controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: controller.policeStationFormKey,
      child: Padding(
        padding: SCREEN_PADDING,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Police stations',
              style: TEXT_HEADER_STYLE,
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: CIRCULAR_BORDER,
                    ),
                    child: DropdownSearch<PoliceStation>(
                      items: controller.policeStations,
                      popupProps: PopupProps.dialog(
                        showSearchBox: true,
                        itemBuilder: (context, item, isSelected) {
                          return Container(
                            padding: EdgeInsets.all(16.sp),
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
                ),
                SizedBox(width: 5.w),
                Expanded(
                  child: SizedBox(
                    width: 45.sp,
                    height: 50.sp,
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Icon(Icons.refresh),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5.h,),
            GetBuilder<HomeController>(
              builder: (controller) {
                if (controller.selectedPoliceStation ==
                        controller.nearestStaion &&
                    controller.selectedPoliceStation != null) {
                  return Text(
                    'is your nearest police station',
                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
                  );
                }

                return const SizedBox();
              },
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}
