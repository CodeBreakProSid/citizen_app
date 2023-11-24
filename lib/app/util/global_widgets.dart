// ignore_for_file: avoid_dynamic_calls, unused_element, dead_code

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import 'theme_data.dart';

final lightBlueGradient     = [Colors.indigo.shade200, Colors.indigo.shade50];
final blueGradient          = [const Color(0xFF1B90F7), Colors.blue.shade300];
final tealGradient          = [const Color(0xFF00897B), Colors.teal.shade300];
final deepPurpleGradient    = [const Color(0xFF7361F7), Colors.indigo.shade200];
final redGradient           = [const Color(0xFFF8456C), Colors.red.shade200];
final brownGradient         = [Colors.brown, Colors.brown.shade200];
final cyanGradient          = [Colors.cyan, Colors.cyan.shade200];
final orangeGradient        = [Colors.orange[600]!, Colors.orange.shade200];

const white                 = Colors.white;
const HEIGHT_06             = SizedBox(height: 6);
const HEIGHT_12             = SizedBox(height: 12);

// ignore: non_constant_identifier_names
final double SCREEN_HEIGHT  = MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.height;

//ignore: prefer-match-file-name
enum SnackbarType {
                    success,
                    warning,
                    error,
                  }


void showSnackBar({
  required SnackbarType type,
  required String message,
  Duration? duration,
}) 
{
  final Color fontColor = type == SnackbarType.warning ? 
                                Colors.black : Colors.white;
  final Color bgColor   = type == SnackbarType.success ? 
                                const Color(0xff28a745): type == SnackbarType.warning ? 
                                                                 const Color(0xffffc107) : const Color(0xffdc3545);
  Get.showSnackbar
  (
    GetSnackBar
    (
      message           : message,
      dismissDirection  : DismissDirection.horizontal,
      snackPosition     : SnackPosition.TOP,
      snackStyle        : SnackStyle.GROUNDED,
      messageText       : Text(message, style: TextStyle(color: fontColor)),
      backgroundColor   : bgColor,
      icon              : type == SnackbarType.success ? 
                                  Icon(Icons.check, color: fontColor) : Icon(Icons.error_outline, color: fontColor),
      duration          : duration ?? 3.seconds,
      shouldIconPulse   : false,
    ),
  );
}

Future<void> showAlertError(BuildContext context, String error) 
{
  return showDialog
  (
    context   : context,
    builder   : (context) 
    {
      return AlertDialog
      (
                         title : Text(
                                       'Warning',
                                       style: TEXT_HEADER,
                                     ),
                        content: Text(
                                      error,
                                      textAlign: TextAlign.justify,
                                     ),
      );
    },
  );
}

Widget processingIndicator() 
{
  return const CircularProgressIndicator();
}

void showAnimatedDialog(Widget dialog, BuildContext context) 
{
  showGeneralDialog
  (
    barrierDismissible  : false,
    context             : context,
    pageBuilder         : (context, al1, al2) 
                           {
                             return const SizedBox();
                           },
    transitionBuilder   : (ctx, a1, a2, child) 
                           {
                             final curve = Curves.easeInOut.transform(a1.value);
                       
                             return Transform.scale
                             (
                               scale: curve,
                               child: dialog,
                             );
                           },
    transitionDuration  : const Duration(milliseconds: 300),
  );
}

//Shimmer Loader for Citizen Home Page
Widget shimmerLoaderHome() 
{
  return SingleChildScrollView
  (
    physics : const BouncingScrollPhysics(),
    child   : Padding(
       padding : SCREEN_PADDING,
       child   : Column(
          children: [
            Container(
              height    : 200.h,
              padding   : SCREEN_PADDING,
              child     : shimmer(
                const BoxDecoration(borderRadius: HOME_BOX_BORDER, color: white),
              ),
            ),
            SizedBox(height: 10.h),
            Container(
              height    : 150.h,
              padding   : SCREEN_PADDING,
              child     : shimmer(
                const BoxDecoration(borderRadius: HOME_BOX_BORDER, color: white),
              ),
            ),
            SizedBox(height: 10.h),
            Container(
              height    : 150.h,
              padding   : SCREEN_PADDING,
              child     : shimmer(
                const BoxDecoration(borderRadius: HOME_BOX_BORDER, color: white),
              ),
            ),
            SizedBox(height: 10.h),
            Container(
              height    : 110.h,
              padding   : SCREEN_PADDING,
              child     : shimmer(
                const BoxDecoration(borderRadius: HOME_BOX_BORDER, color: white),
              ),
            ),
          ],
       ),
    ),
  );
}

//Common ShimmerBox
Widget shimmer(Decoration decoration) 
{
  return Shimmer.fromColors(
    baseColor       : Colors.grey.shade300,
    highlightColor  : Colors.grey.shade100,
    child           : Container(
                       height      : 100,
                       decoration  : decoration,
                               ),
  );
}
