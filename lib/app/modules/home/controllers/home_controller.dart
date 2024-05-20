// ignore_for_file: unnecessary_overrides

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ffi' as ffi;

import 'package:belajandro_kiosk/app/data/graphql_model/menu_model.dart';
import 'package:belajandro_kiosk/app/data/graphql_model/paymenttype_model.dart';
import 'package:belajandro_kiosk/app/data/graphql_model/prefix_model.dart';
import 'package:belajandro_kiosk/app/data/graphql_model/room_type_model.dart';
import 'package:belajandro_kiosk/app/data/graphql_model/seriesdetails_model.dart';
import 'package:belajandro_kiosk/services/constant/graphql_document_constant.dart';
import 'package:belajandro_kiosk/services/constant/lottie_constant.dart';
import 'package:belajandro_kiosk/services/constant/service_constant.dart';
import 'package:belajandro_kiosk/services/providers/service_providers.dart';
import 'package:belajandro_kiosk/services/service_model/service_model.dart';
import 'package:csharp_rpc/csharp_rpc.dart';
import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:translator/translator.dart' as tagasalin;
import 'package:windows_networking/windows_networking.dart';

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

  // integer area
  final languageID = 1.obs;
  final selectedRoomType = 0.obs;
  final selectedPaymentType = 0.obs; //cash
  final selectedPrefixID = 1.obs;
  final noofdays = 0.obs;

  // LIST
  final menuList = <MenuModel>[];
  final pageList = <Menu>[].obs;
  final titleList = <Menu>[].obs;
  final paymentTypeList = <PaymentTypeModel>[];
  final roomTypeList = <RoomTypeModel>[];
  final prefixList = <PrefixModel>[];
  final seriesDetailsList = <SeriesDetailsModel>[];

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
  final pera = NumberFormat.currency(locale: "en_PH", symbol: "₱");
  final orasNgayon = DateTime.now();

  // SCROLL CONTROLLER
  final disclaimer = ScrollController();

  @override
  void onInit() async {
    super.onInit();
    await fetchMenu(langID: 1);
    await fetchPrefix();
  }

  @override
  void onReady() async {
    super.onReady();

    // checkBonwin(30);

    final test = NetworkInformation.getConnectionProfiles();
    final test1 = NetworkInformation.getHostNames();
    if (kDebugMode) {
      print(test);
      print(test1);
    }

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
        "cby": "Kiosk Terminal 1",
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
          "createdBy": "Kiosk Terminal 1",
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
            "modifiedBy": "Kiosk Terminal 1",
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

  Future<Map<String, dynamic>> processBonwinCard(
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
    }
    rpcservice.dispose(); //shutdown the service
    return response;
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

  Future<bool?> fetchRoomTypes({required String? langCode}) async {
    final response = await ServiceModel.getRoomTypes(documents: GQLData.qRoomType);
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
}
