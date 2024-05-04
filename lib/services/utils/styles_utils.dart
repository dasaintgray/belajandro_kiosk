import 'package:belajandro_kiosk/services/colors/service_colors.dart';
import 'package:belajandro_kiosk/services/utils/font_utils.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HenryStyle {
  final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    // textStyle: TextStyle(
    //   fontSize: 20.sp,
    // ),
    backgroundColor: HenryColors.teal,
  );
}

final TextStyle globalTextStyle = TextStyle(fontSize: 20.sp, fontFamily: bernardMT, color: HenryColors.puti);
final TextStyle titleTextStyle = TextStyle(
  fontSize: 20.sp,
  fontFamily: bernardMT,
  color: HenryColors.teal,
);
