import 'package:flutter/material.dart';
import 'package:gmart/Constant/app_color.dart';

InputDecoration textDecorator(
    {String? label,
    Widget? suffixIcon,
    EdgeInsets? contentPadding,
    Color? borderColor}) {
  return InputDecoration(
    suffixIcon: suffixIcon,
    hintText: label ?? "",
    counterText: "",
    fillColor: AppColor.whiteColor,
    filled: true,
    contentPadding: contentPadding,
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: AppColor.hintBlackColor)),
    errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: Colors.red)),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: AppColor.hintBlackColor)),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: borderColor ?? AppColor.hintBlackColor)),
  );
}
