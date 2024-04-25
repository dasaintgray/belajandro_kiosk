import 'package:belajandro_kiosk/services/colors/service_colors.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ClockSkin extends StatelessWidget {
  final String hourText;
  final String minuteText;
  final String location;
  final String? fontName;

  const ClockSkin({
    super.key,
    required this.hourText,
    required this.minuteText,
    required this.location,
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
        width: 200,
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Transform(
                  transform: Matrix4.skewX(-0.2),
                  child: Container(
                    alignment: Alignment.center,
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0), color: Colors.white),
                    child: Text(
                      hourText,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(color: Colors.black, fontSize: 50, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.skewX(-0.1),
                  child: Image.asset(
                    'assets/img/dot.png',
                    fit: BoxFit.cover,
                    height: 18,
                    width: 4,
                  ),
                ),
                const SizedBox(
                  width: 3,
                ),
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.skewX(-0.2),
                  child: Container(
                    alignment: Alignment.center,
                    width: 70,
                    height: 70,
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
