import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TitleHeader extends StatelessWidget {
  final String title;
  final TextStyle textStyle;

  const TitleHeader({
    super.key,
    required this.title,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 8.h,
      width: double.infinity,
      child: Center(
        child: Text(
          title,
          style: textStyle,
        ),
      ),
    );
  }
}
