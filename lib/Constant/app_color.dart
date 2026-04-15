import 'package:flutter/material.dart';

class AppColor extends Color{
  AppColor._(final String hex) : super(_getColor(hex));

  static int _getColor(String hex){
    hex = hex.toUpperCase().replaceAll("#","");
    if(hex.length == 6){
      hex = "FF$hex";
    }
    return int.parse(hex,radix: 16);
  }

  static AppColor primaryColor = AppColor._("#0da587");
  static AppColor lightPrimaryColor = AppColor._("#CDF5E6");
  static AppColor mediumPrimaryColor = AppColor._("#A8EAD4");
  static AppColor statusBarColor = AppColor._("#00695C");
  static AppColor blackColor = AppColor._("#000000");
  static AppColor hintBlackColor = AppColor._("#727579");
  static AppColor secondaryColor = AppColor._("#9edbcf");
  static AppColor lightSecondaryColor = AppColor._("#E7F6F3");
  static AppColor borderColor = AppColor._("#EBEBEB");
  static AppColor whiteColor = AppColor._("#FFFFFF");
}