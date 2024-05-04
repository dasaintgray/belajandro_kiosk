import 'package:belajandro_kiosk/app/modules/home/controllers/home_controller.dart';
import 'package:belajandro_kiosk/app/modules/home/views/noofdays_view.dart';
import 'package:belajandro_kiosk/services/colors/service_colors.dart';
import 'package:belajandro_kiosk/services/constant/image_constant.dart';
import 'package:belajandro_kiosk/services/utils/styles_utils.dart';
import 'package:belajandro_kiosk/widgets/headers_widget.dart';
import 'package:belajandro_kiosk/widgets/loading_widget.dart';
import 'package:belajandro_kiosk/widgets/menu_widget.dart';
import 'package:belajandro_kiosk/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart' as rs;

import 'package:get/get.dart';

class RoomTypeView extends GetView {
  final hc = Get.find<HomeController>();
  final String titulo;
  RoomTypeView({super.key, required this.titulo});
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
                  title: titulo,
                  textStyle: titleTextStyle,
                ),
                Expanded(
                  child: Obx(
                    () => Container(
                      padding: EdgeInsets.only(left: 35.sp, right: 35.sp, top: 10.sp, bottom: 10.sp),
                      child: hc.isLoading.value
                          ? LoadingWidget(
                              lottieFiles: hc.generateLotties(),
                            )
                          : ListView.builder(
                              itemCount: hc.roomTypeList.length,
                              itemBuilder: (context, index) {
                                return MenuWidget(
                                  titleName: hc.roomTypeList[index].description,
                                  imageName: ImageConstant.belajandroICON,
                                  cardColor: HenryColors.teal,
                                  shadowColor: HenryColors.teal.withOpacity(0.5),
                                  onTap: () async {
                                    hc.isLoading.value = true;
                                    hc.selectedRoomType.value = hc.roomTypeList[index].id;
                                    if (hc.languageID.value != 1) {
                                      hc.pageTitle.value = (await hc.iTranslate(
                                          languageCode: hc.languageCode.value, sourceText: 'SELECT NUMBER OF DAYS'))!;
                                      hc.isLoading.value = false;
                                    } else {
                                      hc.isLoading.value = false;
                                      hc.pageTitle.value = 'SELECT NUMBER OF DAYS';
                                    }
                                    Get.to(
                                      () => NoofdaysView(
                                        tituto: hc.pageTitle.value,
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
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