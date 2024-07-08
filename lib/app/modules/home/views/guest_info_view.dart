import 'dart:math' as math;

import 'package:belajandro_kiosk/app/modules/home/controllers/home_controller.dart';
import 'package:belajandro_kiosk/app/modules/home/views/insert_payment_view.dart';
import 'package:belajandro_kiosk/app/modules/screen/controllers/screen_controller.dart';
import 'package:belajandro_kiosk/services/colors/service_colors.dart';
import 'package:belajandro_kiosk/services/constant/image_constant.dart';
import 'package:belajandro_kiosk/services/constant/ledlights_constant.dart';
import 'package:belajandro_kiosk/services/constant/service_constant.dart';
import 'package:belajandro_kiosk/services/utils/styles_utils.dart';
import 'package:belajandro_kiosk/widgets/headers_widget.dart';
import 'package:belajandro_kiosk/widgets/textformfield_widget.dart';
import 'package:belajandro_kiosk/widgets/title_widget.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:responsive_sizer/responsive_sizer.dart' as rs;

import 'package:get/get.dart';
import 'package:virtual_keyboard_custom_layout/virtual_keyboard_custom_layout.dart';
// ignore: depend_on_referenced_packages
import 'package:camera_platform_interface/camera_platform_interface.dart';

class GuestInfoView extends GetView {
  final String titulo;
  final hc = Get.find<HomeController>();
  final sc = Get.find<ScreenController>();

  GuestInfoView({super.key, required this.titulo});

