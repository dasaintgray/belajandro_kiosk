import 'package:belajandro_kiosk/app/modules/home/controllers/home_controller.dart';
import 'package:belajandro_kiosk/services/colors/service_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MenuWidget extends StatelessWidget {
  // final List<Menu> menuList;
  final String? titleName;
  final String? imageName;
  final Color cardColor;
  final Color shadowColor;
  // final int indexKey;
  final Function() onTap;

  MenuWidget({
    super.key,
    // required this.menuList,
    required this.titleName,
    required this.imageName,
    required this.cardColor,
    required this.shadowColor,
    // required this.indexKey,
    required this.onTap,
  });

  final hc = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              // color: HenryColors.teal.withOpacity(.5),
              color: shadowColor,
              blurRadius: 15.0, // soften the shadow
              spreadRadius: 0.0, //extend the shadow
              offset: const Offset(
                7.0, // Move to right 10  horizontally
                7.0, // Move to bottom 10 Vertically
              ),
            )
          ],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Card(
          color: cardColor,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          surfaceTintColor: HenryColors.teal,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            splashColor: HenryColors.itim.withAlpha(50),
            onTap: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 4,
                  child: Center(
                    child: Text(
                      titleName!,
                      style: TextStyle(color: HenryColors.puti, fontSize: 18.sp),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      imageName!,
                      fit: BoxFit.contain,
                      height: 6.h,
                      width: 6.w,
                    ),
                    // child: Image.asset(
                    //   'assets/icons/${menuList[indexKey].images}',
                    //   fit: BoxFit.contain,
                    //   height: 6.h,
                    //   width: 6.w,
                    // ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ).animate().flip(delay: 300.ms, duration: 500.ms).shimmer(duration: 300.ms),
    );
  }
}
