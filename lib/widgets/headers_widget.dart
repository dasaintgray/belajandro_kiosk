import 'package:belajandro_kiosk/app/modules/home/controllers/home_controller.dart';
import 'package:belajandro_kiosk/app/modules/screen/controllers/screen_controller.dart';
import 'package:belajandro_kiosk/services/colors/service_colors.dart';
import 'package:belajandro_kiosk/services/constant/image_constant.dart';
import 'package:belajandro_kiosk/services/utils/font_utils.dart';
import 'package:belajandro_kiosk/widgets/clock_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart' as rs;

class WeatherAndClock extends StatelessWidget {
  final Orientation orientation;
  final rs.ScreenType screenType;
  WeatherAndClock({super.key, required this.orientation, required this.screenType});

  final hc = Get.find<HomeController>();
  final sc = Get.find<ScreenController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: orientation == Orientation.landscape ? 30.h : 22.h,
          width: double.infinity,
          // color: HenryColors.blueAccent,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TIME AND DATE
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: orientation == Orientation.landscape ? 13.h : 13.h,
                      width: 10.w,
                      // color: HenryColors.gold,
                      child: Obx(
                        () => Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat.EEEE().format(DateTime.now()),
                              style: TextStyle(color: HenryColors.puti, fontSize: 15.sp),
                            ),
                            Text(
                              DateFormat.yMMMMd().format(DateTime.now()),
                              style: TextStyle(color: HenryColors.puti, fontSize: 14.sp),
                            ),
                            const Divider(
                              height: 1,
                              thickness: 1,
                            ),
                            Text(
                              sc.oras.value.toString(),
                              style: TextStyle(color: HenryColors.puti, fontSize: 11.sp),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // COMPANY LOGO
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      // color: HenryColors.blueAccent,
                      height: orientation == Orientation.landscape ? 13.h : 13.h,
                      width: 10.w,
                      child: Column(
                        children: [
                          SizedBox(
                            height: orientation == Orientation.landscape ? 5.h : 8.h,
                            child: Image.asset(
                              ImageConstant.belajandro256,
                              fit: BoxFit.contain,
                              // height: 10.h,
                            ),
                          ),
                          ListTile(
                            titleAlignment: ListTileTitleAlignment.center,
                            title: Text(
                              sc.sCOMPANY.value,
                              style: TextStyle(
                                color: HenryColors.lightGold,
                                fontSize: orientation == Orientation.landscape ? 10.sp : 15.sp,
                                fontWeight: FontWeight.bold,
                                fontFamily: atteron,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            subtitle: Text(
                              sc.sCompanyAddress.value,
                              style: TextStyle(
                                color: HenryColors.puti,
                                fontSize: 10.sp,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // WEATHER
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: orientation == Orientation.landscape ? 12.h : 13.h,
                      width: 5.w,
                      // color: HenryColors.gold,
                      child: Obx(
                        () => Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Temp: ${sc.weatherList.first.current.tempC.round()} ºC',
                                        style: TextStyle(
                                          color: HenryColors.puti,
                                          fontSize: 11.sp,
                                          // fontFamily: 'Roboto',
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                      Text(
                                        'Feels: ${sc.weatherList.first.current.feelslikeC.round()} ºC',
                                        style: TextStyle(
                                          color: HenryColors.puti,
                                          fontSize: 11.sp,
                                          // fontFamily: 'Roboto',
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                      Text(
                                        'Humidity: ${sc.weatherList.first.current.humidity.round()} %',
                                        style: TextStyle(
                                          color: HenryColors.puti,
                                          fontSize: 9.sp,
                                          // fontFamily: 'Roboto',
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                      Text(
                                        sc.weatherList.first.current.condition.text,
                                        style: TextStyle(
                                          color: HenryColors.puti,
                                          fontSize: 9.sp,
                                          // fontFamily: 'Roboto',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: SizedBox(
                                    height: orientation == Orientation.landscape ? 8.h : 4.h,
                                    child: Image.network(
                                      sc.imgURL.value,
                                      fit: BoxFit.contain,
                                      height: 5.h,
                                      width: 9.w,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(
                              height: 1,
                              thickness: 1,
                            ),
                            Text(
                              sc.weatherLocation.value,
                              style: TextStyle(
                                color: HenryColors.puti,
                                fontSize: 10.sp,
                                // fontFamily: 'Roboto',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // SPACE
              SizedBox(
                height: orientation == Orientation.landscape ? 2.h : 2.h,
                width: double.infinity,
              ),
              // WORLD TIME
              SizedBox(
                height: orientation == Orientation.landscape ? 10.h : 6.h,
                width: double.infinity,
                // color: HenryColors.gold,
                child: Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ClockSkin(
                        location: 'TOKYO, JAPAN',
                        hourText: sc.tokyo.value.substring(0, 2),
                        minuteText: sc.tokyo.value.substring(3, 5),
                      ),
                      ClockSkin(
                        location: 'SYDNEY, AUSTRALIA',
                        hourText: sc.sydney.value.substring(0, 2),
                        minuteText: sc.sydney.value.substring(3, 5),
                      ),
                      ClockSkin(
                        location: 'LOS ANGELES, USA',
                        hourText: sc.newYork.value.substring(0, 2),
                        minuteText: sc.newYork.value.substring(3, 5),
                        // height: 40.h,
                        // width: 20.w,
                      ),
                      ClockSkin(
                        location: 'RIYADH, KSA',
                        hourText: sc.riyadh.value.substring(0, 2),
                        minuteText: sc.riyadh.value.substring(3, 5),
                        // height: 45.h,
                        // width: 20.w,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
