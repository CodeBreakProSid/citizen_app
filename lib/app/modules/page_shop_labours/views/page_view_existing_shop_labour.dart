import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/railway_station_details.dart';
import '../../../data/shop_category.dart';
import '../../../util/global_widgets.dart';
import '../../../util/theme_data.dart';
import '../controllers/page_shop_labours_controller.dart';

class PageViewExistingShopLabour extends StatelessWidget {
  const PageViewExistingShopLabour({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PageShopLaboursController>();

    const decoration = BoxDecoration(
      color: Colors.white,
      borderRadius: HOME_BOX_BORDER,
      backgroundBlendMode: BlendMode.multiply,
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
            key: controller.shopFormKey,
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
                          child: DropdownSearch<ShopCategory>(
                            items: controller.shopCategoryTypes,
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
                              controller.selectedShopCategoryType = value;
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
                            controller.loadShopList();
                          },
                          child: const Text('Apply',style: TextStyle(color: Colors.white,),),
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            controller.resetFilter();
                          },
                          child: const Text('Reset',style: TextStyle(color: Colors.white,),),
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

    Future<void> openGoogleMaps(double? latitude, double? longitude) async {
      final Uri googleMapsUrl = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
      );
      if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(googleMapsUrl);
      } else {
        throw 'Could not open Google Maps';
      }
    }

    return WillPopScope(
      onWillPop: () async {
        controller.selectedRailwayStation = null;
        controller.selectedShopCategoryType = null;
        controller.loadShopList();

        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: primaryColor,
          shape: appBarShape,
          title: Text(
            'Shops',
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
                    child: GetBuilder<PageShopLaboursController>(
                      builder: (controller) {
                        if (controller.shopListIsLoading) {
                          return Padding(
                            padding: EdgeInsets.all(16.sp),
                            child: processingIndicator(),
                          );
                        }

                        if (controller.shopList.isEmpty) {
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
                              itemCount: controller.shopList.length,
                              itemBuilder: (context, int index) {
                                final int? shopId =
                                    controller.shopList[index].id;
                                final String shopCategory = controller
                                    .shopList[index].shopCategoryLabel;
                                final String shopName =
                                    controller.shopList[index].name;
                                final String ownerContactNo =
                                    controller.shopList[index].contactNumber;
                                final String railwayStation = controller
                                    .shopList[index].railwayStationLabel;
                                final String? ownerName =
                                    controller.shopList[index].ownerName;
                                final int platformNo =
                                    controller.shopList[index].platformNumber;
                                final double? latValue =
                                    controller.shopList[index].latitude;
                                final double? lonValue =
                                    controller.shopList[index].longitude;

                                return Card(
                                  margin: const EdgeInsets.all(3.0),
                                  borderOnForeground: false,
                                  elevation: 4.0.sp,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      15.sp,
                                    ),
                                  ),
                                  shadowColor: Colors.black,
                                  surfaceTintColor: Colors.white,
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
                                              shopName,
                                              style: TextStyle(
                                                color: primaryColor,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        // SizedBox(
                                        //   height: 2.h,
                                        // ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              shopCategory,
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        // SizedBox(
                                        //   height: 10.sp,
                                        // ),
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.person,
                                                        color: Colors.blue,
                                                      ),
                                                      SizedBox(
                                                        width: 8.w,
                                                      ),
                                                      Text(
                                                        '$ownerName',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12.sp,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 5.sp,
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.phone_android,
                                                        color: Colors.blue,
                                                      ),
                                                      SizedBox(
                                                        width: 8.w,
                                                      ),
                                                      Text(
                                                        ownerContactNo,
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
                                              child: Column(
                                                children: [
                                                  Row(
                                                    // mainAxisAlignment:
                                                    //     MainAxisAlignment
                                                    //         .center,
                                                    children: [
                                                      const Icon(
                                                        Icons.card_membership,
                                                        color: Colors.blue,
                                                      ),
                                                      SizedBox(
                                                        width: 8.w,
                                                      ),
                                                      Text(
                                                        'ID : $shopId',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12.sp,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 5.sp,
                                                  ),
                                                  Row(
                                                    // mainAxisAlignment:
                                                    //     MainAxisAlignment
                                                    //         .center,
                                                    children: [
                                                      const Icon(
                                                        Icons.near_me_outlined,
                                                        color: Colors.blue,
                                                      ),
                                                      SizedBox(
                                                        width: 8.w,
                                                      ),
                                                      Text(
                                                        'Platform  $platformNo',
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
                                          ],
                                        ),
                                        // SizedBox(
                                        //   height: 5.h,
                                        // ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.directions_railway,
                                              color: Colors.blue,
                                            ),
                                            SizedBox(
                                              width: 8.w,
                                            ),
                                            Text(
                                              railwayStation,
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        // SizedBox(
                                        //   height: 5.sp,
                                        // ),
                                        Divider(
                                          thickness: 1.5.sp,
                                          color: primaryColor,
                                        ),
                                        // SizedBox(
                                        //   height: 5.h,
                                        // ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: MaterialButton(
                                                child: Container(
                                                  height: 30.h,
                                                  decoration: BoxDecoration(
                                                    color: primaryColor,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(
                                                        10.sp,
                                                      ),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Icon(
                                                        Icons.location_on,
                                                        color: Colors.white,
                                                        size: 15.sp,
                                                      ),
                                                      SizedBox(width: 8.w,),
                                                      Text(
                                                        'Location',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15.sp,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  openGoogleMaps(
                                                    latValue,
                                                    lonValue,
                                                  );
                                                },
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: MaterialButton(
                                                child: Container(
                                                  height: 30.h,
                                                  decoration: BoxDecoration(
                                                    color: primaryColor,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(
                                                        10.sp,
                                                      ),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Icon(
                                                        Icons.call,
                                                        color: Colors.white,
                                                        size: 15.sp,
                                                      ),
                                                      SizedBox(width: 8.w,),
                                                      Text(
                                                        'Call',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15.sp,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  final call = Uri.parse(
                                                    'tel:$ownerContactNo',
                                                  );
                                                  if (await canLaunchUrl(
                                                    call,
                                                  )) {
                                                    launchUrl(call);
                                                  } else {
                                                    throw 'Could not launch $call';
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            //SizedBox(height: 8.sp),
                            GetBuilder<PageShopLaboursController>(
                              builder: (_) {
                                if (_.noMoreShops) {
                                  return const SizedBox();
                                }

                                return _.isMoreShopsLoading
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
                                            _.loadMoreShopList();
                                          },
                                          child: Text(
                                            'Load more',
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              color: Colors.white,
                                            ),
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
          ],
        ),
      ),
    );
  }
}
