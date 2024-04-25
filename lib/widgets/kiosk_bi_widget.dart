import 'package:belajandro_kiosk/services/constant/image_constant.dart';
import 'package:flutter/material.dart';

class KioskBackgroundImage extends StatelessWidget {
  const KioskBackgroundImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImageConstant.background),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
