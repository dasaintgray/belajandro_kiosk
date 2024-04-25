import 'package:belajandro_kiosk/app/modules/screen/controllers/screen_controller.dart';
import 'package:belajandro_kiosk/services/colors/service_colors.dart';
import 'package:belajandro_kiosk/services/constant/image_constant.dart';
import 'package:belajandro_kiosk/widgets/headers_widget.dart';
import 'package:belajandro_kiosk/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
                TitleHeader(
                  title: 'SELECT LANGUAGE',
                  fontSize: 20.sp,
                  color: HenryColors.lightGold,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 40.sp, vertical: 20.sp),
                    child: ListView.builder(
                      itemCount: sc.languagesList.first.data.languages.length,
                      // padding: const EdgeInsets.all(15),
                      itemBuilder: (context, index) {
                        return Card(
                          color: HenryColors.lightGold,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          margin: const EdgeInsets.all(20),
                          child: InkWell(
                            splashColor: HenryColors.itim.withAlpha(50),
                            onTap: () {
                              hc.languageID.value = sc.languagesList.first.data.languages[index].id;
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Text(
                                    sc.languagesList.first.data.languages[index].description,
                                    style: TextStyle(color: HenryColors.puti, fontSize: 20.sp),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: Image.asset(
                                    'assets/flags/${sc.languagesList.first.data.languages[index].flag}',
                                    fit: BoxFit.contain,
                                    height: 7.h,
                                    width: 8.w,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ).animate().fadeIn(duration: 600.ms).then(delay: 300.ms).slide();
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
