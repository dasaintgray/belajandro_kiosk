import 'package:belajandro_kiosk/services/colors/service_colors.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ContainerButton extends StatelessWidget {
  final Widget image;
  final Widget child;
  const ContainerButton({
    super.key,
    required this.image,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 500,
      // padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: HenryColors.lightGold,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.all(15.sp),
              child: child,
            ),
          ),
          // SizedBox(
          //   height: 1.h,
          //   width: double.infinity,
          // ),
          Expanded(
            flex: 1,
            child: Container(
              // height: 3.h,
              width: 1.w,
              decoration: BoxDecoration(
                  color: Color.alphaBlend(
                    Colors.black12,
                    HenryColors.lightGold,
                  ),
                  borderRadius: BorderRadius.circular(30)),
              child: image,
            ),
          ),
        ],
      ),
    );
  }
}
