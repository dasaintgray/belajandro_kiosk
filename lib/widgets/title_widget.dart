import 'package:belajandro_kiosk/services/utils/font_utils.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TitleHeader extends StatelessWidget {
  final String title;
  final double fontSize;
  final String? fontFamily;
  final Color color;

  const TitleHeader({
    super.key,
    required this.title,
    required this.fontSize,
    required this.color,
    this.fontFamily,
  });

  @override
  Widget build(BuildContext context) {
    final isWala = fontFamily?.isEmpty ?? true;
    return SizedBox(
      height: 8.h,
      width: double.infinity,
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: fontSize,
            fontFamily: isWala ? oldAlpha : fontFamily,
          ),
        ),
      ),
    );
  }
}
