import 'package:flutter/services.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gmart/Constant/app_color.dart';
import 'package:gmart/Constant/app_strings.dart';
import 'package:gmart/Core/application_base.dart';
import 'package:gmart/UI/Dashboard/Model/cash_register_details_response_model.dart';
import 'package:gmart/UI/Dashboard/View/new_cash_close_widget.dart';
import 'package:gmart/UI/Dashboard/ViewModel/dashboard_view_model.dart';
import 'package:image/image.dart' as img;
import 'package:imin_vice_screen/imin_vice_screen.dart';
import 'package:intl/intl.dart';
// import 'dart:typed_data';

class RegisterScreen extends StatefulWidget {
  final List printers;
  final void Function() onCloseCash;

  const RegisterScreen(
      {super.key, required this.printers, required this.onCloseCash});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  DashboardViewModel? model;
  SharedPreferences? pref;
  IminViceScreen imInViceScreenPlugin = IminViceScreen();
  final keyLoader = GlobalKey<State>();

  @override
  void initState() {
    pref = spEngine!.prefs;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<DashboardViewModel>(
      prepareModel: (model) {
        this.model = model;
        model.getCashDetails();
      },
      builder: (context, model, child) {
        return model.state == ViewState.innerInActive
            ? Scaffold(
                backgroundColor: AppColor.whiteColor,
                body: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Scaffold(
                appBar: AppBar(
                  elevation: 0.0,
                  titleSpacing: 0.0,
                  backgroundColor: AppColor.hintBlackColor,
                  // toolbarHeight: 0.0,
                  title: Text(
                    // "Register Details ( ${model.cashRegDetails!.openTime} - ${model.cashRegDetails!.closedAt ?? "Present"})",
                    "Daily Closing Report( ${model.cashRegDetails!.openTime} - ${model.cashRegDetails!.closedAt ?? "Present"})",
                    style: const TextStyle(
                        fontSize: 22.0, fontWeight: FontWeight.w700),
                  ),
                  systemOverlayStyle: SystemUiOverlayStyle(
                      statusBarColor: AppColor.hintBlackColor),
                  actions: [
                    Row(
                      children: [
                        InkResponse(
                          radius: 5.0,
                          onTap: () {
                            if (widget.printers.isNotEmpty) {
                              usbPrint(
                                  deviceId:
                                      widget.printers[0]['deviceId'].toString(),
                                  isDetail: false);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 15.0),
                            decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.print_outlined,
                                  color: AppColor.whiteColor,
                                ),
                                const SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  "Print Mini",
                                  style: TextStyle(
                                      color: AppColor.whiteColor,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15.0,
                        ),
                        InkResponse(
                          radius: 5.0,
                          onTap: () {
                            // usbPrint(
                            //     deviceId: "1"
                            //         .toString(),
                            //     isDetail: true);
                            if (widget.printers.isNotEmpty) {
                              usbPrint(
                                  deviceId:
                                      widget.printers[0]['deviceId'].toString(),
                                  isDetail: true);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 15.0),
                            decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.print_outlined,
                                  color: AppColor.whiteColor,
                                ),
                                const SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  "Print Detailed",
                                  style: TextStyle(
                                      color: AppColor.whiteColor,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                      ],
                    ),
                  ],
                ),
                body: Row(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            decoration: const BoxDecoration(
                              border: Border(
                                // top: BorderSide(color: Colors.grey),
                                bottom: BorderSide(color: Colors.grey),
                              ),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.15,
                                  child: Text(
                                    "Payment Method",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppColor.blackColor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.07,
                                  child: Text(
                                    "Sell",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppColor.blackColor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.07,
                                  child: Text(
                                    "Expense",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppColor.blackColor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          cashWidget(
                              method: "Cash in hand",
                              sellCash:
                                  "S\$ ${double.parse(model.cashRegDetails!.cashInHand ?? "0.00").toStringAsFixed(2)}",
                              expensesCash: "--"),
                          cashWidget(
                              method: "Cash Payment",
                              sellCash:
                                  "S\$ ${double.parse(model.cashRegDetails!.totalCash ?? "0.00").toStringAsFixed(2)}",
                              expensesCash:
                                  "S\$ ${double.parse(model.cashRegDetails!.totalCashExpense ?? "0.00").toStringAsFixed(2)}"),
                          cashWidget(
                              method: "Pay Now Payment",
                              sellCash:
                                  "S\$ ${double.parse(model.cashRegDetails!.totalPayNow ?? "0.00").toStringAsFixed(2)}",
                              expensesCash:
                                  "S\$ ${double.parse(model.cashRegDetails!.totalPayNowExpense ?? "0.00").toStringAsFixed(2)}"),
                          cashWidget(
                              method: "Card Payment",
                              sellCash:
                                  "S\$ ${double.parse(model.cashRegDetails!.totalCard ?? "0.00").toStringAsFixed(2)}",
                              expensesCash:
                                  "S\$ ${double.parse(model.cashRegDetails!.totalCardExpense ?? "0.00").toStringAsFixed(2)}"),
                          cashWidget(
                              method: "CDC Payments",
                              sellCash:
                                  "S\$ ${double.parse(model.cashRegDetails!.totalOther ?? "0.00").toStringAsFixed(2)}",
                              expensesCash:
                                  "S\$ ${double.parse(model.cashRegDetails!.totalOtherExpense ?? "0.00").toStringAsFixed(2)}"),
                          cashWidget(
                              method: "Bank Transfer",
                              sellCash:
                                  "S\$ ${double.parse(model.cashRegDetails!.totalBankTransfer ?? "0.00").toStringAsFixed(2)}",
                              expensesCash:
                                  "S\$ ${double.parse(model.cashRegDetails!.totalBankTransferExpense ?? "0.00").toStringAsFixed(2)}",
                              isLast: true),
                          const SizedBox(
                            height: 15.0,
                          ),
                          cashTotalWidget(
                              method: "Total Refund",
                              expensesCash:
                                  "S\$ ${double.parse(model.cashRegDetails!.totalRefund ?? "0.00").toStringAsFixed(2)}"),
                          cashTotalWidget(
                              method: "Total Payment",
                              expensesCash:
                                  "S\$ ${double.parse(model.cashRegDetails!.totalOtherExpense ?? "0.00").toStringAsFixed(2)}"),
                          cashTotalWidget(
                              method: "Credit Sales", expensesCash: "S\$ 0.00"),
                          cashTotalWidget(
                              method: "Total Sales",
                              expensesCash:
                                  "S\$ ${double.parse(model.cashRegDetails!.totalSale ?? "0.00").toStringAsFixed(2)}"),
                          cashTotalWidget(
                              method: "Total Expense",
                              expensesCash:
                                  "S\$ ${double.parse(model.cashRegDetails!.totalExpense ?? "0.00").toStringAsFixed(2)}"),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.15 +
                                MediaQuery.of(context).size.width * 0.07 +
                                MediaQuery.of(context).size.width * 0.07,
                            padding: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 20.0),
                            child: Text(
                              "Total = ${getTotalAmt()}",
                              style: const TextStyle(height: 1.4),
                            ),
                          ),
                          /*Row(
                            children: [
                              InkResponse(
                                radius: 5.0,
                                onTap: () {
                                  if (widget.printers.isNotEmpty) {
                                    usbPrint(
                                        deviceId: widget.printers[0]['deviceId']
                                            .toString(),
                                        isDetail: false);
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 15.0),
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.print_outlined,
                                        color: AppColor.whiteColor,
                                      ),
                                      const SizedBox(
                                        width: 5.0,
                                      ),
                                      Text(
                                        "Print Mini",
                                        style: TextStyle(
                                            color: AppColor.whiteColor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 15.0,
                              ),
                              InkResponse(
                                radius: 5.0,
                                onTap: () {
                                  // usbPrint(
                                  //     deviceId: "1"
                                  //         .toString(),
                                  //     isDetail: true);
                                  if (widget.printers.isNotEmpty) {
                                    usbPrint(
                                        deviceId: widget.printers[0]['deviceId']
                                            .toString(),
                                        isDetail: true);
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 15.0),
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.print_outlined,
                                        color: AppColor.whiteColor,
                                      ),
                                      const SizedBox(
                                        width: 5.0,
                                      ),
                                      Text(
                                        "Print Detailed",
                                        style: TextStyle(
                                            color: AppColor.whiteColor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),*/
                          InkResponse(
                            radius: 5.0,
                            onTap: () {
                              getCloseCash();
                              // widget.onCloseCash();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 35.0),
                              decoration: BoxDecoration(
                                color: AppColor.primaryColor,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              margin:
                                  const EdgeInsets.symmetric(vertical: 15.0),
                              child: Text(
                                "Close Cash".toUpperCase(),
                                style: TextStyle(
                                  color: AppColor.whiteColor,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Card(
                        margin: const EdgeInsets.only(
                            top: 15.0, left: 5.0, right: 5.0, bottom: 10.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 15.0),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade700,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(15.0),
                                  topLeft: Radius.circular(15.0),
                                ),
                              ),
                              child: Text(
                                "Details of products sold (By Brand)",
                                // textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18.0,
                                    color: AppColor.blackColor,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            Container(
                              color: Colors.yellowAccent,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5.0),
                              // margin: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 45.0,
                                    child: Text(
                                      "S.No",
                                      style: TextStyle(
                                          color: AppColor.blackColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15.0),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Brand",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: AppColor.blackColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15.0),
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.07,
                                    child: Text(
                                      "Quantity",
                                      style: TextStyle(
                                          color: AppColor.blackColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15.0),
                                    ),
                                  ),
                                  Text(
                                    "Total amount",
                                    style: TextStyle(
                                        color: AppColor.blackColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15.0),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: model
                                    .cashDetails!.productDetailsByBrand!.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 8.0),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 0.5),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: 35.0,
                                          child: Text(
                                            "${index + 1}",
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15.0,
                                        ),
                                        Expanded(
                                          child: Text(
                                            // "100 PLUS",
                                            model
                                                    .cashDetails!
                                                    .productDetailsByBrand![
                                                        index]
                                                    .brandName ??
                                                "",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.07,
                                          child: Text(double.parse(model
                                                      .cashDetails!
                                                      .productDetailsByBrand![
                                                          index]
                                                      .totalQuantity ??
                                                  "0.00")
                                              .toStringAsFixed(2)),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.06,
                                          child: Text(
                                            // "s\$ 10.00",
                                            "S\$ ${double.parse(model.cashDetails!.productDetailsByBrand![index].totalAmount ?? "0.00").toStringAsFixed(2)}",
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  // "Total Amount: S\$ ${model.cashDetails!.productDetailsByBrand!.map((e) => double.parse(e.totalAmount ?? "0.00")).reduce((a, b) => a + b).toStringAsFixed(2)}",
                                  "Total Amount: S\$ ${model.cashDetails?.productDetailsByBrand?.fold<double>(
                                        0.0,
                                        (sum, e) =>
                                            sum +
                                            (double.tryParse(
                                                    e.totalAmount ?? "0.00") ??
                                                0.0),
                                      ).toStringAsFixed(2) ?? "0.00"}",
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        margin: const EdgeInsets.only(
                            top: 15.0, left: 5.0, right: 5.0, bottom: 10.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 15.0),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade700,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(15.0),
                                  topLeft: Radius.circular(15.0),
                                ),
                              ),
                              child: Text(
                                "Details of products sold",
                                // textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18.0,
                                    color: AppColor.blackColor,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            Container(
                              color: Colors.lightGreen,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5.0),
                              // margin: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 45.0,
                                    child: Text(
                                      "S.No",
                                      style: TextStyle(
                                          color: AppColor.blackColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14.0),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15.0,
                                  ),
                                  // Text(
                                  //   "Product Code",
                                  //   style: TextStyle(
                                  //       color: AppColor.blackColor,
                                  //       fontWeight: FontWeight.w600,
                                  //       fontSize: 14.0),
                                  // ),
                                  Expanded(
                                    child: Text(
                                      "Product",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: AppColor.blackColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14.0),
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.04,
                                    child: Text(
                                      "QTY",
                                      style: TextStyle(
                                          color: AppColor.blackColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14.0),
                                    ),
                                  ),
                                  Text(
                                    "Total amount",
                                    style: TextStyle(
                                        color: AppColor.blackColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14.0),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount:
                                    model.cashDetails!.productDetails!.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 8.0),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 0.5),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: 35.0,
                                          child: Text(
                                            "${index + 1}",
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        // const SizedBox(
                                        //   width: 15.0,
                                        // ),
                                        // Expanded(
                                        //   child: Text(
                                        //     // "125",
                                        //     model
                                        //             .cashDetails!
                                        //             .productDetails![index]
                                        //             .sku ??
                                        //         "",
                                        //     maxLines: 1,
                                        //     overflow: TextOverflow.ellipsis,
                                        //   ),
                                        // ),
                                        const SizedBox(
                                          width: 15.0,
                                        ),
                                        Expanded(
                                          child: Text(
                                            // "100 PLUS",
                                            model
                                                    .cashDetails!
                                                    .productDetails![index]
                                                    .productName ??
                                                "",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05,
                                          // child: Text("1000000000.00",
                                          child: Text(
                                              double.parse(model
                                                          .cashDetails!
                                                          .productDetails![
                                                              index]
                                                          .totalQuantity ??
                                                      "0.00")
                                                  .toStringAsFixed(2),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.06,
                                          child: Text(
                                            "S\$ ${double.parse(model.cashDetails!.productDetails![index].totalAmount ?? "0.00").toStringAsFixed(2)}",
                                            textAlign: TextAlign.end,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  // "Total Amount: S\$ ${model.cashDetails!.productDetails!.map((e) => double.parse(e.totalAmount ?? "0.00")).reduce((a, b) => a + b).toStringAsFixed(2)}",
                                  "Total Amount: S\$ ${model.cashDetails?.productDetails?.fold<double>(
                                        0.0,
                                        (sum, e) =>
                                            sum +
                                            (double.tryParse(
                                                    e.totalAmount ?? "0.00") ??
                                                0.0),
                                      ).toStringAsFixed(2) ?? "0.00"}",
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
      },
    );
  }

  getTotalAmt() {
    double opening = double.parse(model!.cashRegDetails!.cashInHand ?? "0.00");
    double sales = double.parse(model!.cashRegDetails!.totalSale ?? "0.00");
    double refund = double.parse(model!.cashRegDetails!.totalRefund ?? "0.00");
    double expenses =
        double.parse(model!.cashRegDetails!.totalExpense ?? "0.00");
    return "S\$ ${opening.toStringAsFixed(2)}(opening)+S\$ ${sales.toStringAsFixed(2)}(sale)-S\S ${refund.toStringAsFixed(2)}(refund)-S\$ ${expenses.toStringAsFixed(2)}=S\$ ${(opening + sales - refund - expenses).toStringAsFixed(2)}";
  }

  Widget cashWidget(
      {String? method,
      String? sellCash,
      String? expensesCash,
      bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: isLast ? Colors.transparent : Colors.grey),
        ),
      ),
      child: Row(
        children: [
          Container(
              width: MediaQuery.of(context).size.width * 0.15,
              padding: const EdgeInsets.only(left: 15.0),
              child: Text(
                method ?? "",
                textAlign: TextAlign.start,
              )),
          Container(
            width: MediaQuery.of(context).size.width * 0.07,
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(sellCash ?? "", textAlign: TextAlign.start),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.07,
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(expensesCash ?? "", textAlign: TextAlign.start),
          ),
        ],
      ),
    );
  }

  Widget cashTotalWidget({String? method, String? expensesCash}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.15 +
          MediaQuery.of(context).size.width * 0.07 +
          MediaQuery.of(context).size.width * 0.07,
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 15.0),
      color: Colors.redAccent.shade100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(method ?? ""),
          Text(expensesCash ?? ""),
        ],
      ),
    );
  }

  Future<void> usbPrint(
      {required String deviceId, required bool isDetail}) async {
    List<int> bytes = isDetail
        ? await printDetailsReceiptAsBytes(
            sellExpensesDetails: [
              {
                "label": "Cash Float",
                "sell":
                    "s\$ ${double.parse(model!.cashRegDetails!.cashInHand ?? "0.00").toStringAsFixed(2)}",
                "expense": "--"
              },
              {
                "label": "Cash Payment",
                "sell":
                    "s\$ ${double.parse(model!.cashRegDetails!.totalCash ?? "0.00").toStringAsFixed(2)}",
                "expense":
                    "s\$ ${double.parse(model!.cashRegDetails!.totalCashExpense ?? "0.00").toStringAsFixed(2)}"
              },
              {
                "label": "Pay Now Payment",
                "sell":
                    "s\$ ${double.parse(model!.cashRegDetails!.totalPayNow ?? "0.00").toStringAsFixed(2)}",
                "expense":
                    "s\$ ${double.parse(model!.cashRegDetails!.totalPayNowExpense ?? "0.00").toStringAsFixed(2)}"
              },
              {
                "label": "Card Payment",
                "sell":
                    "s\$ ${double.parse(model!.cashRegDetails!.totalCard ?? "0.00").toStringAsFixed(2)}",
                "expense":
                    "s\$ ${double.parse(model!.cashRegDetails!.totalCardExpense ?? "0.00").toStringAsFixed(2)}"
              },
              {
                "label": "CDC Payments",
                "sell":
                    "s\$ ${double.parse(model!.cashRegDetails!.totalOther ?? "0.00").toStringAsFixed(2)}",
                "expense":
                    "s\$ ${double.parse(model!.cashRegDetails!.totalOtherExpense ?? "0.00").toStringAsFixed(2)}"
              },
              {
                "label": "Bank Transfer",
                "sell":
                    "s\$ ${double.parse(model!.cashRegDetails!.totalBankTransfer ?? "0.00").toStringAsFixed(2)}",
                "expense":
                    "s\$ ${double.parse(model!.cashRegDetails!.totalBankTransferExpense ?? "0.00").toStringAsFixed(2)}"
              },
            ],
            total: "Total = ${getTotalAmt()}",
            totalSalesDetails: [
              {
                "label": "Total Refund",
                "value":
                    "s\$ ${double.parse(model!.cashRegDetails!.totalRefund ?? "0.00").toStringAsFixed(2)}"
              },
              {
                "label": "Total Payment",
                "value":
                    "s\$ ${double.parse(model!.cashRegDetails!.totalOtherExpense ?? "0.00").toStringAsFixed(2)}"
              },
              {"label": "Credit Sales", "value": "s\$ 0.00"},
              {
                "label": "Total Sales",
                "value":
                    "s\$ ${double.parse(model!.cashRegDetails!.totalSale ?? "0.00").toStringAsFixed(2)}"
              },
              {
                "label": "Total Expense",
                "value":
                    "s\$ ${double.parse(model!.cashRegDetails!.totalExpense ?? "0.00").toStringAsFixed(2)}"
              },
            ],
            productList: model!.cashDetails!.productDetails ?? [],
            brandList: model!.cashDetails!.productDetailsByBrand ?? [],
            voidList: model!.cashDetails!.productDetailsVoid ?? [])
        : await printMiniReceiptAsBytes(
            sellExpensesDetails: [
              {
                "label": "Cash Float",
                "sell":
                    "s\$ ${double.parse(model!.cashRegDetails!.cashInHand ?? "0.00").toStringAsFixed(2)}",
                "expense": "--"
              },
              {
                "label": "Cash Payment",
                "sell":
                    "s\$ ${double.parse(model!.cashRegDetails!.totalCash ?? "0.00").toStringAsFixed(2)}",
                "expense":
                    "s\$ ${double.parse(model!.cashRegDetails!.totalCashExpense ?? "0.00").toStringAsFixed(2)}"
              },
              {
                "label": "Pay Now Payment",
                "sell":
                    "s\$ ${double.parse(model!.cashRegDetails!.totalPayNow ?? "0.00").toStringAsFixed(2)}",
                "expense":
                    "s\$ ${double.parse(model!.cashRegDetails!.totalPayNowExpense ?? "0.00").toStringAsFixed(2)}"
              },
              {
                "label": "Card Payment",
                "sell":
                    "s\$ ${double.parse(model!.cashRegDetails!.totalCard ?? "0.00").toStringAsFixed(2)}",
                "expense":
                    "s\$ ${double.parse(model!.cashRegDetails!.totalCardExpense ?? "0.00").toStringAsFixed(2)}"
              },
              {
                "label": "CDC Payments",
                "sell":
                    "s\$ ${double.parse(model!.cashRegDetails!.totalOther ?? "0.00").toStringAsFixed(2)}",
                "expense":
                    "s\$ ${double.parse(model!.cashRegDetails!.totalOtherExpense ?? "0.00").toStringAsFixed(2)}"
              },
              {
                "label": "Bank Transfer",
                "sell":
                    "s\$ ${double.parse(model!.cashRegDetails!.totalBankTransfer ?? "0.00").toStringAsFixed(2)}",
                "expense":
                    "s\$ ${double.parse(model!.cashRegDetails!.totalBankTransferExpense ?? "0.00").toStringAsFixed(2)}"
              },
            ],
            total: "Total = ${getTotalAmt()}",
            totalSalesDetails: [
              {
                "label": "Total Refund",
                "value":
                    "s\$ ${double.parse(model!.cashRegDetails!.totalRefund ?? "0.00").toStringAsFixed(2)}"
              },
              {
                "label": "Total Payment",
                "value":
                    "s\$ ${double.parse(model!.cashRegDetails!.totalOtherExpense ?? "0.00").toStringAsFixed(2)}"
              },
              {"label": "Credit Sales", "value": "s\$ 0.00"},
              {
                "label": "Total Sales",
                "value":
                    "s\$ ${double.parse(model!.cashRegDetails!.totalSale ?? "0.00").toStringAsFixed(2)}"
              },
              {
                "label": "Total Expense",
                "value":
                    "s\$ ${double.parse(model!.cashRegDetails!.totalExpense ?? "0.00").toStringAsFixed(2)}"
              },
            ]);
    if (bytes.isNotEmpty) {
      try {
        await model!.requestUsbPermission(deviceId);
        final ok = await model!.printData(deviceId, bytes);
        if (ok) {
          if (mounted) {
            Fluttertoast.showToast(msg: "✅ Receipt printed!");
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('❌ Print failed')),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('❌ Error: $e')),
          );
        }
      }
    }
  }

  Future<void> commonPrinter(
      {required String deviceId}) async {
    List<int> bytes = await printCommonData(
        sellExpensesDetails: [
          {
            "label": "Cash Float",
            "sell":
            "s\$ ${double.parse(model!.cashRegDetails!.cashInHand ?? "0.00").toStringAsFixed(2)}",
            "expense": "--"
          },
          {
            "label": "Cash Payment",
            "sell":
            "s\$ ${double.parse(model!.cashRegDetails!.totalCash ?? "0.00").toStringAsFixed(2)}",
            "expense":
            "s\$ ${double.parse(model!.cashRegDetails!.totalCashExpense ?? "0.00").toStringAsFixed(2)}"
          },
          {
            "label": "Pay Now Payment",
            "sell":
            "s\$ ${double.parse(model!.cashRegDetails!.totalPayNow ?? "0.00").toStringAsFixed(2)}",
            "expense":
            "s\$ ${double.parse(model!.cashRegDetails!.totalPayNowExpense ?? "0.00").toStringAsFixed(2)}"
          },
          {
            "label": "Card Payment",
            "sell":
            "s\$ ${double.parse(model!.cashRegDetails!.totalCard ?? "0.00").toStringAsFixed(2)}",
            "expense":
            "s\$ ${double.parse(model!.cashRegDetails!.totalCardExpense ?? "0.00").toStringAsFixed(2)}"
          },
          {
            "label": "CDC Payments",
            "sell":
            "s\$ ${double.parse(model!.cashRegDetails!.totalOther ?? "0.00").toStringAsFixed(2)}",
            "expense":
            "s\$ ${double.parse(model!.cashRegDetails!.totalOtherExpense ?? "0.00").toStringAsFixed(2)}"
          },
          {
            "label": "Bank Transfer",
            "sell":
            "s\$ ${double.parse(model!.cashRegDetails!.totalBankTransfer ?? "0.00").toStringAsFixed(2)}",
            "expense":
            "s\$ ${double.parse(model!.cashRegDetails!.totalBankTransferExpense ?? "0.00").toStringAsFixed(2)}"
          },
        ],
        total: "Total = ${getTotalAmt()}",
        totalSalesDetails: [
          {
            "label": "Total Refund",
            "value":
            "s\$ ${double.parse(model!.cashRegDetails!.totalRefund ?? "0.00").toStringAsFixed(2)}"
          },
          {
            "label": "Total Payment",
            "value":
            "s\$ ${double.parse(model!.cashRegDetails!.totalOtherExpense ?? "0.00").toStringAsFixed(2)}"
          },
          {"label": "Credit Sales", "value": "s\$ 0.00"},
          {
            "label": "Total Sales",
            "value":
            "s\$ ${double.parse(model!.cashRegDetails!.totalSale ?? "0.00").toStringAsFixed(2)}"
          },
          {
            "label": "Total Expense",
            "value":
            "s\$ ${double.parse(model!.cashRegDetails!.totalExpense ?? "0.00").toStringAsFixed(2)}"
          },
        ],
        productList: model!.cashDetails!.productDetails ?? [],
        brandList: model!.cashDetails!.productDetailsByBrand ?? [],
        voidList: model!.cashDetails!.productDetailsVoid ?? []);
    if (bytes.isNotEmpty) {
      try {
        await model!.requestUsbPermission(deviceId);
        final ok = await model!.printData(deviceId, bytes);
        if (ok) {
          if (mounted) {
            Fluttertoast.showToast(msg: "✅ Receipt printed!");
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('❌ Print failed')),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('❌ Error: $e')),
          );
        }
      }
    }
  }

  img.Image threshold(img.Image src, int t) {
    final out = img.Image.from(src);
    for (int y = 0; y < out.height; y++) {
      for (int x = 0; x < out.width; x++) {
        final pixel = out.getPixel(x, y);
        final luma = img.getLuminance(pixel); // 0..255
        if (luma > t) {
          out.setPixelRgba(x, y, 255, 255, 255, 255); // white
        } else {
          out.setPixelRgba(x, y, 0, 0, 0, 255); // black
        }
      }
    }
    return out;
  }

  Future<img.Image> loadLogoAsImage() async {
    final ByteData data = await rootBundle.load('assets/images/trans_logo.png');
    final Uint8List bytes = data.buffer.asUint8List();
    return img.decodeImage(bytes)!; // convert Uint8List -> image.Image
  }

  img.Image fastThreshold(img.Image src, int t) {
    final bytes = src.getBytes();

    for (int i = 0; i < bytes.length; i += 4) {
      final int r = bytes[i];
      final int g = bytes[i + 1];
      final int b = bytes[i + 2];

      // luma (integer math, fast)
      final int luma = ((299 * r) + (587 * g) + (114 * b)) ~/ 1000;

      if (luma > t) {
        bytes[i] = bytes[i + 1] = bytes[i + 2] = 255; // white
      } else {
        bytes[i] = bytes[i + 1] = bytes[i + 2] = 0; // black
      }
      bytes[i + 3] = 255; // opaque
    }

    return img.Image.fromBytes(
      width: src.width,
      height: src.height,
      bytes: bytes.buffer,
    );
  }

  Future<List<int>> printMiniReceiptAsBytes(
      {required List<Map<String, String>> sellExpensesDetails,
      required List<Map<String, String>> totalSalesDetails,
      required String total}) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    final List<int> bytes = [];
    bytes.addAll(generator.reset());
    // final img.Image logo = await loadLogoAsImage();
    // final int newWidth = (logo.width * 0.5).toInt();
    // final int newHeight = (logo.height * 0.5).toInt();
    // final img.Image resized = img.copyResize(
    //   logo,
    //   width: newWidth,
    //   height: newHeight,
    // );
    // final img.Image flattened = removeTransparency(resized);
    // final img.Image dithered = fastThreshold(flattened, 128);
    // bytes.addAll(generator.image(dithered, align: PosAlign.center));
    bytes.addAll(generator.text(
      "HNMART",
      styles: PosStyles(
        width: PosTextSize.size3,
        height: PosTextSize.size3,
        bold: true,
        align: PosAlign.center,
      ),
    ));
    bytes.addAll(generator.text(
      "Register Details ( ${model!.cashRegDetails!.openTime} - ${model!.cashRegDetails!.closedAt ?? ""})",
      styles: const PosStyles(
          align: PosAlign.center, fontType: PosFontType.fontB, bold: true),
    ));
    bytes.addAll(
      generator.row([
        PosColumn(
          text: 'Payment Method',
          width: 6,
          styles: const PosStyles(bold: true),
        ),
        PosColumn(
          text: 'Sell',
          width: 3,
          styles: const PosStyles(bold: true),
        ),
        PosColumn(
          text: 'Expenses ',
          width: 3,
          styles: const PosStyles(bold: true),
        ),
      ]),
    );
    for (final item in sellExpensesDetails) {
      bytes.addAll(generator.row([
        PosColumn(
            text: item['label'] ?? '',
            width: 6,
            styles: const PosStyles(align: PosAlign.left)),
        PosColumn(
          text: item['sell'] ?? "",
          width: 3,
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text: item['expense'] ?? "",
          width: 3,
          styles: const PosStyles(align: PosAlign.center),
        ),
      ]));
    }
    bytes.addAll(generator.hr());
    for (final item in totalSalesDetails) {
      bytes.addAll(generator.row([
        PosColumn(
            text: item['label'] ?? '',
            width: 6,
            styles: const PosStyles(align: PosAlign.left)),
        PosColumn(
          text: item['value'] ?? "",
          width: 6,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]));
    }
    bytes.addAll(generator.hr());
    bytes.addAll(generator.text(
      total ?? "",
      styles: const PosStyles(align: PosAlign.center),
    ));
    bytes.addAll(generator.feed(2));
    bytes.addAll(generator.cut());
    return bytes;
  }

  Future<List<int>> printDetailsReceiptAsBytes(
      {required List<Map<String, String>> sellExpensesDetails,
      required List<Map<String, String>> totalSalesDetails,
      required String total,
      required List<ProductDetails> productList,
      required List<ProductDetailsByBrand> brandList,
      required List<ProductDetailsVoid> voidList}) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    final List<int> bytes = [];
    bytes.addAll(generator.reset());
    bytes.addAll(generator.text(
      "HNMART",
      styles: const PosStyles(
          align: PosAlign.center, fontType: PosFontType.fontB, bold: true),
    ));

    bytes.addAll(generator.text(
      "Register Details ( ${model!.cashRegDetails!.openTime} - ${model!.cashRegDetails!.closedAt ?? ""})",
      styles: const PosStyles(
          align: PosAlign.center, fontType: PosFontType.fontB, bold: true),
    ));
    bytes.addAll(
      generator.row([
        PosColumn(
          text: 'Payment Method',
          width: 6,
          styles: const PosStyles(bold: true),
        ),
        PosColumn(
          text: 'Sell',
          width: 3,
          styles: const PosStyles(bold: true),
        ),
        PosColumn(
          text: 'Expenses ',
          width: 3,
          styles: const PosStyles(bold: true),
        ),
      ]),
    );
    for (final item in sellExpensesDetails) {
      bytes.addAll(generator.row([
        PosColumn(
            text: item['label'] ?? '',
            width: 6,
            styles: const PosStyles(align: PosAlign.left)),
        PosColumn(
          text: item['sell'] ?? "",
          width: 3,
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text: item['expense'] ?? "",
          width: 3,
          styles: const PosStyles(align: PosAlign.center),
        ),
      ]));
    }
    bytes.addAll(generator.hr());
    for (final item in totalSalesDetails) {
      bytes.addAll(generator.row([
        PosColumn(
            text: item['label'] ?? '',
            width: 6,
            styles: const PosStyles(align: PosAlign.left)),
        PosColumn(
          text: item['value'] ?? "",
          width: 6,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]));
    }
    bytes.addAll(generator.hr());
    bytes.addAll(generator.text(
      total ?? "",
      styles: const PosStyles(align: PosAlign.center),
    ));
    bytes.addAll(generator.hr());
    bytes.addAll(generator.text(
      "Details of products sold",
      styles: const PosStyles(align: PosAlign.center),
    ));
    bytes.addAll(
      generator.row([
        PosColumn(
          text: 'S.No',
          width: 1,
          styles: const PosStyles(align: PosAlign.center, bold: true),
        ),
        /*PosColumn(
          text: 'Code',
          width: 3,
          styles: const PosStyles(bold: true, align: PosAlign.center),
        ),*/
        PosColumn(
          text: 'Product ',
          width: 5,
          styles: const PosStyles(align: PosAlign.center, bold: true),
        ),
        PosColumn(
          text: 'QTY',
          width: 3,
          styles: const PosStyles(align: PosAlign.center, bold: true),
        ),
        PosColumn(
          text: 'T.Amt',
          width: 3,
          styles: const PosStyles(align: PosAlign.center, bold: true),
        ),
      ]),
    );
    for (final entry in productList.asMap().entries) {
      final i = entry.key; // index
      final item = entry.value; // item
      bytes.addAll(generator.row([
        PosColumn(
          text: "${i + 1}",
          width: 1,
          styles: const PosStyles(align: PosAlign.center),
        ),
        PosColumn(
          text: " ${item.productName ?? " "}",
          width: 5,
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text: double.parse(item.totalQuantity ?? "0.00").toStringAsFixed(2),
          width: 3,
          styles: const PosStyles(align: PosAlign.center),
        ),
        PosColumn(
          text: double.parse(item.totalAmount ?? "0.00").toStringAsFixed(2),
          width: 3,
          styles: const PosStyles(align: PosAlign.center),
        ),
      ]));
    }
    bytes.addAll(
      generator.row([
        PosColumn(
          text: '#',
          width: 1,
          styles: const PosStyles(bold: true, align: PosAlign.center),
        ),
        PosColumn(
          text: '',
          width: 5,
          styles: const PosStyles(bold: true, align: PosAlign.center),
        ),
        PosColumn(
          text: productList
              .map((e) => double.parse(e.totalQuantity ?? "0.00"))
              .fold(0.0, (a, b) => a + b)
              .toStringAsFixed(2),
          width: 3,
          styles: const PosStyles(bold: true, align: PosAlign.center),
        ),
        PosColumn(
          text: productList
              .map((e) => double.parse(e.totalAmount ?? "0.00"))
              .fold(0.0, (a, b) => a + b)
              .toStringAsFixed(2),
          width: 3,
          styles: const PosStyles(bold: true, align: PosAlign.center),
        ),
      ]),
    );
    bytes.addAll(generator.hr());
    bytes.addAll(generator.text(
      "Details of products void",
      styles: const PosStyles(align: PosAlign.center),
    ));
    bytes.addAll(
      generator.row([
        PosColumn(
          text: 'S.No',
          width: 2,
          styles: const PosStyles(align: PosAlign.center, bold: true),
        ),
        PosColumn(
          text: 'Brands',
          width: 4,
          styles: const PosStyles(align: PosAlign.center, bold: true),
        ),
        PosColumn(
          text: 'QTY',
          width: 3,
          styles: const PosStyles(align: PosAlign.center, bold: true),
        ),
        PosColumn(
          text: 'T.Amt',
          width: 3,
          styles: const PosStyles(align: PosAlign.center, bold: true),
        ),
      ]),
    );
    for (final entry in voidList.asMap().entries) {
      final i = entry.key; // index
      final item = entry.value; // item
      bytes.addAll(generator.row([
        PosColumn(
            text: "${i + 1}",
            width: 2,
            styles: const PosStyles(align: PosAlign.center)),
        PosColumn(
          text: item.productName ?? "",
          width: 4,
          styles: const PosStyles(align: PosAlign.center),
        ),
        PosColumn(
          text: double.parse(item.totalQuantity ?? "0.00").toStringAsFixed(2),
          width: 3,
          styles: const PosStyles(align: PosAlign.center),
        ),
        PosColumn(
          text: double.parse(item.totalAmount ?? "0.00").toStringAsFixed(2),
          width: 3,
          styles: const PosStyles(align: PosAlign.center),
        ),
      ]));
    }
    bytes.addAll(
      generator.row([
        PosColumn(
          text: '#',
          width: 2,
          styles: const PosStyles(bold: true, align: PosAlign.center),
        ),
        PosColumn(
          text: ' ',
          width: 4,
          styles: const PosStyles(bold: true, align: PosAlign.center),
        ),
        PosColumn(
          text: brandList
              .map((e) => double.parse(e.totalQuantity ?? "0.00"))
              .fold(0.0, (a, b) => a + b)
              .toStringAsFixed(2),
          width: 3,
          styles: const PosStyles(bold: true, align: PosAlign.center),
        ),
        PosColumn(
          text: brandList
              .map((e) => double.parse(e.totalAmount ?? "0.00"))
              .fold(0.0, (a, b) => a + b)
              .toStringAsFixed(2),
          width: 3,
          styles: const PosStyles(bold: true, align: PosAlign.center),
        ),
      ]),
    );
    bytes.addAll(generator.hr());
    bytes.addAll(generator.text(
      "Details of products sold (By Brand)",
      styles: const PosStyles(align: PosAlign.center),
    ));
    bytes.addAll(
      generator.row([
        PosColumn(
          text: 'S.No',
          width: 2,
          styles: const PosStyles(align: PosAlign.center, bold: true),
        ),
        PosColumn(
          text: 'Brands',
          width: 4,
          styles: const PosStyles(align: PosAlign.center, bold: true),
        ),
        PosColumn(
          text: 'QTY',
          width: 3,
          styles: const PosStyles(align: PosAlign.center, bold: true),
        ),
        PosColumn(
          text: 'T.Amt',
          width: 3,
          styles: const PosStyles(align: PosAlign.center, bold: true),
        ),
      ]),
    );
    for (final entry in brandList.asMap().entries) {
      final i = entry.key; // index
      final item = entry.value; // item
      bytes.addAll(generator.row([
        PosColumn(
            text: "${i + 1}",
            width: 2,
            styles: const PosStyles(align: PosAlign.center)),
        PosColumn(
          text: item.brandName ?? "",
          width: 4,
          styles: const PosStyles(align: PosAlign.center),
        ),
        PosColumn(
          text: double.parse(item.totalQuantity ?? "0.00").toStringAsFixed(2),
          width: 3,
          styles: const PosStyles(align: PosAlign.center),
        ),
        PosColumn(
          text: double.parse(item.totalAmount ?? "0.00").toStringAsFixed(2),
          width: 3,
          styles: const PosStyles(align: PosAlign.center),
        ),
      ]));
    }
    bytes.addAll(
      generator.row([
        PosColumn(
          text: '#',
          width: 2,
          styles: const PosStyles(bold: true, align: PosAlign.center),
        ),
        PosColumn(
          text: ' ',
          width: 4,
          styles: const PosStyles(bold: true, align: PosAlign.center),
        ),
        PosColumn(
          text: brandList
              .map((e) => double.parse(e.totalQuantity ?? "0.00"))
              .fold(0.0, (a, b) => a + b)
              .toStringAsFixed(2),
          width: 3,
          styles: const PosStyles(bold: true, align: PosAlign.center),
        ),
        PosColumn(
          text: brandList
              .map((e) => double.parse(e.totalAmount ?? "0.00"))
              .fold(0.0, (a, b) => a + b)
              .toStringAsFixed(2),
          width: 3,
          styles: const PosStyles(bold: true, align: PosAlign.center),
        ),
      ]),
    );
    bytes.addAll(generator.hr());
    bytes.addAll(
      generator.row([
        PosColumn(
          text: 'User',
          width: 3,
          styles: const PosStyles(bold: true, align: PosAlign.left),
        ),
        PosColumn(
          text: pref!.getString(AppStrings.userName) ?? "",
          width: 9,
        )
      ]),
    );
    bytes.addAll(
      generator.row([
        PosColumn(
          text: 'Location',
          width: 3,
          styles: const PosStyles(bold: true, align: PosAlign.left),
        ),
        PosColumn(
            text: pref!.getString(AppStrings.selectedAddress) ?? "",
            width: 9,
            styles: PosStyles(align: PosAlign.left))
      ]),
    );
    bytes.addAll(generator.feed(2));
    bytes.addAll(generator.cut());
    return bytes;
  }

  Future<List<int>> printCommonData(
      {required List<Map<String, String>> sellExpensesDetails,
      required List<Map<String, String>> totalSalesDetails,
      required String total,
      required List<ProductDetails> productList,
      required List<ProductDetailsByBrand> brandList,
      required List<ProductDetailsVoid> voidList}) async {
    final now = DateTime.now();
    final dateStr = DateFormat('dd/MM/yyyy').format(now);
    final timeStr = DateFormat('hh:mm:ss').format(now);
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    final List<int> bytes = [];
    bytes.addAll(generator.reset());
    bytes.addAll(generator.text(
      "HNMART",
      styles: const PosStyles(
        width: PosTextSize.size3,
        height: PosTextSize.size3,
        bold: true,
        align: PosAlign.center,
      ),
    ));
    bytes.addAll(generator.text(
      "Daily Closing Report",
      styles: const PosStyles(
          align: PosAlign.center, fontType: PosFontType.fontB, bold: true),
    ));
    // bytes.addAll(generator.text(
    //   "\n${prefs!.getString(AppStrings.selectedAddress) ?? " "}",
    //   styles: const PosStyles(align: PosAlign.center),
    // ));
    bytes.addAll(generator.text(
      "Printing Date/Time : $dateStr/$timeStr",
      styles: const PosStyles(align: PosAlign.center),
    ));
    bytes.addAll(
      generator.row([
        PosColumn(
          text: 'Start Bill No :',
          width: 6,
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text: model!.cashDetails!.firstBillNo ?? "",
          width: 6,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]),
    );
    bytes.addAll(
      generator.row([
        PosColumn(
          text: 'Last Bill No :',
          width: 6,
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text: model!.cashDetails!.lastBillNo ?? "",
          width: 6,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]),
    );
    bytes.addAll(
      generator.row([
        PosColumn(
          text: 'Total Bill :',
          width: 6,
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text: model!.cashDetails!.totalBills.toString(),
          width: 6,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]),
    );
    bytes.addAll(generator.hr());
    bytes.addAll(generator.text(
      "Department Summary",
      styles: const PosStyles(align: PosAlign.center),
    ));
    for (final entry
        in model!.cashDetails!.productDetailsByCategory!.asMap().entries) {
      final i = entry.key; // index
      final item = entry.value; // item
      bytes.addAll(generator.row([
        PosColumn(
          text: "${item.categoryName}",
          width: 6,
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text: double.parse(item.totalQuantity ?? "0.00").toStringAsFixed(2),
          width: 3,
          styles: const PosStyles(align: PosAlign.center),
        ),
        PosColumn(
          text: double.parse(item.totalAmount ?? "0.00").toStringAsFixed(2),
          width: 3,
          styles: const PosStyles(align: PosAlign.center),
        ),
      ]));
    }
    bytes.addAll(generator.hr());
    bytes.addAll(generator.text(
      "Hourly Sales Summary",
      styles: const PosStyles(align: PosAlign.center),
    ));
    bytes.addAll(
      generator.row([
        PosColumn(
          text: 'Hour',
          width: 3,
          styles: const PosStyles(align: PosAlign.center, bold: true),
        ),
        PosColumn(
          text: 'Orders ',
          width: 3,
          styles: const PosStyles(align: PosAlign.center, bold: true),
        ),
        PosColumn(
          text: 'Items',
          width: 3,
          styles: const PosStyles(align: PosAlign.center, bold: true),
        ),
        PosColumn(
          text: 'Gross',
          width: 3,
          styles: const PosStyles(align: PosAlign.center, bold: true),
        ),
      ]),
    );
    for (final entry in model!.cashDetails!.hourelySales!.asMap().entries) {
      final i = entry.key; // index
      final item = entry.value; // item
      bytes.addAll(generator.row([
        PosColumn(
          text: item.range ?? "",
          width: 3,
          styles: const PosStyles(align: PosAlign.center),
        ),
        PosColumn(
          text: item.ordersCount ?? "",
          width: 3,
          styles: const PosStyles(align: PosAlign.center),
        ),
        PosColumn(
          text: double.parse(item.itemsCount ?? "0.00").toStringAsFixed(2),
          width: 3,
          styles: const PosStyles(align: PosAlign.center),
        ),
        PosColumn(
          text: double.parse(item.totalAmount ?? "0.00").toStringAsFixed(2),
          width: 3,
          styles: const PosStyles(align: PosAlign.center),
        ),
      ]));
    }
    bytes.addAll(generator.hr());
    bytes.addAll(generator.text(
      "Register Details ( ${model!.cashRegDetails!.openTime} - ${model!.cashRegDetails!.closedAt ?? ""})",
      styles: const PosStyles(
          align: PosAlign.center, fontType: PosFontType.fontB, bold: true),
    ));
    bytes.addAll(
      generator.row([
        PosColumn(
          text: 'Payment Method',
          width: 6,
          styles: const PosStyles(bold: true),
        ),
        PosColumn(
          text: 'Sell',
          width: 3,
          styles: const PosStyles(bold: true),
        ),
        PosColumn(
          text: 'Expenses ',
          width: 3,
          styles: const PosStyles(bold: true),
        ),
      ]),
    );
    for (final item in sellExpensesDetails) {
      bytes.addAll(generator.row([
        PosColumn(
            text: item['label'] ?? '',
            width: 6,
            styles: const PosStyles(align: PosAlign.left)),
        PosColumn(
          text: item['sell'] ?? "",
          width: 3,
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text: item['expense'] ?? "",
          width: 3,
          styles: const PosStyles(align: PosAlign.center),
        ),
      ]));
    }
    bytes.addAll(generator.hr());
    for (final item in totalSalesDetails) {
      bytes.addAll(generator.row([
        PosColumn(
            text: item['label'] ?? '',
            width: 6,
            styles: const PosStyles(align: PosAlign.left)),
        PosColumn(
          text: item['value'] ?? "",
          width: 6,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]));
    }
    bytes.addAll(generator.hr());
    bytes.addAll(generator.text(
      total ?? "",
      styles: const PosStyles(align: PosAlign.center),
    ));
    bytes.addAll(generator.hr());
    bytes.addAll(generator.text(
      "Details of products sold",
      styles: const PosStyles(align: PosAlign.center),
    ));
    bytes.addAll(
      generator.row([
        PosColumn(
          text: 'S.No',
          width: 1,
          styles: const PosStyles(align: PosAlign.center, bold: true),
        ),
        /*PosColumn(
          text: 'Code',
          width: 3,
          styles: const PosStyles(bold: true, align: PosAlign.center),
        ),*/
        PosColumn(
          text: 'Product ',
          width: 5,
          styles: const PosStyles(align: PosAlign.center, bold: true),
        ),
        PosColumn(
          text: 'QTY',
          width: 3,
          styles: const PosStyles(align: PosAlign.center, bold: true),
        ),
        PosColumn(
          text: 'T.Amt',
          width: 3,
          styles: const PosStyles(align: PosAlign.center, bold: true),
        ),
      ]),
    );
    for (final entry in productList.asMap().entries) {
      final i = entry.key; // index
      final item = entry.value; // item
      bytes.addAll(generator.row([
        PosColumn(
          text: "${i + 1}",
          width: 1,
          styles: const PosStyles(align: PosAlign.center),
        ),
        PosColumn(
          text: " ${item.productName ?? " "}",
          width: 5,
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text: double.parse(item.totalQuantity ?? "0.00").toStringAsFixed(2),
          width: 3,
          styles: const PosStyles(align: PosAlign.center),
        ),
        PosColumn(
          text: double.parse(item.totalAmount ?? "0.00").toStringAsFixed(2),
          width: 3,
          styles: const PosStyles(align: PosAlign.center),
        ),
      ]));
    }
    bytes.addAll(
      generator.row([
        PosColumn(
          text: '#',
          width: 1,
          styles: const PosStyles(bold: true, align: PosAlign.center),
        ),
        PosColumn(
          text: '',
          width: 5,
          styles: const PosStyles(bold: true, align: PosAlign.center),
        ),
        PosColumn(
          text: productList
              .map((e) => double.parse(e.totalQuantity ?? "0.00"))
              .fold(0.0, (a, b) => a + b)
              .toStringAsFixed(2),
          width: 3,
          styles: const PosStyles(bold: true, align: PosAlign.center),
        ),
        PosColumn(
          text: productList
              .map((e) => double.parse(e.totalAmount ?? "0.00"))
              .fold(0.0, (a, b) => a + b)
              .toStringAsFixed(2),
          width: 3,
          styles: const PosStyles(bold: true, align: PosAlign.center),
        ),
      ]),
    );
    bytes.addAll(generator.hr());
    bytes.addAll(generator.text(
      "Details of products void",
      styles: const PosStyles(align: PosAlign.center),
    ));
    bytes.addAll(
      generator.row([
        PosColumn(
          text: 'S.No',
          width: 2,
          styles: const PosStyles(align: PosAlign.center, bold: true),
        ),
        PosColumn(
          text: 'Brands',
          width: 4,
          styles: const PosStyles(align: PosAlign.center, bold: true),
        ),
        PosColumn(
          text: 'QTY',
          width: 3,
          styles: const PosStyles(align: PosAlign.center, bold: true),
        ),
        PosColumn(
          text: 'T.Amt',
          width: 3,
          styles: const PosStyles(align: PosAlign.center, bold: true),
        ),
      ]),
    );
    for (final entry in voidList.asMap().entries) {
      final i = entry.key; // index
      final item = entry.value; // item
      bytes.addAll(generator.row([
        PosColumn(
            text: "${i + 1}",
            width: 2,
            styles: const PosStyles(align: PosAlign.center)),
        PosColumn(
          text: item.productName ?? "",
          width: 4,
          styles: const PosStyles(align: PosAlign.center),
        ),
        PosColumn(
          text: double.parse(item.totalQuantity ?? "0.00").toStringAsFixed(2),
          width: 3,
          styles: const PosStyles(align: PosAlign.center),
        ),
        PosColumn(
          text: double.parse(item.totalAmount ?? "0.00").toStringAsFixed(2),
          width: 3,
          styles: const PosStyles(align: PosAlign.center),
        ),
      ]));
    }
    bytes.addAll(
      generator.row([
        PosColumn(
          text: '#',
          width: 2,
          styles: const PosStyles(bold: true, align: PosAlign.center),
        ),
        PosColumn(
          text: ' ',
          width: 4,
          styles: const PosStyles(bold: true, align: PosAlign.center),
        ),
        PosColumn(
          text: brandList
              .map((e) => double.parse(e.totalQuantity ?? "0.00"))
              .fold(0.0, (a, b) => a + b)
              .toStringAsFixed(2),
          width: 3,
          styles: const PosStyles(bold: true, align: PosAlign.center),
        ),
        PosColumn(
          text: brandList
              .map((e) => double.parse(e.totalAmount ?? "0.00"))
              .fold(0.0, (a, b) => a + b)
              .toStringAsFixed(2),
          width: 3,
          styles: const PosStyles(bold: true, align: PosAlign.center),
        ),
      ]),
    );
    bytes.addAll(generator.hr());
    bytes.addAll(generator.text(
      "Details of products sold (By Brand)",
      styles: const PosStyles(align: PosAlign.center),
    ));
    bytes.addAll(
      generator.row([
        PosColumn(
          text: 'S.No',
          width: 2,
          styles: const PosStyles(align: PosAlign.center, bold: true),
        ),
        PosColumn(
          text: 'Brands',
          width: 4,
          styles: const PosStyles(align: PosAlign.center, bold: true),
        ),
        PosColumn(
          text: 'QTY',
          width: 3,
          styles: const PosStyles(align: PosAlign.center, bold: true),
        ),
        PosColumn(
          text: 'T.Amt',
          width: 3,
          styles: const PosStyles(align: PosAlign.center, bold: true),
        ),
      ]),
    );
    for (final entry in brandList.asMap().entries) {
      final i = entry.key; // index
      final item = entry.value; // item
      bytes.addAll(generator.row([
        PosColumn(
            text: "${i + 1}",
            width: 2,
            styles: const PosStyles(align: PosAlign.center)),
        PosColumn(
          text: item.brandName ?? "",
          width: 4,
          styles: const PosStyles(align: PosAlign.center),
        ),
        PosColumn(
          text: double.parse(item.totalQuantity ?? "0.00").toStringAsFixed(2),
          width: 3,
          styles: const PosStyles(align: PosAlign.center),
        ),
        PosColumn(
          text: double.parse(item.totalAmount ?? "0.00").toStringAsFixed(2),
          width: 3,
          styles: const PosStyles(align: PosAlign.center),
        ),
      ]));
    }
    bytes.addAll(
      generator.row([
        PosColumn(
          text: '#',
          width: 2,
          styles: const PosStyles(bold: true, align: PosAlign.center),
        ),
        PosColumn(
          text: ' ',
          width: 4,
          styles: const PosStyles(bold: true, align: PosAlign.center),
        ),
        PosColumn(
          text: brandList
              .map((e) => double.parse(e.totalQuantity ?? "0.00"))
              .fold(0.0, (a, b) => a + b)
              .toStringAsFixed(2),
          width: 3,
          styles: const PosStyles(bold: true, align: PosAlign.center),
        ),
        PosColumn(
          text: brandList
              .map((e) => double.parse(e.totalAmount ?? "0.00"))
              .fold(0.0, (a, b) => a + b)
              .toStringAsFixed(2),
          width: 3,
          styles: const PosStyles(bold: true, align: PosAlign.center),
        ),
      ]),
    );
    bytes.addAll(generator.hr());
    bytes.addAll(
      generator.row([
        PosColumn(
          text: 'User',
          width: 3,
          styles: const PosStyles(bold: true, align: PosAlign.left),
        ),
        PosColumn(
          text: pref!.getString(AppStrings.userName) ?? "",
          width: 9,
        )
      ]),
    );
    bytes.addAll(
      generator.row([
        PosColumn(
          text: 'Location',
          width: 3,
          styles: const PosStyles(bold: true, align: PosAlign.left),
        ),
        PosColumn(
            text: pref!.getString(AppStrings.selectedAddress) ?? "",
            width: 9,
            styles: PosStyles(align: PosAlign.left))
      ]),
    );
    bytes.addAll(generator.feed(2));
    bytes.addAll(generator.cut());
    return bytes;
  }

  void getCloseCash() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            contentPadding: EdgeInsets.zero,
            content: NewCashCloseWidget(
              // onDone: (Map<String, dynamic> postData) =>
              //     onCashClose(postData)
              onDone: (postData) => onCashClose(postData),
            ),
          ),
        );
      },
    );
  }

  Future<void> onCashClose(Map<String, dynamic> postData) async {
    pref = spEngine!.prefs;
    int? cashId = pref!.getInt(AppStrings.cashId) ?? 0;
    bool result = await model!.cashCloseApi(
        postBody: postData,
        context: context,
        key: keyLoader,
        cashId: cashId.toString());
    if (result) {
      if (result) {
        if (widget.printers.isNotEmpty) {
          commonPrinter(
              deviceId:
              widget.printers[0]['deviceId'].toString(),);
        }
        Navigator.of(context).pushNamedAndRemoveUntil(
          "/",
          (route) => false,
        );
        sendMsgToSubScreen(method: "list", data: model!.cartListModel.toJson());
        sendMsgToSubScreen(
            method: "pay", data: {"payment": [], "discount_type": ""});
      }
    }
  }

  Future<void> sendMsgToSubScreen({String? method, data}) async {
    final isMultipleScreen =
        await imInViceScreenPlugin.isSupportMultipleScreen();
    if (isMultipleScreen != null && isMultipleScreen) {
      imInViceScreenPlugin
          .sendMsgToViceScreen(method!, params: {"data": data!});
    }
  }
}
