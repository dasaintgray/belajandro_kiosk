import 'dart:convert';

import 'package:belajandro_kiosk/app/data/graphql_model/availablerooms_model.dart';
import 'package:belajandro_kiosk/app/data/graphql_model/menu_model.dart';
import 'package:belajandro_kiosk/app/data/graphql_model/paymenttype_model.dart';
import 'package:belajandro_kiosk/app/data/graphql_model/prefix_model.dart';
import 'package:belajandro_kiosk/app/data/graphql_model/room_type_model.dart';
import 'package:belajandro_kiosk/app/data/graphql_model/seriesdetails_model.dart';
import 'package:belajandro_kiosk/services/constant/graphql_document_constant.dart';
import 'package:belajandro_kiosk/services/constant/service_constant.dart';
import 'package:belajandro_kiosk/services/providers/service_providers.dart';
import 'package:hasura_connect/hasura_connect.dart';

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
        graphQLURL: GlobalConstant.gqlURL, documents: documents, headers: GlobalConstant.globalHeader, docVar: docVar);
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

  // SERIES DETAILS MODEL
  static Future<List<SeriesDetailsModel>?> getSeriesDetails({required Map<String, dynamic>? docVar}) async {
    final response = await ServiceProvider.gQLQuery(
        graphQLURL: GlobalConstant.gqlURL,
        documents: GQLData.qrySeriesDetails,
        headers: GlobalConstant.globalHeader,
        docVar: docVar!);
    if (response['data']['SeriesDetails'] != null) {
      return seriesDetailsModelFromJson(jsonEncode(response['data']['SeriesDetails']));
    } else {
      return null;
    }
  }

  static Future<List<AvailableRoomsModel>?> getAvailableRooms({required Map<String, int>? params}) async {
    final response = await ServiceProvider.gQLQuery(
      graphQLURL: GlobalConstant.gqlURL,
      documents: GQLData.qryAvailableRooms,
      headers: GlobalConstant.globalHeader,
      docVar: params,
    );
    if (response['data']['vRoomAvailable'] != null) {
      return availableRoomsModelFromJson(jsonEncode(response['data']['vRoomAvailable']));
    } else {
      return null;
    }
  }

  // SUBSCRIPTION
  static Future<Snapshot<dynamic>> getAvailableRoomsSubscription({required Map<String, int>? docParams}) async {
    final response = await ServiceProvider.getSubscription(
      graphQLURL: GlobalConstant.gqlURL,
      documents: GQLData.sAvailableRooms,
      headers: GlobalConstant.globalHeader,
      docVar: docParams,
    );
    return response;
  }

  static Future<Snapshot> getReactiveRoomTypes({required Map<String, int>? docParams}) async {
    final response = await ServiceProvider.getSubscription(
      graphQLURL: GlobalConstant.gqlURL,
      documents: GQLData.sRoomTypes,
      headers: GlobalConstant.globalHeader,
      docVar: docParams,
    );
    return response;
  }

  // for LANGUAGE
} //end of service_model
