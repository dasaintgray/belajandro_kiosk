import 'dart:convert';

import 'package:belajandro_kiosk/app/data/graphql_model/menu_model.dart';
import 'package:belajandro_kiosk/app/data/graphql_model/paymenttype_model.dart';
import 'package:belajandro_kiosk/app/data/graphql_model/prefix_model.dart';
import 'package:belajandro_kiosk/app/data/graphql_model/room_type_model.dart';
import 'package:belajandro_kiosk/services/constant/graphql_document_constant.dart';
import 'package:belajandro_kiosk/services/constant/service_constant.dart';
import 'package:belajandro_kiosk/services/providers/service_providers.dart';

class ServiceModel {
  /// ==========================================================================
  /// FETCHING GRAPHQL DOCUMENTS
  /// AUTHOR: HENRY V. MEMPIN
  /// DATE: 26 APRIL 2024
  /// ==========================================================================
  static Future<MenuModel?> getMenuInformation(
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

  static Future<List<PaymentTypeModel>?> getPaymentType(
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

  static Future<List<RoomTypeModel>?> getRoomTypes({required String? documents, Map<String, dynamic>? docVar}) async {
    final response = await ServiceProvider.gQLQuery(
        graphQLURL: GlobalConstant.gqlURL, documents: documents, headers: GlobalConstant.globalHeader);
    if (response['data']['vRoomTypes'] != null) {
      return roomTypeModelFromJson(jsonEncode(response['data']['vRoomTypes']));
    } else {
      return null;
    }
  }

  /// USE IN PREFIX TABLE
  static Future<List<PrefixModel>?> getPrefix({required String? documents, Map<String, dynamic>? docVar}) async {
    final response = await ServiceProvider.gQLQuery(
        graphQLURL: GlobalConstant.gqlURL, documents: GQLData.qPrefix, headers: GlobalConstant.globalHeader);
    if (response['data']['Prefixes'] != null) {
      return prefixModelFromJson(jsonEncode(response['data']['Prefixes']));
    } else {
      return null;
    }
  }


} //end of service_model
