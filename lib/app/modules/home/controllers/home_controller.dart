// ignore_for_file: unnecessary_overrides

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  // integer area
  final languageID = 0.obs;

  @override
  void onInit() async {
    super.onInit();
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
}
