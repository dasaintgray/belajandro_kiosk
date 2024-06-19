import 'package:belajandro_kiosk/app/modules/home/controllers/home_controller.dart';
import 'package:belajandro_kiosk/app/modules/home/views/room_type_view.dart';
import 'package:belajandro_kiosk/app/modules/screen/controllers/screen_controller.dart';
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

class CiprocessView extends GetView {
  // call the controller
  final hc = Get.find<HomeController>();
  final sc = Get.find<ScreenController>();

  CiprocessView({super.key});

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
                  title: hc.titleList.first.translationText,
                  textStyle: titleTextStyle,
                ),
                Expanded(
                  child: Obx(
                    () => Container(
                      padding: EdgeInsets.symmetric(horizontal: 35.sp, vertical: 20.sp),
                      child: hc.isLoading.value
                          ? LoadingWidget(
                              lottieFiles: hc.generateLotties(),
                            )
                          : ListView.builder(
                              itemCount: hc.pageList.length,
                              itemBuilder: (context, index) {
                                return MenuWidget(
                                  titleName: hc.pageList[index].translationText,
                                  imageName: 'assets/icons/${hc.pageList[index].images}',
                                  cardColor: HenryColors.teal,
                                  shadowColor: HenryColors.teal.withOpacity(0.5),
                                  onTap: () async {
                                    switch (index) {
                                      case 0: //booked room
                                        Get.defaultDialog(
                                          title: 'Info',
                                          middleText: 'To be follow',
                                        );
                                        break;
                                      case 1: //walkin
                                        hc.isLoading.value = true;
                                        final response = await hc.fetchRoomTypes(
                                            langCode: hc.languageCode.value, agentID: sc.iAgentID.value);
                                        if (hc.languageID.value != 1) {
                                          hc.pageTitle.value = (await hc.iTranslate(
                                              languageCode: hc.languageCode.value, sourceText: 'SELECT ROOM TYPE'))!;
                                          hc.isLoading.value = false;
                                        } else {
                                          hc.isLoading.value = false;
                                          hc.pageTitle.value = 'SELECT ROOM TYPE';
                                        }
                                        if (response!) {
                                          Get.to(
                                            () => RoomTypeView(
                                              titulo: hc.pageTitle.value,
                                            ),
                                          );
                                        }
                                        break;
                                      default:
                                    }
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
                      final result = hc.makeMenu(languageID: hc.languageID.value, code: 'ST');
                      result ? Get.back() : Get.snackbar('Error', 'Unable to get back');
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
