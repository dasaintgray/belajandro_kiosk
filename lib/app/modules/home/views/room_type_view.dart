import 'package:belajandro_kiosk/app/modules/home/controllers/home_controller.dart';
import 'package:belajandro_kiosk/app/modules/home/views/noofdays_view.dart';
import 'package:belajandro_kiosk/services/colors/service_colors.dart';
import 'package:belajandro_kiosk/services/constant/image_constant.dart';
import 'package:belajandro_kiosk/services/utils/font_utils.dart';
import 'package:belajandro_kiosk/services/utils/styles_utils.dart';
import 'package:belajandro_kiosk/widgets/headers_widget.dart';
import 'package:belajandro_kiosk/widgets/loading_widget.dart';
import 'package:belajandro_kiosk/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:responsive_sizer/responsive_sizer.dart' as rs;

import 'package:get/get.dart';
import 'package:stacked_list_carousel/stacked_list_carousel.dart';
import 'package:flutter_html_reborn/flutter_html_reborn.dart';

class RoomTypeView extends GetView {
  final hc = Get.find<HomeController>();
  final String titulo;
  RoomTypeView({super.key, required this.titulo});
  @override
  Widget build(BuildContext context) {
    // GALING NG CHECK IN PROCESS VIEW
    // final priceFormat = NumberFormat("#,##0.00", "en_PH",);
    // final pera = NumberFormat.currency(locale: "en_PH", symbol: "P");

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
                      padding: EdgeInsets.only(left: 30.sp, right: 30.sp, top: 5.sp, bottom: 5.sp),
                      child: hc.isLoading.value
                          ? LoadingWidget(
                              lottieFiles: hc.generateLotties(),
                            )
                          : stackedListCarousel(),
                    ),
                    //listViewMode()),
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

