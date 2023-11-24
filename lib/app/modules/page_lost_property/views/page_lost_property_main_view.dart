import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../util/asset_urls.dart';
import '../../../util/global_widgets.dart';
import '../../../util/theme_data.dart';
import '../controllers/page_lost_property_controller.dart';

class PageLostPropertyMainView extends GetView<PageLostPropertyController> {
  const PageLostPropertyMainView({super.key});
  @override
  Widget build(BuildContext context) {
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

    return Stack(
      children: [
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                decoration: decoration,
                child: GetBuilder<PageLostPropertyController>(
                  builder: (controller) {
                    if (controller.isLostPropertiesLoading) {
                      return Padding(
                        padding: EdgeInsets.all(16.sp),
                        child: processingIndicator(),
                      );
                    }

                    if (controller.listOfLostProperties.isEmpty) {
                      return Text(
                        'NO PROPERTIES FOUND',
                        style: TEXT_WATER_MARK,
                      );
                    }

                    return Column(
                      children: [
                        SizedBox(
                          height: 2.h,
                        ),
                        ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: controller.listOfLostProperties.length,
                          itemBuilder: (context, int index) {
                            final int propertyID =
                                controller.listOfLostProperties[index].id;
                            final propertyCategoryLabel = controller
                                .listOfLostProperties[index]
                                .lostPropertyCategoryLabel;
                            final foundIn =
                                controller.listOfLostProperties[index].foundIn;
                            final propertyFoundOn =
                                controller.listOfLostProperties[index].foundOn;
                            final keptIn = controller
                                .listOfLostProperties[index].policeStationLabel;
                            final policeStationNumber = controller
                                .listOfLostProperties[index]
                                .policeStationNumber;
                            final String? image = controller
                                .listOfLostProperties[index].thumbnails;

                            Future<String?> getImgUrl(String image) async {
                              final String imgUrl = image;

                              try {
                                // final Uint8List bytes =
                                //     (await NetworkAssetBundle(Uri.parse(imgUrl))
                                //             .load(imgUrl))
                                //         .buffer
                                //         .asUint8List();

                                (await NetworkAssetBundle(Uri.parse(imgUrl))
                                        .load(imgUrl))
                                    .buffer
                                    .asUint8List();

                                return imgUrl;
                              } catch (e) {
                                return null;
                              }
                            }

                            return MaterialButton(
                              padding: EdgeInsets.zero,
                              onPressed: () async {
                                final call =
                                    Uri.parse('tel:$policeStationNumber');
                                if (await canLaunchUrl(call)) {
                                  launchUrl(call);
                                } else {
                                  throw 'Could not launch $call';
                                }
                              },
                              child: Card(
                                surfaceTintColor:Colors.white,
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
                                            propertyCategoryLabel,
                                            style: TextStyle(
                                              color: BACKGROUND_COLOR,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // SizedBox(
                                      //   height: 15.sp,
                                      // ),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 75.w,
                                                  height: 75.h,
                                                  decoration: BoxDecoration(
                                                    //color: Colors.red,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(
                                                        25.sp,
                                                      ),
                                                    ),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      FutureBuilder(
                                                        future:
                                                            getImgUrl('$image'),
                                                        builder: (
                                                          BuildContext context,
                                                          AsyncSnapshot<String?>
                                                              snapshot,
                                                        ) {
                                                          final bool error =
                                                              snapshot.data ==
                                                                  null;

                                                          return error
                                                              ? Center(
                                                                  child:
                                                                      ClipOval(
                                                                    child: Image
                                                                        .asset(
                                                                      AssetUrls
                                                                          .LOST_PROPERTY,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      height:
                                                                          70.h,
                                                                      width:
                                                                          70.w,
                                                                    ),
                                                                  ),
                                                                )
                                                              : Center(
                                                                  child:
                                                                      ClipOval(
                                                                    child: Image
                                                                        .network(
                                                                      snapshot
                                                                          .data!,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      height:
                                                                          70.h,
                                                                      width:
                                                                          70.w,
                                                                    ),
                                                                  ),
                                                                );
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.workspaces,
                                                      color: Colors.blue,
                                                    ),
                                                    SizedBox(
                                                      width: 8.w,
                                                    ),
                                                    Text(
                                                      foundIn,
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
                                                      Icons.place,
                                                      color: Colors.blue,
                                                    ),
                                                    SizedBox(
                                                      width: 8.w,
                                                    ),
                                                    Text(
                                                      keptIn,
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
                                                      Icons.calendar_month,
                                                      color: Colors.blue,
                                                    ),
                                                    SizedBox(
                                                      width: 8.w,
                                                    ),
                                                    Text(
                                                      propertyFoundOn,
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
                                                  width: 50.w,
                                                  height: 45.h,
                                                  decoration: BoxDecoration(
                                                    //color: primaryColor,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(
                                                        50.sp,
                                                      ),
                                                    ),
                                                  ),
                                                  child: const Icon(
                                                    Icons.call,
                                                    color: primaryColor,
                                                    size: 35,
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
                                      Divider(
                                        thickness: 1.5.sp,
                                        color: primaryColor,
                                      ),
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(
                                                      Icons.card_membership,
                                                      color: Colors.black,
                                                    ),
                                                    SizedBox(
                                                      width: 8.w,
                                                    ),
                                                    Text(
                                                      'ID : $propertyID',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12.sp,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(
                                                      Icons.replay,
                                                      color: Colors.black,
                                                    ),
                                                    SizedBox(
                                                      width: 8.w,
                                                    ),
                                                    Text(
                                                      'Not returned',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12.sp,
                                                      ),
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
                                                Icons.settings_phone_rounded,
                                                color: Colors.black,
                                              ),
                                              SizedBox(
                                                width: 8.w,
                                              ),
                                              Text(
                                                policeStationNumber,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12.sp,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      // SizedBox(
                                      //   height: 8.h,
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 8.sp),
                        GetBuilder<PageLostPropertyController>(
                          builder: (_) {
                            if (_.noMoreLostProperty) {
                              return const SizedBox();
                            }

                            return controller.isMoreLostPropertiesLoading
                                ? Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10.sp,
                                    ),
                                    child: SizedBox(
                                      height: 25.sp,
                                      width: 25.sp,
                                      child: const CircularProgressIndicator(),
                                    ),
                                  )
                                : SizedBox(
                                    height: 35.sp,
                                    width: 200.sp,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        _.loadMoreLostProperty();
                                      },
                                      child: Text(
                                        'Load more',
                                        style: TextStyle(fontSize: 12.sp,color: Colors.white),
                                      ),
                                    ),
                                  );
                          },
                        ),
                        SizedBox(height: 5.h),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
