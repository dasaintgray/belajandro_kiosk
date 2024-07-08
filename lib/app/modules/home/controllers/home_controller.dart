// ignore_for_file: unnecessary_overrides

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ffi' as ffi;

import 'package:belajandro_kiosk/app/data/graphql_model/availablerooms_model.dart';
import 'package:belajandro_kiosk/app/data/graphql_model/menu_model.dart';
import 'package:belajandro_kiosk/app/data/graphql_model/paymenttype_model.dart';
import 'package:belajandro_kiosk/app/data/graphql_model/people_model.dart';
import 'package:belajandro_kiosk/app/data/graphql_model/prefix_model.dart';
import 'package:belajandro_kiosk/app/data/graphql_model/reactive_room_types_model.dart';
import 'package:belajandro_kiosk/app/data/graphql_model/room_type_model.dart';
import 'package:belajandro_kiosk/app/data/graphql_model/seriesdetails_model.dart';
import 'package:belajandro_kiosk/app/data/graphql_model/terminal_data_model.dart';
import 'package:belajandro_kiosk/services/constant/graphql_document_constant.dart';
import 'package:belajandro_kiosk/services/constant/lottie_constant.dart';
import 'package:belajandro_kiosk/services/constant/service_constant.dart';
import 'package:belajandro_kiosk/services/providers/service_providers.dart';
import 'package:belajandro_kiosk/services/service_model/service_model.dart';
import 'package:csharp_rpc/csharp_rpc.dart';
import 'package:email_otp/email_otp.dart';
import 'package:ffi/ffi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:get/get.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:translator/translator.dart' as tagasalin;
import 'package:windows_networking/windows_networking.dart';
import 'package:dotenv/dotenv.dart';

// ignore: depend_on_referenced_packages
import 'package:camera_platform_interface/camera_platform_interface.dart';

class HomeController extends GetxController {
  // boolean
  final isLoading = true.obs;
  final isBonwinCardDeviceReady = false.obs;
  final isShiftEnabled = false.obs;
  final isNumericMode = false.obs;
  final isButtonSubmitReady = false.obs;
  final isNumericKeypad = false.obs;
  final isEmailKeypad = false.obs;
  final isRegistered = true.obs; //check if already registered
  final isTextNotEmpty = false.obs;
  final isOverPaymentDetected = false.obs;
  final isConfirmReady = false.obs;

  // integer area
  final languageID = 1.obs;
  final selectedRoomType = 0.obs;
  final selectedPaymentType = 0.obs; //cash
  final selectedPrefixID = 1.obs;
  final noofdays = 0.obs;
  final agentID = 2.obs;
  final iAgentTypeID = 2.obs;
  // MONEY DUE
  final iP20 = 0.obs;
  final iP50 = 0.obs;
  final iP100 = 0.obs;
  final iP200 = 0.obs;
  final iP500 = 0.obs;
  final iP1000 = 0.obs;
  final iTotal = 0.obs;

  // double
  final nabasangPera = 0.00.obs;
  final totalAmountDue = 0.00.obs;
  final overPayment = 0.00.obs;

  // STRING
  final selectedRooNumber = ''.obs;
  final selectedLockCode = ''.obs;

  // LIST
  final menuList = <MenuModel>[];
  final pageList = <Menu>[].obs;
  final titleList = <Menu>[].obs;
  final paymentTypeList = <PaymentTypeModel>[];
  final roomTypeList = <RoomTypeModel>[];
  final reactiveRoomTypeList = <ReactiveRoomTypesModel>[].obs;
  final prefixList = <PrefixModel>[];
  final seriesDetailsList = <SeriesDetailsModel>[];
  final availableRoomList = <AvailableRoomsModel>[];
  final peopleList = <PeoplesModel>[];
  final terminalDataList = <TerminalDataModel>[];

  // LATE VARIABLE DECLARATION
  late var terminalNo = 0;
  late var terminalName = '';

  final List animationList = [
    LottieConstant.circularProgress,
    LottieConstant.harddisk,
    LottieConstant.kamay,
  ];

