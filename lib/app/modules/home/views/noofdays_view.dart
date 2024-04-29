import 'package:belajandro_kiosk/app/modules/home/controllers/home_controller.dart';
import 'package:belajandro_kiosk/app/modules/home/views/payment_type_view.dart';
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
  final String tituto;
  NoofdaysView({super.key, required this.tituto});
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
                  title: tituto,
                  fontSize: 20.sp,
                  color: HenryColors.lightGold,
                  fontFamily: atteron,
                ),
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 40.h,
                        width: 90.w,
                        child: SfDateRangePicker(
                          onSelectionChanged: hc.onSelectionChanged,
                          enableMultiView: true,
                          headerHeight: 5.h,
                          selectionMode: DateRangePickerSelectionMode.range,
                          // initialSelectedRange: PickerDateRange(sc.dtNow.value, sc.dtNow.value.add(2.days)),
                          enablePastDates: false,
                          showTodayButton: true,
                          selectionColor: HenryColors.teal,
                          startRangeSelectionColor: HenryColors.lightGold,
                          endRangeSelectionColor: HenryColors.lightGold,
                          rangeSelectionColor: HenryColors.lightGold.withOpacity(0.3),
                          selectionTextStyle: TextStyle(fontSize: 15.sp, fontFamily: bernardMT),
                          rangeTextStyle: TextStyle(fontSize: 15.sp, fontFamily: bernardMT),
                          headerStyle: DateRangePickerHeaderStyle(
                            textStyle: TextStyle(
                              color: HenryColors.lightGold,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: bernardMT,
                            ),
                          ),
                          monthViewSettings: DateRangePickerMonthViewSettings(
                            dayFormat: 'EEE',
                            viewHeaderHeight: 60,
                            weekendDays: const [7],
                            viewHeaderStyle: DateRangePickerViewHeaderStyle(
                              textStyle: TextStyle(fontSize: 15.sp, fontFamily: bernardMT),
                            ),
                            // weekNumberStyle: DateRangePickerWeekNumberStyle(
                            //   textStyle: TextStyle(
                            //     fontFamily: bernardMT,
                            //     fontSize: 15.sp,
                            //   ),
                            // ),
                          ),
                          monthCellStyle: DateRangePickerMonthCellStyle(
                            weekendTextStyle:
                                TextStyle(color: HenryColors.blueAccent, fontFamily: bernardMT, fontSize: 15.sp),
                            specialDatesTextStyle:
                                TextStyle(color: HenryColors.pula, fontFamily: bernardMT, fontSize: 15.sp),
                            textStyle: TextStyle(fontSize: 15.sp, color: HenryColors.itim, fontFamily: bernardMT),
                            todayTextStyle: TextStyle(
                              fontSize: 15.sp,
                              fontFamily: bernardMT,
                              color: HenryColors.gold,
                            ),
                            leadingDatesDecoration: BoxDecoration(
                                color: const Color(0xFFDFDFDF),
                                border: Border.all(color: const Color(0xFFB6B6B6), width: 1),
                                shape: BoxShape.circle),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                        width: double.infinity,
                      ),
                      SizedBox(
                        height: 6.h,
                        width: 35.w,
                        child: Obx(
                          () => Visibility(
                            visible: hc.noofdays.value != 0,
                            child: ElevatedButton(
                              onPressed: () async {
                                hc.isLoading.value = true;
                                final translatedText = await hc.iTranslate(
                                    languageCode: hc.languageCode.value, sourceText: 'SELECT PAYMENT TYPE');
                                final response = await hc.fetchPayment(langCode: hc.languageCode.value);
                                if (response!) {
                                  hc.isLoading.value = false;
                                  Get.to(
                                    () => PaymentTypeView(
                                      titulo: translatedText!,
                                    ),
                                  );
                                }
                              },
                              autofocus: true,
                              style: ElevatedButton.styleFrom(backgroundColor: HenryColors.teal),
                              child: hc.isLoading.value
                                  ? Text(
                                      'Processing..',
                                      style: TextStyle(color: HenryColors.puti, fontSize: 12.sp),
                                    )
                                  : Text(
                                      hc.noofdays.value == 0
                                          ? 'OK'
                                          : 'Agree (${hc.noofdays.value} ${hc.noofdays.value >= 2 ? 'days' : 'day'})?',
                                      style: TextStyle(
                                        color: HenryColors.puti,
                                        fontSize: 15.sp,
                                        // fontFamily: bernardMT,
                                      ),
                                    ),
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
