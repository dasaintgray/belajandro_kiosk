import 'package:belajandro_kiosk/app/modules/home/controllers/home_controller.dart';
import 'package:belajandro_kiosk/app/modules/screen/controllers/screen_controller.dart';
import 'package:belajandro_kiosk/services/colors/service_colors.dart';
import 'package:belajandro_kiosk/services/constant/image_constant.dart';
import 'package:belajandro_kiosk/services/utils/font_utils.dart';
import 'package:belajandro_kiosk/widgets/headers_widget.dart';
import 'package:belajandro_kiosk/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart' as rs;

import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class NoofdaysView extends GetView {
  final hc = Get.find<HomeController>();
  final sc = Get.find<ScreenController>();

  NoofdaysView({super.key});
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
                  title: 'SELECT NUMBER OF DAYS',
                  fontSize: 20.sp,
                  color: HenryColors.lightGold,
                  fontFamily: atteron,
                ),
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 40.h,
                        width: 70.w,
                        child: SfDateRangePicker(
                          onSelectionChanged: hc.onSelectionChanged,
                          headerHeight: 5.h,
                          selectionMode: DateRangePickerSelectionMode.range,
                          initialSelectedRange: PickerDateRange(sc.dtNow.value, sc.dtNow.value.add(3.days)),
                          enablePastDates: false,
                          headerStyle: DateRangePickerHeaderStyle(
                            textStyle: TextStyle(
                              color: HenryColors.lightGold,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: bernardMT,
                            ),
                          ),
                        ),
                      ),
                      Obx(
                        () => ListTile(
                          leading: Text(
                            'Range Count: ${hc.rangeCount.value}',
                            style: TextStyle(
                              color: HenryColors.puti,
                            ),
                          ),
                          title: Center(
                            child: Text(
                              'Range Value: ${hc.range.value}',
                              style: TextStyle(
                                color: HenryColors.puti,
                              ),
                            ),
                          ),
                          subtitle: Center(
                            child: Text(
                              'Selected: ${hc.selectedDate.value}',
                              style: TextStyle(
                                color: HenryColors.puti,
                              ),
                            ),
                          ),
                          trailing: Text(
                            'Date Count: ${hc.dateCount.value}',
                            style: TextStyle(
                              color: HenryColors.puti,
                            ),
                          ),
                        ),
                      ),
                    ],
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
