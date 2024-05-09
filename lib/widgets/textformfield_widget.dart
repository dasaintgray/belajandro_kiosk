import 'package:belajandro_kiosk/services/colors/service_colors.dart';
import 'package:belajandro_kiosk/services/utils/validators_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class KioskTextFormField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String tecLabel;
  final int? maxLength;
  final Function() onTap;
  // final Function(PointerDownEvent) onTapOutside;

  const KioskTextFormField({
    super.key,
    required this.textEditingController,
    required this.tecLabel,
    // required this.onTapOutside,
    required this.onTap,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      cursorColor: HenryColors.puti,
      textAlignVertical: TextAlignVertical.bottom,
      style: TextStyle(color: HenryColors.puti, fontSize: 15.sp),
      maxLength: maxLength,
      // onTapOutside: onTapOutside,
      onTap: onTap,
      validator: (value) {
        return Validator.validateTextOnly(value!);
      },
      inputFormatters: [
        FilteringTextInputFormatter(RegExp(r'[a-zA-Z]'), allow: true),
      ],
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          // width: 0.0 produces a thin "hairline" border
          borderSide: BorderSide(color: HenryColors.puti, width: 1.0),
        ),
        border: const OutlineInputBorder(),
        disabledBorder: InputBorder.none,
        focusedBorder: OutlineInputBorder(
          // width: 0.0 produces a thin "hairline" border
          borderSide: BorderSide(color: HenryColors.puti, width: 1.0),
        ),
        // hintText: 'Username',
        labelText: tecLabel,
        // helperText: 'Only accept letters from A to Z',
        helperStyle: TextStyle(color: HenryColors.puti, fontSize: 10.sp),
        prefixIcon: Icon(
          Icons.person_outline,
          color: HenryColors.puti,
          size: 15.sp,
        ),
        labelStyle: TextStyle(
          color: HenryColors.puti,
          fontSize: 12.sp,
        ),
        hintStyle: TextStyle(
          color: HenryColors.puti,
          fontSize: 12.sp,
        ),
      ),
    );
  }
}
