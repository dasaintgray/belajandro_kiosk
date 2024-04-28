// ignore_for_file: unnecessary_overrides

import 'dart:convert';

import 'package:belajandro_kiosk/app/data/graphql_model/menu_model.dart';
import 'package:belajandro_kiosk/services/constant/graphql_document_constant.dart';
import 'package:belajandro_kiosk/services/constant/service_constant.dart';
import 'package:belajandro_kiosk/services/providers/service_providers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:translator/translator.dart' as tagasalin;

class HomeController extends GetxController {
  // integer area
  final languageID = 1.obs;

  // LIST
  final menuList = <MenuModel>[];
  final pageList = <Menu>[].obs;
  final titleList = <Menu>[].obs;

  // STRING
  final pageTitle = ''.obs;
  final languageCode = ''.obs;

  // translator
  final palitan = tagasalin.GoogleTranslator();

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

  // bool generateMenu({required Translation itemList, required String? code, required String? type, required int? languageID}) {
  //   menuList.clear();
  //   menuList.addAll(itemList);

  //   if () {

  //   }
  // }

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
}
