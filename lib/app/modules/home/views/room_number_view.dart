import 'package:belajandro_kiosk/app/modules/home/controllers/home_controller.dart';
import 'package:belajandro_kiosk/services/colors/service_colors.dart';
import 'package:belajandro_kiosk/services/constant/image_constant.dart';
import 'package:belajandro_kiosk/services/utils/styles_utils.dart';
import 'package:belajandro_kiosk/widgets/headers_widget.dart';
import 'package:belajandro_kiosk/widgets/loading_widget.dart';
import 'package:belajandro_kiosk/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:responsive_sizer/responsive_sizer.dart' as rs;

import 'package:get/get.dart';

class RoomNumberView extends GetView {
  final hc = Get.find<HomeController>();
  final String titulo;

  RoomNumberView({super.key, required this.titulo});
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
                          : SizedBox(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        hc.availableRoomList.first.roomType,
                                        style: TextStyle(
                                          color: HenryColors.puti,
                                          fontSize: 18.sp,
                                        ),
                                      ),
                                      Text(
                                        '${hc.availableRoomList.length} rooms',
                                        style: TextStyle(
                                          color: HenryColors.puti,
                                          fontSize: 18.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 30.sp,
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.nightlight_round,
                                        color: HenryColors.puti,
                                        size: 20.sp,
                                      ),
                                      title: Center(
                                        child: Text(
                                          hc.pera.format(hc.availableRoomList.first.rate),
                                          style: TextStyle(
                                            color: HenryColors.puti,
                                            fontSize: 20.sp,
                                          ),
                                        ),
                                      ),
                                      trailing: Icon(
                                        Icons.night_shelter,
                                        color: HenryColors.puti,
                                        size: 21.sp,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: MasonryGridView.count(
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: hc.availableRoomList.length,
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 5.sp,
                                      crossAxisSpacing: 5.sp,
                                      itemBuilder: (buildContext, index) {
                                        return Card(
                                          color: HenryColors.teal,
                                          child: ListTile(
                                            title: Text(
                                              hc.availableRoomList[index].description,
                                              style: TextStyle(
                                                color: HenryColors.puti,
                                                fontSize: 18.sp,
                                              ),
                                            ),
                                            subtitle: Text(
                                              hc.availableRoomList[index].bed == 1
                                                  ? '${hc.availableRoomList[index].bed} bed'
                                                  : '${hc.availableRoomList[index].bed} beds',
                                              style: TextStyle(
                                                color: HenryColors.puti,
                                                fontSize: 15.sp,
                                              ),
                                            ),
                                          ),
                                        );
                                        // return SizedBox(
                                        //   height: (index % 3 + 1) * 100,
                                        //   child: ListTile(
                                        //     title: Text(
                                        //       hc.availableRoomList[index].description,
                                        //       style: TextStyle(
                                        //         color: HenryColors.puti,
                                        //         fontSize: 18.sp,
                                        //       ),
                                        //     ),
                                        //   ),
                                        // );
                                      },
                                    ),
                                  ),
                                ],
                              ),
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
