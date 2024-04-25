// ignore_for_file: unnecessary_overrides

import 'dart:async';
import 'dart:convert';

import 'package:belajandro_kiosk/app/data/graphql_model/languages_model.dart';
import 'package:belajandro_kiosk/app/data/graphql_model/settings_model.dart';
import 'package:belajandro_kiosk/app/data/rest_model/weather_model.dart';
import 'package:belajandro_kiosk/services/base/base_client_service.dart';
import 'package:belajandro_kiosk/services/constant/graphql_document_constant.dart';
import 'package:belajandro_kiosk/services/constant/service_constant.dart';
import 'package:belajandro_kiosk/services/controller/base_controller.dart';
import 'package:belajandro_kiosk/services/providers/service_providers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:window_manager/window_manager.dart';
import 'package:get/get.dart';

class ScreenController extends GetxController with BaseController {
  final settingsList = <SettingsModel>[];
  final languagesList = <LanguagesModel>[];

  final weatherList = <WeatherModel>[].obs;

  // boolean
  final isLoading = true.obs;

  // string
  final imgURL = ''.obs;
  final weatherLocation = ''.obs;
  final oras = ''.obs;
  final sCITY = ''.obs;

  final tokyo = ''.obs;
  final sydney = ''.obs;
  final newYork = ''.obs;
  final riyadh = ''.obs;

  // integer
  final tempC = 0.obs;

  // date
  final dtNow = DateTime.now();
  final rxDTNOW = DateTime.now().obs;
  final dtFormatter = DateFormat();

  @override
  void onInit() async {
    super.onInit();

    await windowManager.ensureInitialized();

    if (GetPlatform.isWindows) {
      WindowOptions windowOptions = const WindowOptions(
        size: Size(1080, 1920),
        center: true,
        skipTaskbar: false,
        titleBarStyle: TitleBarStyle.hidden,
      );

      windowManager.waitUntilReadyToShow(
        windowOptions,
        () async {
          await windowManager.setAlignment(Alignment.center);
          await windowManager.setFullScreen(true);
          await windowManager.focus();
          await windowManager.show();
        },
      );
    }

    final settingResponse = await getSettings(
      accessHeader: GlobalConstant.globalHeader,
      gqlURL: GlobalConstant.gqlURL,
      documents: GQLData.qrySettings,
    );
    if (settingResponse != null) {
      settingsList.add(settingResponse);

      final indexKey = settingsList.first.data.settings.indexWhere((element) => element.code == 'CITY');
      sCITY.value = settingsList.first.data.settings[indexKey].value;

      final response = await getWeather(sCITY.value);
      if (response) {
        isLoading.value = false;
        autoFetchWeather(
          duration: const Duration(minutes: 1),
        );
      }
    }
  }

  @override
  void onReady() async {
    super.onReady();
    startTime();
    final languageResponse = await getLanguages(
      headers: GlobalConstant.globalHeader,
      graphQLURL: GlobalConstant.gqlURL,
      documents: GQLData.qryLanguages,
    );
    if (languageResponse != null) {
      languagesList.add(languageResponse);
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  void startTime() {
    DateTime baseTime = DateTime(dtNow.year, dtNow.month, dtNow.day, dtNow.hour, dtNow.minute, dtNow.second);

    DateTime japanTime = DateTime(dtNow.year, dtNow.month, dtNow.day, dtNow.hour - 1, dtNow.minute, dtNow.second);
    DateTime sydneyTime = DateTime(dtNow.year, dtNow.month, dtNow.day, dtNow.hour - 2, dtNow.minute, dtNow.second);
    DateTime newYorkTime = DateTime(dtNow.year, dtNow.month, dtNow.day, dtNow.hour + 12, dtNow.minute, dtNow.second);
    DateTime riyadhTime = DateTime(dtNow.year, dtNow.month, dtNow.day, dtNow.hour + 5, dtNow.minute, dtNow.second);

    Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        Duration difference = DateTime.now().difference(baseTime);
        oras.value = DateFormat("hh:mm:ss a").format(dtNow.add(difference));

        Duration japanDifference = DateTime.now().difference(japanTime);
        // tokyo.value = DateFormat("Hh:mm").format(dtNow.add(japanDifference));
        tokyo.value = DateFormat.Hm().format(dtNow.add(japanDifference));

        Duration sydneyDifference = DateTime.now().difference(sydneyTime);
        sydney.value = DateFormat.Hm().format(dtNow.add(sydneyDifference));

        Duration newyorkDifference = DateTime.now().difference(newYorkTime);
        newYork.value = DateFormat.Hm().format(dtNow.add(newyorkDifference));

        Duration riyadDifference = DateTime.now().difference(riyadhTime);
        riyadh.value = DateFormat.Hm().format(dtNow.add(riyadDifference));
      },
    );
  }

  void autoFetchWeather({required Duration duration}) {
    Timer.periodic(duration, (timer) async {
      await getWeather('New York');
    });
  }

  Future<bool> getWeather(String? cityName) async {
    final weatherResponse = await fetchWeather(cityName).timeout(
      const Duration(seconds: 10),
    );
    if (weatherResponse != null) {
      weatherList.clear();
      weatherList.add(weatherResponse);
      imgURL.value = 'http:${weatherResponse.current.condition.icon}';
      weatherLocation.value = "${weatherResponse.location.name}, ${weatherResponse.location.country}";
      return true;
    }
    return false;
  }

  /// ACCESSING GRAPHQL
  /// --------------------------------------------------------------------------
  /// SETTINGS
  Future<SettingsModel?> getSettings(
      {required Map<String, String> accessHeader,
      required String? gqlURL,
      required String? documents,
      Map<String, dynamic>? docVar}) async {
    final response = await ServiceProvider.gQLQuery(
      graphQLURL: gqlURL,
      documents: documents,
      headers: accessHeader,
    );

    try {
      if (response['data']['Settings'] != null) {
        return settingsModelFromJson(jsonEncode(response));
      }
      return null;
    } finally {
      isLoading.value = true;
    }
  }

  /// LANGUAGES
  /// AUTHOR: HVM
  Future<LanguagesModel?> getLanguages(
      {required Map<String, String> headers,
      required String? graphQLURL,
      required String? documents,
      Map<String, dynamic>? docVar}) async {
    final response = await ServiceProvider.gQLQuery(graphQLURL: graphQLURL, documents: documents, headers: headers);
    if (response['data']['Languages'] != null) {
      return languagesModelFromJson(jsonEncode(response));
    } else {
      return null;
    }
  }

  /// END OF GRAPHQL
  /// --------------------------------------------------------------------------

  // HTTP
  Future<WeatherModel?> fetchWeather(String? cityName) async {
    final String searchParams = 'q=$cityName';
    final weatherResponse = await HenryBaseClient()
        .getv1(
          GlobalConstant.weatherURL,
          GlobalConstant.weatherEndpoint + searchParams,
          GlobalConstant.httpHeader,
        )
        .catchError(handleError);

    if (weatherResponse != null) {
      return weatherModelFromJson(weatherResponse);
    }
    return null;
  }
}
