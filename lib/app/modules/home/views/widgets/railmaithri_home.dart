import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../routes/app_pages.dart';
import '../../../../util/asset_urls.dart';
import '../../../../util/theme_data.dart';
import '../../controllers/home_controller.dart';

class RailmaithriHome extends GetView<HomeController> {
  const RailmaithriHome({super.key});

  @override
  Widget build(BuildContext context) {
    //final controller = Get.find<HomeController>();
    const decoration = BoxDecoration(
      color: FORGROUND_COLOR, //BACKGROUND_COLOR
      borderRadius: HOME_BOX_BORDER,
      boxShadow: [
        BoxShadow(
          blurRadius: 10,
          spreadRadius: -1,
          offset: Offset(0, 5),
        ),
      ],
    );
    const decoration1 = BoxDecoration(
      color: BACKGROUND_COLOR,
      borderRadius: HOME_BOX_BORDER,
      boxShadow: [
        BoxShadow(
          blurRadius: 8,
          spreadRadius: -5,
          offset: Offset(0, 5),
        ),
      ],
    );

    return Padding(
      // padding: SCREEN_PADDING,
      padding: EdgeInsets.all(3.sp),
      child: Container(
        height: 602.h,
        // padding: SCREEN_PADDING,
        padding: EdgeInsets.all(2.sp),
        decoration: decoration,
        // height: MediaQuery.of(context).size.height,
        // width: MediaQuery.of(context).size.width,
        child: Container(
          //decoration: decoration,
          padding: const EdgeInsets.only(top: 8),
          // padding: SCREEN_PADDING,
          // height: MediaQuery.of(context).size.height,
          // width: MediaQuery.of(context).size.width,
          decoration: decoration1,
          //color: BACKGROUND_COLOR,
          child: GridView.count(
            //shrinkWrap: true,
            primary: false,
            padding: const EdgeInsets.all(8),
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            crossAxisCount: 3,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Get.toNamed(
                    Routes.PAGE_LONELY,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0),
                    boxShadow: const [
                      gridTheme,
                    ],
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          child: Center(
                            child: Container(
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(AssetUrls.LONELY_PASSENGER),
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          //padding: EdgeInsets.all(0.5.sp),
                          child: Center(
                            child: Column(
                              //mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Lonely Passenger',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 8.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(
                    Routes.PAGE_INCIDENT_TRAIN,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0),
                    boxShadow: const [
                      gridTheme,
                    ],
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          child: Center(
                            child: Container(
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(AssetUrls.INCIDENT_TRAIN),
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          //padding: EdgeInsets.all(0.5.sp),
                          child: Center(
                            child: Column(
                              //mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Incident in Train',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 8.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(
                    Routes.PAGE_INCIDENT_TRACK,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0),
                    boxShadow: const [
                      gridTheme,
                    ],
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          child: Center(
                            child: Container(
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(AssetUrls.INCIDENT_TRACK),
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          //padding: EdgeInsets.all(0.5.sp),
                          child: Center(
                            child: Column(
                              //mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Incident on Track',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 9.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(
                    Routes.PAGE_INCIDENT_PLATFORM,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0),
                    boxShadow: const [
                      gridTheme,
                    ],
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          child: Center(
                            child: Container(
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image:
                                      AssetImage(AssetUrls.INCIDENT_PLATFORM),
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          //padding: EdgeInsets.all(0.5.sp),
                          child: Center(
                            child: Column(
                              //mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Incident on Platform',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 8.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(
                    Routes.PAGE_INTELLIGENCE,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0),
                    boxShadow: const [
                      gridTheme,
                    ],
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          child: Center(
                            child: Container(
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(AssetUrls.INTELLIGENCE),
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          //padding: EdgeInsets.all(0.5.sp),
                          child: Center(
                            child: Column(
                              //mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Intelligence',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 8.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(
                    Routes.PAGE_INTRUDER_ALERT,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0),
                    boxShadow: const [
                      gridTheme,
                    ],
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          child: Center(
                            child: Container(
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(AssetUrls.INTRUDER),
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          //padding: EdgeInsets.all(0.5.sp),
                          child: Center(
                            child: Column(
                              //mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Ladies Coach Alert',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 8.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Get.toNamed(
                  //   Routes.PAGE_RAIL_VOLUNTEER,
                  // );
                  if (controller.registeredRailvolunteerDetails.isEmpty) {
                    Get.toNamed(
                      Routes.PAGE_RAIL_VOLUNTEER,
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            '${controller.user?.fullName ?? controller.user?.username}',
                          ),
                          content: Text(
                            'Your mobile number (${controller.user?.phoneNumber}) is already registered as rail volunteer',
                            textAlign: TextAlign.justify,
                            style: TextStyle(fontSize: 14.sp),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            // TextButton(
                            //   onPressed: () {
                            //     Navigator.pop(context);
                            //     Get.toNamed(Routes.PROFILE);
                            //   },
                            //   child: const Text('Verify'),
                            // ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0),
                    boxShadow: const [
                      gridTheme,
                    ],
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          child: Center(
                            child: Container(
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(AssetUrls.RAIL_VOLUNTEER),
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          //padding: const EdgeInsets.all(0.5),
                          child: Center(
                            child: Column(
                              //mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Rail Volunteer',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 8.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(
                    Routes.PAGE_SHOP_LABOURS,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0),
                    boxShadow: const [
                      gridTheme,
                    ],
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          child: Center(
                            child: Container(
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(AssetUrls.SHOPS),
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          //padding: const EdgeInsets.all(0.5),
                          child: Center(
                            child: Column(
                              //mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Shops & Labours',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 8.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(
                    Routes.PAGE_PORTER_REGISTRATION,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0),
                    boxShadow: const [
                      gridTheme,
                    ],
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          child: Center(
                            child: Container(
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(AssetUrls.STAFF),
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          //padding: const EdgeInsets.all(0.5),
                          child: Center(
                            child: Column(
                              //mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Staff & Porter',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 8.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(
                    Routes.PAGE_LOST_PROPERTY,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0),
                    boxShadow: const [
                      gridTheme,
                    ],
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          child: Center(
                            child: Container(
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(AssetUrls.LOST_PROPERTY),
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          //padding: const EdgeInsets.all(0.5),
                          child: Center(
                            child: Column(
                              //mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Lost Properrties',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 8.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(
                    Routes.PAGE_AWARENESS_CLASS,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0),
                    boxShadow: const [
                      gridTheme,
                    ],
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          child: Center(
                            child: Container(
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(AssetUrls.AWARENESS),
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          //padding: const EdgeInsets.all(0.5),
                          child: Center(
                            child: Column(
                              //mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Awareness Class',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 8.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(
                    Routes.PAGE_SAFETY_TIP,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0),
                    boxShadow: const [
                      gridTheme,
                    ],
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          child: Center(
                            child: Container(
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(AssetUrls.SAFETY),
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          //padding: const EdgeInsets.all(0.5),
                          child: Center(
                            child: Column(
                              //mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Safety Tips',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 8.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(
                    //Routes.PAGE_CONTACTS,
                    Routes.PAGE_CONTACT_DETAILS,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0),
                    boxShadow: const [
                      gridTheme,
                    ],
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          child: Center(
                            child: Container(
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(AssetUrls.CONTACT),
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          //padding: const EdgeInsets.all(0.5),
                          child: Center(
                            child: Column(
                              //mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Contacts',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 8.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // GestureDetector(
              //   onTap: () {
              //     // Get.toNamed(
              //     //   Routes.PAGE_CONTACTS,
              //     // );
              //   },
              //   child: Container(
              //     padding: const EdgeInsets.all(3),
              //     decoration: BoxDecoration(
              //       color: Colors.white,
              //       borderRadius: BorderRadius.circular(30.0),
              //       boxShadow: const [
              //         gridTheme,
              //       ],
              //     ),
              //     child: Column(
              //       children: [
              //         Expanded(
              //           flex: 3,
              //           child: Container(
              //             padding: const EdgeInsets.all(5),
              //             child: Center(
              //               child: Container(
              //                 decoration: const BoxDecoration(
              //                   image: DecorationImage(
              //                     image: AssetImage(AssetUrls.WEBLINK),
              //                     fit: BoxFit.scaleDown,
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ),
              //         Expanded(
              //           child: Container(
              //             padding: const EdgeInsets.all(0.5),
              //             child: Center(
              //               child: Column(
              //                 mainAxisAlignment: MainAxisAlignment.center,
              //                 children: const [
              //                   Text(
              //                     'Web Link',
              //                     textAlign: TextAlign.center,
              //                     style: TextStyle(
              //                       fontWeight: FontWeight.bold,
              //                       fontSize: 9,
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // GestureDetector(
              //   onTap: () {
              //     // Get.toNamed(
              //     //   Routes.PAGE_CONTACTS,
              //     // );
              //   },
              //   child: Container(
              //     padding: const EdgeInsets.all(3),
              //     decoration: BoxDecoration(
              //       color: Colors.white,
              //       borderRadius: BorderRadius.circular(30.0),
              //       boxShadow: const [
              //         gridTheme,
              //       ],
              //     ),
              //     child: Column(
              //       children: [
              //         Expanded(
              //           flex: 3,
              //           child: Container(
              //             padding: const EdgeInsets.all(5),
              //             child: Center(
              //               child: Container(
              //                 decoration: const BoxDecoration(
              //                   image: DecorationImage(
              //                     image: AssetImage(AssetUrls.NOTICEBOARD),
              //                     fit: BoxFit.scaleDown,
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ),
              //         Expanded(
              //           child: Container(
              //             padding: const EdgeInsets.all(0.5),
              //             child: Center(
              //               child: Column(
              //                 mainAxisAlignment: MainAxisAlignment.center,
              //                 children: const [
              //                   Text(
              //                     'Notice Board',
              //                     textAlign: TextAlign.center,
              //                     style: TextStyle(
              //                       fontWeight: FontWeight.bold,
              //                       fontSize: 9,
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
