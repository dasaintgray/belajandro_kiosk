import 'package:belajandro_kiosk/app/modules/home/controllers/home_controller.dart';
import 'package:belajandro_kiosk/app/modules/home/views/ciprocess_view.dart';
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

class TransactionView extends GetView {
  // call the controller
  final hc = Get.find<HomeController>();
  final sc = Get.find<ScreenController>();

  TransactionView({super.key});
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
                  screenType: screenType,
                ),
                TitleHeader(
                  title: hc.titleList.first.translationText,
                  fontSize: 20.sp,
                  color: HenryColors.lightGold,
                  fontFamily: atteron,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: hc.pageList.length,
                    padding: EdgeInsets.only(left: 35.sp, right: 35.sp, top: 10.sp, bottom: 10.sp),
                    itemBuilder: (buildContext, index) {
                      return MenuWidget(
                        titleName: hc.pageList[index].translationText,
                        imageName: 'assets/icons/${hc.pageList[index].images}',
                        cardColor: HenryColors.teal,
                        shadowColor: HenryColors.teal.withOpacity(0.5),
                        onTap: () {
                          hc.languageID.value = hc.pageList[index].languageId;
                          switch (index) {
                            case 0:
                              final result = hc.makeMenu(languageID: hc.languageID.value, code: 'SCIP');
                              if (result) {
                                hc.isLoading.value = false;
                                Get.to(() => CiprocessView());
                              }
                              break;
                            default:
                              Get.defaultDialog(title: 'Future', middleText: 'To be follow');
                              break;
                          }
                        },
                      );
                    },
                  ),
                ),
                // BACK IMAGE
                SizedBox(
                  height: 5.h,
                  width: double.infinity,
                  child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Image.asset(
                      ImageConstant.backArrow,
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
                // CM LOGO
                SizedBox(
                  height: 4.h,
                  width: double.infinity,
                  child: Image.asset(
                    ImageConstant.cmLOGO,
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
