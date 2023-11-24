// ignore_for_file: unused_local_variable, avoid_bool_literals_in_conditional_expressions

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../util/asset_urls.dart';
import '../../../util/global_widgets.dart';
import '../../../util/theme_data.dart';
import '../controllers/page_awareness_class_controller.dart';

class PageAwarenessClassMainView extends StatelessWidget {
  const PageAwarenessClassMainView({super.key});
  @override
  Widget build(BuildContext context) {
    const decoration = BoxDecoration(
      color: FORGROUND_COLOR,
      borderRadius: HOME_BOX_BORDER,
      boxShadow: [
        BoxShadow(
          blurRadius: 8,
          spreadRadius: -5,
          offset: Offset(0, 5),
        ),
      ],
    );
    final tablePadding = EdgeInsets.only(bottom: 4.sp, top: 4.sp);

    Future<void> launchYoutube(String url) async {
      final Uri url1 = Uri.parse(url);
      if (await canLaunchUrl(url1)) {
        await launchUrl(
          url1,
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw 'Not launch $url';
      }
    }

    return Container(
      decoration: const BoxDecoration(
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
      ),
      child: GetBuilder<PageAwarenessClassController>(
        builder: (controller) {
          if (controller.isAwarenessClassListLoading) {
            return Padding(
              padding: EdgeInsets.all(16.sp),
              child: processingIndicator(),
            );
          }

          if (controller.listOfAwareness.isEmpty) {
            return Text(
              'NO INFO FOUND',
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
                itemCount: controller.listOfAwareness.length,
                itemBuilder: (context, int index) {
                  final random = Random();
                  final String category = controller
                      .listOfAwareness[index].awarenessClassTopicLabel;
                  final String videoURL =
                      controller.listOfAwareness[index].videoUrl;
                  final String? image =
                      controller.listOfAwareness[index].thumbnails;
                  final bool imageLoadingError = image != null ? false : true;
                  final double randomDouble = 1 + random.nextDouble();
                  final double roundedNumber =
                      double.parse(randomDouble.toStringAsFixed(2));

                  Future<String?> getImgUrl(String image) async {
                    final String imgUrl = image;

                    try {
                      final Uint8List bytes =
                          (await NetworkAssetBundle(Uri.parse(imgUrl))
                                  .load(imgUrl))
                              .buffer
                              .asUint8List();

                      return imgUrl;
                    } catch (e) {
                      return null;
                    }
                  }

                  Widget assetImage1() {
                    return Image.asset(
                      AssetUrls.THUMBNAIL,
                      fit: BoxFit.fill,
                      //height: 50,
                    );
                  }

                  Widget assetImage() {
                    return const Icon(
                      Icons.video_library,
                      size: 50,
                      color: Colors.blue,
                    );
                  }

                  Widget urlImage(String image) {
                    return Image.network(
                      image,
                      fit: BoxFit.fill,
                      height: 50,
                    );
                  }

                  return MaterialButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      launchYoutube(videoURL);
                    },
                    child: Card(
                      surfaceTintColor: Colors.white,
                      margin: const EdgeInsets.all(3.0),
                      borderOnForeground: false,
                      elevation: 5.0.sp,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          10.sp,
                        ),
                      ),
                      shadowColor: Colors.black,
                      color: Colors.white,
                      child: Padding(
                        padding: SCREEN_PADDING,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: SizedBox(
                                    width: 5.w,
                                    height: 90.h,
                                    child: FutureBuilder(
                                      future: getImgUrl('$image'),
                                      builder: (
                                        BuildContext context,
                                        AsyncSnapshot<String?> snapshot,
                                      ) {
                                        final bool error =
                                            snapshot.data == null;

                                        return error
                                            ? Image.asset(
                                                AssetUrls.THUMBNAIL,
                                                fit: BoxFit.fill,
                                                // fit: BoxFit.cover,
                                                // height: 70.h,
                                                // width: 70.w,
                                              )
                                            : Image.network(
                                                snapshot.data!,
                                                fit: BoxFit.fill,
                                                // fit: BoxFit.cover,
                                                // height: 70.h,
                                                // width: 70.w,
                                              );
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20.w,
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            category,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.star_rate,
                                            color: Colors.red,
                                          ),
                                          const Icon(
                                            Icons.star_rate,
                                            color: Colors.red,
                                          ),
                                          const Icon(
                                            Icons.star_rate,
                                            color: Colors.red,
                                          ),
                                          const Icon(
                                            Icons.star_rate,
                                            color: Colors.red,
                                          ),
                                          const Icon(
                                            Icons.star_rate,
                                            color: Colors.red,
                                          ),
                                          SizedBox(
                                            width: 8.w,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          Text(
                                            '$roundedNumber K views',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          Text(
                                            'by Railway Police',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // Expanded(
                                //   child: Padding(
                                //     padding: const EdgeInsets.all(10.0),
                                //     child: Container(
                                //       decoration: const BoxDecoration(
                                //         borderRadius: BorderRadius.all(
                                //           Radius.circular(50),
                                //         ),
                                //         boxShadow: [
                                //           BoxShadow(
                                //             color: Colors.black12,
                                //             spreadRadius: 1,
                                //             blurRadius: 0.5,
                                //             offset: Offset(1, 1),
                                //           ),
                                //         ],
                                //       ),
                                //       child: Center(
                                //         child: Icon(
                                //           Icons.play_circle_filled_outlined,
                                //           color: primaryColor,
                                //           size: 50.sp,
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                                // ),
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
              GetBuilder<PageAwarenessClassController>(
                builder: (_) {
                  if (_.noMoreAwareness) {
                    return const SizedBox();
                  }

                  return _.isMoreAwarenessClassListLoading
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
                              _.loadMoreAwarenessClassList();
                            },
                            child: Text(
                              'Load more',
                              style: TextStyle(fontSize: 12.sp),
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
    );
  }
}
