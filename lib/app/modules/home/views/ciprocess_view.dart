import 'package:belajandro_kiosk/app/modules/home/controllers/home_controller.dart';
import 'package:belajandro_kiosk/app/modules/screen/controllers/screen_controller.dart';
import 'package:belajandro_kiosk/services/colors/service_colors.dart';
import 'package:belajandro_kiosk/services/constant/image_constant.dart';
import 'package:belajandro_kiosk/services/utils/font_utils.dart';
import 'package:belajandro_kiosk/widgets/headers_widget.dart';
import 'package:belajandro_kiosk/widgets/menu_widget.dart';
import 'package:belajandro_kiosk/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart' as rs;

import 'package:get/get.dart';

class CiprocessView extends GetView {
  // call the controller
  final hc = Get.find<HomeController>();
  final sc = Get.find<ScreenController>();

  CiprocessView({super.key});

  @override
  Widget build(BuildContext context) {
    return rs.ResponsiveSizer(
      builder: (buildContext, orientation, screenType) {
        return Scaffold(
          body: Container(
            height: 100.h,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImageConstant.background),
                fit: BoxFit.fill,
              ),
            ),
            padding: EdgeInsets.all(12.sp),
            child: Column(
              children: [
                WeatherAndClock(
                  orientation: orientation,
                ),
                TitleHeader(
                  title: hc.titleList.first.translationText,
                  fontSize: 20.sp,
                  color: HenryColors.lightGold,
                  fontFamily: atteron,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 35.sp, vertical: 20.sp),
                    child: ListView.builder(
                      itemCount: hc.pageList.length,
                      itemBuilder: (context, index) {
                        return MenuWidget(
                          titleName: hc.pageList[index].translationText,
                          imageName: 'assets/icons/${hc.pageList[index].images}',
                          cardColor: HenryColors.teal,
                          shadowColor: HenryColors.teal.withOpacity(0.5),
                          onTap: () {},
                        );
                        // return Card(
                        //   color: HenryColors.lightGold,
                        //   clipBehavior: Clip.antiAliasWithSaveLayer,
                        //   shadowColor: HenryColors.puti,
                        //   elevation: 5,
                        //   margin: const EdgeInsets.all(20),
                        //   child: InkWell(
                        //     borderRadius: BorderRadius.circular(10),
                        //     splashColor: HenryColors.itim.withAlpha(50),
                        //     // hoverColor: HenryColors.teal,
                        //     // hoverDuration6.: 500.ms,
                        //     onTap: () async {},
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //       children: [
                        //         Expanded(
                        //           flex: 4,
                        //           child: Center(
                        //             child: Text(
                        //               hc.pageList[index].translationText,
                        //               style: TextStyle(color: HenryColors.puti, fontSize: 18.sp),
                        //             ),
                        //           ),
                        //         ),
                        //         Expanded(
                        //           flex: 1,
                        //           child: Padding(
                        //             padding: const EdgeInsets.all(8.0),
                        //             child: Image.asset(
                        //               'assets/icons/${hc.pageList[index].images}',
                        //               fit: BoxFit.contain,
                        //               height: 6.h,
                        //               width: 6.w,
                        //             ),
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ).animate().flip(delay: 300.ms, duration: 500.ms).shimmer(duration: 300.ms);
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.h,
                  width: double.infinity,
                  child: InkWell(
                    onTap: () {
                      final result = hc.makeMenu(languageID: hc.languageID.value, code: 'ST');
                      result ? Get.back() : Get.snackbar('Error', 'Unable to get back');
                    },
                    child: Image.asset(
                      'assets/icons/back-icon.png',
                      fit: BoxFit.contain,
                      height: 5.h,
                      width: 5.w,
                    ),
                  ),
                ),
                // SPACE
                SizedBox(
                  height: 2.h,
                  width: double.infinity,
                ),
                SizedBox(
                  height: 4.h,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/img/cmlogo.png',
                    fit: BoxFit.contain,
                    height: 5.h,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
