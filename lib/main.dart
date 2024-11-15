import 'package:belajandro_kiosk/services/colors/service_colors.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    GetMaterialApp(
      title: "Belajandro Kiosk",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.cupertino,
      // transitionDuration: const Duration(milliseconds: 300),
      theme: ThemeData(
        primaryColor: HenryColors.teal,
        fontFamily: 'Product Sans',
      ),
    ),
  );
}
