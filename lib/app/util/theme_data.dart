// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

const bodyBackgroundColor = Color.fromARGB(255, 255, 255, 255);
const primaryColor = Color(0xFF008585);
const textColor = Color.fromARGB(255, 252, 241, 241);
const buttonColor = Color.fromARGB(176, 4, 16, 14);
const darkModeBlack = Color.fromARGB(255, 8, 48, 48);
const double HEADER_LOGO_SCALE = 1.4;
const double MENU_MAX_HEIGHT = 300;
const ICON_BORDER = BorderRadius.all(Radius.circular(5));
const CIRCULAR_BORDER = BorderRadius.all(Radius.circular(15));
const HOME_BOX_BORDER = BorderRadius.all(Radius.circular(10));
const FORM_CIRCULAR_BORDER = BorderRadius.all(Radius.circular(10));
const CONTAINER_TEXT_COLOR = Colors.white;
const COLOREDBOX_COLOR = primaryColor;
const BACKGROUND_COLOR = Color(0xFF008585);
const FORGROUND_COLOR = Color.fromARGB(255, 255, 255, 255);
const ICON_COLOR = buttonColor;
const PROFILE_TEXT_COLOR = Colors.white;
final boxConstraints = BoxConstraints(maxWidth: Get.size.longestSide * 0.7);
final appHeaderStyle = TextStyle(fontSize: 14.sp);
EdgeInsets SCREEN_PADDING = EdgeInsets.all(8.sp);
EdgeInsets FIT_SCREEN_PADDING = EdgeInsets.all(5.sp);

//***My Template******

const appBarShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.only(
    bottomRight: Radius.circular(25),
    bottomLeft: Radius.circular(25),
  ),
);

TextStyle appBarTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 12.sp,
);

BorderRadius HINT_BOARDER_STYLE = BorderRadius.all(Radius.circular(15.sp));

TextStyle HINT_TEXT_LABEL = TextStyle(
  color: Colors.black,
  fontSize: 10.sp,
);

TextStyle SMALL_TEXT_LABEL = TextStyle(
  color: Colors.black,
  fontSize: 12.sp,
);

TextStyle SUB_HEADER_STYLE = TextStyle(
  color: CONTAINER_TEXT_COLOR,
  fontWeight: FontWeight.bold,
  fontSize: 12.sp,
);
EdgeInsets TOP_SCREEN_PADDING =
    EdgeInsets.only(top: 20.sp, left: 8.sp, right: 8.sp);

//*********************

const gridTheme = BoxShadow(
  color: Colors.grey,
  blurRadius: 1.0,
  offset: Offset(
    0.5,
    0.5,
  ),
  spreadRadius: 2.5, //3.5,
);

final themeData = ThemeData(
  scaffoldBackgroundColor: bodyBackgroundColor,
  primaryColor: primaryColor,
  secondaryHeaderColor: primaryColor,
  applyElevationOverlayColor: false,
  cardTheme: const CardTheme(shadowColor: buttonColor),
  appBarTheme: const AppBarTheme(shadowColor: buttonColor),
  colorScheme: const ColorScheme.light(primary: primaryColor),
  iconTheme: IconThemeData(size: 18.sp),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: buttonColor,
  ),
  inputDecorationTheme: InputDecorationTheme(
    contentPadding: EdgeInsets.all(14.sp),
    hintStyle: TextStyle(fontSize: 12.sp),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: primaryColor,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: textColor,
      padding: EdgeInsets.zero,
      fixedSize: Size(45.sp, 45.sp),
      backgroundColor: buttonColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
  ),
);

TextStyle TEXT_HEADER_STYLE = TextStyle(
  color: CONTAINER_TEXT_COLOR,
  fontWeight: FontWeight.bold,
  fontSize: 14.sp,
);

TextStyle TEXT_DRAWER_STYLE = TextStyle(
  color: CONTAINER_TEXT_COLOR,
  fontSize: 12.sp,
);

TextStyle TEXT_WATER_MARK = TextStyle(
  color: Colors.grey,
  fontWeight: FontWeight.bold,
  fontSize: 30.sp,
);

TextStyle TEXT_TICKET_STYLE = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 14.sp,
);

TextStyle TEXT_TICKET_STYLE_CARD = TextStyle(
  color: Colors.white,
  //fontWeight: FontWeight.bold,
  fontSize: 12.sp,
);

TextStyle TEXT_HEADER = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 14.sp,
);

TextStyle TEXT_STYLE_DROPDOWN = TextStyle(
  color: Colors.black,
  fontSize: 14.sp,
);

TextStyle TEXT_LABEL = TextStyle(
  color: Colors.grey,
  fontSize: 9.sp,
);
