import 'package:belajandro_kiosk/services/colors/service_colors.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ClockSkin extends StatelessWidget {
  final String hourText;
  final String minuteText;
  final String location;
  final String? fontName;
  final double? height;
  final double? width;

  const ClockSkin({
    super.key,
    required this.hourText,
    required this.minuteText,
    required this.location,
    this.height,
    this.width,
    this.fontName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.zero),
      ),
      child: SizedBox(
        width: width,
        height: height,
        // color: HenryColors.green,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Transform(
                  transform: Matrix4.skewX(-0.2),
                  child: Container(
                    alignment: Alignment.center,
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0), color: Colors.white),
                    child: Text(
                      hourText,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Transform(
                //   alignment: Alignment.center,
                //   transform: Matrix4.skewX(-0.1),
                //   child: Image.asset(
                //     'assets/img/dot.png',
                //     fit: BoxFit.cover,
                //     height: 15,
                //     width: 8,
                //   ),
                // ),
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.skewX(-0.2),
                  child: Container(
                    alignment: Alignment.center,
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0), color: Colors.white),
                    child: Text(
                      // intl.DateFormat('mm').format(datetime),
                      minuteText,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              child: Text(
                location,
                style: TextStyle(
                  color: HenryColors.puti,
                  fontSize: 10.sp,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
