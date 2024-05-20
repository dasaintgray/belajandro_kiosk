import 'dart:math' as math;

import 'package:belajandro_kiosk/app/modules/home/controllers/home_controller.dart';
import 'package:belajandro_kiosk/services/colors/service_colors.dart';
import 'package:belajandro_kiosk/services/constant/image_constant.dart';
import 'package:belajandro_kiosk/services/utils/styles_utils.dart';
import 'package:belajandro_kiosk/widgets/headers_widget.dart';
import 'package:belajandro_kiosk/widgets/textformfield_widget.dart';
import 'package:belajandro_kiosk/widgets/title_widget.dart';
import 'package:dropdown_search/dropdown_search.dart';
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

  GuestInfoView({super.key, required this.titulo});

  @override
  Widget build(BuildContext context) {
    final imgKey = GlobalKey();
    final formKey = GlobalKey();

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
                      Container(
                        padding: EdgeInsets.only(left: 25.sp, right: 25.sp, top: 10.sp, bottom: 10.sp),
                        child: Form(
                          key: formKey,
                          child: SingleChildScrollView(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      flex: 1,
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
                                    Expanded(
                                      flex: 3,
                                      child: KioskTextFormField(
                                        textEditingController: hc.firstName,
                                        tecLabel: ' FIRST NAME ',
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
                                        onTap: () {
                                          hc.globalTEC.value = hc.middleName;
                                          hc.keypadType.value = 'text';
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
                                        onTap: () {
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
                                        onTap: () {
                                          hc.globalTEC.value = hc.phoneNumber;
                                          // hc.isNumericKeypad.value = true;
                                          hc.keypadType.value = 'numeric';
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
                                        onTap: () {
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
                                            onPressed: () {
                                              if (hc.firstName.text.isNotEmpty &&
                                                  hc.lastName.text.isNotEmpty &&
                                                  hc.middleName.text.isNotEmpty &&
                                                  hc.phoneNumber.text.isNotEmpty &&
                                                  hc.emailAddress.text.isNotEmpty) {
                                                hc.isButtonSubmitReady.value = true;
                                              }
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
                            ),
                          )),
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
                      // SizedBox(
                      //   height: 20.h,
                      //   width: 70.w,
                      //   child: Obx(
                      //     () => hc.keypadType.value == "numeric"
                      //         ? VirtualKeyboard(
                      //             textController: hc.globalTEC.value,
                      //             textColor: HenryColors.puti,
                      //             fontSize: 18.sp,
                      //             type: VirtualKeyboardType.Custom,
                      //             keys: hc.numericOnly,
                      //             alwaysCaps: true,
                      //           )
                      //         : VirtualKeyboard(
                      //             textController: hc.globalTEC.value,
                      //             textColor: HenryColors.puti,
                      //             fontSize: 18.sp,
                      //             type: VirtualKeyboardType.Custom,
                      //             keys: hc.customKey,
                      //             alwaysCaps: true,
                      //           ),
                      //   ),
                      // ),
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
}
