import 'package:belajandro_kiosk/app/modules/home/controllers/home_controller.dart';
import 'package:belajandro_kiosk/app/modules/home/views/guest_info_view.dart';
import 'package:belajandro_kiosk/app/modules/home/views/home_view.dart';
import 'package:belajandro_kiosk/app/modules/screen/controllers/screen_controller.dart';
import 'package:belajandro_kiosk/services/colors/service_colors.dart';
import 'package:belajandro_kiosk/services/constant/image_constant.dart';
import 'package:belajandro_kiosk/services/utils/styles_utils.dart';
import 'package:belajandro_kiosk/widgets/headers_widget.dart';
import 'package:belajandro_kiosk/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart' as rs;

import 'package:get/get.dart';

class DisclaimerView extends GetView {
  // call the controller, if active
  final hc = Get.find<HomeController>();
  final sc = Get.find<ScreenController>();
  final String titulo;
  final String? agreeText;
  final String? cancelText;

  DisclaimerView({super.key, required this.titulo, required this.agreeText, required this.cancelText});

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
                  title: titulo,
                  textStyle: titleTextStyle,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: hc.disclaimer,
                    child: Text(
                      sc.getDisclaimer(hc.languageID.value),
                      style: TextStyle(
                        color: HenryColors.puti,
                        fontSize: 15.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 2.h,
                  width: double.infinity,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 7.h,
                      width: 30.w,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.snackbar(
                            "Thank you",
                            "Thank you very much for using Belajandro Kiosk System",
                            colorText: HenryColors.puti,
                            snackPosition: SnackPosition.BOTTOM,
                          );
                          Get.off(
                            () => HomeView(),
                          );
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: HenryColors.teal),
                        child: Text(
                          cancelText!,
                          style: TextStyle(
                            color: HenryColors.puti,
                            fontSize: 15.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 7.h,
                      width: 30.w,
                      child: ElevatedButton(
                        onPressed: () async {
                          final translatedText =
                              await hc.iTranslate(languageCode: hc.languageCode.value, sourceText: 'GUEST INFORMATION');
                          await hc.initializeCamera();
                          Get.to(
                            () => GuestInfoView(titulo: translatedText!),
                          );
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: HenryColors.teal),
                        child: Text(
                          agreeText!,
                          style: TextStyle(
                            color: HenryColors.puti,
                            fontSize: 15.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: 2.h,
                  width: double.infinity,
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