  @override
  Widget build(BuildContext context) {
    final imgKey = GlobalKey();
    final formKey = GlobalKey();

    hc.emailAddress.addListener(() {
      if (hc.emailAddress.value.text.isEmail) {
        hc.isTextNotEmpty.value = true;
      } else {
        hc.isTextNotEmpty.value = false;
      }
    });

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
                Visibility(
                  visible: false,
                  child: SizedBox(
                    height: 10.h,
                    width: 35.w,
                    child: Transform(
                      key: imgKey,
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(math.pi),
                      child: Obx(
                        () => CameraPlatform.instance.buildPreview(hc.cameraID.value),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Obx(
                        () => Container(
                          padding: EdgeInsets.only(left: 25.sp, right: 25.sp, top: 10.sp, bottom: 10.sp),
                          child: Form(
                            key: formKey,
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: hc.isRegistered.value ? existingUser() : newUserRegistration(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 1.h,
                        width: double.infinity,
                      ),
                      // CUSTOM KEYBOARD
                      SizedBox(
                        height: 20.h,
                        width: 70.w,
                        child: Obx(
                          () => VirtualKeyboard(
                            textController: hc.globalTEC.value,
                            textColor: HenryColors.puti,
                            fontSize: 18.sp,
                            type: VirtualKeyboardType.Custom,
                            keys: hc.keypadType.value == "numeric"
                                ? hc.numericLamang
                                : hc.keypadType.value == "email"
                                    ? hc.emailKey
                                    : hc.customKey,
                            alwaysCaps: hc.keypadType.value == "email" ? false : true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //BUTTON REGISTER
                Obx(
                  () => Visibility(
                    visible: hc.isButtonSubmitReady.value,
                    child: SizedBox(
                      height: 5.h,
                      width: 25.w,
                      child: ElevatedButton(
                        onPressed: () async {
                          final result = await hc.addContacts(
                            prefixID: hc.selectedPrefixID.value,
                            firstName: hc.firstName.text,
                            mName: hc.middleName.text,
                            lastName: hc.lastName.text,
                            mobileNo: hc.phoneNumber.text,
                            emailAddress: hc.emailAddress.text,
                          );
                          if (result!) {
                            hc.disposeCamera();
                            Get.snackbar('Success', result.toString());
                          }
                        },
                        autofocus: true,
                        style: ElevatedButton.styleFrom(backgroundColor: HenryColors.teal),
                        child: Text(
                          'REGISTER',
                          style: TextStyle(color: HenryColors.puti, fontSize: 15.sp),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                SizedBox(
                  height: 5.h,
                  width: double.infinity,
                  child: InkWell(
                    onTap: () {
                      hc.disposeCamera();
                      hc.clearTextEditingController();
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

  Widget existingUser() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: KioskTextFormField(
                textEditingController: hc.emailAddress,
                tecLabel: "Input Valid Email Address for sending OTP",
                isNumeric: false,
                onTap: () async {
                  hc.globalTEC.value = hc.emailAddress;
                  hc.keypadType.value = 'email';
                },
                unahangICON: Icon(
                  Icons.abc,
                  color: HenryColors.puti,
                ),
              ),
            ),
            SizedBox(
              width: 3.w,
            ),
            Obx(
              () => Visibility(
                visible: hc.isTextNotEmpty.value,
                child: Expanded(
                  flex: 1,
                  child: TextButton.icon(
                    onPressed: () async {
                      if (hc.emailAddress.value.text.isEmail) {
                        hc.isLoading.value = true;
                        // final name =
                        //     "${hc.firstName.value.text.trim()} ${hc.middleName.value.text.trim()} ${hc.lastName.value.text.trim()}";
                        final result = await hc.fetchPeople(emailAddress: hc.emailAddress.value.text);
                        if (result!) {
                          hc.disposeCamera();
                          // hc.emailAddress.text = hc.peopleList.first.email;
                          hc.phoneNumber.text = hc.peopleList.first.mobileNo;

                          hc.isRegistered.value = true;
                          hc.isLoading.value = false;

                          final response = await hc.setupEmail(
                            emailAddressToSend: hc.emailAddress.value.text,
                          );

                          if (response) {
                            Get.snackbar(
                              'Success sent',
                              "OTP Sent",
                              colorText: HenryColors.puti,
                            );
                          } else {
                            Get.snackbar(
                              'Error Sending',
                              "failed to sent",
                              colorText: HenryColors.puti,
                            );
                          }
                        } else {
                          Get.snackbar(
                            'New User',
                            "Create New User",
                            colorText: HenryColors.puti,
                          );
                          hc.isRegistered.value = false;
                        }
                      }
                    },
                    icon: const Icon(Icons.password),
                    label: Text(
                      'Get OTP',
                      style: TextStyle(
                        color: HenryColors.puti,
                        fontSize: 15.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        //space
        SizedBox(
          height: 15.sp,
          width: double.infinity,
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: KioskTextFormField(
                textEditingController: hc.otp,
                tecLabel: "Input OTP for Verification",
                isNumeric: true,
                onTap: () async {
                  hc.globalTEC.value = hc.otp;
                  hc.keypadType.value = 'numeric';
                },
                unahangICON: Icon(
                  Icons.numbers,
                  color: HenryColors.puti,
                ),
              ),
            ),
            SizedBox(
              width: 2.w,
            ),
            Obx(
              () => Visibility(
                visible: hc.isTextNotEmpty.value,
                child: Expanded(
                  flex: 2,
                  child: hc.isLoading.value
                      ? const CircularProgressIndicator.adaptive()
                      : TextButton.icon(
                          onPressed: () async {
                            final response = EmailOTP.verifyOTP(otp: hc.otp.text);
                            if (response) {
                              hc.isLoading.value = true;
                              // Get.defaultDialog(title: "Verified", middleText: "Na verified kang hayop ka");
                              var translatedText = "Suggested Guest Room";
                              if (hc.languageID.value > 1) {
                                translatedText = (await hc.iTranslate(
                                    languageCode: hc.languageCode.value, sourceText: translatedText))!;
                              }

                              // DITO RIN ILAGAY ANG INITIALIZING THE CASH ACCEPTOR
                              final response = await hc.sendKioskCommand(
                                  sCommand: GlobalConstant.startCashAcceptor, apiKEY: sc.apiKEY);
                              if (response) {
                                // await hc.startCashAcceptor();
                                await hc.fetchTerminalData(terminalID: hc.terminalNo);
                                hc.signalLEDLights(sCommandMode: LedlightsConstant.cashDispenserON, comPort: 'COM1');
                                Get.to(
                                  () => InsertPaymentView(
                                    titulo: translatedText,
                                  ),
                                );

                                // if (hc.terminalDataList.isNotEmpty) {
                                //   //update the terminal data to read
                                //   final res = hc.terminalDataList.where((element) =>
                                //       element.terminalId == hc.terminalNo &&
                                //       element.code == GlobalConstant.startCashAcceptor);
                                //   if (res.isNotEmpty) {
                                //     await hc.updateTerminalData(
                                //         tableID: res.first.id, terminalID: res.first.terminalId, code: res.first.code);
                                //     hc.isLoading.value = false;
                                //     Get.to(
                                //       () => InsertPaymentView(
                                //         titulo: translatedText,
                                //       ),
                                //     );
                                //   }
                                // }
                              }
                            } else {
                              Get.snackbar(
                                'Failed',
                                "Failed to Verify OTP",
                                colorText: HenryColors.puti,
                              );
                            }
                          },
                          icon: const Icon(Icons.password),
                          label: Text(
                            'Verify OTP',
                            style: TextStyle(
                              color: HenryColors.puti,
                              fontSize: 15.sp,
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget newUserRegistration() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 1,
              //HONORIFICS
              child: SizedBox(
                height: 4.h,
                child: Obx(
                  () => DropdownButtonHideUnderline(
                    child: DropdownSearch<String>(
                      items: hc.prefixList.map((e) => e.description).toList(),
                      onChanged: (newvalue) {
                        hc.selectedPrefixData.value = newvalue!;
                      },
                      selectedItem: hc.selectedPrefixData.value,
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: 'Honorifics',
                          filled: true,
                          labelStyle: TextStyle(
                            color: HenryColors.itim,
                          ),
                        ),
                        textAlign: TextAlign.center,
                        baseStyle: TextStyle(color: HenryColors.itim, fontSize: 15.sp),
                      ),
                      popupProps: PopupProps.menu(
                        // showSearchBox: true,
                        showSelectedItems: true,
                        searchDelay: 100.ms,
                        menuProps: MenuProps(
                          elevation: 5,
                          backgroundColor: HenryColors.puti,
                          borderOnForeground: true,
                        ),
                        title: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Center(
                            child: Text(
                              'List of Honorifics',
                              style: TextStyle(
                                color: HenryColors.gold,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 0.5.h,
              width: 1.w,
            ),
            // FIRSTNAME
            Expanded(
              flex: 3,
              child: KioskTextFormField(
                textEditingController: hc.firstName,
                tecLabel: ' FIRST NAME ',
                isNumeric: false,
                onTap: () {
                  hc.globalTEC.value = hc.firstName;
                  hc.isNumericKeypad.value = false;
                  hc.keypadType.value = 'text';
                },
                unahangICON: Icon(
                  Icons.abc,
                  color: HenryColors.puti,
                ),
              ),
            ),
            SizedBox(
              height: 0.5.h,
              width: 1.w,
            ),
            Expanded(
              flex: 1,
              child: KioskTextFormField(
                textEditingController: hc.middleName,
                tecLabel: ' M.I. ',
                isNumeric: false,
                onTap: () {
                  // if (hc.firstName.text.isEmpty) {
                  //   Get.defaultDialog(
                  //     middleText: "Cannot proceed with an empty string.",
                  //   );
                  //   // FocusScope.of(context).requestFocus(hc.focusNode);
                  // }
                  // hc.globalTEC.value = hc.middleName;
                  // hc.keypadType.value = 'text';
                },
                unahangICON: Icon(
                  Icons.abc,
                  color: HenryColors.puti,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 0.5.h,
          width: double.infinity,
        ),
        SizedBox(
          height: 1.h,
          width: double.infinity,
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: KioskTextFormField(
                textEditingController: hc.lastName,
                tecLabel: ' LAST NAME ',
                isNumeric: false,
                onTap: () {
                  // if (hc.middleName.text.isEmpty) {
                  //   Get.defaultDialog(
                  //     middleText: "Cannot proceed with an empty string.",
                  //   );
                  // }
                  hc.isLoading.value = false;

                  hc.globalTEC.value = hc.lastName;
                  hc.keypadType.value = 'text';
                },
                unahangICON: Icon(
                  Icons.abc,
                  color: HenryColors.puti,
                ),
              ),
            ),
            SizedBox(
              width: 1.w,
            ),
            Expanded(
              flex: 2,
              child: KioskTextFormField(
                textEditingController: hc.phoneNumber,
                tecLabel: "MOBILE#",
                isNumeric: true,
                onTap: () {
                  if (hc.phoneNumber.text.isEmpty) {
                    Get.defaultDialog(
                      middleText: "Cannot proceed with an empty string.",
                    );
                  }
                  hc.globalTEC.value = hc.phoneNumber;
                  // hc.isNumericKeypad.value = true;
                  hc.keypadType.value = 'numeric';
                  hc.isLoading.value = false;
                },
                unahangICON: Icon(
                  Icons.phone,
                  color: HenryColors.puti,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 1.h,
          width: double.infinity,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 3,
              child: KioskTextFormField(
                textEditingController: hc.emailAddress,
                tecLabel: "EMAIL ADDRESS",
                isNumeric: false,
                onTap: () async {
                  if (hc.phoneNumber.text.isEmpty) {
                    Get.defaultDialog(
                      middleText: "Cannot proceed with an empty string.",
                    );
                  }
                  hc.isLoading.value = true;
                  // final name =
                  //     "${hc.firstName.value.text.trim()} ${hc.middleName.value.text.trim()} ${hc.lastName.value.text.trim()}";
                  // final result = await hc.fetchPeople(name: name, mobileNo: hc.phoneNumber.value.text);
                  // if (result!) {
                  //   hc.emailAddress.text = hc.peopleList.first.email;
                  //   hc.isRegistered.value = true;
                  // }
                  hc.isLoading.value = false;
                  //search existing record
                  hc.globalTEC.value = hc.emailAddress;
                  hc.keypadType.value = 'email';
                },
                unahangICON: Icon(
                  Icons.alternate_email,
                  color: HenryColors.puti,
                ),
              ),
            ),
            // SizedBox(
            //   width: 1.w,
            // ),
            Expanded(
              flex: 1,
              child: Obx(
                () => Visibility(
                  visible: !hc.isButtonSubmitReady.value,
                  child: TextButton.icon(
                    onPressed: () async {
                      if (hc.firstName.text.isNotEmpty &&
                          // hc.middleName.text.isNotEmpty &&
                          hc.lastName.text.isNotEmpty &&
                          hc.phoneNumber.text.isNotEmpty &&
                          hc.emailAddress.text.isNotEmpty) {
                        hc.isButtonSubmitReady.value = true;
                      }
                      var translatedText = "Suggested Guest Room";
                      if (hc.languageID.value > 1) {
                        translatedText =
                            (await hc.iTranslate(languageCode: hc.languageCode.value, sourceText: translatedText))!;
                      }

                      Get.to(
                        () => InsertPaymentView(
                          titulo: translatedText,
                        ),
                      );
                    },
                    icon: const Icon(Icons.done),
                    label: Text(
                      'Finish',
                      style: TextStyle(
                        color: HenryColors.puti,
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
