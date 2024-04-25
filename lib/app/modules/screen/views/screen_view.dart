import 'package:belajandro_kiosk/app/modules/home/views/home_view.dart';
import 'package:belajandro_kiosk/services/colors/service_colors.dart';
import 'package:belajandro_kiosk/services/constant/image_constant.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart' as rs;

import 'package:get/get.dart';

import '../controllers/screen_controller.dart';

class ScreenView extends GetView<ScreenController> {
  ScreenView({super.key});

  final sc = Get.find<ScreenController>();

  @override
  Widget build(BuildContext context) {
    return rs.ResponsiveSizer(
      builder: (buildContext, orientation, screenType) {
        return Scaffold(
          body: GestureDetector(
            onTap: () {
              Get.to(() => HomeView());
            },
            child: Container(
              // height: 100.h,
              width: double.infinity,
              padding: EdgeInsets.all(10.sp),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ImageConstant.screenSaver),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 15.h,
                          width: 5.w,
                          color: HenryColors.teal,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Image.asset(
                              'assets/img/cmlogo.png',
                              fit: BoxFit.contain,
                              height: 10.h,
                              width: 10.w,
                            ),
                          ),
                        ),
                      ),
                      Obx(
                        () => Expanded(
                          flex: 3,
                          child: Container(
                            height: 15.h,
                            width: 30.w,
                            color: HenryColors.blueAccent,
                            child: sc.isLoading.value
                                ? SizedBox(
                                    height: 5.h,
                                    width: 5.w,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        // const CircularProgressIndicator.adaptive(),
                                        Text(
                                          'Fetching Weather...',
                                          style: TextStyle(
                                            color: HenryColors.puti,
                                            fontSize: 10.sp,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Image.network(
                                        sc.imgURL.value,
                                        fit: BoxFit.contain,
                                        height: 25.h,
                                        width: 15.w,
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Temp: ${sc.weatherList.first.current.tempC.round()} ºC',
                                            style: TextStyle(
                                              color: HenryColors.puti,
                                              fontSize: 12.sp,
                                              // fontFamily: 'Roboto',
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                          Text(
                                            'Feels: ${sc.weatherList.first.current.feelslikeC.round()} ºC',
                                            style: TextStyle(
                                              color: HenryColors.puti,
                                              fontSize: 12.sp,
                                              // fontFamily: 'Roboto',
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                          Text(
                                            'Humidity: ${sc.weatherList.first.current.humidity.round()} %',
                                            style: TextStyle(
                                              color: HenryColors.puti,
                                              fontSize: 12.sp,
                                              // fontFamily: 'Roboto',
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                          Text(
                                            sc.weatherList.first.current.condition.text,
                                            style: TextStyle(
                                              color: HenryColors.puti,
                                              fontSize: 10.sp,
                                              // fontFamily: 'Roboto',
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 15.h,
                          width: 20.w,
                          color: HenryColors.green,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                DateFormat.EEEE().format(sc.dtNow),
                                style: TextStyle(
                                  color: HenryColors.puti,
                                  fontSize: 15.sp,
                                ),
                              ),
                              Text(
                                DateFormat.yMMMMd().format(sc.dtNow),
                                style: TextStyle(
                                  color: HenryColors.puti,
                                  fontSize: 12.sp,
                                ),
                              ),
                              Obx(
                                () => Text(
                                  sc.oras.value.toString(),
                                  style: TextStyle(
                                    color: HenryColors.puti,
                                    fontSize: 11.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  // SizedBox(
                  //   height: orientation == Orientation.landscape ? 10.h : 25.h,
                  //   width: double.infinity,
                  // ),
                  // SizedBox(
                  //   height: orientation == Orientation.landscape ? 45.h : 20.h,
                  //   width: double.infinity,
                  //   child: Image.asset(
                  //     'assets/img/belajandro_logo.png',
                  //     fit: BoxFit.contain,
                  //     height: 15.h,
                  //     width: 15.w,
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 15.h,
                  //   width: 35.w,
                  //   child: Image.asset(
                  //     'assets/img/tap.png',
                  //     fit: BoxFit.contain,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
