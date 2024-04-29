import 'package:belajandro_kiosk/app/modules/home/views/transaction_view.dart';
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

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  // call the controller
  final hc = Get.find<HomeController>();
  final sc = Get.find<ScreenController>();

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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                WeatherAndClock(
                  orientation: orientation,
                  screenType: screenType,
                ),
                TitleHeader(
                  title: 'SELECT LANGUAGE',
                  fontSize: 20.sp,
                  color: HenryColors.lightGold,
                  fontFamily: atteron,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 35.sp, right: 35.sp, top: 10.sp, bottom: 10.sp),
                    child: ListView.builder(
                      itemCount: sc.languagesList.first.data.languages.length,
                      // padding: const EdgeInsets.all(15),
                      itemBuilder: (context, index) {
                        return MenuWidget(
                          titleName: sc.languagesList.first.data.languages[index].description,
                          imageName: 'assets/flags/${sc.languagesList.first.data.languages[index].flag}',
                          cardColor: HenryColors.teal,
                          shadowColor: HenryColors.teal.withOpacity(0.5),
                          onTap: () {
                            hc.languageID.value = sc.languagesList.first.data.languages[index].id;
                            hc.languageCode.value = sc.languagesList.first.data.languages[index].code;
                            final result = hc.makeMenu(languageID: hc.languageID.value, code: 'ST');
                            if (result) {
                              Get.to(
                                () => TransactionView(),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 3.h,
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