  Widget listViewMode() {
    return ListView.builder(
      itemCount: hc.reactiveRoomTypeList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  // color: HenryColors.teal.withOpacity(.5),
                  color: HenryColors.teal.withOpacity(0.5),
                  blurRadius: 8.0, // soften the shadow
                  spreadRadius: 0.0, //extend the shadow
                  offset: const Offset(
                    5.0, // Move to right 10  horizontally
                    5.0, // Move to bottom 10 Vertically
                  ),
                )
              ],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Card(
              color: HenryColors.teal,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: ListTile(
                leading: Icon(
                  Icons.night_shelter_rounded,
                  color: HenryColors.puti,
                  size: 18.sp,
                ),
                title: Text(
                  hc.reactiveRoomTypeList[index].description,
                  style: TextStyle(
                    color: HenryColors.puti,
                    fontSize: 18.sp,
                  ),
                ),
                subtitle: Text(
                  hc.pera.format(hc.reactiveRoomTypeList[index].price.first.rate),
                  style: TextStyle(
                    color: HenryColors.puti,
                    fontSize: 13.sp,
                  ),
                ),
                trailing: CircleAvatar(
                  minRadius: 30,
                  maxRadius: 40,
                  backgroundColor: HenryColors.puti,
                  child: Text(
                    '${hc.reactiveRoomTypeList[index].available.total.count}',
                    style: TextStyle(
                      color: HenryColors.teal,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
                onTap: () async {
                  hc.isLoading.value = true;
                  hc.selectedRoomType.value = hc.reactiveRoomTypeList[index].id;
                  if (hc.languageID.value != 1) {
                    hc.pageTitle.value = (await hc.iTranslate(
                        languageCode: hc.languageCode.value, sourceText: 'SELECT NUMBER OF DAYS'))!;
                    hc.isLoading.value = false;
                  } else {
                    hc.isLoading.value = false;
                    hc.pageTitle.value = 'SELECT NUMBER OF DAYS';
                  }
                  await hc.getCamera();
                  final buttonText = await hc.iTranslate(languageCode: hc.languageCode.value, sourceText: "Agree");
                  hc.isLoading.value = true;
                  await hc.fetchAvailableRooms(agentID: hc.iAgentTypeID.value, roomTypeID: hc.selectedRoomType.value);

                  Get.to(
                    () => NoofdaysView(
                      tituto: hc.pageTitle.value,
                      buttonText: buttonText!,
                    ),
                  );
                },
              ),
            ),
          ).animate().flip(delay: 300.ms, duration: 500.ms).shimmer(duration: 300.ms),
        );
      },
    );
  }

  Widget stackedListCarousel() {
    return StackedListCarousel(
      items: hc.reactiveRoomTypeList,
      animationDuration: 2000.ms,
      transitionCurve: Curves.elasticOut,
      cardBuilder: (context, item, size) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: Stack(
            children: [
              item.picture.isEmpty
                  ? Image.asset(
                      ImageConstant.noImageAvailable,
                      width: size.width,
                      height: size.height,
                      fit: BoxFit.cover,
                    )
                  : Image.memory(
                      hc.loadImage(item.picture),
                      width: size.width,
                      height: size.height,
                      fit: BoxFit.cover,
                      colorBlendMode: BlendMode.dstATop,
                    ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.description,
                        style: TextStyle(
                          color: HenryColors.puti,
                          fontSize: 25.sp,
                          backgroundColor: HenryColors.itim.withOpacity(0.2),
                          fontFamily: bernardMT,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        '${hc.pera.format(item.price.first.rate)}/night',
                        style: TextStyle(
                          color: HenryColors.puti,
                          fontSize: 20.sp,
                          backgroundColor: HenryColors.itim.withOpacity(0.2),
                        ),
                      ),
                      Expanded(
                        child: Html(
                          data: item.remarks,
                          style: {
                            "div": Style(
                              border: const Border(
                                bottom: BorderSide(color: Colors.grey),
                                top: BorderSide(color: Colors.grey),
                              ),
                              fontSize: FontSize(30.0),
                              color: HenryColors.itim,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                            "ul": Style(
                              border: const Border(
                                bottom: BorderSide(color: Colors.grey),
                                top: BorderSide(color: Colors.grey),
                              ),
                              fontSize: FontSize(30.0),
                              color: HenryColors.itim,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                          },
                          // style: {
                          //   "p.fancy": Style(
                          //     textAlign: TextAlign.center,
                          //     // padding: const EdgeInsets.all(16),
                          //     backgroundColor: HenryColors.gold,
                          //     fontSize: FontSize(100),
                          //     margin: Margins(left: Margin(80, Unit.px), right: Margin.auto()),
                          //     width: Width(300, Unit.px),
                          //     fontWeight: FontWeight.bold,
                          //   ),
                          // },
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            hc.isLoading.value = true;
                            hc.selectedRoomType.value = item.id;
                            if (hc.languageID.value != 1) {
                              hc.pageTitle.value = (await hc.iTranslate(
                                  languageCode: hc.languageCode.value, sourceText: 'SELECT NUMBER OF DAYS'))!;
                              hc.isLoading.value = false;
                            } else {
                              hc.isLoading.value = false;
                              hc.pageTitle.value = 'SELECT NUMBER OF DAYS';
                            }
                            await hc.getCamera();
                            final buttonText =
                                await hc.iTranslate(languageCode: hc.languageCode.value, sourceText: "SELECT");
                            hc.isLoading.value = true;
                            await hc.fetchAvailableRooms(
                                agentID: hc.iAgentTypeID.value, roomTypeID: hc.selectedRoomType.value);

                            Get.to(
                              () => NoofdaysView(
                                tituto: hc.pageTitle.value,
                                buttonText: buttonText!,
                              ),
                            );
                          },
                          autofocus: true,
                          style: ElevatedButton.styleFrom(backgroundColor: HenryColors.teal),
                          child: Text(
                            'SELECT',
                            style: TextStyle(color: HenryColors.puti, fontSize: 15.sp),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      behavior: CarouselBehavior.loop,
    ).animate().flip(delay: 300.ms, duration: 500.ms).shimmer(duration: 300.ms);
  }
}
