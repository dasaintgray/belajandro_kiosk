import 'package:belajandro_kiosk/app/modules/screen/controllers/screen_controller.dart';
import 'package:belajandro_kiosk/services/colors/service_colors.dart';
import 'package:belajandro_kiosk/services/constant/image_constant.dart';
import 'package:belajandro_kiosk/services/utils/font_utils.dart';
import 'package:belajandro_kiosk/widgets/button_widget.dart';
import 'package:belajandro_kiosk/widgets/headers_widget.dart';
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
                ),
                SizedBox(
                  height: 10.h,
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      'SELECT LANGUAGE',
                      style: TextStyle(
                        color: HenryColors.lightGold,
                        fontSize: 20.sp,
                        fontFamily: oldAlpha,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 40.sp, vertical: 20.sp),
                    child: ListView.builder(
                      itemCount: sc.languagesList.first.data.languages.length,
                      padding: const EdgeInsets.all(15),
                      itemBuilder: (context, index) {
                        return ContainerButton(
                          image: Image.asset(
                            'assets/flags/${sc.languagesList.first.data.languages[index].flag}',
                            fit: BoxFit.contain,
                          ),
                          child: Text(
                            sc.languagesList.first.data.languages[index].description,
                            style: TextStyle(color: HenryColors.puti, fontSize: 12.sp),
                          ),
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