  final customKey = const [
    // ['@', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0'],
    ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "BACKSPACE"],
    ["a", "s", "d", "f", "g", "h", "j", "k", "l"],
    ["z", "x", "c", "v", "b", "n", 'ñ', "m", "."],
    ["SPACE"],
  ];

  final emailKey = const [
    ['@', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0'],
    ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "BACKSPACE"],
    ["a", "s", "d", "f", "g", "h", "j", "k", "l", "_", "-"],
    ["z", "x", "c", "v", "b", "n", "m", "."],
    ['@gmail.com', '@yahoo.com'],
  ];

  final numericOnly = const [
    ['1', '2', '3', '4'],
    ['5', '6', '7', '8'],
    ['9', '0', '+'],
  ];

  final numericLamang = const [
    ['7', '8', '9'],
    ['4', '5', '6'],
    ['1', '2', '3'],
    ['0', '+', 'BACKSPACE']
  ];

  // STRING
  final pageTitle = ''.obs;
  final languageCode = ''.obs;
  final range = ''.obs;
  final selectedDate = ''.obs;
  final dateCount = '0'.obs;
  final rangeCount = '0'.obs;
  final typeText = ''.obs; //hold the text that user typed on virtual keyboard
  final selectedPrefixData = 'MR'.obs;
  final keypadType = 'text'.obs;

  // translator
  final isalin = tagasalin.GoogleTranslator();

  // TextEditing Controllers for Guest Information
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController middleName = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController emailAddress = TextEditingController();
  final TextEditingController otp = TextEditingController();

  final TextEditingController discriminator = TextEditingController(); //auto filled = Contact
  final globalTEC = TextEditingController().obs;

  // LATE DECLARTION
  late Size previewSize;

  // CAMERA
  final cameraInfo = 'Unkown'.obs;
  final cameraList = [].obs;
  final isInitialized = false.obs;
  final cameraID = 0.obs;
  StreamSubscription<CameraClosingEvent>? errorStreamSubscription;
  StreamSubscription<CameraClosingEvent>? cameraClosingEvent;

  // final CameraController cameraController = CameraController();
  // final ImagePickerPlatform imagePickerPlatform = ImagePickerPlatform.instance;
  final pera = NumberFormat.currency(locale: "en_PH", symbol: "₱", decimalDigits: 0);
  final orasNgayon = DateTime.now();

  // SCROLL CONTROLLER
  final disclaimer = ScrollController();

  // SNAPSHOT DATA
  late final Snapshot availRoomSnapshot;
  late final Snapshot terminalDataSnapshot;

  late DotEnv globalEnv;

  @override
  void onInit() async {
    super.onInit();
    await fetchMenu(langID: 1);
    await fetchPrefix();
    // await fetchAvailableRooms();
  }

  @override
  void onReady() async {
    super.onReady();
    globalEnv = DotEnv(includePlatformEnvironment: true)..load();
    terminalName = globalEnv['TERMINAL_NAME']!;
    terminalNo = int.parse(globalEnv['TERMINAL_NO']!);

    // initEmailSender();

    // email verification otp
    // checkBonwin(30);

    // final test = NetworkInformation.getConnectionProfiles();
    // final test1 = NetworkInformation.getHostNames();
    // if (kDebugMode) {
    //   print(test);
    //   print(test1);
    // }

    // // CHECK RPC SERVICE
    // final rpcService = await CsharpRpc('assets/service/bonwin/BonwinService.exe').start();
    // // final rpcService = await CsharpRpc("BonwinService.exe").start();
    // // final rpcService = await HenryRPC('assets/service/bonwin/BonwinService.exe').start();
    // if (kDebugMode) {
    //   print(rpcService);
    // }

    // // var response = await csharpRpc.invoke<String>(method: "RunCashValidator", params: ["COM1", 0])
    // final roomCodes = ["010201", "010202"];
    // final response =
    //     await rpcService.invoke<Map<String, dynamic>>(method: "WriteToCard", params: [roomCodes, 0, "2405031200"]);

    // // final response = await rpcService.invoke<Map<String, dynamic>>(method: "DisableCard");
    // // final response = await rpcService.invoke(method: "Test");
    // if (kDebugMode) {
    //   print(response['success']);
    //   print(response['message']);
    //   print(response['values']);
    // }

    // // final macaddr = await rpcService.invoke<String>(method: "GetMacAddress");
    // // print(macaddr);
    // rpcService.dispose();
  }

  @override
  void onClose() {
    super.onClose();
    // cameraController.dispose();
    firstName.dispose();
    lastName.dispose();
    middleName.dispose();
  }

  void initEmailSender() {
    EmailOTP.config(
      appName: globalEnv['APP_NAME'] ?? 'Belajandro Hotel Kiosk System',
      appEmail: globalEnv['APP_EMAIL'] ?? 'kiosk@belajandrohotel.com',
      otpType: OTPType.numeric,
      // emailTheme: EmailTheme.v4,
    );

    EmailOTP.setSMTP(
      emailPort: EmailPort.port587,
      secureType: SecureType.tls,
      host: globalEnv['EMAIL_HOST'] ?? 'smtp.mailersend.net',
      username: globalEnv['EMAIL_USERNAME'] ?? 'MS_RmErOq@trial-7dnvo4dk9z3l5r86.mlsender.net',
      password: globalEnv['EMAIL_PASSWORD'] ?? 'xs319c5CerQ7fLyA',
    );

    // EmailOTP.setTemplate(
    //   template: globalEnv['EMAIL_TEMPLATE'] ??
    //       '''
    //   <div style="background-color: #f4f4f4; padding: 20px; font-family: Arial, sans-serif;">
    //     <div style="background-color: #fff; padding: 20px; border-radius: 10px; box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);">
    //       <h1 style="color: #333;">{{appName}}</h1>
    //       <h2 style="color: #333;">Your OTP</h2>
    //       <h2 style="background: #00466a; color: #fff;border-radius: 4px;width: max-content;padding: 0 20px">{{otp}}</h2>
    //       <p style="color: #333;">This OTP is valid for 5 minutes.</p>
    //       <p style="color: #333;">Thank you for using {{appName}}.</p>
    //     </div>
    //   </div>
    //   ''',
    // );

    EmailOTP.setTemplate(
      template: '''
      <div style="background-color: #f4f4f4; padding: 20px; font-family: Arial, sans-serif;">
        <div style="background-color: #fff; padding: 20px; border-radius: 10px; box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);">
          <h1 style="color: #333;">{{appName}}</h1>
          <h2 style="color: #333;">Your OTP</h2>
          <h2 style="background: #00466a; color: #fff;border-radius: 4px;width: max-content;padding: 0 20px">{{otp}}</h2>
          <p style="color: #333;">This OTP is valid for 5 minutes.</p>
          <p style="color: #333;">Thank you for using {{appName}}.</p>
        </div>
      </div>
      ''',
    );
  }

  Future<bool> setupEmail({required String? emailAddressToSend}) async {
    initEmailSender();
    final response = await EmailOTP.sendOTP(email: emailAddressToSend!);
    if (response) {
      return true;
    }
    return false;
  }

  /// TRANSACTION
  /// --------------------------------------------------------------------------
  Future<bool?> addContacts({
    required int prefixID,
    required String? firstName,
    required String? mName,
    required String? lastName,
    required String? mobileNo,
    required String? emailAddress,
  }) async {
    // GET THE SERIES DETAILS DATA FIRST
    final result = await fetchSeriesDetails();
    if (result!) {
      // PROCCESS THE contacts
      // ADDING NEW CONTACTS ON PEOPLE TABLE
      final Map<String, dynamic> peopleParams = {
        "fn": firstName,
        "mi": mName,
        "ln": lastName,
        "prefixID": prefixID,
        "cby": terminalName,
        "cdate": DateFormat('yyyy-MM-dd HH:mm:ss').format(orasNgayon),
        "mobileNo": mobileNo,
        "email": emailAddress,
        "code": seriesDetailsList.first.docNo,
      };

      // var test = jsonEncode(peopleParams);
      // print(test);

      final response = await ServiceProvider.updateGraphQL(
          graphQLURL: GlobalConstant.gqlURL,
          documents: GQLData.mPeople,
          headers: GlobalConstant.globalHeader,
          docVar: peopleParams);
      if (response['data']['insert_People']['affected_rows'] != null) {
        final peopleID = response['data']['insert_People']['returning'][0]['Id'];
        // UPDATE SERIES DETAILS
        // print(peopleID);
        final larawan = await takePicture(camID: cameraID.value);

        final Map<String, dynamic> contactParams = {
          "contactID": peopleID,
          "photo": larawan,
          "createdBy": terminalName,
          "createdDate": DateFormat('yyyy-MM-dd HH:mm:ss').format(orasNgayon),
        };
        final contactResponse = await ServiceProvider.updateGraphQL(
          graphQLURL: GlobalConstant.gqlURL,
          documents: GQLData.mPhotoes,
          headers: GlobalConstant.globalHeader,
          docVar: contactParams,
        );
        if (contactResponse['data']['insert_ContactPhotoes']['affected_rows'] != null) {
          // UPDATE THE SERIES DETAILS
          final Map<String, dynamic> updateParams = {
            "isActive": false,
            "modifiedBy": terminalName,
            "modifiedDate": DateFormat('yyyy-MM-dd HH:mm:ss').format(orasNgayon),
            "reservationDate": DateFormat('yyyy-MM-dd HH:mm:ss').format(orasNgayon),
            "tranDate": DateFormat('yyyy-MM-dd HH:mm:ss').format(orasNgayon),
            "seriesID": seriesDetailsList.first.id,
          };
          final seriesdetailResponse = await ServiceProvider.updateGraphQL(
              graphQLURL: GlobalConstant.gqlURL,
              documents: GQLData.mUpdateSeriesDetails,
              headers: GlobalConstant.globalHeader,
              docVar: updateParams);
          if (seriesdetailResponse['data']['update_SeriesDetails']['affected_rows'] != null) {
            return true;
          }
        }
      }
      return false;
    }
    return false;
  }

  Future startCashAcceptor() async {
    final startPath = globalEnv['LEYM_SERVICE'];
    final comPort = globalEnv['CASH_ACCEPTOR_PORT'];
    final rpcService = await CsharpRpc(startPath!).start();

    final response = rpcService.invoke(method: "RunCashValidator", params: [comPort, 0]);
    if (kDebugMode) print(response);
  }

  Future<Map<String, dynamic>?> processBonwinCard(
      {required String servicePath, required String command, List<dynamic>? params}) async {
    late final Map<String, dynamic> response;

    final rpcservice = await CsharpRpc(servicePath).start();

    switch (command) {
      case "write":
        response =
            await rpcservice.invoke<Map<String, dynamic>>(method: "WriteToCard", params: params).timeout(15.seconds);
        break;
      case "read":
        response = await rpcservice.invoke<Map<String, dynamic>>(method: "ReadFromCard").timeout(15.seconds);
        break;
      case "revoke":
        response = await rpcservice.invoke<Map<String, dynamic>>(method: "DisableCard").timeout(15.seconds);
        break;
      case "RunCashValidator":
        break;
    }
    if (response["success"]) {
      rpcservice.dispose(); //shutdown the service
      return response;
    }
    return null;
  }

  void keyboardListeners() {
    firstName.addListener(() {
      globalTEC.value = firstName;
      if (firstName.text.isNotEmpty && lastName.text.isNotEmpty && middleName.text.isNotEmpty) {
        isButtonSubmitReady.value = true;
      }
    });

    middleName.addListener(() {
      globalTEC.value = middleName;
      if (firstName.text.isNotEmpty && lastName.text.isNotEmpty && middleName.text.isNotEmpty) {
        isButtonSubmitReady.value = true;
      }
    });

    lastName.addListener(() {
      globalTEC.value = lastName;
      if (firstName.text.isNotEmpty && lastName.text.isNotEmpty && middleName.text.isNotEmpty) {
        isButtonSubmitReady.value = true;
      }
    });
    if (firstName.text.isNotEmpty && lastName.text.isNotEmpty && middleName.text.isNotEmpty) {
      isButtonSubmitReady.value = true;
    }
  }

  void printConnectionInformation(ConnectionProfile? profile) {
    if (profile
        case ConnectionProfile(
          :final profileName,
          :final isWlanConnectionProfile,
          :final wlanConnectionProfileDetails
        )) {
      if (kDebugMode) {
        print('Profile name: $profileName');
      }
      final connectivityLevel = switch (profile.getNetworkConnectivityLevel()) {
        NetworkConnectivityLevel.constrainedInternetAccess => 'Limited Internet access.',
        NetworkConnectivityLevel.internetAccess => 'Local and Internet access.',
        NetworkConnectivityLevel.localAccess => 'Local network access only.',
        NetworkConnectivityLevel.none => 'No connectivity.',
      };
      if (kDebugMode) {
        print('Connectivity level: $connectivityLevel');
      }

      if (isWlanConnectionProfile) {
        final ssid = wlanConnectionProfileDetails?.getConnectedSsid();
        if (kDebugMode) {
          print('Connected SSID: ${ssid ?? 'N/A'}');
        }
      }
    }
  }

  // SERIES DETAILS
  Future<bool?> fetchSeriesDetails() async {
    final Map<String, dynamic> params = {
      "moduleID": 5,
    };

    final response = await ServiceModel.getSeriesDetails(docVar: params);
    if (response != null) {
      seriesDetailsList.clear(); //clear first
      seriesDetailsList.addAll(response);
      return true;
    } else {
      return false;
    }
  }

  Future<bool?> fetchMenu({required int? langID}) async {
    final response = await ServiceModel.getMenuInformation(
        headers: GlobalConstant.globalHeader, graphQLURL: GlobalConstant.gqlURL, documents: GQLData.qryTranslation);
    if (response != null) {
      menuList.add(response);
      return true;
    } else {
      return false;
    }
  }

  Future<bool?> fetchPayment({required String? langCode}) async {
    final response = await ServiceModel.getPaymentType(
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

  Future<bool?> fetchRoomTypes({required String? langCode, required int? agentID}) async {
    final Map<String, int> param = {"agentID": agentID ??= 2};

    final response = await ServiceModel.getRoomTypes(documents: GQLData.qRoomType, docVar: param);
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

  Future<bool?> fetchPrefix() async {
    final response = await ServiceModel.getPrefix(documents: GQLData.qPrefix);
    if (response != null) {
      prefixList.addAll(response);
      return true;
    } else {
      return false;
    }
  }

  Future<bool?> getRoomAvailableRooms({required int? agentID, required int? roomTypeID}) async {
    final Map<String, int> params = {
      "AgentTypdID": agentID!,
      "roomTypeID": roomTypeID!,
    };
    final response = await ServiceModel.getAvailableRooms(params: params);
    if (response != null) {
      availableRoomList.clear();
      availableRoomList.addAll(response);
      return true;
    } else {
      availableRoomList.clear();
      return false;
    }
  }

  Future<dynamic> fetchReactiveRoomType({required String? langCode, required int? agentID}) async {
    final Map<String, int> param = {"agentID": agentID ??= 2};
    final roomTypeResponse = await ServiceModel.getReactiveRoomTypes(docParams: param);

    roomTypeResponse.listen((event) {
      final eventResponse = reactiveRoomTypesModelFromJson(jsonEncode(event['data']['vRoomTypes']));
      if (eventResponse.isNotEmpty) {
        reactiveRoomTypeList.clear();
        reactiveRoomTypeList.addAll(eventResponse);
        // print('DUMAAN DITO YUNG REACTIVE');
        isLoading.value = false;
      }
    });
  }

  Future<dynamic> fetchAvailableRooms({required int? agentID, required int? roomTypeID}) async {
    final Map<String, int> params = {
      "AgentTypdID": agentID!,
      "roomTypeID": roomTypeID!,
    };
    availRoomSnapshot = await ServiceModel.getAvailableRoomsSubscription(docParams: params);

    // LISTEN ON SNAPSHOT
    availRoomSnapshot.listen(
      (event) {
        final eventResponse = availableRoomsModelFromJson(jsonEncode(event['data']['vRoomAvailable']));
        if (eventResponse.isNotEmpty) {
          availableRoomList.clear();
          availableRoomList.addAll(eventResponse);
          isLoading.value = false;
        }
      },
    );
  }

  Future<dynamic> fetchTerminalData({required int terminalID}) async {
    final Map<String, dynamic> params = {
      "terminalID": terminalID,
      "status": "NEW",
    };
    terminalDataSnapshot = await ServiceModel.getTerminalDataSubscription(docParams: params);

    //listen on the snapshopt
    terminalDataSnapshot.listen((event) {
      final eventResponse = terminalDataModelFromJson(jsonEncode(event['data']['TerminalDatas']));
      if (eventResponse.isNotEmpty) {
        terminalDataList.clear();
        terminalDataList.addAll(eventResponse);

        if (kDebugMode) print(terminalDataList.first.code);
        if (terminalDataList.first.code == GlobalConstant.cashInsert) {
          final valueRead = terminalDataList.first.value;
          if (valueRead.isCurrency) {
            nabasangPera.value == 0.00
                ? nabasangPera.value = double.parse(valueRead)
                : nabasangPera.value = nabasangPera.value + double.parse(valueRead);
            if (kDebugMode) print('COMPUTED DENOM: ${nabasangPera.value}');
            // ADD DENOMINATION COUNT IN DB
            updateDenominationData(klaseNgPera: valueRead, iCount: 1, terminalID: terminalID, bCounterIncrement: true);

            // UPDATE THE TERMINAL DATA
            updateTD(recordID: terminalDataList.first.id, terminalID: terminalID);

            // chech the money
            if (nabasangPera.value >= totalAmountDue.value) {
              if (nabasangPera.value == totalAmountDue.value) {
                isOverPaymentDetected.value = false;
              } else {
                overPayment.value = nabasangPera.value - totalAmountDue.value;
                isOverPaymentDetected.value = true;
              }
              isConfirmReady.value = true;
              // openLEDLibserial(ledLocationAndStatus: LedOperation.cashDispenserOFF, portName: ledPort.value);
              // cashDispenserCommand(sCommand: APIConstant.cashPoolingStop, iTerminalID: defaultTerminalID.value);
            } else {
              isConfirmReady.value = false;
            }
          }
        }
        updateTD(recordID: terminalDataList.first.id, terminalID: terminalDataList.first.terminalId);
      }
    });
  }

  // UPDATE THE TERMINAL DATA USING MUTATION
  // DATE: 14 AUGUST, 2023
  Future<bool?> updateTD({required int recordID, required int terminalID}) async {
    Map<String, dynamic> params = {"tID": recordID, "terminalID": terminalID};

    // var response = await GlobalProvider()
    //     .mutateGraphQLData(documents: updateTerminalDataGraphQL, variables: params, accessHeaders: accessToken);
    final response = await ServiceProvider.updateGraphQL(
        graphQLURL: GlobalConstant.gqlURL,
        headers: GlobalConstant.globalHeader,
        documents: GQLData.mUpdateTD,
        docVar: params);
    if (response['data']['update_TerminalDatas']['affected_rows'] != null) {
      // print(response);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateDenominationData(
      {required String klaseNgPera,
      required int iCount,
      required int terminalID,
      required bool bCounterIncrement}) async {
    // ignore: constant_pattern_never_matches_value_type
    final String docs;

    if (kDebugMode) print(klaseNgPera);

    switch (klaseNgPera) {
      case "20.00" || "20.0" || "20":
        {
          iP20.value = bCounterIncrement ? iP20.value + iCount : iP20.value - iCount;
          docs =
              'mutation updateTerminalDenomination {update_TerminalDenominations(where: {TerminalId: {_eq: $terminalID}}, _set: {p20: ${iP20.value}}) {affected_rows}}';
        }
        break;
      case "50.00" || "50.0" || "50":
        {
          iP50.value = bCounterIncrement ? iP50.value + iCount : iP50.value - iCount;
          docs =
              'mutation updateTerminalDenomination {update_TerminalDenominations(where: {TerminalId: {_eq: $terminalID}}, _set: {p50: ${iP50.value}}) {affected_rows}}';
        }
        break;
      case "100.00" || "100.0" || "100":
        {
          iP100.value = bCounterIncrement ? iP100.value + iCount : iP100.value - iCount;
          docs =
              'mutation updateTerminalDenomination {update_TerminalDenominations(where: {TerminalId: {_eq: $terminalID}}, _set: {p100: ${iP100.value}}) {affected_rows}}';
        }
        break;
      case "200.00" || "200.0" || "200":
        {
          iP200.value = bCounterIncrement ? iP200.value + iCount : iP200.value - iCount;
          docs =
              'mutation updateTerminalDenomination {update_TerminalDenominations(where: {TerminalId: {_eq: $terminalID}}, _set: {p200: ${iP200.value}}) {affected_rows}}';
        }
        break;
      case "500.00" || "500.0" || "500":
        {
          iP500.value = bCounterIncrement ? iP500.value + iCount : iP500.value - iCount;
          docs =
              'mutation updateTerminalDenomination {update_TerminalDenominations(where: {TerminalId: {_eq: $terminalID}}, _set: {p500: ${iP500.value}}) {affected_rows}}';
        }
        break;
      case "1000.00" || "1000.0" || "1000":
        {
          iP1000.value = bCounterIncrement ? iP1000.value + iCount : iP1000.value - iCount;
          docs =
              'mutation updateTerminalDenomination {update_TerminalDenominations(where: {TerminalId: {_eq: $terminalID}}, _set: {p1000: ${iP1000.value}}) {affected_rows}}';
        }
        break;
      default:
        {
          docs =
              'mutation updateDenomination {TerminalDenominations(mutate: {TerminalId : $terminalID } where: {TerminalId: $terminalID}) {Ids response}}';
        }
        break;
    }

    // if (kDebugMode) print(docs);
    final response = ServiceProvider.updateGraphQL(
        graphQLURL: GlobalConstant.gqlURL, headers: GlobalConstant.globalHeader, documents: docs);
    // ignore: unnecessary_null_comparison
    if (response != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool?> fetchPeople({required String? emailAddress}) async {
    final Map<String, String> params = {"email": emailAddress!};

    final response = await ServiceModel.getPeople(params: params);
    if (response != null) {
      peopleList.addAll(response);
      return true;
    }
    return false;
  }

  /// UPDATE AREA
  /// UPDATE TERMINAL DATAS
  Future<bool> updateTerminalData({
    required int? tableID,
    required int? terminalID,
    required String? code,
  }) async {
    final Map<String, dynamic> updateParams = {
      "tID": tableID,
      "terminalID": terminalID,
      "status": "NEW",
      "code": code,
    };

    final response = await ServiceProvider.updateGraphQL(
      graphQLURL: GlobalConstant.gqlURL,
      headers: GlobalConstant.globalHeader,
      documents: GQLData.mUpdateTerminalData,
      docVar: updateParams,
    );
    if (response['data']['update_TerminalDatas']['affected_rows'] != 0) {
      return true;
    }
    return false;
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

  // BONWIN

  checkPrinterDLL() {
    final dylib = ffi.DynamicLibrary.open("assets/library/printer/Msprintsdkx64.dll");
    if (!dylib.handle.address.isNaN) {
      // print('OK YUNG PRINTER');
    }
  }

  // PRINTER
  bool printResibo({
    required String? address,
    required String? owner,
    required String? telephone,
    required String? email,
    required String? vatTin,
    required int? bookingID,
    required int? terminalID,
    required int? qty,
    required String? roomRate,
    required String? deposit,
    required String? totalAmount,
    required String? totalAmountPaid,
    required String? paymentMethod,
    required String? changeValue,
    required String? currencyString,
    required String? vatTable,
    required String? vatTax,
    required String? roomNumber,
    required String? timeConsume,
    required DateTime? endTime,
    required bool? isOR,
  }) {
    // final libPath = Platform.script.resolve("assets/hardware/Msprintsdkx64.dll").path;
    // final logoPath = Platform.script.resolve("assets/logo/iotel.bmp").path;
    // final dylib = ffi.DynamicLibrary.open(libPath.substring(1, libPath.length));
    final dylib = ffi.DynamicLibrary.open("assets/library/printer/Msprintsdkx64.dll");

    DateTime dtNow = DateTime.now();
    final ngayongAraw = DateFormat('yyyy-MM-dd HH:mm:ss').format(dtNow);
    final checkout = DateFormat("dd, MMM yyyy hh:mm aa").format(endTime!);

    if (!dylib.handle.address.isNaN) {
      final openPrinter = dylib.lookupFunction<ffi.Int32 Function(), int Function()>('SetUsbportauto');
      final openResult = openPrinter();
      if (openResult == 0) {
        // final telephonePath = Platform.script.resolve("telephone.bmp").path;
        // final emailPath = Platform.script.resolve("email.bmp").path;
        // OPEN ALL THE FUNCTIONS IF THE USB IS OPEN
        final setInit = dylib.lookupFunction<ffi.Int32 Function(), int Function()>('SetInit');
        final setCommandmode = dylib.lookupFunction<ffi.Int32 Function(ffi.Int32), int Function(int)>('SetCommandmode');
        final setAlignment = dylib.lookupFunction<ffi.Int32 Function(ffi.Int32), int Function(int)>('SetAlignment');
        final printFeedline = dylib.lookupFunction<ffi.Int32 Function(ffi.Int32), int Function(int)>('PrintFeedline');
        final printDiskbmpfile = dylib
            .lookupFunction<ffi.Int32 Function(ffi.Pointer<Utf8>), int Function(ffi.Pointer<Utf8>)>('PrintDiskbmpfile');
        final setClean = dylib.lookupFunction<ffi.Int32 Function(), int Function()>('SetClean');
        final setSizetext =
            dylib.lookupFunction<ffi.Int32 Function(ffi.Int32, ffi.Int32), int Function(int, int)>('SetSizetext');
        final printString = dylib.lookupFunction<ffi.Int32 Function(ffi.Pointer<Utf8>, ffi.Int32),
            int Function(ffi.Pointer<Utf8>, int)>('PrintString');
        final setAlignmentLeftRight =
            dylib.lookupFunction<ffi.Int32 Function(ffi.Int32), int Function(int)>('SetAlignmentLeftRight');
        final printFeedDot = dylib.lookupFunction<ffi.Int32 Function(ffi.Int32), int Function(int)>('PrintFeedDot');
        final printCutpaper = dylib.lookupFunction<ffi.Int32 Function(ffi.Int32), int Function(int)>('PrintCutpaper');
        final setClose = dylib.lookupFunction<ffi.Int32 Function(), int Function()>("SetClose");
        final setBold = dylib.lookupFunction<ffi.Int32 Function(ffi.Int32), int Function(int)>("SetBold");
        // final setSizechar = dylib.lookupFunction<ffi.Int32 Function(ffi.Int32, ffi.Int32, ffi.Int32, ffi.Int32),
        //     int Function(int, int, int, int)>("SetSizechar");
        // final printQrcode = dylib.lookupFunction<ffi.Int32 Function(ffi.Pointer<Utf8>, ffi.Int32, ffi.Int32, ffi.Int32),
        //     int Function(ffi.Pointer<Utf8>, int, int, int)>("PrintQrcode");

        // begin to use the function
        final initResponse = setInit();
        if (initResponse == 0) {
          setCommandmode(3);
          setAlignment(1);
          // printFeedline(1);
          // printDiskbmpfile(logoPath.substring(1, logoPath.length).toNativeUtf8());
          printDiskbmpfile('assets/logo/iotel.bmp'.toNativeUtf8());
          //
          // printDiskbmpfile(emailPath.substring(1, emailPath.length).toNativeUtf8());
          setClean();
          printFeedline(1);
          setAlignment(1);
          setSizetext(1, 1);
          // setSizechar(1, 1, 1, 1);
          printString(address.toString().toNativeUtf8(), 0);
          printString('Owned & Operated by:'.toNativeUtf8(), 0);
          setBold(1);
          printString(owner.toString().toNativeUtf8(), 0);
          setBold(0);
          printFeedline(1);
          printString('VAT REG TIN: $vatTin'.toNativeUtf8(), 0);
          // printDiskbmpfile(telephonePath.substring(1, telephonePath.length).toNativeUtf8());
          printString(telephone.toString().toNativeUtf8(), 0);
          // printDiskbmpfile(emailPath.substring(1, emailPath.length).toNativeUtf8());
          printString('$email'.toNativeUtf8(), 0);
          printString(ngayongAraw.toNativeUtf8(), 0);
          printFeedline(1);
          setAlignment(0);
          setClean();
          setAlignmentLeftRight(0);
          printString('RCPT#: $bookingID'.toNativeUtf8(), 1);
          setAlignmentLeftRight(2);
          printString('TERMINAL# $terminalID'.toNativeUtf8(), 0);
          setClean();
          setAlignmentLeftRight(0);
          printString('BRANCH#: 1'.toNativeUtf8(), 1);
          setAlignmentLeftRight(2);
          printString('SERIAL# '.toNativeUtf8(), 0);
          setClean();
          setAlignment(0);
          printString('MIN #: '.toNativeUtf8(), 0);
          printFeedline(1);

          // DITO YUNG MGA CHARGES
          // setClean();
          setAlignment(1);
          setBold(1);
          printString('[ Acknowledgement Receipt ]'.toNativeUtf8(), 0);
          setBold(0);
          printFeedline(1);
          setClean();
          setAlignment(0);
          // setClean();
          printString('ROOM'.toNativeUtf8(), 0);
          // setClean();
          setAlignmentLeftRight(0);
          printString('  x$qty'.toNativeUtf8(), 1);
          setAlignmentLeftRight(2);
          printString('$currencyString ${roomRate!}'.toNativeUtf8(), 0);
          setClean();
          setAlignmentLeftRight(0);
          printString('KEY CARD DEPOSIT'.toNativeUtf8(), 1);
          setAlignmentLeftRight(2);
          printString('$currencyString ${deposit!}'.toNativeUtf8(), 0);
          setClean();

          printString('------------------------------------------------'.toNativeUtf8(), 0);
          setClean();
          setAlignmentLeftRight(0);
          printString('TOTAL'.toNativeUtf8(), 1);
          setAlignmentLeftRight(2);
          printString('$currencyString ${totalAmount!}'.toNativeUtf8(), 0);
          setClean();
          setAlignmentLeftRight(0);
          printString('$paymentMethod'.toNativeUtf8(), 1);
          setAlignmentLeftRight(2);
          printString('$currencyString $totalAmountPaid'.toNativeUtf8(), 0);
          setClean();
          setAlignmentLeftRight(0);
          printString('CHANGE'.toNativeUtf8(), 1);
          setAlignmentLeftRight(2);
          printString('$currencyString $changeValue'.toNativeUtf8(), 0);
          printFeedline(1);
          setAlignmentLeftRight(0);
          printString('VATable '.toNativeUtf8(), 1);
          setAlignmentLeftRight(2);
          printString('$currencyString ${vatTable!}'.toNativeUtf8(), 0);
          setClean();
          setAlignmentLeftRight(0);
          printString('VAT_Tax'.toNativeUtf8(), 1);
          setAlignmentLeftRight(2);
          printString('$currencyString ${vatTax!}'.toNativeUtf8(), 0);
          setClean();
          setAlignmentLeftRight(0);
          printString('ZERO_Rated'.toNativeUtf8(), 1);
          setAlignmentLeftRight(2);
          printString('$currencyString 0.00'.toNativeUtf8(), 0);
          setClean();
          setAlignmentLeftRight(0);
          printString('VAT Exempted'.toNativeUtf8(), 1);
          setAlignmentLeftRight(2);
          printString('$currencyString 0.00'.toNativeUtf8(), 0);
          setClean();

          // ignore: dead_code
          if (isOR!) {
            printString('SOLD TO-----------------------------------------'.toNativeUtf8(), 0);
            printString('NAME--------------------------------------------'.toNativeUtf8(), 0);
            printString('ADDRESS-----------------------------------------'.toNativeUtf8(), 0);
            printString('TIN#--------------------------------------------'.toNativeUtf8(), 0);
            printString('BUSINESS STYLE ---------------------------------'.toNativeUtf8(), 0);
          }

          // setUnderline(1);
          printFeedline(1);
          setAlignment(1);
          setSizetext(2, 2);
          printString('WELCOME GUEST'.toNativeUtf8(), 0);
          printFeedline(1);
          setSizetext(1, 1);
          printString('YOUR ASSIGNED ROOM NUMBER'.toNativeUtf8(), 0);
          setSizetext(3, 4);
          printString('$roomNumber'.toNativeUtf8(), 0);
          printFeedline(1);
          setSizetext(1, 1);
          printString("YOU'RE STAYING WITH US FOR".toNativeUtf8(), 0);
          setSizetext(2, 2);
          printString("$timeConsume".toNativeUtf8(), 0);
          printFeedline(2);
          setSizetext(1, 1);
          printString("YOU'RE CHECK-OUT TIME IS:".toNativeUtf8(), 0);
          setSizetext(2, 2);
          printString(checkout.toNativeUtf8(), 0);
          printFeedline(2);
          setSizetext(1, 1);
          printString('Please dial 0 if you need assistance'.toNativeUtf8(), 0);
          printString('Enjoy you stay'.toNativeUtf8(), 0);
          printFeedline(2);
          printString('THIS OFFICIAL RECEIPT SHALL BE VALID'.toNativeUtf8(), 0);
          printString('FOR FIVE(5) YEARS FROM THE DATE OF ATP'.toNativeUtf8(), 0);
          printFeedline(1);
          // printQrcode('WWW.CIRCUITMINDZ.COM'.toNativeUtf8(), 2, 8, 0);
          printString('www.circuitmindz.com'.toNativeUtf8(), 0);

          printFeedDot(100);
          printCutpaper(0);
          setClean();
          setClose();
          return true;
        }
      }
    }
    return false;
  }

  /// SERIAL COMMUNICATION ************************************************************
  /// THIS IS AREA IS BELONG TO THE SERIAL COMMUNICATION
  /// HARDWARE LIKE, PRINTER, LED LIGHTS, QRCODE SCANNER, ETC
  /// AUTHOR: HENRY V. MEMPIN
  /// DATE: 5 JULY 2024
  /// *********************************************************************************
  /// LED LIGHTS
  void signalLEDLights({required String? sCommandMode, String? comPort}) {
    final serialConfig = SerialPortConfig();
    final port = SerialPort(comPort ?? globalEnv['LED_LIGHTS_PORT']!);
    serialConfig.baudRate = 9600;
    serialConfig.parity = SerialPortParity.none;

    if (port.isOpen) {
      port.close();
    } else {
      if (kDebugMode) print('Connect to ${port.name}');
    }

    port.openWrite();

    //encode the string using specific encoding (e.g, ASCII)
    List<int> encodedBytes = ascii.encode(sCommandMode!);

    //create a Uint8List from the encoded bytes
    Uint8List uint8list = Uint8List.fromList(encodedBytes);

    port.isOpen ? port.write(uint8list) : port.close();
  }

  /// FOR KIOSK SERVICE
  /// AUTHOR: Henry V. Mempin
  /// Date: 5 July 2024 @ CM HQ
  /// Future / Async
  Future<bool> sendKioskCommand({required String? sCommand, required String apiKEY}) async {
    final response = await ServiceModel.submitKioskServiceCommand(
      hostURL: globalEnv['KIOSK_SERVICE']!,
      sCommand: sCommand!,
      terminalID: terminalNo,
      apiKEY: apiKEY,
    ).timeout(GlobalConstant.connectionTimeOut.seconds);
    if (response != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> getCamera() async {
    try {
      cameraList.value = await CameraPlatform.instance.availableCameras();
      if (cameraList.isEmpty) {
        cameraInfo.value = "No Available Camera";
      } else {
        debugPrint(cameraList.toString());
      }
    } on PlatformException catch (e) {
      cameraInfo.value = 'Failed to get cameras : ${e.code} : ${e.message}';
    }
  }

  Future<void> initializeCamera() async {
    assert(!isInitialized.value);

    if (cameraList.isEmpty) {
      return;
    }

    try {
      final CameraDescription cameraDescription = cameraList[0];
      cameraID.value = await CameraPlatform.instance.createCamera(cameraDescription, ResolutionPreset.veryHigh);
      errorStreamSubscription?.cancel();

      final Future<CameraInitializedEvent> cameraInitialized =
          CameraPlatform.instance.onCameraInitialized(cameraID.value).first;

      await CameraPlatform.instance.initializeCamera(cameraID.value);

      final CameraInitializedEvent event = await cameraInitialized;
      previewSize = Size(event.previewWidth, event.previewHeight);
    } on CameraException catch (e) {
      if (cameraID.value >= 0) {
        await CameraPlatform.instance.dispose(cameraID.value);
      } else {
        debugPrint('Failed to dispose camera ${e.code} : ${e.description}');
      }
    }
  }

  Future<void> disposeCamera() async {
    if (cameraID.value >= 0) {
      try {
        await CameraPlatform.instance.dispose(cameraID.value);
      } on CameraException catch (e) {
        cameraInfo.value = 'Failed to dispose camera ${e.code} : ${e.description}';
      }
    }
  }

  Future<String?> takePicture({required int? camID}) async {
    // final XFile pictureFile = await CameraPlatform.instance.takePicture(cameraID.value);
    final XFile pictureFile = await CameraPlatform.instance.takePicture(camID!);
    final imgBytes = File(pictureFile.path).readAsBytesSync();

    final img64 = base64Encode(imgBytes);
    if (img64.isNotEmpty) {
      File(pictureFile.path).delete();
      return img64.toString();
    } else {
      return '';
    }
  }

  void clearTextEditingController() {
    firstName.clear();
    middleName.clear();
    lastName.clear();
    isButtonSubmitReady.value = false;
  }

  (double? sW, double? sH) getScreenSize(BuildContext context) {
    return (context.width, context.height);
  }

  String generateLotties() {
    return animationList[Random().nextInt(animationList.length)];
  }

  (String? roomNo, String? lockCode, double? rate) getRandromRoomNumber() {
    final resultCode = availableRoomList[Random().nextInt(availableRoomList.length)].code;
    final result = availableRoomList.where((element) => element.code == resultCode);

    return (result.first.description, result.first.lockCode, result.first.rate);
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

  Future<String?> iTranslate({required String languageCode, required String sourceText}) async {
    final response = await isalin.translate(sourceText, to: languageCode);
    return response.toString();
  }

  void clearToDefault() {
    languageID.value = 1;
    selectedRoomType.value = 0;
    selectedPaymentType.value = 0; //cash
    selectedPrefixID.value = 1;
    noofdays.value = 0;
    agentID.value = 2;
    iAgentTypeID.value = 2;
    selectedRooNumber.value = '';
    selectedLockCode.value = '';
  }
}
