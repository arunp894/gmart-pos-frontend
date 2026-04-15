import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:gmart/Constant/app_color.dart';
import 'package:gmart/Constant/app_strings.dart';
import 'package:gmart/Core/application_base.dart';
import 'package:gmart/UI/Splash/Model/cash_checking_response_model.dart';
import 'package:gmart/UI/ViceDisplay/Model/method_response_model.dart';
import 'package:gmart/UI/ViceDisplay/ViewModel/vice_display_view_model.dart';
import 'package:imin_vice_screen/imin_vice_screen.dart';
import 'package:intl/intl.dart';

class ViceDisplayScreen extends StatefulWidget {
  const ViceDisplayScreen({super.key});

  static const routeName = '/viceMain';

  // static const routeName = '/main';

  @override
  State<ViceDisplayScreen> createState() => _ViceDisplayScreenState();
}

class _ViceDisplayScreenState extends State<ViceDisplayScreen> {
  IminViceScreen imInViceScreenPlugin = IminViceScreen();
  ViceDisplayViewModel? model;
  String? receiveData, qrCodeImage;
  SharedPreferences? pref;
  List<Payment> paymentList = [];

  @override
  void initState() {
    if (!mounted) return;
    pref = spEngine!.prefs;
    String? permittedList = pref?.getString(AppStrings.paymentList);
    if (permittedList != null) {
      List<dynamic> decodedList = jsonDecode(permittedList);
      List<Payment> mainList =
          decodedList.map((e) => Payment.fromJson(e)).toList();
      setState(() {
        paymentList = mainList;
      });
    }
    initScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<ViceDisplayViewModel>(
      prepareModel: (model) {
        this.model = model;
      },
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          toolbarHeight: 0.0,
          systemOverlayStyle:
              const SystemUiOverlayStyle(statusBarColor: Colors.white),
        ),
        body: !model.isEnable!
            ? Center(
                child: Image.asset(
                  "assets/images/image_2.png",
                  fit: BoxFit.cover,
                ),
              )
            : Row(
                children: [
                  Expanded(
                    child: model.isShow
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "FOR PAYNOW",
                                style: TextStyle(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[700],
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              paymentText(),
                              const SizedBox(height: 25.0),
                              Image.network(
                                model.qrImg,
                                height: 300.0,
                                width: 300.0,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Column(
                                    children: [
                                      Icon(Icons.error_outline),
                                      SizedBox(
                                        height: 15.0,
                                      ),
                                      Text("payment QR loading failed")
                                    ],
                                  );
                                },
                              ),
                            ],
                          )
                        : Image.asset("assets/images/image_2.png"),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5.0),
                          decoration: const BoxDecoration(color: Colors.yellow),
                          child: Row(
                            children: [
                              // Text("S.No"),
                              const Expanded(child: Text("Products")),
                              Padding(
                                padding: EdgeInsets.only(
                                    right: MediaQuery.of(context).size.width *
                                        0.07),
                                child: const Text("U.Price"),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    right: MediaQuery.of(context).size.width *
                                        0.08),
                                child: const Text("Qty"),
                              ),
                              const Text("T.Price"),
                            ],
                          ),
                        ),
                        (model.productList.isNotEmpty)
                            ? cartListWidget(model)
                            : const Center(
                                child: Text("Cart is empty"),
                              ),
                        const Divider(
                          thickness: 1.0,
                        ),
                        calculation(),
                        const SizedBox(
                          height: 15.0,
                        ),
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }

  Widget paymentText() {
    String subTotal = (double.parse(model!.productList
            .map((item) => item.totalPrice as double)
            .fold(0.00, (a, b) => a + b)
            .toString()))
        .toStringAsFixed(2);
    String discount = double.parse(model!.discountAmount.isEmpty
            ? "0.00"
            : model!.discountAmount.contains("null")
                ? "0.00"
                : model!.discountAmount)
        .toStringAsFixed(2);
    String total =
        (double.parse(subTotal) - double.parse(discount)).toStringAsFixed(2);
    String balance = (double.parse(total) - getPaid()).toStringAsFixed(2);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // getQrPay(),
          // const SizedBox(
          //   height: 5.0,
          // ),
          Text(
            "Please scan and pay amount S\$ $total",
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
          ),
          /*double.parse(balance) <= 0
              ? Text(
                  "Your remaining change ${" \$ ${double.parse(balance).abs()}"} amount")
              : Text(
                  "You can pay the ${model!.payments.payment != null ? "remaining" : ""}${" \$ $balance"} amount by scanning the QR code below.")*/
        ],
      ),
    );
  }

  getTotalWithTaxAmt(totalAmt) {
    String taxRate = pref!.getString(AppStrings.taxRate) ?? "0";
    double tax = int.parse(taxRate) / 100;
    double taxAmount = tax * totalAmt;
    String taxType = pref!.getString(AppStrings.taxType) ?? "inclusive";
    if (taxType.toLowerCase() != "inclusive") {
      return (totalAmt + taxAmount).toStringAsFixed(2);
    } else {
      return (totalAmt).toStringAsFixed(2);
    }
  }

  getTaxAmt(totalAmt) {
    String taxRate = pref!.getString(AppStrings.taxRate) ?? "0";
    double tax = int.parse(taxRate) / 100;
    double taxAmount = tax * totalAmt;
    return taxAmount.toStringAsFixed(2);
  }

  Widget calculation() {
    String subTotal = (double.parse(model!.productList
            .map((item) => item.totalPrice as double)
            .reduce((a, b) => a + b)
            .toString()))
        .toStringAsFixed(2);
    String discount = double.parse(model!.discountAmount.isEmpty
            ? "0.00"
            : model!.discountAmount.contains("null")
                ? "0.00"
                : model!.discountAmount)
        .toStringAsFixed(2);
    String total =
        (double.parse(subTotal) - double.parse(discount)).toStringAsFixed(2);
    String balance = (double.parse(total) - getPaid()).toStringAsFixed(2);
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Subtotal"),
              Text(
                "\$ ${(double.parse(subTotal)).toStringAsFixed(2)}",
                style: TextStyle(color: AppColor.blackColor, fontSize: 20.0),
              ),
            ],
          ),
          discount == "0.00"
              ? const SizedBox()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Discount"),
                    Text(
                      "(-) \$ $discount",
                      style:
                          TextStyle(color: AppColor.blackColor, fontSize: 20.0),
                    ),
                  ],
                ),
          const SizedBox(
            height: 5.0,
          ),
          pref!.getBool(AppStrings.isTax)!
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Tax(${pref!.getString(AppStrings.taxType)!})",
                      style: TextStyle(
                          color: AppColor.blackColor,
                          fontSize: 24.0,
                          fontWeight: FontWeight.w900),
                    ),
                    Text(
                      "\$ ${getTaxAmt(total)}",
                      style: TextStyle(
                          color: AppColor.blackColor,
                          fontSize: 24.0,
                          fontWeight: FontWeight.w900),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
          const SizedBox(
            height: 5.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Grand Total",
                style: TextStyle(
                    color: AppColor.blackColor,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w900),
              ),
              Text(
                "\$ ${pref!.getBool(AppStrings.isTax)! ? getTotalWithTaxAmt(total) : total}",
                style: TextStyle(
                    color: AppColor.blackColor,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w900),
              ),
            ],
          ),
          getAmtWidget(),
          Visibility(
            visible: (double.parse(total) != double.parse(balance)) ||
                balance == "0.00",
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  double.parse(balance) <= 0 ? "Change Return" : "Balance",
                  style: TextStyle(color: AppColor.blackColor, fontSize: 20.0),
                ),
                Text(
                  "\$ ${double.parse(balance).abs().toStringAsFixed(2)}",
                  style: TextStyle(color: AppColor.blackColor, fontSize: 20.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  getPaid() {
    Map<String, double> grouped = {};
    for (var payment in model!.payments.payment ?? []) {
      String method = payment.method ?? "";
      String amount = payment.amount ?? "0.00";
      grouped[method] = (grouped[method] ?? 0.0) + double.parse(amount);
    }
    return grouped.entries.fold(
      0.0,
      (previousValue, element) {
        return previousValue + element.value;
      },
    ).toDouble();
  }

  paymentGet() {
    pref = spEngine!.prefs;
    String? permittedList = pref?.getString(AppStrings.paymentList);
    if (permittedList != null) {
      List<dynamic> decodedList = jsonDecode(permittedList);
      List<Payment> mainList =
          decodedList.map((e) => Payment.fromJson(e)).toList();
      setState(() {
        paymentList = mainList;
      });
    }
  }

  Widget getAmtWidget() {
    // paymentGet();
    Map<String, double> grouped = {};
    for (var payment in model!.payments.payment ?? []) {
      String method = payment.method ?? "";
      String amount = payment.amount ?? "0.00";
      grouped[method] = (grouped[method] ?? 0) + double.parse(amount);
    }
    return Column(
      children: grouped.entries.map((e) {
        final match = model!.paymentList.isNotEmpty
            ? model!.paymentList
                .where((element) => element.key == e.key)
                .toList()
            : paymentList.where((element) => element.key == e.key).toList();
        final displayKey = match.isNotEmpty ? match[0].type : e.key;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              displayKey ?? "",
              style: TextStyle(color: AppColor.blackColor, fontSize: 20.0),
            ),
            Text(
              "\$ ${e.value.toStringAsFixed(2)}",
              style: TextStyle(color: AppColor.blackColor, fontSize: 20.0),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget getQrPay() {
    Map<String, double> grouped = {};
    for (var payment in model!.payments.payment!) {
      String method = payment.method ?? "";
      String amount = payment.amount ?? "0.00";
      grouped[method] = (grouped[method] ?? 0) + double.parse(amount);
    }

    return Column(
      children: grouped.entries.map((e) {
        final match =
            paymentList.where((element) => element.key == e.key).toList();
        final displayKey = match.isNotEmpty ? match[0].type : e.key;

        return Text(
          "You have paid the ${"\$ ${e.value.toStringAsFixed(2)}"} by ${displayKey ?? ""}",
          style: TextStyle(color: AppColor.blackColor),
        );
      }).toList(),
    );
  }

  Widget billHeadWidget({required String top, required String bottom}) {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            // "Bill No : ${model.cartListModel.billNo ?? ""}".toUpperCase(),
            top,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Text(
            // "Item Count : ${model.cartListModel.productList!.length}",
            bottom,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget cartListWidget(ViceDisplayViewModel model) {
    List<CustomerProductList> reversedItems =
        model.productList.reversed.toList();
    return Expanded(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: reversedItems.length,
        reverse: reversedItems.length > 18,
        itemBuilder: (context, index) {
          return cartWidget(reversedItems, index);
        },
      ),
    );
  }

  Widget cartWidget(
    List<CustomerProductList> reversedItems,
    int index,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 0.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                reversedItems[index].name ?? "",
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      "${reversedItems[index].unitPrice} (${reversedItems[index].unit})"),
                  const Spacer(),
                  Text(NumberFormat("#.##")
                      .format(reversedItems[index].quantity)),
                  const Spacer(),
                  Text(
                    reversedItems[index].totalPrice!.toStringAsFixed(2),
                    textAlign: TextAlign.end,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void initScreen() {
    imInViceScreenPlugin.viceStream.listen((event) {
      updateEvent(event);
    });
  }

  void updateEvent(MethodCall event) {
    // Fluttertoast.showToast(msg: "Started $event");
    model!.updateData(event).then(
      (value) {
        setState(() {});
      },
    );
  }
}
