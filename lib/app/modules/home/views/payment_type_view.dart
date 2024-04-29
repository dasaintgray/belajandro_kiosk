import 'package:belajandro_kiosk/app/modules/home/controllers/home_controller.dart';
import 'package:belajandro_kiosk/services/colors/service_colors.dart';
import 'package:belajandro_kiosk/services/constant/image_constant.dart';
import 'package:belajandro_kiosk/services/utils/font_utils.dart';
import 'package:belajandro_kiosk/widgets/headers_widget.dart';
import 'package:belajandro_kiosk/widgets/menu_widget.dart';
import 'package:belajandro_kiosk/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart' as rs;

import 'package:get/get.dart';

class PaymentTypeView extends GetView {
  final String titulo;
  final hc = Get.find<HomeController>();
  PaymentTypeView({super.key, required this.titulo});
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
                  title: titulo,
                  fontSize: 20.sp,
                  color: HenryColors.lightGold,
                  fontFamily: atteron,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 35.sp, right: 35.sp, top: 10.sp, bottom: 10.sp),
                    child: ListView.builder(
                      itemCount: hc.paymentTypeList.length,
                      itemBuilder: (context, index) {
                        return MenuWidget(
                          titleName: hc.paymentTypeList[index].description,
                          imageName: 'assets/icons/payment${hc.paymentTypeList[index].id}.png',
                          cardColor: HenryColors.teal,
                          shadowColor: HenryColors.teal.withOpacity(0.5),
                          onTap: () {},
                        );
                      },
                    ),
                  ),
                ),
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
