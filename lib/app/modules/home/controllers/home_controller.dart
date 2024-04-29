// ignore_for_file: unnecessary_overrides

import 'dart:convert';
import 'dart:math';

import 'package:belajandro_kiosk/app/data/graphql_model/menu_model.dart';
import 'package:belajandro_kiosk/app/data/graphql_model/paymenttype_model.dart';
import 'package:belajandro_kiosk/app/data/graphql_model/room_type_model.dart';
import 'package:belajandro_kiosk/services/constant/graphql_document_constant.dart';
import 'package:belajandro_kiosk/services/constant/lottie_constant.dart';
import 'package:belajandro_kiosk/services/constant/service_constant.dart';
import 'package:belajandro_kiosk/services/providers/service_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:translator/translator.dart' as tagasalin;

class HomeController extends GetxController {
  // boolean
  final isLoading = true.obs;

  // integer area
  final languageID = 1.obs;
  final selectedRoomType = 0.obs;

  // LIST
  final menuList = <MenuModel>[];
  final pageList = <Menu>[].obs;
  final titleList = <Menu>[].obs;
  final paymentTypeList = <PaymentTypeModel>[];
  final roomTypeList = <RoomTypeModel>[];
  final List animationList = [
    LottieConstant.circularProgress,
    LottieConstant.harddisk,
    LottieConstant.kamay,
    LottieConstant.meeting
  ];

  // STRING
  final pageTitle = ''.obs;
  final languageCode = ''.obs;
  final range = ''.obs;
  final selectedDate = ''.obs;
  final dateCount = '0'.obs;
  final rangeCount = '0'.obs;
  final noofdays = 0.obs;

  // translator
  final isalin = tagasalin.GoogleTranslator();

  @override
  void onInit() async {
    super.onInit();
    await fetchMenu(langID: 1);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  (double? sW, double? sH) getScreenSize(BuildContext context) {
    return (context.width, context.height);
  }

  String generateLotties() {
    return animationList[Random().nextInt(animationList.length)];
  }

  void onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is PickerDateRange) {
      range.value = '${DateFormat('MMMM dd').format(args.value.startDate)} -'
          ' ${DateFormat('MMMM dd').format(args.value.endDate ?? args.value.startDate)}';
      if (args.value.endDate != null) {
        // rangeCount.value = args.value.endDate.difference(args.value.startDate).inDays + 1;
        noofdays.value = args.value.endDate.difference(args.value.startDate).inDays + 1;
        if (kDebugMode) print(args.value.endDate.difference(args.value.startDate).inDays + 1);
      }
    } else if (args.value is DateTime) {
      selectedDate.value = args.value.toString();
    } else if (args.value is List<DateTime>) {
      dateCount.value = args.value.length.toString();
    } else {
      rangeCount.value = args.value.length.toString();
    }
  }

  Future<bool?> fetchMenu({required int? langID}) async {
    final response = await getMenuInformation(
        headers: GlobalConstant.globalHeader, graphQLURL: GlobalConstant.gqlURL, documents: GQLData.qryTranslation);
    if (response != null) {
      menuList.add(response);
      return true;
    } else {
      return false;
    }
  }

  Future<String?> iTranslate({required String languageCode, required String sourceText}) async {
    final response = await isalin.translate(sourceText, to: languageCode);
    return response.toString();
  }

  Future<bool?> fetchPayment({required String? langCode}) async {
    final response = await getPaymentType(
        headers: GlobalConstant.globalHeader, graphQLURL: GlobalConstant.gqlURL, documents: GQLData.qryPaymentTypes);
    if (response != null) {
      if (languageID.value > 1) {
        for (var i = 0; i < response.length; i++) {
          final newtext = await isalin.translate(response[i].description.toString(), to: languageCode.value);
          // print(newtext);
          response[i].description = newtext.toString();
        }
      }
      paymentTypeList.clear();
      paymentTypeList.addAll(response);
      return true;
    } else {
      return false;
    }
  }

  Future<bool?> fetchRoomTypes({required String? langCode}) async {
    final response = await getRoomTypes(documents: GQLData.qryRoomType);
    if (response != null) {
      if (languageID.value > 1) {
        for (var i = 0; i < response.length; i++) {
          final newtext = await isalin.translate(response[i].description.toString(), to: languageCode.value);
          // print(newtext);
          response[i].description = newtext.toString();
        }
      }
      roomTypeList.clear();
      roomTypeList.addAll(response);
      return true;
    } else {
      return false;
    }
  }

  bool makeMenu({required int? languageID, required String? code, String? type}) {
    if (menuList.isNotEmpty) {
      pageList.clear();
      titleList.clear();
      if (type != null) {
        pageList.addAll(menuList.first.data.menu
            .where((element) => element.languageId == languageID && element.code == code && element.type == type));
      } else {
        pageList.addAll(
            menuList.first.data.menu.where((element) => element.languageId == languageID && element.code == code));
      }
      if (pageList.isNotEmpty) {
        final idx = pageList.indexWhere((p0) => p0.languageId == languageID && p0.type == 'TITLE');
        // final String titleResult = pageList[idx].translationText;
        titleList.addAll(pageList.where((p0) => p0.languageId == languageID && p0.type == 'TITLE'));
        pageList.removeAt(idx);
        pageList.refresh();
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  /// ==========================================================================
  /// FETCHING GRAPHQL DOCUMENTS
  /// AUTHOR: HENRY V. MEMPIN
  /// DATE: 26 APRIL 2024
  /// ==========================================================================
  Future<MenuModel?> getMenuInformation(
      {required Map<String, String> headers,
      required String? graphQLURL,
      required String? documents,
      Map<String, dynamic>? docVar}) async {
    final response = await ServiceProvider.gQLQuery(graphQLURL: graphQLURL, documents: documents, headers: headers);
    if (response['data']['menu'] != null) {
      return menuModelFromJson(jsonEncode(response));
    } else {
      return null;
    }
  }

  Future<List<PaymentTypeModel>?> getPaymentType(
      {required Map<String, String> headers,
      required String? graphQLURL,
      required String? documents,
      Map<String, dynamic>? docVar}) async {
    final response = await ServiceProvider.gQLQuery(graphQLURL: graphQLURL, documents: documents, headers: headers);
    if (response['data']['PaymentTypes'] != null) {
      return paymentTypeModelFromJson(jsonEncode(response['data']['PaymentTypes']));
    } else {
      return null;
    }
  }

  Future<List<RoomTypeModel>?> getRoomTypes({required String? documents, Map<String, dynamic>? docVar}) async {
    final response = await ServiceProvider.gQLQuery(
        graphQLURL: GlobalConstant.gqlURL, documents: documents, headers: GlobalConstant.globalHeader);
    if (response['data']['vRoomTypes'] != null) {
      return roomTypeModelFromJson(jsonEncode(response['data']['vRoomTypes']));
    } else {
      return null;
    }
  }
}
