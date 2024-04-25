import 'package:belajandro_kiosk/app/modules/home/controllers/home_controller.dart';
import 'package:belajandro_kiosk/app/modules/screen/controllers/screen_controller.dart';
import 'package:belajandro_kiosk/services/colors/service_colors.dart';
import 'package:belajandro_kiosk/widgets/clock_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class WeatherAndClock extends StatelessWidget {
  final Orientation orientation;
  WeatherAndClock({super.key, required this.orientation});

  final hc = Get.find<HomeController>();
  final sc = Get.find<ScreenController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: orientation == Orientation.landscape ? 25.h : 18.h,
          width: double.infinity,
          // color: HenryColors.teal,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: orientation == Orientation.landscape ? 12.h : 6.h,
                      width: 10.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat.EEEE().format(sc.dtNow),
                            style: TextStyle(color: HenryColors.puti, fontSize: 15.sp),
                          ),
                          Text(
                            DateFormat.yMMMd().format(sc.dtNow),
                            style: TextStyle(color: HenryColors.puti, fontSize: 14.sp),
                          ),
                          const Divider(
                            height: 1,
                            thickness: 1,
                          ),
                          Obx(
                            () => Text(
                              sc.oras.value.toString(),
                              style: TextStyle(color: HenryColors.puti, fontSize: 11.sp),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 6.h,
                      width: 10.w,
                      child: SizedBox(
                        height: orientation == Orientation.landscape ? 20.h : 8.h,
                        child: Image.asset(
                          'assets/img/belajandro_256.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: orientation == Orientation.landscape ? 12.h : 6.h,
                      width: 5.w,
                      child: Column(
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
                            '${sc.weatherList.first.location.name}, ${sc.weatherList.first.location.country}',
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
                ],
              ),
              SizedBox(
                height: orientation == Orientation.landscape ? 2.h : 3.h,
                width: double.infinity,
              ),
              SizedBox(
                height: orientation == Orientation.landscape ? 10.h : 5.h,
                width: double.infinity,
                child: Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                        location: 'NEW YORK, USA',
                        hourText: sc.newYork.value.substring(0, 2),
                        minuteText: sc.newYork.value.substring(3, 5),
                      ),
                      ClockSkin(
                        location: 'RIYADH, KSA',
                        hourText: sc.riyadh.value.substring(0, 2),
                        minuteText: sc.riyadh.value.substring(3, 5),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // SizedBox(
        //   height: orientation == Orientation.landscape ? 10.h : 8.h,
        //   child: Image.asset(
        //     'assets/img/belajandro_256.png',
        //     fit: BoxFit.contain,
        //   ),
        // ),
      ],
    );
  }
}
