import 'package:belajandro_kiosk/app/modules/home/controllers/home_controller.dart';
import 'package:belajandro_kiosk/app/modules/home/views/printing_view.dart';
import 'package:belajandro_kiosk/app/modules/screen/controllers/screen_controller.dart';
import 'package:belajandro_kiosk/services/colors/service_colors.dart';
import 'package:belajandro_kiosk/services/constant/image_constant.dart';
import 'package:belajandro_kiosk/services/constant/ledlights_constant.dart';
import 'package:belajandro_kiosk/services/constant/service_constant.dart';
import 'package:belajandro_kiosk/services/utils/styles_utils.dart';
import 'package:belajandro_kiosk/widgets/headers_widget.dart';
import 'package:belajandro_kiosk/widgets/loading_widget.dart';
import 'package:belajandro_kiosk/widgets/title_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart' as rs;

import 'package:get/get.dart';

class InsertPaymentView extends GetView {
  final String titulo;
  final hc = Get.find<HomeController>();
  final sc = Get.find<ScreenController>();

  InsertPaymentView({super.key, required this.titulo});
  @override
  Widget build(BuildContext context) {
    return rs.ResponsiveSizer(
      builder: (buildContext, orientation, screenType) {
        hc.totalAmountDue.value =
            hc.reactiveRoomTypeList.where((p0) => p0.id == hc.selectedRoomType.value).first.price.first.rate *
                hc.noofdays.value;

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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  flex: 1,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hc.peopleList.first.name,
                        style: contentTextStyle,
                      ),
                      Text(
                        '${hc.reactiveRoomTypeList.where((p0) => p0.id == hc.selectedRoomType.value).first.description}, ${hc.selectedRooNumber.value}',
                        style: contentTextStyle15,
                      ),
                      Text(
                        '${hc.pera.format(hc.reactiveRoomTypeList.where((p0) => p0.id == hc.selectedRoomType.value).first.price.first.rate)}/night X ${hc.noofdays.value}',
                        style: contentTextStyle15,
                      ),
                      Text(
                        'Payable: ${hc.pera.format(hc.totalAmountDue.value)}',
                        style: contentTextStyle15,
                      ),
                      // Text(
                      //   'Payable: ${hc.pera.format(hc.reactiveRoomTypeList.where((p0) => p0.id == hc.selectedRoomType.value).first.price.first.rate * hc.noofdays.value)}',
                      //   style: contentTextStyle15,
                      // ),

                      Text(
                        hc.selectedLockCode.value,
                        style: contentTextStyle15,
                      ),
                      // Text(
                      //   hc.reactiveRoomTypeList.where((p0) => p0.id == hc.selectedRoomType.value).first.code,
                      //   style: contentTextStyle15,
                      // ),
                      // Text(
                      //   hc.reactiveRoomTypeList.where((p0) => p0.id == hc.selectedRoomType.value).first.description,
                      //   style: contentTextStyle15,
                      // ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Obx(
                    () => Column(
                      children: [
                        Text(
                          hc.nabasangPera.value == 0.00 ? '~ Please Insert Payment ~' : "~ Bank Note's Received ~",
                          style: titleTextStyle,
                        ),
                        SizedBox(
                          height: 25.h,
                          child: hc.nabasangPera.value == 0.00
                              ? const LoadingWidget(
                                  lottieFiles: 'assets/lotties/card.lottie',
                                )
                              : hc.isOverPaymentDetected.value
                                  ? Text(
                                      'Read: ${hc.pera.format(hc.nabasangPera.value)}, \nOver Payment: ${hc.pera.format(hc.overPayment.value)}',
                                      style: contentTextStyle,
                                      textAlign: TextAlign.center,
                                    )
                                  : Text(
                                      hc.pera.format(hc.nabasangPera.value),
                                      style: contentTextStyle,
                                    ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.h,
                  width: double.infinity,
                  child: Obx(() => Visibility(
                        visible: hc.nabasangPera.value != 0.00,
                        child: ElevatedButton(
                          onPressed: () async {
                            final response =
                                await hc.sendKioskCommand(sCommand: GlobalConstant.stopCashAcceptor, apiKEY: sc.apiKEY);
                            if (response) {
                              //finalizination of guest check in
                              //printing the receipt and
                              //and release the card
                              final vat = '1.${sc.iVat}';
                              final computeVat = hc.totalAmountDue.value / double.parse(vat);
                              final tax = hc.totalAmountDue.value - computeVat;

                              hc.signalLEDLights(
                                  sCommandMode: LedlightsConstant.cashDispenserOFF,
                                  comPort: kDebugMode ? 'COM1' : hc.globalEnv['LED_LIGHTS_PORT']);
                              hc.signalLEDLights(
                                  sCommandMode: LedlightsConstant.printingON,
                                  comPort: kDebugMode ? 'COM1' : hc.globalEnv['LED_LIGHTS_PORT']);
                              final response = hc.printResibo(
                                address: sc.sCompanyAddress.value,
                                owner: sc.settingsList.first.data.settings
                                    .where((element) => element.code == 'R13')
                                    .first
                                    .value,
                                telephone: sc.settingsList.first.data.settings
                                    .where((element) => element.code == 'R3')
                                    .first
                                    .value,
                                email: sc.settingsList.first.data.settings
                                    .where((element) => element.code == 'R5')
                                    .first
                                    .value,
                                vatTin: '008-664-218-00000',
                                bookingID: 123,
                                terminalID: hc.terminalNo,
                                qty: 1,
                                roomRate: hc.salapi.format(hc.totalAmountDue.value),
                                roomType: hc.reactiveRoomTypeList
                                    .where((element) => element.id == hc.selectedRoomType.value)
                                    .first
                                    .description,
                                deposit: '0.00',
                                totalAmount: hc.salapi.format(hc.totalAmountDue.value),
                                totalAmountPaid: hc.salapi.format(hc.nabasangPera.value),
                                paymentMethod: hc.paymentTypeList
                                    .where((element) => element.id == hc.selectedPaymentType.value)
                                    .first
                                    .description,
                                changeValue: hc.salapi.format(hc.overPayment.value),
                                currencyString: 'PHP',
                                vatTable: computeVat.toStringAsFixed(2),
                                vatTax: tax.toStringAsFixed(2),
                                roomNumber: hc.selectedRooNumber.value,
                                timeConsume: hc.daysToStay.value,
                                endTime: '${hc.checkOutDate} @ ${sc.checkOutTime}',
                                standardCI:
                                    'Standard ${sc.settingsList.first.data.settings.where((element) => element.code == 'C1').first.description} : ${sc.settingsList.first.data.settings.where((element) => element.code == 'C1').first.value}',
                                standardCO:
                                    'Standard ${sc.settingsList.first.data.settings.where((element) => element.code == 'O1').first.description} : ${sc.settingsList.first.data.settings.where((element) => element.code == 'O1').first.value}',
                                isOR: false,
                                isSelfCheck: false,
                              );
                              if (response) {
                                hc.signalLEDLights(
                                    sCommandMode: LedlightsConstant.printingOFF,
                                    comPort: kDebugMode ? 'COM1' : hc.globalEnv['LED_LIGHTS_PORT']);

                                // Get.to(
                                //   () => PrintingView(),
                                // );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: HenryColors.teal),
                          child: Text(
                            'CHECK-IN',
                            style: TextStyle(
                              color: HenryColors.puti,
                              fontSize: 15.sp,
                            ),
                          ),
                        ),
                      )),
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
