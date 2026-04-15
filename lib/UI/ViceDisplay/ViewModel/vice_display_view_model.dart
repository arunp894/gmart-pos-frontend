import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:gmart/Constant/app_strings.dart';
import 'package:gmart/Core/application_base.dart';
import 'package:gmart/UI/ViceDisplay/Model/method_response_model.dart';
import 'package:gmart/UI/ViceDisplay/Model/payment_model.dart';
import 'package:gmart/UI/Splash/Model/cash_checking_response_model.dart' as p;

class ViceDisplayViewModel extends BaseModel {
  String? receiveData;
  bool? isEnable = false;
  List<CustomerProductList> productList = [];
  String customCash = "",
      customBill = "",
      customBalance = "",
      discountAmount = "",
      qrImg = "";
  bool isShow = false;
  PaymentModel payments = PaymentModel();
  SharedPreferences? prefs;
  List<p.Payment> paymentList = [];
  String errorText = "";

  Future updateData(MethodCall event) async {
    String tag = event.method;
    getData(tag, event);
  }

  getData(
    String tag,
    MethodCall event,
  ) {
    prefs = spEngine!.prefs;
    // errorText = "Data is transferring";
    switch (tag) {
      case "text":
        isEnable = true;
        receiveData = event.arguments['data'];
      case "list":
        isEnable = true;
        try {
          final fullMap = (event.arguments as Map).map(
            (key, value) => MapEntry(key.toString(), value),
          );

          final dataMap = Map<String, dynamic>.from(fullMap['data']);
          productList = (dataMap['productList'] as List)
              .map((item) => CustomerProductList.fromJson(
                  Map<String, dynamic>.from(item as Map)))
              .toList();
          customCash = dataMap['cashPaid'] ?? "0.0";
          customBill = dataMap['billNo'] ?? "0.0";
          customBalance = dataMap['balance'] ?? "0.0";
          discountAmount = dataMap['discountAmount'].toString();
        } catch (e, stack) {
          debugPrint("Parse error: $e\n$stack");
        }
        if (productList.isNotEmpty) {
          isEnable = true;
          isShow = false;
        } else {
          isEnable = false;
          isShow = false;
        }
      case "qr":
        prefs = spEngine!.prefs;
        String img = event.arguments['data'] ??
            prefs?.getString(AppStrings.qrCodeImage) ??
            "";
        qrImg = img;
        isEnable = true;
        isShow = true;
        String? permittedList = prefs?.getString(AppStrings.paymentList);
        if (permittedList != null) {
          List<dynamic> decodedList = jsonDecode(permittedList);
          List<p.Payment> mainList =
          decodedList.map((e) => p.Payment.fromJson(e)).toList();
          paymentList = mainList;
        }
      case "qr-off":
        isEnable = true;
        isShow = false;
      case "pay":
        try {
          String? permittedList = prefs?.getString(AppStrings.paymentList);
          if (permittedList != null) {
            List<dynamic> decodedList = jsonDecode(permittedList);
            List<p.Payment> mainList =
            decodedList.map((e) => p.Payment.fromJson(e)).toList();
              paymentList = mainList;
          }
          final fullMap = (event.arguments as Map).map(
            (key, value) => MapEntry(key.toString(), value),
          );
          final dataMap = Map<String, dynamic>.from(fullMap['data']);
          payments.payment = (dataMap['payment'] as List)
              .map((item) =>
                  Payment.fromJson(Map<String, dynamic>.from(item as Map)))
              .toList();
          payments.discountType = dataMap['discount_type'];
        } catch (e) {
          debugPrint("Parse error: $e\n$e");
        }
      default:
        isEnable = false;
        productList = [];
        receiveData = "";
    }
  }

  Future showDialogueBox({String? msg}) async {
    return showDialog(
      context: applicationCore!.navigatorKey.currentState!.overlay!.context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Row(
              children: [
                Expanded(
                    child: Divider(
                  height: 2,
                  color: Colors.black12,
                )),
                SizedBox(
                  width: 15.0,
                ),
                Text(AppStrings.appName),
                SizedBox(
                  width: 15.0,
                ),
                Expanded(
                    child: Divider(
                  height: 2,
                  color: Colors.black12,
                )),
              ],
            ),
            const SizedBox(
              height: 15.0,
            ),
            Text(msg ?? ""),
            Image.asset(
              "assets/images/logo.png",
              height: 150.0,
              width: 150.0,
            )
          ],
        ),
      ),
    );
  }
}
