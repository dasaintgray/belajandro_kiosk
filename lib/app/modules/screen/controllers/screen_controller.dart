// ignore_for_file: unnecessary_overrides

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:belajandro_kiosk/app/data/graphql_model/languages_model.dart';
import 'package:belajandro_kiosk/app/data/graphql_model/settings_and_translation_model.dart';
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
  final satList = <SettingsAndTranslationModel>[];

  final weatherList = <WeatherModel>[].obs;

  // boolean
  final isLoading = true.obs;

  // string
  final imgURL = ''.obs;
  final weatherLocation = ''.obs;
  final oras = ''.obs;
  final sCITY = ''.obs;
  final sCOMPANY = ''.obs;
  final sCompanyAddress = ''.obs;

  final tokyo = ''.obs;
  final sydney = ''.obs;
  final newYork = ''.obs;
  final riyadh = ''.obs;

  // integer
  final tempC = 0.obs;
  final iAgentTypeID = 2.obs;

  late var apiKEY = '';

  // LIST
  final List cities = [
    'Angeles City',
    'Quezon City',
    'Baguio City',
    'Tagaytay City',
    'Tokyo',
    'Sydney',
    'New York',
    'Riyadh',
  ];

  // date
  final dtNow = DateTime.now().obs;
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
          // await windowManager.setPosition(const Offset(1080, 1920));
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
      //   // COMPANY NAME AND ADDRESS
      final r1Result = settingsList.first.data.settings.indexWhere((element) => element.code == 'R1');
      final r2Result = settingsList.first.data.settings.indexWhere((element) => element.code == 'R2');
      sCOMPANY.value = settingsList.first.data.settings[r1Result].value;
      sCompanyAddress.value = settingsList.first.data.settings[r2Result].value;

      final agentData = settingsList.first.data.settings.where((element) => element.code == 'AGENTID');
      iAgentTypeID.value = int.parse(agentData.first.value);

      final keyAPI = settingsList.first.data.settings.where((element) => element.code == 'APIKEY');
      apiKEY = keyAPI.first.value;

      final response = await getWeather(sCITY.value);
      if (response) {
        isLoading.value = false;
        autoFetchWeather(duration: 10.minutes);
      }
    }

    // final satResponse = await getSAT(
    //     accessHeader: GlobalConstant.globalHeader,
    //     gqlURL: GlobalConstant.gqlURL,
    //     documents: GQLData.settingsAndTranslation);
    // if (satResponse != null) {
    //   satList.add(satResponse);

    //   final indexKey = satList.first.data.settings.indexWhere((element) => element.code == 'CITY');
    //   sCITY.value = satList.first.data.settings[indexKey].value;

    //   // COMPANY NAME AND ADDRESS
    //   final r1Result = satList.first.data.settings.indexWhere((element) => element.code == 'R1');
    //   final r2Result = satList.first.data.settings.indexWhere((element) => element.code == 'R2');
    //   sCOMPANY.value = satList.first.data.settings[r1Result].value;
    //   sCompanyAddress.value = satList.first.data.settings[r2Result].value;

    //   final weatherResponse = await getWeather(sCITY.value); //first intial city
    //   if (weatherResponse) {
    //     isLoading.value = false;
    //     autoFetchWeather(duration: 10.minutes);
    //   }
    // }
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

    // INITIALIZE THE LIST
  }

  @override
  void onClose() {
    super.onClose();
  }

  String getDisclaimer(int languageID) {
    if (languagesList.isNotEmpty) {
      final result = languagesList.first.data.languages.where((element) => element.id == languageID);
      return result.first.disclaimer;
    }
    return '';
  }

  void startTime() {
    DateTime baseTime = DateTime(
        dtNow.value.year, dtNow.value.month, dtNow.value.day, dtNow.value.hour, dtNow.value.minute, dtNow.value.second);

    DateTime japanTime = DateTime(dtNow.value.year, dtNow.value.month, dtNow.value.day, dtNow.value.hour - 1,
        dtNow.value.minute, dtNow.value.second);
    DateTime sydneyTime = DateTime(dtNow.value.year, dtNow.value.month, dtNow.value.day, dtNow.value.hour - 2,
        dtNow.value.minute, dtNow.value.second);
    DateTime newYorkTime = DateTime(dtNow.value.year, dtNow.value.month, dtNow.value.day, dtNow.value.hour + 12,
        dtNow.value.minute, dtNow.value.second);
    DateTime riyadhTime = DateTime(dtNow.value.year, dtNow.value.month, dtNow.value.day, dtNow.value.hour + 5,
        dtNow.value.minute, dtNow.value.second);

    Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        Duration difference = DateTime.now().difference(baseTime);
        // Duration difference = dtNow.value.difference(baseTime);
        oras.value = DateFormat("hh:mm:ss a").format(dtNow.value.add(difference));

        Duration japanDifference = DateTime.now().difference(japanTime);
        // tokyo.value = DateFormat("Hh:mm").format(dtNow.add(japanDifference));
        tokyo.value = DateFormat.Hm().format(dtNow.value.add(japanDifference));

        Duration sydneyDifference = DateTime.now().difference(sydneyTime);
        sydney.value = DateFormat.Hm().format(dtNow.value.add(sydneyDifference));

        Duration newyorkDifference = DateTime.now().difference(newYorkTime);
        newYork.value = DateFormat.Hm().format(dtNow.value.add(newyorkDifference));

        Duration riyadDifference = DateTime.now().difference(riyadhTime);
        riyadh.value = DateFormat.Hm().format(dtNow.value.add(riyadDifference));
      },
    );
  }

  void autoFetchWeather({required Duration duration}) {
    Timer.periodic(duration, (timer) async {
      await getWeather(getRandomCity());
    });
  }

  String getRandomCity() {
    return cities[Random().nextInt(cities.length)];
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
      isLoading.value = false;
      return true;
    }
    isLoading.value = true;
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

  /// SETTINGS AND TRANSLATION
  /// DESCRIPTION: PINAG MIX KO NA LANG YUNG SETTINGS AND TRANSLATION TABLE PARA
  /// MABILIS ANG PAG QUERY
  /// AUTHOR: HENRY V. MEMPIN
  Future<SettingsAndTranslationModel?> getSAT(
      {required Map<String, String> accessHeader,
      required String? gqlURL,
      required String? documents,
      Map<String, dynamic>? docVar}) async {
    final response = await ServiceProvider.gQLQuery(graphQLURL: gqlURL, documents: documents, headers: accessHeader);
    final List res1 = response['data']['Settings'];
    final List res2 = response['data']['Translations'];

    if (res1.isNotEmpty && res2.isNotEmpty) {
      return settingsAndTranslationModelFromJson(jsonEncode(response));
    } else {
      return null;
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
