import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gmart/Constant/app_color.dart';
import 'package:gmart/Constant/app_strings.dart';
import 'package:gmart/Core/application_base.dart';
import 'package:gmart/UI/Dashboard/Model/cart_list_model.dart';
import 'package:gmart/UI/Dashboard/Model/custom_report_model.dart';
import 'package:gmart/UI/Dashboard/Model/order_hold_model.dart';
import 'package:gmart/UI/Dashboard/Model/place_order_model.dart';
import 'package:gmart/UI/Dashboard/Model/product_list_reponse_model.dart';
import 'package:gmart/UI/Dashboard/Model/recall_hold_order_details_response_model.dart';
import 'package:gmart/UI/Dashboard/Model/recall_hold_order_response_model.dart';
import 'package:gmart/UI/Dashboard/Model/scanned_product_response_model.dart';
import 'package:gmart/UI/Dashboard/View/add_customer_screen.dart';
import 'package:gmart/UI/Dashboard/View/date_range_screen.dart';
import 'package:gmart/UI/Dashboard/View/discount_widget.dart';
import 'package:gmart/UI/Dashboard/View/kilogram_reading_widget.dart';
import 'package:gmart/UI/Dashboard/View/new_cash_close_widget.dart';
import 'package:gmart/UI/Dashboard/View/payment_finish_widget.dart';
import 'package:gmart/UI/Dashboard/View/payment_widget.dart';
import 'package:gmart/UI/Dashboard/View/register_screen.dart';
import 'package:gmart/UI/Dashboard/View/search_widget.dart';
import 'package:gmart/UI/Dashboard/View/selling_price_widget.dart';
import 'package:gmart/UI/Dashboard/View/stock_transfer.dart';
import 'package:gmart/UI/Dashboard/View/view_receipt_screen.dart';
import 'package:gmart/UI/Dashboard/View/void_bill_screen.dart';
import 'package:gmart/UI/Dashboard/View/xy_report_screen.dart';
import 'package:gmart/UI/Dashboard/ViewModel/dashboard_view_model.dart';
import 'package:gmart/UI/Dashboard/ViewModel/local_dashboard_view_model.dart';
import 'package:gmart/UI/Splash/Model/cash_checking_response_model.dart';
import 'package:gmart/UI/Stock/View/add_product_screen.dart';
import 'package:gmart/Utils/custom_dialog_box.dart';
import 'package:imin_printer/column_maker.dart';
import 'package:imin_printer/enums.dart';
import 'package:imin_printer/imin_printer.dart';
import 'package:imin_printer/imin_style.dart';
import 'package:imin_vice_screen/imin_vice_screen.dart';
import 'package:intl/intl.dart';
import 'package:image/image.dart' as img;
import 'dart:typed_data';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  LocalDashboardViewModel? model;
  int selectedCategoryId = 0;
  int selectedProductId = 0;
  DateTime? currentBackPressTime;
  final keyLoader = GlobalKey<State>();
  final scanKeyLoader = GlobalKey<State>();
  final formKey = GlobalKey<FormState>();
  String? typeValue = "";
  TextEditingController amtCtrl = TextEditingController();
  TextEditingController searchCtrl = TextEditingController();
  int? selectedCart;
  String? selectedName = "";
  String? selectedDiscount = "";
  String disCount = "";
  IminPrinter imInPrinter = IminPrinter();
  IminViceScreen imInViceScreenPlugin = IminViceScreen();
  ScrollController categoryScroll = ScrollController();
  ScrollController productCtrl = ScrollController();
  ScrollController btnScrollCtrl = ScrollController();
  final FocusNode _focusNode = FocusNode();
  bool isHold = false,
      isPay = false,
      isSearch = false,
      isRecall = false,
      isOrder = false,
      isVisible = false,
      isNor = false;
  int? holdId = 0;
  List<Map<String, dynamic>> paymentMethod = [];
  List<dynamic> printers = [];
  SharedPreferences? prefs;
  double kiloUnit = 0.00,
      returnChange = 0.00,
      lastTotal = 0.00,
      lastDiscount = 0.00;
  String lastBillNo = "", lastTransaction = "";
  List<Payment> paymentList = [];
  List<ProductList> lastItems = [];
  int time = 120;
  List<Map<String, String>> lastPayments = [];
  String cusName = "", mobile = "";

  @override
  void initState() {
    prefs = spEngine!.prefs;
    initPrinter();
    // initScreen();
    // _loadPrinters();
    String? permittedList = prefs!.getString(AppStrings.paymentList);
    if (permittedList != null) {
      List<dynamic> decodedList = jsonDecode(permittedList);
      List<Payment> mainList =
          decodedList.map((e) => Payment.fromJson(e)).toList();
      setState(() {
        paymentList = mainList;
      });
    }
    productCtrl.addListener(
      () {
        if (productCtrl.position.pixels ==
            productCtrl.position.maxScrollExtent) {
          debugPrint("Event call this area");
          // getMoreProduct();
        }
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
    super.initState();
  }

  Widget getAmt(List<Map<String, String>> payType) {
    Map<String, double> grouped = {};

    for (var payment in payType) {
      final method = payment['method'] ?? "";
      final amount = payment['amount'] ?? "0.00";
      grouped[method] = (grouped[method] ?? 0) + double.parse(amount);
    }

    // Convert to widget items
    final items = grouped.entries.map((e) {
      final match =
          paymentList.where((element) => element.key == e.key).toList();
      final displayKey = match.isNotEmpty ? match[0].type : e.key;

      return Expanded(
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${displayKey ?? ""} :",
              style: TextStyle(
                  fontSize: 14.0,
                  color: AppColor.whiteColor,
                  fontWeight: FontWeight.w400),
            ),
            Text(
              "S\$${e.value.toStringAsFixed(2)}",
              style: TextStyle(
                  color: AppColor.whiteColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 17.0),
            ),
            const SizedBox(
              width: 15.0,
            )
          ],
        ),
      );
    }).toList();

    // Build rows with 2 items each
    List<Row> rows = [];
    for (int i = 0; i < items.length; i += 2) {
      rows.add(
        Row(
          children: [
            items[i],
            if (i + 1 < items.length)
              items[i + 1]
            else
              const Expanded(child: SizedBox()),
          ],
        ),
      );
    }

    return Column(children: rows);
  }

  void startTimer() {
    Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (time == 0) {
          setState(() {
            isVisible = false;
            time = 120;
          });
        } else {
          setState(() {
            time--;
          });
        }
      },
    );
  }

  String getDataFormat({required String date, String? type}) {
    String formatData = "";
    switch (type) {
      case "date":
        try {
          formatData = DateFormat("dd/MM/yyyy").format(DateTime.parse(date));
          return formatData;
        } catch (e) {
          return date;
        }
      case "time":
        try {
          formatData = DateFormat("HH:mm").format(DateTime.parse(date));
          return formatData;
        } catch (e) {
          return date;
        }
      default:
        try {
          formatData = DateFormat("dd/MM/yyyy").format(DateTime.parse(date));
          return formatData;
        } catch (e) {
          return date;
        }
    }
  }

  getTotalWithTaxAmt() {
    String taxRate = prefs!.getString(AppStrings.taxRate) ?? "0";
    double tax = int.parse(taxRate) / 100;
    double totalAmount = model!.calculation.grandTotal != null
        ? model!.calculation.grandTotal!
        : model!.calculation.grandTotal ?? 0.0;
    double taxAmount = tax * totalAmount;
    String taxType = prefs!.getString(AppStrings.taxType) ?? "inclusive";
    if (taxType.toLowerCase() != "inclusive") {
      return (totalAmount + taxAmount).toStringAsFixed(2);
    } else {
      return (totalAmount).toStringAsFixed(2);
    }
  }

  getTaxAmt() {
    String taxRate = prefs!.getString(AppStrings.taxRate) ?? "0";
    double tax = int.parse(taxRate) / 100;
    double totalAmount = model!.calculation.grandTotal != null
        ? model!.calculation.grandTotal!
        : model!.calculation.grandTotal ?? 0.0;
    double taxAmount = tax * totalAmount;
    return taxAmount.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<LocalDashboardViewModel>(
      prepareModel: (model) {
        this.model = model;
        loadPrinters();
        model.loadInitial().then(
          (value) {
            // if (model.state == ViewState.active) {
            selectedCategoryId = model.categoryId;
            // }
          },
        );
      },
      builder: (context, model, child) {
        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            if (!didPop) {
              DateTime now = DateTime.now();
              if (currentBackPressTime == null ||
                  now.difference(currentBackPressTime!) >
                      const Duration(seconds: 2)) {
                currentBackPressTime = DateTime.now();
                Fluttertoast.showToast(
                  msg: "Press again to exit",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: AppColor.primaryColor,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              } else {
                Navigator.of(context).pop();
              }
            }
          },
          child: model.state == ViewState.inActive
              ? const Scaffold(body: Center(child: CircularProgressIndicator()))
              : KeyboardListener(
                  focusNode: _focusNode,
                  onKeyEvent: (value) {
                    setState(() {
                      isVisible = false;
                    });
                    model.handleKeyEvent(
                        value: value,
                        typeValue: typeValue ?? "",
                        context: context,
                        keyLoader: keyLoader,
                        onDone: () {
                          setState(() {
                            typeValue = "";
                          });
                          sendMsgToSubScreen(
                              method: "list",
                              data: model.cartListModel.toJson());
                          sendMsgToSubScreen(method: "pay", data: {
                            "payment": paymentMethod.toList(),
                            "discount_type": selectedDiscount
                          });
                        });
                    _focusNode.requestFocus();
                    setState(() {});
                  },
                  child: Scaffold(
                    backgroundColor: AppColor.whiteColor,
                    appBar: AppBar(
                      toolbarHeight: 0.0,
                      title: const Text("G-Mart POS"),
                      elevation: 0.0,
                      systemOverlayStyle: SystemUiOverlayStyle(
                          statusBarColor: AppColor.whiteColor,
                          statusBarIconBrightness: Brightness.dark),
                    ),
                    body: Column(
                      children: [
                        isVisible
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5.0),
                                color: AppColor.blackColor,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "Receipt No: ",
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: AppColor.whiteColor,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              Flexible(
                                                child: Text(
                                                  lastBillNo,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color:
                                                          AppColor.whiteColor,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 17.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Cashier: ",
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: AppColor.whiteColor,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              Text(
                                                prefs!.getString(
                                                        AppStrings.userName) ??
                                                    "",
                                                style: TextStyle(
                                                    color: AppColor.whiteColor,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 17.0),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15.0,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "Date: ",
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: AppColor.whiteColor,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              Flexible(
                                                child: Text(
                                                  getDataFormat(
                                                    date: model.lastPurchase ??
                                                        "",
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color:
                                                          AppColor.whiteColor,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 17.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Time: ",
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: AppColor.whiteColor,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              Flexible(
                                                child: Text(
                                                  getDataFormat(
                                                      date:
                                                          model.lastPurchase ??
                                                              "",
                                                      type: "time"),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color:
                                                          AppColor.whiteColor,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 17.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                          /* returnChange.toStringAsFixed(2) ==
                                                  "0.00"
                                              ? const SizedBox.shrink()
                                              : Row(
                                                  children: [
                                                    Text(
                                                      "Change Return: ",
                                                      style: TextStyle(
                                                          fontSize: 14.0,
                                                          color: AppColor
                                                              .whiteColor,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                    Text(
                                                      "S\$${returnChange.toStringAsFixed(2)}",
                                                      style: TextStyle(
                                                          color: AppColor
                                                              .whiteColor,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 17.0),
                                                    ),
                                                  ],
                                                ),*/
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15.0,
                                    ),
                                    Expanded(child: getAmt(lastPayments)),
                                    const SizedBox(
                                      width: 5.0,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Total Amount: ",
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  color: AppColor.whiteColor,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            Text(
                                              "S\$${lastTotal.toStringAsFixed(2)}",
                                              style: TextStyle(
                                                  color: AppColor.whiteColor,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 17.0),
                                            ),
                                          ],
                                        ),
                                        // const SizedBox(height: 10.0),
                                        returnChange.toStringAsFixed(2) ==
                                                "0.00"
                                            ? const SizedBox()
                                            : Row(
                                                children: [
                                                  Text(
                                                    "Change Return: ",
                                                    style: TextStyle(
                                                        fontSize: 14.0,
                                                        color:
                                                            AppColor.whiteColor,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  Text(
                                                    "S\$${returnChange.toStringAsFixed(2)}",
                                                    style: TextStyle(
                                                        color:
                                                            AppColor.whiteColor,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 17.0),
                                                  ),
                                                ],
                                              ),
                                      ],
                                    ),
                                    // Text(getAmt(lastPayments),style: TextStyle(color: AppColor.whiteColor),),
                                    // Text(lastPayments.toString(),style: TextStyle(color: AppColor.whiteColor),)
                                  ],
                                ),
                              )
                            : Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 5.0),
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    billHeadWidget(
                                        top:
                                            "Location : ${prefs!.getString(AppStrings.selectedHub) ?? ""}",
                                        bottom:
                                            "Cashier : ${prefs!.getString(AppStrings.userName) ?? ""}"),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Date : ${DateFormat("dd/MM/yyy").format(DateTime.now())}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          const SizedBox(
                                            width: 15.0,
                                          ),
                                          Visibility(
                                            visible: (model.calculation
                                                            .discountAmount ??
                                                        0.0)
                                                    .toStringAsFixed(2) !=
                                                "0.00",
                                            child: Text(
                                              "Dis/Voc : \$ ${(model.calculation.discountAmount ?? 0.0).toStringAsFixed(2)}",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 15.0,
                                          ),
                                          Visibility(
                                            visible: prefs!.getBool(
                                                    AppStrings.isTax) ??
                                                false,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Tax : ${prefs!.getString(AppStrings.taxType)}",
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                                const SizedBox(
                                                  height: 5.0,
                                                ),
                                                Text(
                                                  // "Total :  \$ ${model.calculation.grandTotal != null ? model.calculation.grandTotal!.toStringAsFixed(2) : model.calculation.grandTotal!}",
                                                  "Tax Amt :  \$ ${getTaxAmt()}",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            // "Total :  \$ ${model.calculation.grandTotal != null ? model.calculation.grandTotal!.toStringAsFixed(2) : model.calculation.grandTotal!}",
                                            "Total :  \$ ${getTotalWithTaxAmt()}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                // child: !isSearch
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      categoryListWidget(model),
                                      const SizedBox(
                                        height: 6.0,
                                      ),
                                      productListWidget(context)
                                    ],
                                  ),
                                ),
                              ),
                              // const SizedBox(
                              //   width: 15.0,
                              // ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15.0,
                                                vertical: 10.0),
                                            decoration: BoxDecoration(
                                              color: Colors.yellow,
                                              border: Border(
                                                bottom: BorderSide(
                                                    color: AppColor.blackColor,
                                                    width: 2.0),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                /*const Text(
                                                  "S/No",
                                                  style:
                                                      TextStyle(fontSize: 15.0),
                                                ),
                                                const SizedBox(
                                                  width: 5.0,
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.22,
                                                  child: const Text(
                                                    "Products",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        fontSize: 15.0),
                                                  ),
                                                ),
                                                SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.07,
                                                    child: const Text(
                                                      "QTY",
                                                      style: TextStyle(
                                                          fontSize: 15.0),
                                                    )),
                                                const Text(
                                                  "U.Price",
                                                  textAlign: TextAlign.end,
                                                  style:
                                                      TextStyle(fontSize: 15.0),
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 35.0),
                                                  child: Text(
                                                    "T.Price",
                                                    style: TextStyle(
                                                        fontSize: 15.0),
                                                  ),
                                                ),*/

                                                const SizedBox(
                                                  width: 50.0,
                                                  child: Text(
                                                    "S.NO",
                                                    textAlign: TextAlign.center,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 18.0,
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.2,
                                                  child: const Text("PRODUCTS",
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                ),
                                                const SizedBox(
                                                  width: 15.0,
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.09,
                                                  child: const Text("QTY",
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                ),
                                                const SizedBox(
                                                  width: 15.0,
                                                ),
                                                // const Spacer(),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.05,
                                                  child: const Text(
                                                    "U.PRICE",
                                                    textAlign: TextAlign.end,
                                                  ),
                                                ),
                                                // const Spacer(),
                                                const Expanded(
                                                  child: Text(
                                                    "T.PRICE",
                                                    textAlign: TextAlign.end,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child:
                                                (model.cartListModel
                                                                .productList !=
                                                            null &&
                                                        model
                                                            .cartListModel
                                                            .productList!
                                                            .isNotEmpty)
                                                    ? cartListWidget(model)
                                                    : isVisible
                                                        ? Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Image.asset(
                                                                    "assets/images/order_compeleted.png",
                                                                    height:
                                                                        50.0,
                                                                    width: 50.0,
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 10.0,
                                                                  ),
                                                                  const Text(
                                                                      "Sales Completed"),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                height: 15.0,
                                                              ),
                                                              InkResponse(
                                                                radius: 5.0,
                                                                onTap: () {
                                                                  if (printers
                                                                      .isNotEmpty) {
                                                                    /*Map<String,
                                                                            double>
                                                                        grouped =
                                                                        {};
                                                                    for (var payment
                                                                        in lastPayments) {
                                                                      String
                                                                          method =
                                                                          payment['method'] ??
                                                                              "";
                                                                      String
                                                                          amount =
                                                                          payment["amount"]
                                                                              .toString();
                                                                      grouped[
                                                                          method] = (grouped[method] ??
                                                                              0) +
                                                                          double.parse(
                                                                              amount);
                                                                    }
                                                                    // Add change return if available
                                                                    double
                                                                        changeReturn =
                                                                        returnChange ??
                                                                            0.00; // assuming it's a string
                                                                    double
                                                                        changeAmount =
                                                                        double.tryParse(changeReturn.toString()) ??
                                                                            0.00;
                                                                    if (changeAmount >
                                                                        0) {
                                                                      grouped[
                                                                          "Balance"] = (grouped["Balance"] ??
                                                                              0) +
                                                                          changeAmount;
                                                                    }*/
                                                                    Map<String,
                                                                            double>
                                                                        grouped =
                                                                        {};
                                                                    for (var payment
                                                                        in lastPayments) {
                                                                      String
                                                                          method =
                                                                          payment['method'] ??
                                                                              "";
                                                                      String
                                                                          amount =
                                                                          payment["amount"]
                                                                              .toString();
                                                                      grouped[
                                                                          method] = (grouped[method] ??
                                                                              0) +
                                                                          double.parse(
                                                                              amount);
                                                                    }
                                                                    // Add change return if available
                                                                    double
                                                                        changeReturn =
                                                                        returnChange ??
                                                                            0.00; // assuming it's a string
                                                                    double
                                                                        changeAmount =
                                                                        double.tryParse(changeReturn.toString()) ??
                                                                            0.00;
                                                                    if (changeAmount >
                                                                        0) {
                                                                      grouped[
                                                                          "Balance"] = (grouped["Balance"] ??
                                                                              0) +
                                                                          changeAmount;
                                                                    }
                                                                    usbPrint(
                                                                        deviceId:
                                                                            printers[0]['deviceId']
                                                                                .toString(),
                                                                        gTotal:
                                                                            lastTotal.toStringAsFixed(
                                                                                2),
                                                                        products:
                                                                            lastItems,
                                                                        receipt:
                                                                            lastBillNo,
                                                                        time: getDataFormat(
                                                                            date: model.lastPurchase ??
                                                                                "",
                                                                            type:
                                                                                "time"),
                                                                        date: getDataFormat(
                                                                            date: model.lastPurchase ??
                                                                                ""),
                                                                        discount:
                                                                            lastDiscount.toStringAsFixed(
                                                                                2),
                                                                        payHistory: grouped
                                                                            .entries
                                                                            .map((e) =>
                                                                                {
                                                                                  e.key: e.value
                                                                                })
                                                                            .toList());
                                                                  }
                                                                },
                                                                child:
                                                                    Container(
                                                                  width: 120.0,
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          10.0),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    // color: Colors.redAccent,
                                                                    border: Border.all(
                                                                        color: AppColor
                                                                            .primaryColor),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5.0),
                                                                  ),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .local_print_shop_outlined,
                                                                        color: AppColor
                                                                            .primaryColor,
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            5.0,
                                                                      ),
                                                                      Text(
                                                                        "Print",
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .w600,
                                                                            fontSize:
                                                                                16.0,
                                                                            color:
                                                                                AppColor.primaryColor),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          )
                                                        : const Center(
                                                            child: Text(
                                                                "Cart is empty"),
                                                          ),
                                          ),
                                          Text(
                                            typeValue!,
                                            style:
                                                const TextStyle(fontSize: 16.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Visibility(
                                      visible: selectedDiscount!.isNotEmpty,
                                      child: InkResponse(
                                        onTap: () {
                                          setState(() {
                                            model.calculation.grandTotal =
                                                double.parse((model.calculation
                                                            .grandTotal! +
                                                        model.calculation
                                                            .discountAmount!)
                                                    .toStringAsFixed(1));
                                            model.calculation.discountAmount =
                                                0.0;
                                            model.cartListModel.discountAmount =
                                                0.0;
                                            selectedDiscount = "";
                                            disCount = "";
                                          });
                                          sendMsgToSubScreen(
                                              method: "list",
                                              data:
                                                  model.cartListModel.toJson());
                                          sendMsgToSubScreen(
                                              method: "pay",
                                              data: {
                                                "payment":
                                                    paymentMethod.toList(),
                                                "discount_type":
                                                    selectedDiscount
                                              });
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "${selectedDiscount!} : \$ $disCount",
                                              style: const TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.red),
                                            ),
                                            const SizedBox(
                                              width: 5.0,
                                            ),
                                            const Icon(
                                              Icons.delete_forever,
                                              color: Colors.red,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(child: inputWidget()),
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.18,
                                            child: inputWidget2()),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  void clearBillAndAdd() {
    // setState(() {
    //   isOrder = false;
    //   model!.cartListModel.productList!.clear();
    //   typeValue = "";
    //   model!.cartListModel.billNo = "";
    //   model!.cartListModel.cashPaid = "0.0";
    //   model!.cartListModel.balance = "0.0";
    //   model!.calculation.grandTotal = 0.0;
    //   model!.calculation.discountAmount = 0.0;
    //   model!.cartListModel.discountAmount = 0.0;
    //   selectedDiscount = "";
    //   paymentMethod = [];
    //   returnChange = 0.0;
    //   isHold = false;
    // });
    // sendMsgToSubScreen(method: "list", data: model!.cartListModel.toJson());
    // sendMsgToSubScreen(
    //     method: "pay",
    //     data: {"payment": [], "discount_type": selectedDiscount});
  }

  onSearchProcess(ScanProduct details) {
    if (details.variationDouble != null &&
        details.variationDouble!.isNotEmpty) {
      /* setState(() {
        if (details.variationDouble!
            .where((element) =>
        element.name == details.name)
            .isEmpty) {
          details.variationDouble!
              .add(VariationDouble(
            name: details.name ?? "",
            id: 0,
            barcode: details.barcode ?? "",
            defaultSellPrice: details.sellingPrice ??
                "",
            unit: details.unit ?? "",
            variationId: details.variationId
                .toString(),
            productId: details.productId
                .toString(),
          ));
        }
      });*/
      getDoublePrice(
          variationDouble: details.variationDouble,
          productName: details.name ?? "",
          unit: details.unit ?? "");
    } else {
      if (details.sellingPrice == "0" ||
          details.sellingPrice == "0.00" ||
          details.sellingPrice == "0.0000" ||
          details.sellingPrice == "") {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              content: SellingPriceWidget(
                onDone: (data) {
                  if (typeValue != null && typeValue!.isEmpty) {
                    if (details.posSellQuantityEdit.toString().toLowerCase() ==
                        "1") {
                      getKgBox(
                        onKg: () {
                          sellingProductUpdate(
                            name: details.name ?? "",
                            quantity: kiloUnit,
                            unitPrice:
                                double.parse(data['selling_price'] ?? "0.0"),
                            id: details.productId.toString(),
                            variantId: details.variationId.toString(),
                            isEdit: details.posSellQuantityEdit ?? "0",
                            unit: details.unit.toString(),
                            totalPrice: kiloUnit *
                                (double.parse(data['selling_price'] ?? "0.0")),
                          );
                        },
                      );
                    } else {
                      sellingProductUpdate(
                        name: details.name ?? "",
                        quantity: 1.0,
                        unitPrice: double.parse(data['selling_price'] ?? "0.0"),
                        id: details.productId.toString(),
                        isEdit: details.posSellQuantityEdit ?? "0",
                        variantId: details.variationId.toString(),
                        unit: details.unit.toString(),
                        totalPrice: 1.0 *
                            (double.parse(data['selling_price'] ?? "0.0")),
                      );
                    }
                  } else {
                    if (typeValue!.length <= 2) {
                      sellingProductUpdate(
                        name: details.name ?? "",
                        quantity: double.parse(typeValue ?? "0"),
                        unitPrice: double.parse(data['selling_price'] ?? "0.0"),
                        id: details.productId.toString(),
                        isEdit: details.posSellQuantityEdit ?? "0",
                        unit: details.unit.toString(),
                        variantId: details.variationId.toString(),
                        totalPrice: int.parse(typeValue ?? "0") *
                            (double.parse(data['selling_price'] ?? "0.0")),
                      );
                    } else {
                      Fluttertoast.showToast(
                          msg:
                              "You are not allow to purchase the product by this quantity.",
                          backgroundColor: Colors.red);
                    }
                  }
                  Navigator.of(context).pop();
                },
              ),
            );
          },
        );
      } else {
        if (typeValue != null && typeValue!.isEmpty) {
          if (details.posSellQuantityEdit.toString().toLowerCase() == "1") {
            getKgBox(
              onKg: () {
                productUpdate(
                  name: details.name ?? "",
                  quantity: kiloUnit,
                  unitPrice: double.parse(details.sellingPrice ?? "0.0"),
                  isEdit: details.posSellQuantityEdit ?? "0",
                  id: details.productId.toString(),
                  variantId: details.variationId.toString(),
                  unit: details.unit.toString(),
                  totalPrice:
                      kiloUnit * (double.parse(details.sellingPrice ?? "0.0")),
                );
              },
            );
          } else {
            productUpdate(
              name: details.name ?? "",
              quantity: 1.0,
              unitPrice: double.parse(details.sellingPrice ?? "0.0"),
              id: details.productId.toString(),
              isEdit: details.posSellQuantityEdit ?? "0",
              variantId: details.variationId.toString(),
              unit: details.unit.toString(),
              totalPrice: 1.0 * (double.parse(details.sellingPrice ?? "0.0")),
            );
          }
        } else {
          if (typeValue!.length <= 2) {
            if (details.posSellQuantityEdit.toString().toString() == "1") {
              getKgBox(
                onKg: () {
                  productUpdate(
                    name: details.name ?? "",
                    quantity: kiloUnit,
                    unitPrice: double.parse(details.sellingPrice ?? "0.0"),
                    id: details.productId.toString(),
                    isEdit: details.posSellQuantityEdit ?? "0",
                    unit: details.unit.toString(),
                    variantId: details.variationId.toString(),
                    totalPrice: kiloUnit *
                        (double.parse(details.sellingPrice ?? "0.0")),
                  );
                },
              );
            } else {
              productUpdate(
                name: details.name ?? "",
                quantity: double.parse(typeValue ?? "0.00"),
                unitPrice: double.parse(details.sellingPrice ?? "0.0"),
                isEdit: details.posSellQuantityEdit ?? "0",
                id: details.productId.toString(),
                unit: details.unit.toString(),
                variantId: details.variationId.toString(),
                totalPrice: int.parse(typeValue ?? "0") *
                    (double.parse(details.sellingPrice ?? "0.0")),
              );
            }
          } else {
            Fluttertoast.showToast(
                msg:
                    "You are not allow to purchase the product by this quantity.",
                backgroundColor: Colors.red);
          }
        }
      }
    }
    _focusNode.requestFocus();
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
            height: 5.0,
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

  Widget cartListWidget(LocalDashboardViewModel model) {
    List<ProductList> reversedItems =
        model.cartListModel.productList!.reversed.toList();
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      reverse: model.cartListModel.productList!.length >= 8 ? true : false,
      itemCount: reversedItems.length,
      itemBuilder: (context, index) {
        return cartWidget(
            model.cartListModel.productList!.length >= 8
                ? model.cartListModel.productList!.reversed.toList()
                : model.cartListModel.productList!,
            index);
      },
    );
  }

  Widget cartWidget(
    List<ProductList> reversedItems,
    int index,
  ) {
    // bool isSelected = index == selectedCart;
    return InkResponse(
      radius: 5.0,
      onTap: () {
        setState(() {
          selectedCart = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        decoration: const BoxDecoration(
          color: Colors.transparent,
          // border: Border(
          //   bottom: BorderSide(color: Colors.grey),
          // ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 50.0,
              child: Text(
                "${model!.cartListModel.productList!.length >= 8 ? (model!.cartListModel.productList!.length - 1 - index) + 1 : index + 1}",
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(
              width: 18.0,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.17,
              child: Text(
                reversedItems[index].name!,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                    color: selectedCart == null
                        ? reversedItems.length < 8
                            ? index == reversedItems.length - 1
                                ? Colors.red
                                : AppColor.blackColor
                            : index == 0
                                ? Colors.red
                                : AppColor.blackColor
                        : selectedCart == index
                            ? Colors.red
                            : AppColor.blackColor),
              ),
            ),
            const SizedBox(
              width: 15.0,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.09,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                    visible: selectedCart == null
                        ? reversedItems.length < 8
                            ? index == reversedItems.length - 1
                            : index == 0
                        : selectedCart == index,
                    child: Visibility(
                      visible:
                          reversedItems[index].isEdit!.toLowerCase() == "0",
                      child: InkResponse(
                        radius: 5.0,
                        onTap: () async {
                          if (model!.cartListModel.billNo!.isEmpty) {
                            if (reversedItems[index].quantity! != 1) {
                              await model!.sellingUpdateProduct(
                                  name: reversedItems[index].name!,
                                  tag: "remove",
                                  isEdit: reversedItems[index].isEdit ?? "0",
                                  uPrice: reversedItems[index].unitPrice!);
                              setState(() {});
                              sendMsgToSubScreen(
                                  method: "list",
                                  data: model!.cartListModel.toJson());
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Minimum cart quantity is 1");
                            }
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          // decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(8.0),
                          //     color: Colors.white,
                          //     border: Border.all(
                          //         color: AppColor.hintBlackColor, width: 1)),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.black38),
                          child: Image.asset(
                            "assets/images/minus-sign.png",
                            scale: 60.0,
                            color: AppColor.whiteColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  SizedBox(
                    width: 60.0,
                    child: Text(
                      "${NumberFormat("#.##").format(reversedItems[index].quantity)} ${reversedItems[index].unit!.isNotEmpty ? "(${reversedItems[index].unit})" : ""}",
                      // "${99} (Litter)",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13.0),
                    ),
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Visibility(
                    visible: selectedCart == null
                        ? reversedItems.length < 8
                            ? index == reversedItems.length - 1
                            : index == 0
                        : selectedCart == index,
                    child: Visibility(
                      visible:
                          reversedItems[index].isEdit?.toLowerCase() == "0",
                      child: InkResponse(
                        radius: 5.0,
                        onTap: () async {
                          if (model!.cartListModel.billNo!.isEmpty) {
                            await model!.sellingUpdateProduct(
                                name: reversedItems[index].name!,
                                tag: "add",
                                isEdit: reversedItems[index].isEdit ?? "0",
                                uPrice: reversedItems[index].unitPrice!);
                            setState(() {});
                            sendMsgToSubScreen(
                                method: "list",
                                data: model!.cartListModel.toJson());
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          // decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(8.0),
                          //     color: Colors.white,
                          //     border: Border.all(
                          //         color: AppColor.hintBlackColor, width: 1)),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.black38),
                          child: Image.asset(
                            "assets/images/plus.png",
                            scale: 60.0,
                            color: AppColor.whiteColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 25.0,
            ),
            // const Spacer(),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.065,
              child: Text(
                reversedItems[index].unitPrice!.toStringAsFixed(2),
                textAlign: TextAlign.end,
                style: TextStyle(
                    color: selectedCart == null
                        ? reversedItems.length < 8
                            ? index == reversedItems.length - 1
                                ? Colors.red
                                : AppColor.blackColor
                            : index == 0
                                ? Colors.red
                                : AppColor.blackColor
                        : selectedCart == index
                            ? Colors.red
                            : AppColor.blackColor),
              ),
            ),
            // const Spacer(),
            Expanded(
              child: Text(
                reversedItems[index]
                    .totalPrice!
                    // .ceilToDouble()
                    .toStringAsFixed(2),
                textAlign: TextAlign.end,
                style: TextStyle(
                    color: selectedCart == null
                        ? reversedItems.length < 8
                            ? index == reversedItems.length - 1
                                ? Colors.red
                                : AppColor.blackColor
                            : index == 0
                                ? Colors.red
                                : AppColor.blackColor
                        : selectedCart == index
                            ? Colors.red
                            : AppColor.blackColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget productListWidget([BuildContext? context]) {
    return Expanded(
      child: model!.productList.isEmpty
          ? const Center(
              child: Text("No Data Found"),
            )
          : Scrollbar(
              thickness: 5.0,
              interactive: true,
              thumbVisibility: true,
              controller: productCtrl,
              radius: const Radius.circular(8.0),
              child: GridView.builder(
                controller: productCtrl,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 2.5,
                    mainAxisSpacing: 2.5,
                    crossAxisCount: 8,
                    mainAxisExtent: 165.0),
                itemCount: model!.productList.length,
                itemBuilder: (context, index) {
                  return InkResponse(
                    radius: 5.0,
                    onTap: () {
                      setState(() {
                        isVisible = false;
                        selectedCart = null;
                      });
                      if (model!.productList[index].isTimeLimit == null) {
                        if (model!.productList[index].isAgeLimit == null) {
                          if (model!.productList[index].variationDouble !=
                                  null &&
                              model!.productList[index].variationDouble!
                                  .isNotEmpty) {
                            getDoublePrice(
                                variationDouble:
                                    model!.productList[index].variationDouble,
                                productName:
                                    model!.productList[index].name ?? "",
                                unit: model!.productList[index].unit ?? "");
                          } else {
                            if (model!.productList[index].sellingPrice == "0" ||
                                model!.productList[index].sellingPrice ==
                                    "0.00" ||
                                model!.productList[index].sellingPrice ==
                                    "0.0000" ||
                                model!
                                    .productList[index].sellingPrice!.isEmpty) {
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0)),
                                    content: SellingPriceWidget(
                                      onDone: (data) {
                                        if (typeValue != null &&
                                            typeValue!.isEmpty) {
                                          if (model!.productList[index]
                                                  .posSellQuantityEdit
                                                  .toString()
                                                  .toLowerCase() ==
                                              "1") {
                                            // Here Dialog box
                                            getKgBox(onKg: () {
                                              sellingProductUpdate(
                                                name: model!.productList[index]
                                                        .name ??
                                                    "",
                                                quantity: kiloUnit,
                                                isEdit: model!
                                                        .productList[index]
                                                        .posSellQuantityEdit ??
                                                    "0",
                                                unitPrice: double.parse(
                                                    data['selling_price'] ??
                                                        "0.0"),
                                                id: model!.productList[index]
                                                    .productId
                                                    .toString(),
                                                variantId: model!
                                                    .productList[index]
                                                    .variantId
                                                    .toString(),
                                                unit: model!
                                                    .productList[index].unit
                                                    .toString(),
                                                totalPrice: kiloUnit *
                                                    (double.parse(
                                                        data['selling_price'] ??
                                                            "0.0")),
                                              );
                                            });
                                          } else {
                                            sellingProductUpdate(
                                              name: model!.productList[index]
                                                      .name ??
                                                  "",
                                              quantity: 1.0,
                                              unitPrice: double.parse(
                                                  data['selling_price'] ??
                                                      "0.0"),
                                              id: model!
                                                  .productList[index].productId
                                                  .toString(),
                                              isEdit: model!.productList[index]
                                                      .posSellQuantityEdit ??
                                                  "0",
                                              variantId: model!
                                                  .productList[index].variantId
                                                  .toString(),
                                              unit: model!
                                                  .productList[index].unit
                                                  .toString(),
                                              totalPrice: 1.0 *
                                                  (double.parse(
                                                      data['selling_price'] ??
                                                          "0.0")),
                                            );
                                          }
                                        } else {
                                          if (typeValue!.length <= 2) {
                                            if (model!.productList[index]
                                                    .posSellQuantityEdit
                                                    .toString()
                                                    .toLowerCase() ==
                                                "1") {
                                              getKgBox(
                                                onKg: () {
                                                  sellingProductUpdate(
                                                    name: model!
                                                            .productList[index]
                                                            .name ??
                                                        "",
                                                    quantity: kiloUnit,
                                                    unitPrice: double.parse(
                                                        data['selling_price'] ??
                                                            "0.0"),
                                                    isEdit: model!
                                                            .productList[index]
                                                            .posSellQuantityEdit ??
                                                        "0",
                                                    id: model!
                                                        .productList[index]
                                                        .productId
                                                        .toString(),
                                                    unit: model!
                                                        .productList[index].unit
                                                        .toString(),
                                                    variantId: model!
                                                        .productList[index]
                                                        .variantId
                                                        .toString(),
                                                    totalPrice: kiloUnit *
                                                        (double.parse(data[
                                                                'selling_price'] ??
                                                            "0.0")),
                                                  );
                                                },
                                              );
                                            } else {
                                              sellingProductUpdate(
                                                name: model!.productList[index]
                                                        .name ??
                                                    "",
                                                isEdit: model!
                                                        .productList[index]
                                                        .posSellQuantityEdit ??
                                                    "0",
                                                quantity: double.parse(
                                                    typeValue ?? "0"),
                                                unitPrice: double.parse(
                                                    data['selling_price'] ??
                                                        "0.0"),
                                                id: model!.productList[index]
                                                    .productId
                                                    .toString(),
                                                unit: model!
                                                    .productList[index].unit
                                                    .toString(),
                                                variantId: model!
                                                    .productList[index]
                                                    .variantId
                                                    .toString(),
                                                totalPrice: int.parse(
                                                        typeValue ?? "0") *
                                                    (double.parse(
                                                        data['selling_price'] ??
                                                            "0.0")),
                                              );
                                            }
                                          } else {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "You are not allow to purchase the product by this quantity.",
                                                backgroundColor: Colors.red);
                                          }
                                        }
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  );
                                },
                              );
                            } else {
                              if (typeValue != null && typeValue!.isEmpty) {
                                if (model!
                                        .productList[index].posSellQuantityEdit
                                        .toString()
                                        .toLowerCase() ==
                                    "1") {
                                  getKgBox(
                                    onKg: () {
                                      productUpdate(
                                        name: model!.productList[index].name ??
                                            "",
                                        quantity: kiloUnit,
                                        unitPrice: double.parse(model!
                                                .productList[index]
                                                .sellingPrice ??
                                            "0.0"),
                                        id: model!.productList[index].productId
                                            .toString(),
                                        variantId: model!
                                            .productList[index].variantId
                                            .toString(),
                                        isEdit: model!.productList[index]
                                                .posSellQuantityEdit ??
                                            "0",
                                        unit: model!.productList[index].unit
                                            .toString(),
                                        totalPrice: kiloUnit *
                                            (double.parse(model!
                                                    .productList[index]
                                                    .sellingPrice ??
                                                "0.0")),
                                      );
                                    },
                                  );
                                } else {
                                  productUpdate(
                                    name: model!.productList[index].name ?? "",
                                    quantity: 1.0,
                                    unitPrice: double.parse(model!
                                            .productList[index].sellingPrice ??
                                        "0.0"),
                                    id: model!.productList[index].productId
                                        .toString(),
                                    isEdit: model!.productList[index]
                                            .posSellQuantityEdit ??
                                        "0",
                                    variantId: model!
                                        .productList[index].variantId
                                        .toString(),
                                    unit: model!.productList[index].unit
                                        .toString(),
                                    totalPrice: 1.0 *
                                        (double.parse(model!.productList[index]
                                                .sellingPrice ??
                                            "0.0")),
                                  );
                                }
                              } else {
                                if (typeValue!.length <= 2) {
                                  if (model!.productList[index]
                                          .posSellQuantityEdit
                                          .toString()
                                          .toLowerCase() ==
                                      "1") {
                                    getKgBox(
                                      onKg: () {
                                        productUpdate(
                                          name:
                                              model!.productList[index].name ??
                                                  "",
                                          quantity: kiloUnit,
                                          unitPrice: double.parse(model!
                                                  .productList[index]
                                                  .sellingPrice ??
                                              "0.0"),
                                          id: model!
                                              .productList[index].productId
                                              .toString(),
                                          unit: model!.productList[index].unit
                                              .toString(),
                                          isEdit: model!.productList[index]
                                                  .posSellQuantityEdit ??
                                              "0",
                                          variantId: model!
                                              .productList[index].variantId
                                              .toString(),
                                          totalPrice: kiloUnit *
                                              (double.parse(model!
                                                      .productList[index]
                                                      .sellingPrice ??
                                                  "0.0")),
                                        );
                                      },
                                    );
                                  } else {
                                    productUpdate(
                                      name:
                                          model!.productList[index].name ?? "",
                                      quantity: double.parse(typeValue ?? "0"),
                                      unitPrice: double.parse(model!
                                              .productList[index]
                                              .sellingPrice ??
                                          "0.0"),
                                      id: model!.productList[index].productId
                                          .toString(),
                                      isEdit: model!.productList[index]
                                              .posSellQuantityEdit ??
                                          "0",
                                      unit: model!.productList[index].unit
                                          .toString(),
                                      variantId: model!
                                          .productList[index].variantId
                                          .toString(),
                                      totalPrice: int.parse(typeValue ?? "0") *
                                          (double.parse(model!
                                                  .productList[index]
                                                  .sellingPrice ??
                                              "0.0")),
                                    );
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                      msg:
                                          "You are not allow to purchase the product by this quantity.",
                                      backgroundColor: Colors.red);
                                }
                              }
                            }
                          }
                        } else {
                          showDialogueBox(
                            onYes: () {
                              Navigator.of(context).pop();
                              if (model!.productList[index].variationDouble !=
                                      null &&
                                  model!.productList[index].variationDouble!
                                      .isNotEmpty) {
                                /*setState(() {
                              if (model!.productList[index].variationDouble!
                                  .where((element) =>
                              element.name ==
                                  model!.productList[index].name)
                                  .isEmpty) {
                                model!.productList[index].variationDouble!
                                    .add(VariationDouble(
                                  name: model!.productList[index].name ?? "",
                                  id: 0,
                                  barcode:
                                  model!.productList[index].subSku ?? "",
                                  defaultSellPrice:
                                  model!.productList[index].sellingPrice ??
                                      "",
                                  unit: model!.productList[index].unit ?? "",
                                  variationId: model!
                                      .productList[index].variantId
                                      .toString(),
                                  productId: model!.productList[index].productId
                                      .toString(),
                                ));
                              }
                            });*/
                                getDoublePrice(
                                    variationDouble: model!
                                        .productList[index].variationDouble,
                                    productName:
                                        model!.productList[index].name ?? "",
                                    unit: model!.productList[index].unit ?? "");
                              } else {
                                if (model!.productList[index].sellingPrice ==
                                        "0" ||
                                    model!.productList[index].sellingPrice ==
                                        "0.00" ||
                                    model!.productList[index].sellingPrice ==
                                        "0.0000" ||
                                    model!.productList[index].sellingPrice!
                                        .isEmpty) {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0)),
                                        content: SellingPriceWidget(
                                          onDone: (data) {
                                            if (typeValue != null &&
                                                typeValue!.isEmpty) {
                                              if (model!.productList[index]
                                                      .posSellQuantityEdit
                                                      .toString()
                                                      .toLowerCase() ==
                                                  "1") {
                                                getKgBox(
                                                  onKg: () {
                                                    sellingProductUpdate(
                                                      name: model!
                                                              .productList[
                                                                  index]
                                                              .name ??
                                                          "",
                                                      quantity: kiloUnit,
                                                      unitPrice: double.parse(
                                                          data['selling_price'] ??
                                                              "0.0"),
                                                      id: model!
                                                          .productList[index]
                                                          .productId
                                                          .toString(),
                                                      isEdit: model!
                                                              .productList[
                                                                  index]
                                                              .posSellQuantityEdit ??
                                                          "0",
                                                      variantId: model!
                                                          .productList[index]
                                                          .variantId
                                                          .toString(),
                                                      unit: model!
                                                          .productList[index]
                                                          .unit
                                                          .toString(),
                                                      totalPrice: kiloUnit *
                                                          (double.parse(data[
                                                                  'selling_price'] ??
                                                              "0.0")),
                                                    );
                                                  },
                                                );
                                              } else {
                                                sellingProductUpdate(
                                                  name: model!
                                                          .productList[index]
                                                          .name ??
                                                      "",
                                                  quantity: 1.0,
                                                  unitPrice: double.parse(
                                                      data['selling_price'] ??
                                                          "0.0"),
                                                  id: model!.productList[index]
                                                      .productId
                                                      .toString(),
                                                  isEdit: model!
                                                          .productList[index]
                                                          .posSellQuantityEdit ??
                                                      "0",
                                                  variantId: model!
                                                      .productList[index]
                                                      .variantId
                                                      .toString(),
                                                  unit: model!
                                                      .productList[index].unit
                                                      .toString(),
                                                  totalPrice: 1.0 *
                                                      (double.parse(data[
                                                              'selling_price'] ??
                                                          "0.0")),
                                                );
                                              }
                                            } else {
                                              if (typeValue!.length <= 2) {
                                                if (model!.productList[index]
                                                        .posSellQuantityEdit
                                                        .toString()
                                                        .toLowerCase() ==
                                                    "1") {
                                                  getKgBox(
                                                    onKg: () {
                                                      sellingProductUpdate(
                                                        name: model!
                                                                .productList[
                                                                    index]
                                                                .name ??
                                                            "",
                                                        quantity: kiloUnit,
                                                        unitPrice: double.parse(
                                                            data['selling_price'] ??
                                                                "0.0"),
                                                        id: model!
                                                            .productList[index]
                                                            .productId
                                                            .toString(),
                                                        unit: model!
                                                            .productList[index]
                                                            .unit
                                                            .toString(),
                                                        isEdit: model!
                                                                .productList[
                                                                    index]
                                                                .posSellQuantityEdit ??
                                                            "0",
                                                        variantId: model!
                                                            .productList[index]
                                                            .variantId
                                                            .toString(),
                                                        totalPrice: kiloUnit *
                                                            (double.parse(data[
                                                                    'selling_price'] ??
                                                                "0.0")),
                                                      );
                                                    },
                                                  );
                                                } else {
                                                  sellingProductUpdate(
                                                    name: model!
                                                            .productList[index]
                                                            .name ??
                                                        "",
                                                    quantity: double.parse(
                                                        typeValue ?? "0"),
                                                    unitPrice: double.parse(
                                                        data['selling_price'] ??
                                                            "0.0"),
                                                    id: model!
                                                        .productList[index]
                                                        .productId
                                                        .toString(),
                                                    isEdit: model!
                                                            .productList[index]
                                                            .posSellQuantityEdit ??
                                                        "0",
                                                    unit: model!
                                                        .productList[index].unit
                                                        .toString(),
                                                    variantId: model!
                                                        .productList[index]
                                                        .variantId
                                                        .toString(),
                                                    totalPrice: int.parse(
                                                            typeValue ?? "0") *
                                                        (double.parse(data[
                                                                'selling_price'] ??
                                                            "0.0")),
                                                  );
                                                }
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "You are not allow to purchase the product by this quantity.",
                                                    backgroundColor:
                                                        Colors.red);
                                              }
                                            }
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  if (typeValue != null && typeValue!.isEmpty) {
                                    if (model!.productList[index]
                                            .posSellQuantityEdit
                                            .toString()
                                            .toLowerCase() ==
                                        "1") {
                                      getKgBox(
                                        onKg: () {
                                          productUpdate(
                                            name: model!
                                                    .productList[index].name ??
                                                "",
                                            quantity: kiloUnit,
                                            unitPrice: double.parse(model!
                                                    .productList[index]
                                                    .sellingPrice ??
                                                "0.0"),
                                            isEdit: model!.productList[index]
                                                    .posSellQuantityEdit ??
                                                "0",
                                            id: model!
                                                .productList[index].productId
                                                .toString(),
                                            variantId: model!
                                                .productList[index].variantId
                                                .toString(),
                                            unit: model!.productList[index].unit
                                                .toString(),
                                            totalPrice: kiloUnit *
                                                (double.parse(model!
                                                        .productList[index]
                                                        .sellingPrice ??
                                                    "0.0")),
                                          );
                                        },
                                      );
                                    } else {
                                      productUpdate(
                                        name: model!.productList[index].name ??
                                            "",
                                        quantity: 1.0,
                                        unitPrice: double.parse(model!
                                                .productList[index]
                                                .sellingPrice ??
                                            "0.0"),
                                        id: model!.productList[index].productId
                                            .toString(),
                                        isEdit: model!.productList[index]
                                                .posSellQuantityEdit ??
                                            "0",
                                        variantId: model!
                                            .productList[index].variantId
                                            .toString(),
                                        unit: model!.productList[index].unit
                                            .toString(),
                                        totalPrice: 1.0 *
                                            (double.parse(model!
                                                    .productList[index]
                                                    .sellingPrice ??
                                                "0.0")),
                                      );
                                    }
                                  } else {
                                    if (typeValue!.length <= 2) {
                                      if (model!.productList[index].unit
                                              .toString()
                                              .toLowerCase() ==
                                          "kg") {
                                        getKgBox(
                                          onKg: () {
                                            productUpdate(
                                              name: model!.productList[index]
                                                      .name ??
                                                  "",
                                              quantity: kiloUnit,
                                              isEdit: model!.productList[index]
                                                      .posSellQuantityEdit ??
                                                  "0",
                                              unitPrice: double.parse(model!
                                                      .productList[index]
                                                      .sellingPrice ??
                                                  "0.0"),
                                              id: model!
                                                  .productList[index].productId
                                                  .toString(),
                                              unit: model!
                                                  .productList[index].unit
                                                  .toString(),
                                              variantId: model!
                                                  .productList[index].variantId
                                                  .toString(),
                                              totalPrice: kiloUnit *
                                                  (double.parse(model!
                                                          .productList[index]
                                                          .sellingPrice ??
                                                      "0.0")),
                                            );
                                          },
                                        );
                                      } else {
                                        productUpdate(
                                          name:
                                              model!.productList[index].name ??
                                                  "",
                                          quantity:
                                              double.parse(typeValue ?? "0"),
                                          unitPrice: double.parse(model!
                                                  .productList[index]
                                                  .sellingPrice ??
                                              "0.0"),
                                          id: model!
                                              .productList[index].productId
                                              .toString(),
                                          unit: model!.productList[index].unit
                                              .toString(),
                                          isEdit: model!.productList[index]
                                                  .posSellQuantityEdit ??
                                              "0",
                                          variantId: model!
                                              .productList[index].variantId
                                              .toString(),
                                          totalPrice:
                                              int.parse(typeValue ?? "0") *
                                                  (double.parse(model!
                                                          .productList[index]
                                                          .sellingPrice ??
                                                      "0.0")),
                                        );
                                      }
                                    } else {
                                      Fluttertoast.showToast(
                                          msg:
                                              "You are not allow to purchase the product by this quantity.",
                                          backgroundColor: Colors.red);
                                    }
                                  }
                                }
                              }
                            },
                            msg: getTenYearsBefore(
                              msg: "Are you bron before",
                              years: int.parse(
                                  model!.productList[index].isAgeLimit!.age ??
                                      "0"),
                            ),
                          );
                        }
                      } else {
                        if (isNowBetween(
                            model!.productList[index].isTimeLimit!.fromTime ??
                                "",
                            model!.productList[index].isTimeLimit!.toTime ??
                                "")) {
                          if (model!.productList[index].variationDouble !=
                                  null &&
                              model!.productList[index].variationDouble!
                                  .isNotEmpty) {
                            /*setState(() {
                          if (model!.productList[index].variationDouble!
                              .where((element) =>
                          element.name ==
                              model!.productList[index].name)
                              .isEmpty) {
                            model!.productList[index].variationDouble!
                                .add(VariationDouble(
                              name: model!.productList[index].name ?? "",
                              id: 0,
                              barcode:
                              model!.productList[index].subSku ?? "",
                              defaultSellPrice:
                              model!.productList[index].sellingPrice ??
                                  "",
                              unit: model!.productList[index].unit ?? "",
                              variationId: model!
                                  .productList[index].variantId
                                  .toString(),
                              productId: model!.productList[index].productId
                                  .toString(),
                            ));
                          }
                        });*/
                            getDoublePrice(
                                variationDouble:
                                    model!.productList[index].variationDouble,
                                productName:
                                    model!.productList[index].name ?? "",
                                unit: model!.productList[index].unit ?? "");
                          } else {
                            if (model!.productList[index].sellingPrice == "0" ||
                                model!.productList[index].sellingPrice ==
                                    "0.00" ||
                                model!.productList[index].sellingPrice ==
                                    "0.0000" ||
                                model!
                                    .productList[index].sellingPrice!.isEmpty) {
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0)),
                                    content: SellingPriceWidget(
                                      onDone: (data) {
                                        if (typeValue != null &&
                                            typeValue!.isEmpty) {
                                          if (model!.productList[index]
                                                  .posSellQuantityEdit
                                                  .toString()
                                                  .toLowerCase() ==
                                              "1") {
                                            getKgBox(
                                              onKg: () {
                                                sellingProductUpdate(
                                                  name: model!
                                                          .productList[index]
                                                          .name ??
                                                      "",
                                                  quantity: kiloUnit,
                                                  unitPrice: double.parse(
                                                      data['selling_price'] ??
                                                          "0.0"),
                                                  id: model!.productList[index]
                                                      .productId
                                                      .toString(),
                                                  isEdit: model!
                                                          .productList[index]
                                                          .posSellQuantityEdit ??
                                                      "0",
                                                  variantId: model!
                                                      .productList[index]
                                                      .variantId
                                                      .toString(),
                                                  unit: model!
                                                      .productList[index].unit
                                                      .toString(),
                                                  totalPrice: kiloUnit *
                                                      (double.parse(data[
                                                              'selling_price'] ??
                                                          "0.0")),
                                                );
                                              },
                                            );
                                          } else {
                                            sellingProductUpdate(
                                              name: model!.productList[index]
                                                      .name ??
                                                  "",
                                              quantity: 1.0,
                                              unitPrice: double.parse(
                                                  data['selling_price'] ??
                                                      "0.0"),
                                              isEdit: model!.productList[index]
                                                      .posSellQuantityEdit ??
                                                  "0",
                                              id: model!
                                                  .productList[index].productId
                                                  .toString(),
                                              variantId: model!
                                                  .productList[index].variantId
                                                  .toString(),
                                              unit: model!
                                                  .productList[index].unit
                                                  .toString(),
                                              totalPrice: 1.0 *
                                                  (double.parse(
                                                      data['selling_price'] ??
                                                          "0.0")),
                                            );
                                          }
                                        } else {
                                          if (typeValue!.length <= 2) {
                                            if (model!.productList[index]
                                                    .posSellQuantityEdit
                                                    .toString()
                                                    .toLowerCase() ==
                                                "1") {
                                              getKgBox(
                                                onKg: () {
                                                  sellingProductUpdate(
                                                    name: model!
                                                            .productList[index]
                                                            .name ??
                                                        "",
                                                    quantity: kiloUnit,
                                                    isEdit: model!
                                                            .productList[index]
                                                            .posSellQuantityEdit ??
                                                        "0",
                                                    unitPrice: double.parse(
                                                        data['selling_price'] ??
                                                            "0.0"),
                                                    id: model!
                                                        .productList[index]
                                                        .productId
                                                        .toString(),
                                                    unit: model!
                                                        .productList[index].unit
                                                        .toString(),
                                                    variantId: model!
                                                        .productList[index]
                                                        .variantId
                                                        .toString(),
                                                    totalPrice: kiloUnit *
                                                        (double.parse(data[
                                                                'selling_price'] ??
                                                            "0.0")),
                                                  );
                                                },
                                              );
                                            } else {
                                              sellingProductUpdate(
                                                name: model!.productList[index]
                                                        .name ??
                                                    "",
                                                quantity: double.parse(
                                                    typeValue ?? "0"),
                                                unitPrice: double.parse(
                                                    data['selling_price'] ??
                                                        "0.0"),
                                                id: model!.productList[index]
                                                    .productId
                                                    .toString(),
                                                unit: model!
                                                    .productList[index].unit
                                                    .toString(),
                                                variantId: model!
                                                    .productList[index]
                                                    .variantId
                                                    .toString(),
                                                isEdit: model!
                                                        .productList[index]
                                                        .posSellQuantityEdit ??
                                                    "0",
                                                totalPrice: int.parse(
                                                        typeValue ?? "0") *
                                                    (double.parse(
                                                        data['selling_price'] ??
                                                            "0.0")),
                                              );
                                            }
                                          } else {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "You are not allow to purchase the product by this quantity.",
                                                backgroundColor: Colors.red);
                                          }
                                        }
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  );
                                },
                              );
                            } else {
                              if (typeValue != null && typeValue!.isEmpty) {
                                if (model!
                                        .productList[index].posSellQuantityEdit
                                        .toString()
                                        .toLowerCase() ==
                                    "1") {
                                  getKgBox(
                                    onKg: () {
                                      productUpdate(
                                        name: model!.productList[index].name ??
                                            "",
                                        quantity: kiloUnit,
                                        unitPrice: double.parse(model!
                                                .productList[index]
                                                .sellingPrice ??
                                            "0.0"),
                                        isEdit: model!.productList[index]
                                                .posSellQuantityEdit ??
                                            "0",
                                        id: model!.productList[index].productId
                                            .toString(),
                                        variantId: model!
                                            .productList[index].variantId
                                            .toString(),
                                        unit: model!.productList[index].unit
                                            .toString(),
                                        totalPrice: kiloUnit *
                                            (double.parse(model!
                                                    .productList[index]
                                                    .sellingPrice ??
                                                "0.0")),
                                      );
                                    },
                                  );
                                } else {
                                  productUpdate(
                                    name: model!.productList[index].name ?? "",
                                    quantity: 1.0,
                                    unitPrice: double.parse(model!
                                            .productList[index].sellingPrice ??
                                        "0.0"),
                                    id: model!.productList[index].productId
                                        .toString(),
                                    variantId: model!
                                        .productList[index].variantId
                                        .toString(),
                                    unit: model!.productList[index].unit
                                        .toString(),
                                    isEdit: model!.productList[index]
                                            .posSellQuantityEdit ??
                                        "0",
                                    totalPrice: 1.0 *
                                        (double.parse(model!.productList[index]
                                                .sellingPrice ??
                                            "0.0")),
                                  );
                                }
                              } else {
                                if (typeValue!.length <= 2) {
                                  if (model!.productList[index]
                                          .posSellQuantityEdit
                                          .toString()
                                          .toLowerCase() ==
                                      "1") {
                                    getKgBox(
                                      onKg: () {
                                        productUpdate(
                                          name:
                                              model!.productList[index].name ??
                                                  "",
                                          quantity: kiloUnit,
                                          unitPrice: double.parse(model!
                                                  .productList[index]
                                                  .sellingPrice ??
                                              "0.0"),
                                          id: model!
                                              .productList[index].productId
                                              .toString(),
                                          unit: model!.productList[index].unit
                                              .toString(),
                                          variantId: model!
                                              .productList[index].variantId
                                              .toString(),
                                          isEdit: model!.productList[index]
                                                  .posSellQuantityEdit ??
                                              "0",
                                          totalPrice: kiloUnit *
                                              (double.parse(model!
                                                      .productList[index]
                                                      .sellingPrice ??
                                                  "0.0")),
                                        );
                                      },
                                    );
                                  } else {
                                    productUpdate(
                                      name:
                                          model!.productList[index].name ?? "",
                                      quantity: double.parse(typeValue ?? "0"),
                                      unitPrice: double.parse(model!
                                              .productList[index]
                                              .sellingPrice ??
                                          "0.0"),
                                      id: model!.productList[index].productId
                                          .toString(),
                                      unit: model!.productList[index].unit
                                          .toString(),
                                      variantId: model!
                                          .productList[index].variantId
                                          .toString(),
                                      isEdit: model!.productList[index]
                                              .posSellQuantityEdit ??
                                          "0",
                                      totalPrice: int.parse(typeValue ?? "0") *
                                          (double.parse(model!
                                                  .productList[index]
                                                  .sellingPrice ??
                                              "0.0")),
                                    );
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                      msg:
                                          "You are not allow to purchase the product by this quantity.",
                                      backgroundColor: Colors.red);
                                }
                              }
                            }
                          }
                        } else {
                          dialogueEngine!.showDialogueBox(
                              msg: model!.productList[index].isTimeLimit!
                                      .timeDescription ??
                                  "");
                        }
                      }

                      // } else {
                      //   Fluttertoast.showToast(
                      //       msg: "The stock is not available.");
                      // }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        color: AppColor.primaryColor,
                        // borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Center(
                        child: Text(
                          model!.productList[index].name ?? "",
                          style: TextStyle(color: AppColor.whiteColor),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  String getTenYearsBefore({required String? msg, required int years}) {
    final now = DateTime.now(); // current date
    final before = DateTime(now.year - years, now.month, now.day);
    return "$msg ${before.day.toString().padLeft(2, '0')}-"
        "${before.month.toString().padLeft(2, '0')}-"
        "${before.year}";
  }

  void onCategoryTap(int id) async {
    setState(() {
      selectedCategoryId = id;
      debugPrint("Widget Rebuild");
    });
    // await model!.getProductList(
    //   categoryId: selectedCategoryId,
    //   page: 1,
    //   context: context,
    //   keyLoader: keyLoader,
    //   isInitial: false,
    // );
  }

  Widget categoryListWidget(LocalDashboardViewModel model) {
    return SizedBox(
      height: 115.0,
      child: (model.categoryProduct == null || model.categoryProduct!.isEmpty)
          ? const Center(
              child: Text("No Data Found"),
            )
          : Scrollbar(
              controller: categoryScroll,
              thickness: 5.0,
              interactive: true,
              thumbVisibility: true,
              radius: const Radius.circular(8.0),
              child: GridView.builder(
                controller: categoryScroll,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    // crossAxisSpacing: 0.0,
                    // mainAxisSpacing: 2.0,
                    crossAxisSpacing: 2.5,
                    mainAxisSpacing: 2.5,
                    crossAxisCount: 2,
                    mainAxisExtent: 165.0),
                itemCount: model.categoryProduct!.length,
                itemBuilder: (context, index) {
                  return InkResponse(
                    radius: 5.0,
                    onTap: () async {
                      setState(() {
                        isVisible = false;
                        selectedCategoryId =
                            model.categoryProduct![index].id ?? 0;
                      });
                      /* await model
                          .getProductList(
                        categoryId: selectedCategoryId,
                        page: 1,
                        context: context,
                        keyLoader: keyLoader,
                        isInitial: false,
                      )
                          .then(
                        (value) {
                          setState(() {});
                        },
                      );*/
                      await model
                          .getProductsWithVariants(
                        selectedCategoryId,
                      )
                          .then(
                        (value) {
                          setState(() {});
                        },
                      );
                    },
                    child:
                        /*Container(
                      margin: const EdgeInsets.only(left: 2.0),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                      decoration: BoxDecoration(
                        color: selectedCategoryId ==
                                model.categoryProduct![index].id
                            ? Colors.orange
                            : Colors.red,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Center(
                        child: Text(
                          model.categoryProduct![index].name ?? "",
                          style: TextStyle(color: AppColor.whiteColor),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )*/
                        Container(
                      // margin: const EdgeInsets.only(left: 2.0),
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        color: selectedCategoryId ==
                                model.categoryProduct![index].id
                            ? Colors.orange
                            : Colors.red,
                        // borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Center(
                        child: Text(
                          model.categoryProduct![index].name ?? "",
                          style: TextStyle(color: AppColor.whiteColor),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  bool isNowBetween(String fromTime, String toTime) {
    final now = DateTime.now();
    final cur =
        Duration(hours: now.hour, minutes: now.minute, seconds: now.second);

    Duration toDur(String t) {
      final p = t.split(':');
      return Duration(
          hours: int.parse(p[0]),
          minutes: int.parse(p[1]),
          seconds: int.parse(p[2]));
    }

    return cur >= toDur(fromTime) && cur <= toDur(toTime);
  }

  showDialogueBox({String? msg, required Function() onYes}) {
    // prefs = spEngine!.prefs;
    showDialog(
      context: context,
      barrierDismissible: false,
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
            Text(msg ?? "")
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: onYes,
            child: const Text("Yes"),
          ),
          const SizedBox(
            width: 15.0,
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
            },
            child: const Text("No"),
          ),
        ],
      ),
    );
  }

  Widget inputWidget() {
    return Column(
      children: [
        Row(
          children: [
            buttonWidget(
              title: "Clear",
              textColor: AppColor.whiteColor,
              btnColor: Colors.blueAccent,
              onTap: () {
                if (model!.cartListModel.billNo!.isEmpty) {
                  setState(() {
                    typeValue = "";
                  });
                }
              },
            ),
            buttonWidget(
                onTap: () {
                  // setState(() {
                  //   isSearch = !isSearch;
                  // });
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SearchWidget(
                        onClose: (close) {
                          setState(() {
                            isSearch = close;
                          });
                          _focusNode.requestFocus();
                        },
                        onSearchDone: (ScanProduct details) {
                          setState(() {
                            isVisible = false;
                          });
                          if (details.isTimeLimit == null) {
                            if (details.isAgeLimit == null) {
                              if (details.variationDouble != null &&
                                  details.variationDouble!.isNotEmpty) {
                                /*setState(() {
                                      if (details.variationDouble!
                                          .where((element) =>
                                      element.name == details.name)
                                          .isEmpty) {
                                        details.variationDouble!
                                            .add(VariationDouble(
                                          name: details.name ?? "",
                                          id: 0,
                                          barcode: details.barcode ?? "",
                                          defaultSellPrice: details
                                              .sellingPrice ??
                                              "",
                                          unit: details.unit ?? "",
                                          variationId: details.variationId
                                              .toString(),
                                          productId: details.productId
                                              .toString(),
                                        ));
                                      }
                                    });*/
                                getDoublePrice(
                                    variationDouble: details.variationDouble,
                                    productName: details.name ?? "",
                                    unit: details.unit ?? "");
                              } else {
                                onSearchProcess(details);
                              }
                            } else {
                              showDialogueBox(
                                onYes: () {
                                  Navigator.of(context).pop();
                                  onSearchProcess(details);
                                },
                                msg: getTenYearsBefore(
                                  msg: "Are you bron before",
                                  years:
                                      int.parse(details.isAgeLimit!.age ?? "0"),
                                ),
                              );
                            }
                          } else {
                            if (isNowBetween(
                                details.isTimeLimit!.fromTime ?? "",
                                details.isTimeLimit!.toTime ?? "")) {
                              onSearchProcess(details);
                            } else {
                              dialogueEngine!.showDialogueBox(
                                  msg: details.isTimeLimit!.timeDescription ??
                                      "");
                            }
                          }
                        },
                      ),
                    ),
                  );
                },
                title: "Search",
                textColor: AppColor.whiteColor,
                btnColor: isSearch ? Colors.red : Colors.blueAccent),
            /* buttonWidget(
                title: "View Receipt",
                onTap: () async {
                  await model!
                      .getHolderOrder(
                          context: context,
                          keyLoader: keyLoader,
                          url: AppStrings.viewReceiptUrl)
                      .then(
                    (value) {
                      setState(() {});
                      if (model!.holderOrder.isNotEmpty) {
                        // getTodayReceiptDialogue();
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ViewReceiptScreen(
                              receipts: model!.holderOrder,
                              printers: printers,
                              model: model),
                        ));
                      }
                    },
                  );
                },
                textColor: AppColor.whiteColor,
                btnColor: Colors.blueAccent),*/
            buttonWidget(
                onTap: () {
                  // await model!
                  //     .purchaseReport(context: context, keyLoader: keyLoader)
                  //     .then(
                  //   (value) {
                  //     if (value) {
                  //       if (printers.isNotEmpty) {
                  //       } else {
                  //         printDailyClosingReport(model!.finalReport);
                  //       }
                  //     }
                  //   },
                  // );
                  getReportDialogue(context);
                },
                title: "Report", // void Receipt
                textColor: AppColor.whiteColor,
                btnColor: Colors.blueAccent),
          ],
        ),
        Row(
          children: [
            buttonWidget(
              title: "7",
              isNum: true,
              onTap: () {
                if (model!.cartListModel.billNo!.isEmpty) {
                  setState(() {
                    typeValue = "${typeValue}7";
                  });
                }
              },
            ),
            buttonWidget(
              title: "8",
              isNum: true,
              onTap: () {
                if (model!.cartListModel.billNo!.isEmpty) {
                  setState(() {
                    typeValue = "${typeValue}8";
                  });
                }
              },
            ),
            buttonWidget(
              title: "9",
              isNum: true,
              onTap: () {
                if (model!.cartListModel.billNo!.isEmpty) {
                  setState(() {
                    typeValue = "${typeValue}9";
                  });
                }
              },
            )
          ],
        ),
        Row(
          children: [
            buttonWidget(
              title: "4",
              isNum: true,
              onTap: () {
                if (model!.cartListModel.billNo!.isEmpty) {
                  setState(() {
                    typeValue = "${typeValue}4";
                  });
                }
              },
            ),
            buttonWidget(
              title: "5",
              isNum: true,
              onTap: () {
                if (model!.cartListModel.billNo!.isEmpty) {
                  setState(() {
                    typeValue = "${typeValue}5";
                  });
                }
              },
            ),
            buttonWidget(
              title: "6",
              isNum: true,
              onTap: () {
                if (model!.cartListModel.billNo!.isEmpty) {
                  setState(() {
                    typeValue = "${typeValue}6";
                  });
                }
              },
            ),
          ],
        ),
        Row(
          children: [
            buttonWidget(
              title: "1",
              isNum: true,
              onTap: () {
                if (model!.cartListModel.billNo!.isEmpty) {
                  setState(() {
                    typeValue = "${typeValue}1";
                  });
                }
              },
            ),
            buttonWidget(
              title: "2",
              isNum: true,
              onTap: () {
                if (model!.cartListModel.billNo!.isEmpty) {
                  setState(() {
                    typeValue = "${typeValue}2";
                  });
                }
              },
            ),
            buttonWidget(
              title: "3",
              isNum: true,
              onTap: () {
                if (model!.cartListModel.billNo!.isEmpty) {
                  setState(() {
                    typeValue = "${typeValue}3";
                  });
                }
              },
            ),
          ],
        ),
        Row(
          children: [
            buttonWidget(
              title: "0",
              isNum: true,
              onTap: () {
                if (model!.cartListModel.billNo!.isEmpty) {
                  setState(() {
                    typeValue = "${typeValue}0";
                  });
                }
              },
            ),
            buttonWidget(
              title: ".",
              isNum: true,
              onTap: () {
                if (model!.cartListModel.billNo!.isEmpty) {
                  setState(() {
                    if (typeValue!.isNotEmpty) {
                      typeValue = "${typeValue!}.";
                    } else {
                      typeValue = "0.";
                    }
                  });
                }
              },
            ),
            buttonWidget(
              title: "X",
              isNum: true,
              onTap: () async {
                if (model!.cartListModel.billNo!.isEmpty) {
                  if (model!.cartListModel.productList!.isNotEmpty) {
                    await model!.updateXAction(
                        selectedName: selectedName,
                        index: selectedCart!,
                        quantity: int.parse(typeValue!));
                    setState(() {
                      typeValue = "";
                    });
                  }
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  void showVoidDialog({required List<Map<String, dynamic>> payment}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            content: VoidBillScreen(
                payments: payment,
                onVoid: (List<Map<String, dynamic>> returnPay) =>
                    onVoidCartReturn(returnPay)),
          ),
        );
      },
    );
  }

  getReportDialogue(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            content: Row(
              children: [
                InkResponse(
                  radius: 5.0,
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => XyReportScreen(
                          printers: printers,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      "Cashier Report",
                      style: TextStyle(color: AppColor.whiteColor),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15.0,
                ),
                InkResponse(
                  radius: 5.0,
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => RegisterScreen(
                            printers: printers,
                            onCloseCash: () => getCloseCash()),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      "Daily Closing Report",
                      style: TextStyle(color: AppColor.whiteColor),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15.0,
                ),
                InkResponse(
                  radius: 5.0,
                  onTap: () {
                    Navigator.of(context).pop();
                    showDateDialog(context);
                    /* Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => RegisterScreen(
                            printers: printers,
                            onCloseCash: () => getCloseCash()),
                      ),
                    );*/
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      "Past Bill Report",
                      style: TextStyle(color: AppColor.whiteColor),
                    ),
                  ),
                ),
              ],
            ));
      },
    );
  }

  dateSlector() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          content: DateRangeScreen(),
        );
      },
    );
  }

  void showDateDialog(BuildContext context) {
    DateTime? fromDate;
    DateTime? toDate;

    final now = DateTime.now();
    final firstDate = DateTime(now.year - 5, now.month, now.day);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            String format(DateTime? d) =>
                d == null ? "Select Date" : "${d.day}-${d.month}-${d.year}";

            return AlertDialog(
              title: const Text("Select Date Range"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // FROM DATE
                  TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "From Date",
                      hintText: format(fromDate),
                    ),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        firstDate: firstDate,
                        lastDate: now,
                        initialDate: fromDate ?? now,
                      );

                      if (picked != null) {
                        setState(() {
                          fromDate = picked;

                          // reset toDate if invalid
                          if (toDate != null && toDate!.isBefore(fromDate!)) {
                            toDate = null;
                          }
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 15),

                  // TO DATE
                  TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "To Date",
                      hintText: format(toDate),
                    ),
                    onTap: () async {
                      if (fromDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Select From Date first"),
                          ),
                        );
                        return;
                      }

                      final picked = await showDatePicker(
                        context: context,
                        firstDate: fromDate!, // important condition
                        lastDate: now,
                        initialDate: toDate ?? fromDate!,
                      );

                      if (picked != null) {
                        setState(() {
                          toDate = picked;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (fromDate == null || toDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please select both dates"),
                        ),
                      );
                      return;
                    }
                    String timePrase =
                        "from=${DateFormat('dd-MM-yyyy').format(fromDate!)}&to=${DateFormat('dd-MM-yyyy').format(toDate!)}";
                    Navigator.pop(context);
                    await model!
                        .getHolderOrder(
                            context: context,
                            keyLoader: keyLoader,
                            url:
                                // "${AppStrings.viewReceiptUrl}&location_id=${prefs!.getInt(AppStrings.businessLocations)}&length=150")
                                "${AppStrings.viewReceiptUrl}&location_id=${prefs!.getInt(AppStrings.businessLocations)}?$timePrase")
                        .then(
                      (value) {
                        // setState(() {});
                        if (model!.holderOrder.isNotEmpty) {
                          // getTodayReceiptDialogue();
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ViewReceiptScreen(
                                receipts: model!.holderOrder,
                                printers: printers,
                                loadCart: (receipt) => loadCart(receipt),
                                model: model),
                          ));
                        }
                      },
                    );
                  },
                  child: const Text("Apply"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget inputWidget2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            buttonWidget(
              title: "Void",
              btnColor: Colors.green,
              textColor: AppColor.whiteColor,
              onTap: () async {
                if (model!.cartListModel.productList!.isNotEmpty) {
                  /* if (isHold) {
                    if (model!.cartListModel.productList!.isNotEmpty) {
                      if (model!.cartListModel.billNo!.isEmpty) {
                        Map<String, dynamic> postData = {
                          "is_enabled_stock": 1, // default
                          "location_id": 1, // default
                          "contact_id": 1, // default
                          "price_group": 0, // default
                          "sell_price_tax": "includes", // default
                          "products": getProductList(),
                          "advance_balance": 0.0000, // default
                          "payment": [],
                          "change_return": 0.000, // default
                          "is_suspend": 1,
                          "recur_interval_type": "days", // default
                          "final_total":
                              model!.calculation.grandTotal!.toStringAsFixed(2),
                          "is_credit_sale": 0, // default
                          "discount_type":
                              selectedDiscount != null && selectedDiscount != ""
                                  ? selectedDiscount == "% Discount"
                                      ? "Discount"
                                      : "Percentage"
                                  : "",
                          "discount_amount":
                              selectedDiscount != null && selectedDiscount != ""
                                  ? model!.calculation.discountAmount ?? 0.0
                                  : 0.0,
                          "rp_redeemed": 0, // default
                          "rp_redeemed_amount": 0, // default
                          "tax_rate_id": 1, // default
                          "tax_calculation_amount": 5.000,
                          "shipping_charges": 0.000, // default
                          "discount_type_modal":
                              selectedDiscount != null && selectedDiscount != ""
                                  ? selectedDiscount
                                  : "",
                          "discount_amount_modal": 0.000,
                          "order_tax_modal": 1, // default
                          "shipping_charges_modal": 0, // default
                          "status": "final" // default
                        };
                        await model!
                            .voidOrder(postData,
                                context: context,
                                keyLoader: keyLoader,
                                id: holdId.toString())
                            .then((value) {
                          if (value) {
                            setState(() {
                              model!.cartListModel.productList!.clear();
                              typeValue = "";
                              model!.cartListModel.cashPaid = "0.00";
                              model!.cartListModel.balance = "0.00";
                              model!.calculation.grandTotal = 0.00;
                              model!.calculation.discountAmount = 0.00;
                              selectedDiscount = "";
                              paymentMethod = [];
                              isHold = false;
                            });
                          }
                        });
                        sendMsgToSubScreen(
                            method: "list",
                            data: model!.cartListModel.toJson());
                        sendMsgToSubScreen(method: "pay", data: {
                          "payment": [],
                          "discount_type": selectedDiscount
                        });
                      }
                    }
                  } else */
                  if (isRecall) {
                    showVoidDialog(payment: paymentMethod);
                  } else {
                    voidCartProduct();
                    sendMsgToSubScreen(
                        method: "list", data: model!.cartListModel.toJson());
                    sendMsgToSubScreen(method: "pay", data: {
                      "payment": [],
                      "discount_type": selectedDiscount
                    });
                  }
                }
              },
            ),
            /* buttonWidget(
                onTap: () {
                  setState(() {
                    isSearch = !isSearch;
                  });
                },
                title: "Search",
                textColor: AppColor.whiteColor,
                btnColor: isSearch ? Colors.red : Colors.green),*/
            buttonWidget(
              title: "Home/Logout",
              textColor: AppColor.whiteColor,
              btnColor: Colors.green,
              onTap: () async {
                CustomDialogBox().getCustomBox(
                  message: "Are you want to logout?",
                  context: context,
                  onCancel: () => Navigator.of(context).pop(),
                  onDone: () async {
                    setState(() {
                      model!.cartListModel.productList!.clear();
                      typeValue = "";
                      model!.cartListModel.billNo = "";
                      model!.cartListModel.cashPaid = "0.0";
                      model!.cartListModel.balance = "0.0";
                      model!.calculation.grandTotal = 0.0;
                      model!.calculation.discountAmount = 0.0;
                      model!.cartListModel.discountAmount = 0.0;
                      selectedDiscount = "";
                      paymentMethod = [];
                      isHold = false;
                    });
                    sendMsgToSubScreen(
                        method: "list", data: model!.cartListModel.toJson());
                    sendMsgToSubScreen(method: "pay", data: {
                      "payment": [],
                      "discount_type": selectedDiscount
                    });
                    await clearPrefsExcept(AppStrings.isUpdate);
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      "/",
                      (route) => false,
                    );
                  },
                );
              },
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*buttonWidget(
              title: "\$ 10",
              textColor: AppColor.whiteColor,
              btnColor: Colors.green,
              onTap: () async {
                if (model!.cartListModel.productList!.isNotEmpty) {
                  if (model!.cartListModel.billNo!.isEmpty) {
                    setState(() {
                      model!.cartListModel
                          .cashPaid = model!.cartListModel.cashPaid != null &&
                              model!.cartListModel.cashPaid!.isNotEmpty
                          ? (double.parse(
                                      model!.cartListModel.cashPaid ?? "0.0") +
                                  10.0)
                              .toStringAsFixed(2)
                          : double.parse("10").toStringAsFixed(2);
                      model!.cartListModel.balance =
                          ((model!.calculation.grandTotal! -
                                  double.parse(model!.cartListModel.cashPaid!)))
                              .abs()
                              .toStringAsFixed(2);
                      typeValue = "";
                    });
                    if (model!.calculation.grandTotal! <= 10) {
                      paymentMethod.add({
                        "method": "cash",
                        "amount":
                            model!.calculation.grandTotal!.toStringAsFixed(2)
                      });
                    } else {
                      paymentMethod.add({"method": "cash", "amount": "10"});
                    }
                    sendMsgToSubScreen(
                        method: "list", data: model!.cartListModel.toJson());
                    sendMsgToSubScreen(method: "pay", data: {
                      "payment": paymentMethod.toList(),
                      "discount_type": selectedDiscount
                    });
                    // debugPrint(paymentMethod.toString());
                    if (model!.calculation.grandTotal! <=
                        double.parse(model!.cartListModel.cashPaid ?? "0.0")) {
                      paymentUpdate();
                    }
                  }
                }
              },
            ),*/
            model!.cartListModel.productList!.isEmpty
                ? buttonWidget(
                    title: "Recall Order",
                    textColor: AppColor.whiteColor,
                    btnColor: Colors.green,
                    onTap: () async {
                      if (model!.cartListModel.billNo!.isEmpty) {
                        await model!
                            .getHolderOrder(
                                context: context,
                                keyLoader: keyLoader,
                                url:
                                    "${AppStrings.recallHoldOrderUrl}&location_id=${prefs!.getInt(AppStrings.businessLocations)}")
                            .then(
                          (value) {
                            setState(() {});
                            if (model!.holderOrder.isNotEmpty) {
                              getHoldOrdersDialogue();
                            }
                          },
                        );
                      }
                    },
                  )
                : buttonWidget(
                    title: "Hold Order",
                    textColor: AppColor.whiteColor,
                    btnColor: Colors.green,
                    onTap: () async {
                      if (model!.cartListModel.billNo!.isEmpty) {
                        if (model!.cartListModel.productList!.isNotEmpty) {
                          setState(() {
                            model!.cartListModel.cashPaid =
                                (model!.calculation.grandTotal ?? 0.0)
                                    .toStringAsFixed(1);
                          });
                          Map<String, dynamic> postData = {
                            "is_enabled_stock": 1, // default
                            "location_id": prefs!.getInt(
                                AppStrings.businessLocations), // default
                            "contact_id": 1, // default
                            "price_group": 0, // default
                            "sell_price_tax": "includes", // default
                            "products": getProductList(),
                            "advance_balance": 0.0000, // default
                            "payment": {
                              "0": {
                                "amount": double.parse(
                                    model!.cartListModel.cashPaid ?? "0.0"),
                                "method": "cash", // default
                                "card_type": "credit", // default
                                "note": null // default
                              },
                              "change_return": {
                                "method": "cash", // default
                                "card_type": "credit" // default
                              }
                            },
                            "change_return": 0.000, // default
                            "is_suspend": 0, // default
                            "recur_interval_type": "days", // default
                            "final_total": double.parse(
                                model!.cartListModel.cashPaid ?? "0.0"),
                            "is_credit_sale": 0, // default
                            "discount_type": selectedDiscount != null &&
                                    selectedDiscount != ""
                                ? selectedDiscount == "% Discount"
                                    ? "Discount"
                                    : "Percentage"
                                : "",
                            "discount_amount": selectedDiscount != null &&
                                    selectedDiscount != ""
                                ? model!.calculation.discountAmount ?? 0.0
                                : 0.0,
                            "rp_redeemed": 0, // default
                            "rp_redeemed_amount": 0, // default
                            "tax_rate_id": 1, // default
                            "tax_calculation_amount": 5.000,
                            "shipping_charges": 0.000, // default
                            "discount_type_modal": selectedDiscount != null &&
                                    selectedDiscount != ""
                                ? selectedDiscount
                                : "",
                            "discount_amount_modal": 0.000,
                            "order_tax_modal": 1, // default
                            "shipping_charges_modal": 0, // default
                            "status": "draft" // default
                          };
                          // debugPrint(postData.toString());
                          await model!
                              .holdOrder(postData,
                                  context: context,
                                  keyLoader: keyLoader,
                                  url: isHold
                                      ? AppStrings.recallOrderUpdateUrl +
                                          holdId.toString()
                                      : AppStrings.placeOrderUrl)
                              .then((value) {
                            if (value) {
                              setState(() {
                                model!.cartListModel.productList!.clear();
                                typeValue = "";
                                model!.cartListModel.cashPaid = "0.0";
                                model!.cartListModel.balance = "0.0";
                                model!.calculation.grandTotal = 0.0;
                                model!.calculation.discountAmount = 0.0;
                                selectedDiscount = "";
                                paymentMethod = [];
                                isHold = false;
                              });
                              sendMsgToSubScreen(
                                  method: "list",
                                  data: model!.cartListModel.toJson());
                              sendMsgToSubScreen(method: "pay", data: {
                                "payment": [],
                                "discount_type": selectedDiscount
                              });
                            }
                          });
                        }
                      }
                    },
                  ),
            buttonWidget(
                title: "View Receipt",
                onTap: () async {
                  await model!
                      .getHolderOrder(
                          context: context,
                          keyLoader: keyLoader,
                          url:
                              // "${AppStrings.viewReceiptUrl}&location_id=${prefs!.getInt(AppStrings.businessLocations)}&length=150")
                              "${AppStrings.viewReceiptUrl}&location_id=${prefs!.getInt(AppStrings.businessLocations)}")
                      .then(
                    (value) {
                      setState(() {});
                      if (model!.holderOrder.isNotEmpty) {
                        // getTodayReceiptDialogue();
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ViewReceiptScreen(
                              receipts: model!.holderOrder,
                              printers: printers,
                              loadCart: (receipt) => loadCart(receipt),
                              model: model),
                        ));
                      }
                    },
                  );
                },
                textColor: AppColor.whiteColor,
                btnColor: Colors.green),
            /*buttonWidget(
                onTap: () {
                  setState(() {
                    isSearch = !isSearch;
                  });
                },
                title: "Search",
                textColor: AppColor.whiteColor,
                btnColor: isSearch ? Colors.red : Colors.green),*/
            /*buttonWidget(
                title: "Close Cash", // Report
                onTap: () {
                  getCloseCash();
                },
                textColor: AppColor.whiteColor,
                btnColor: Colors.green),*/

            // }),
          ],
        ),
        Row(
          children: [
            /*buttonWidget(
                title: "\$ 50",
                textColor: AppColor.whiteColor,
                btnColor: Colors.green,
                onTap: () async {
                  if (model!.cartListModel.productList!.isNotEmpty) {
                    if (model!.cartListModel.billNo!.isEmpty) {
                      setState(() {
                        // paymentMethod.add({"method": "cash", "amount": "50"});
                        model!.cartListModel.cashPaid =
                            model!.cartListModel.cashPaid != null &&
                                    model!.cartListModel.cashPaid!.isNotEmpty
                                ? (double.parse(model!.cartListModel.cashPaid ??
                                            "0.0") +
                                        50.0)
                                    .toStringAsFixed(2)
                                : double.parse("50.0").toStringAsFixed(2);
                        model!.cartListModel.balance = ((model!
                                    .calculation.grandTotal! -
                                double.parse(model!.cartListModel.cashPaid!)))
                            .abs()
                            .toStringAsFixed(2);
                        typeValue = "";
                      });
                      if (model!.calculation.grandTotal! <= 50) {
                        paymentMethod.add({
                          "method": "cash",
                          "amount":
                              model!.calculation.grandTotal!.toStringAsFixed(2)
                        });
                      } else {
                        paymentMethod.add({"method": "cash", "amount": "50"});
                      }
                      sendMsgToSubScreen(
                          method: "list", data: model!.cartListModel.toJson());
                      sendMsgToSubScreen(method: "pay", data: {
                        "payment": paymentMethod.toList(),
                        "discount_type": selectedDiscount
                      });
                      if (model!.calculation.grandTotal! <=
                          double.parse(
                              model!.cartListModel.cashPaid ?? "0.0")) {
                        paymentUpdate();
                      }
                    }
                  }
                }),*/
            buttonWidget(
              title: "Open Drawer",
              textColor: AppColor.whiteColor,
              btnColor: Colors.green,
              onTap: () async {
                try {
                  await model!.openCashBox();
                } on PlatformException catch (e) {
                  Fluttertoast.showToast(msg: e.toString());
                } catch (e) {
                  Fluttertoast.showToast(msg: e.toString());
                }
              },
            ),
            /*buttonWidget(
                title: "View Receipt",
                onTap: () async {
                  await model!
                      .getHolderOrder(
                          context: context,
                          keyLoader: keyLoader,
                          url:
                              // "${AppStrings.viewReceiptUrl}&location_id=${prefs!.getInt(AppStrings.businessLocations)}&length=150")
                              "${AppStrings.viewReceiptUrl}&location_id=${prefs!.getInt(AppStrings.businessLocations)}")
                      .then(
                    (value) {
                      setState(() {});
                      if (model!.holderOrder.isNotEmpty) {
                        // getTodayReceiptDialogue();
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ViewReceiptScreen(
                              receipts: model!.holderOrder,
                              printers: printers,
                              loadCart: (receipt) => loadCart(receipt),
                              model: model),
                        ));
                      }
                    },
                  );
                },
                textColor: AppColor.whiteColor,
                btnColor: Colors.green),*/
            buttonWidget(
              title: "Sub Total",
              btnColor: Colors.green,
              textColor: AppColor.whiteColor,
              onTap: () {
                prefs = spEngine!.prefs;
                if (model!.cartListModel.productList!.isNotEmpty) {
                  if (model!.cartListModel.billNo!.isEmpty) {
                    sendMsgToSubScreen(
                        method: "qr",
                        data: prefs!.getString(AppStrings.qrCodeImage) ?? "");
                    sendMsgToSubScreen(method: "pay", data: {
                      "payment": paymentMethod.toList(),
                      "discount_type": selectedDiscount
                    });
                  }
                }
                // if (model!.cartListModel.billNo!.isEmpty) {
                //   if (typeValue!.isNotEmpty) {
                //     setState(() {
                //       model!.cartListModel.cashPaid = typeValue;
                //       model!.cartListModel.balance =
                //           ((model!.calculation.grandTotal! -
                //                   double.parse(model!.cartListModel.cashPaid!)))
                //               .abs()
                //               .toString();
                //       typeValue = "";
                //     });
                //   } else {
                //     setState(() {
                //       model!.cartListModel.cashPaid =
                //           model!.calculation.grandTotal.toString();
                //     });
                //   }
                // }
              },
            ),
            /*buttonWidget(
              title: "Payment",
              textColor: AppColor.whiteColor,
              btnColor: Colors.green,
              onTap: () {
                if (model!.cartListModel.productList!.isNotEmpty) {
                  getPaymentDialogue();
                } else {
                  Fluttertoast.showToast(msg: "The cart is empty");
                }
              },
            ),*/
          ],
        ),
        Row(
          children: [
            buttonWidget(
              title: "Discount/Voucher",
              onTap: () {
                if (model!.cartListModel.billNo!.isEmpty) {
                  if (model!.cartListModel.productList!.isNotEmpty) {
                    getDiscountBox();
                  }
                }
              },
            ),
            // buttonWidget(
            //   title: "Stock Transfer",
            //   onTap: () async {
            //     var result = await Navigator.of(context).push(
            //       MaterialPageRoute(
            //         builder: (context) => const StockTransfer(),
            //       ),
            //     );
            //     if (result ?? true) {
            //       _focusNode.requestFocus();
            //     }
            //   },
            // ),
            // buttonWidget(
            //   title: "Add Customer",
            //   onTap: () async {
            //     var result = await Navigator.of(context).push(
            //       MaterialPageRoute(
            //         builder: (context) => const AddCustomerScreen(),
            //       ),
            //     );
            //     if (result ?? true) {
            //
            //     }
            //   },
            // ),
            /* buttonWidget(
              title: "Print Receipt",
              onTap: () async {
                if (printers.isNotEmpty) {
                  usbPrint(
                      deviceId: printers[0]['deviceId'].toString(),
                      payHistory: [],
                      discount: disCount,
                      gTotal: model!.calculation.grandTotal!.toStringAsFixed(2),
                      products: model!.cartListModel.productList ?? []);
                } else {
                  await printReceipt(
                      total: model!.calculation.grandTotal!.toStringAsFixed(2),
                      products: model!.cartListModel.productList ?? []);
                }
              },
            ), */
            /*buttonWidget(
              title: "Payment",
              onTap: () {
                if (model!.cartListModel.productList!.isNotEmpty) {
                  getPaymentDialogue();
                } else {
                  Fluttertoast.showToast(msg: "The cart is empty");
                }
              },
            ),*/
          ],
        ),
        Row(
          children: [
            buttonWidget(
              title: "Payment",
              textColor: AppColor.blackColor,
              // btnColor: Colors.green,
              onTap: () {
                if (model!.cartListModel.productList!.isNotEmpty) {
                  getPaymentDialogue();
                } else {
                  Fluttertoast.showToast(msg: "The cart is empty");
                }
              },
            ),
            /*buttonWidget(
              title: "Payment",
              onTap: () {
                if (model!.cartListModel.productList!.isNotEmpty) {
                  getPaymentDialogue();
                } else {
                  Fluttertoast.showToast(msg: "The cart is empty");
                }
              },
            ),*/
            /*buttonWidget(
              title: "Pay Now",
              onTap: () {
                if (model!.cartListModel.productList!.isNotEmpty) {
                  if (model!.cartListModel.billNo!.isEmpty) {
                    sendMsgToSubScreen(method: "qr-off", data: true);
                    updateData(method: "paynow");
                  }
                } else {
                  Fluttertoast.showToast(
                      msg: "Please enter the amount want to pay.");
                }
              },
            ),
            buttonWidget(
              title: "Cash",
              onTap: () async {
                if (model!.cartListModel.productList!.isNotEmpty) {
                  if (model!.cartListModel.billNo!.isEmpty) {
                    try {
                      await model!.openCashBox();
                    } on PlatformException catch (e) {
                      Fluttertoast.showToast(msg: e.toString());
                    } catch (e) {
                      Fluttertoast.showToast(msg: e.toString());
                    }
                    sendMsgToSubScreen(
                        method: "list", data: model!.cartListModel.toJson());
                    updateData(method: "cash");
                  }
                } else {
                  Fluttertoast.showToast(
                      msg: "Please enter the amount want to pay.");
                }
              },
            ),*/
          ],
        ),
      ],
    );
  }

  Widget inputWidget3() {
    return Column(
      children: [
        buttonWidget(
          title: "Stock",
          btnColor: Colors.green,
          textColor: AppColor.whiteColor,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ProductsPage(),
              ),
            );
          },
        ),
        buttonWidget(
          title: "Settings",
          btnColor: Colors.green,
          textColor: AppColor.whiteColor,
          onTap: () {},
        ),
      ],
    );
  }

  printReceipt(
      {required String total, required List<ProductList> products}) async {
    Uint8List img = await getImage();
    if (products.isNotEmpty) {
      await imInPrinter.resetDevice();
      await imInPrinter.exitPrinterBuffer(false);
      await imInPrinter.setPrinterSpeed(10000);
      await imInPrinter.printAndLineFeed().then(
        (value) async {
          await imInPrinter.printSingleBitmap(img,
              pictureStyle: IminPictureStyle(
                alignment: IminPrintAlign.center,
                width: 250,
                height: 50,
              ));
          await imInPrinter.printText("Beer & Bites",
              style: IminTextStyle(
                  align: IminPrintAlign.center,
                  fontStyle: IminFontStyle.bold,
                  typeface: IminTypeface.typefaceDefaultBold,
                  fontSize: 30));
          await imInPrinter.printText(
            "\nAddress\n${prefs!.getString(AppStrings.selectedAddress) ?? ""}",
            style: IminTextStyle(align: IminPrintAlign.center),
          );
          await imInPrinter.printColumnsText(
              cols: List.generate(
            350,
            (index) {
              return ColumnMaker(text: "-");
            },
          ));
          await imInPrinter.printColumnsText(cols: [
            ColumnMaker(
              text: 'Product',
              width: 150,
              fontSize: 26,
              // align: IminPrintAlign.center
            ),
            ColumnMaker(
              text: 'Qty',
              width: 150,
              fontSize: 26,
              align: IminPrintAlign.center,
            ),
            ColumnMaker(
              text: 'Unit Price',
              width: 150,
              fontSize: 26,
              // align: IminPrintAlign.right,
            ),
            ColumnMaker(
              text: 'Total Price',
              width: 150,
              fontSize: 26,
              // align: IminPrintAlign.right,
            )
          ]);
          await imInPrinter.printColumnsText(
              cols: List.generate(
            350,
            (index) {
              return ColumnMaker(text: "-");
            },
          ));
          for (int i = 0; i < products.length; i++) {
            await imInPrinter.printColumnsText(cols: [
              ColumnMaker(
                text: products[i].name ?? "",
                width: 150,
                fontSize: 26,
                // align: IminPrintAlign.center
              ),
              ColumnMaker(
                  text: products[i].quantity.toString(),
                  width: 150,
                  fontSize: 26,
                  align: IminPrintAlign.center),
              ColumnMaker(
                  text: products[i].unitPrice!.toStringAsFixed(2),
                  width: 150,
                  fontSize: 26,
                  align: IminPrintAlign.center),
              ColumnMaker(
                  text: products[i].totalPrice!.toStringAsFixed(2),
                  width: 150,
                  fontSize: 26,
                  align: IminPrintAlign.center)
            ]);
          }
          await imInPrinter.printColumnsText(
              cols: List.generate(
            350,
            (index) {
              return ColumnMaker(text: "-");
            },
          ));
        },
      );
      await imInPrinter.printColumnsText(cols: [
        ColumnMaker(
          text: '',
          width: 150,
          fontSize: 26,
          // align: IminPrintAlign.center
        ),
        ColumnMaker(
          text: '',
          width: 150,
          fontSize: 26,
          // align: IminPrintAlign.left,
        ),
        ColumnMaker(
          text: 'Total',
          width: 110,
          fontSize: 26,
          align: IminPrintAlign.center,
        ),
        ColumnMaker(
          text: "\$ $total",
          width: 150,
          fontSize: 26,
          align: IminPrintAlign.right,
        )
      ]);
      await imInPrinter.commitPrinterBuffer().then(
        (value) async {
          await imInPrinter.partialCut();
        },
      ).whenComplete(
        () async {
          await imInPrinter.resetDevice();
        },
      );
    }
  }

  Widget buttonWidget(
      {required String title,
      Color? btnColor,
      Color? textColor,
      bool? isNum = false,
      Function()? onTap}) {
    return Expanded(
      child: InkResponse(
        onTap: onTap,
        splashColor: Colors.grey,
        containedInkWell: true,
        hoverColor: Colors.grey,
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Container(
            // width: 100.0,
            padding: EdgeInsets.symmetric(vertical: isNum! ? 18.0 : 20.5),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: btnColor ?? Colors.black12,
              borderRadius: BorderRadius.circular(0.0),
            ),
            child: Text(
              title.toUpperCase(),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: textColor ?? Colors.black,
                  fontSize: isNum ? 16.0 : 12.1,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> productUpdate(
      {required String name,
      required double quantity,
      required double unitPrice,
      required String id,
      required String variantId,
      required String unit,
      required double totalPrice,
      required String isEdit,
      int? variationDoubleId}) async {
    await model!
        .updateList(
            id: id,
            variantId: variantId,
            name: name,
            quantity: quantity,
            unit: unit,
            unitPrice: unitPrice,
            totalPrice: totalPrice,
            variationDoubleId: variationDoubleId,
            isEdit: isEdit)
        .then(
      (value) {
        if (value) {
          setState(() {
            typeValue = "";
            selectedName = name;
            model!.scannedProduct = [];
            selectedCart = null;
            isOrder = false;
          });
          sendMsgToSubScreen(
              method: "list", data: model!.cartListModel.toJson());
          sendMsgToSubScreen(method: "pay", data: {
            "payment": paymentMethod.toList(),
            "discount_type": selectedDiscount
          });
        }
      },
    );
  }

  Future<void> sellingProductUpdate(
      {required String name,
      required double quantity,
      required double unitPrice,
      required String id,
      required String variantId,
      required String unit,
      required double totalPrice,
      required String isEdit,
      int? variationDoubleId}) async {
    await model!
        .sellingUpdateList(
            id: id,
            variantId: variantId,
            name: name,
            quantity: quantity,
            unit: unit,
            isEdit: isEdit,
            unitPrice: unitPrice,
            totalPrice: totalPrice,
            variationDoubleId: variationDoubleId)
        .then(
      (value) {
        if (value) {
          setState(() {
            typeValue = "";
            selectedName = name;
            model!.scannedProduct = [];
            selectedCart = null;
            isOrder = false;
          });
          sendMsgToSubScreen(
              method: "list", data: model!.cartListModel.toJson());
          sendMsgToSubScreen(method: "pay", data: {
            "payment": paymentMethod.toList(),
            "discount_type": selectedDiscount
          });
        }
      },
    );
  }

  Future<void> getMoreProduct() async {
    await model!.loadMore(context, keyLoader, selectedCategoryId).then(
      (value) {
        setState(() {});
      },
    );
  }

  getHoldProduct() {
    List<OrderedProduct> productList = [];
    for (var product in model!.cartListModel.productList!) {
      productList.add(
        OrderedProduct(
          productId: int.parse(product.id ?? ""),
          quantity: product.quantity!,
          sellerPrice: product.unitPrice!,
          productVariablesId: product.productVariantId == null
              ? null
              : int.parse(product.productVariantId!),
        ),
      );
    }
    return productList;
  }

  getOrderPlaceProduct() {
    List<Bill> productList = [];
    for (var product in model!.cartListModel.productList!) {
      productList.add(
        Bill(
          productId: int.parse(product.id ?? ""),
          quantity: product.quantity!,
          productVariableId: product.productVariantId == null
              ? null
              : int.parse(product.productVariantId!),
        ),
      );
    }
    return productList;
  }

  getProductList() {
    List pro = [];
    for (var product in model!.cartListModel.productList!) {
      pro.add({
        "product_type": "single",
        "unit_price": product.unitPrice ?? 0.0,
        "line_discount_type": "fixed", // default
        "line_discount_amount": 0.000, // default
        "item_tax": 0.000,
        "tax_id": null,
        "sell_line_note": null,
        "pos_sell_quantity_edit": product.isEdit ?? "0",
        "product_id": int.parse(product.id ?? "0"),
        "variation_id": int.parse(product.productVariantId!.isEmpty
            ? "0"
            : product.productVariantId!),
        "enable_stock": 1,
        "variation_double_id": product.variationDoubleId,
        "quantity": double.parse(product.quantity.toString()),
        "base_unit_multiplier": 1, // default
        "unit_price_inc_tax": product.unitPrice ?? 0.0
      });
    }
    return pro;
  }

  void getHoldOrdersDialogue() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(16),
          contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          title: const Row(
            children: [
              Expanded(child: Divider(color: Colors.black12)),
              SizedBox(width: 15.0),
              Text("Hold Bills"),
              SizedBox(width: 15.0),
              Expanded(child: Divider(color: Colors.black12)),
            ],
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 250, // Limit dialog height (adjust as needed)
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
/*                  const SizedBox(height: 10),
                  const Text("Hold Bills"),
                  const SizedBox(height: 10),*/
                  Expanded(
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      // Prevent nested scrolling
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        // 🔧 Adjust based on how many items per row
                        crossAxisSpacing: 5.0,
                        mainAxisSpacing: 5.0,
                        mainAxisExtent:
                            80.0, // 🔧 Optional fixed height for each card
                      ),
                      itemCount: model!.holderOrder.length,
                      itemBuilder: (context, index) {
                        final e = model!.holderOrder[index];

                        return InkResponse(
                          onTap: () async {
                            Navigator.of(context).pop();
                            await model!
                                .getHolderOrderDetails(
                                    keyLoader: keyLoader,
                                    context: context,
                                    draftId: e.id ?? 0)
                                .then((value) {
                              if (value) {
                                setState(() {
                                  isHold = true;
                                  isNor = true;
                                  holdId = e.id;
                                  model!.cartListModel.productList =
                                      mapSeller(model!.sellerOrder);
                                  model!.calculation.grandTotal = 0.0;
                                  model!.calculation.discountAmount = 0.0;
                                  model!.calculation.grandTotal = double.parse(
                                      model!.cartListModel.productList!
                                          .map((item) =>
                                              item.totalPrice as double)
                                          .reduce((a, b) => a + b)
                                          .toStringAsFixed(2));

                                  disCount = "0.0";
                                });

                                sendMsgToSubScreen(
                                  method: "list",
                                  data: model!.cartListModel.toJson(),
                                );
                              }
                            });
                          },
                          child: Container(
                            // width: 105.0,
                            padding: const EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                              color: Colors.purple.shade600,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Total : \$ ${e.finalTotal.toString()}",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 15.0),
                                ),
                                const SizedBox(height: 10.0),
                                Text(
                                  "Bill No : ${e.invoiceNo.toString()}",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 15.0),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void getDiscountBox() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            content: DiscountWidget(
                onDone: (Map<String, dynamic> data) {
                  Navigator.of(context).pop();
                  setState(() {
                    if (data["type"] == "Voucher") {
                      double finalPrice = double.parse(
                          (model!.calculation.grandTotal! -
                                  double.parse(data["discount"]))
                              .toStringAsFixed(2));
                      if (finalPrice > 0.0) {
                        selectedDiscount = data["type"];
                        disCount = data["discount"];
                        model!.calculation.grandTotal = double.parse(
                            (model!.calculation.grandTotal! -
                                    double.parse(disCount))
                                .toStringAsFixed(1));
                        model!.calculation.discountAmount =
                            double.parse(disCount);
                        model!.cartListModel.discountAmount =
                            double.parse(disCount);
                      } else {
                        Fluttertoast.showToast(
                          msg: "This voucher value is not allowed.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                        );
                      }
                    } else if (data["type"] == "% Discount") {
                      double finalPrice = double.parse(model!
                              .calculation.grandTotal!
                              .toStringAsFixed(2)) -
                          double.parse(data["discount"]) /
                              100 *
                              double.parse(model!.calculation.grandTotal!
                                  .toStringAsFixed(2));
                      if (finalPrice > 0.0) {
                        selectedDiscount = data["type"];
                        disCount = data["discount"];
                        model!.calculation.discountAmount =
                            (double.parse(disCount) / 100) *
                                model!.calculation.grandTotal!;
                        model!.cartListModel.discountAmount =
                            (double.parse(disCount) / 100) *
                                model!.calculation.grandTotal!;
                        model!.calculation.grandTotal = double.parse(
                            (model!.calculation.grandTotal! -
                                    model!.calculation.discountAmount!)
                                .toStringAsFixed(1));
                      } else {
                        Fluttertoast.showToast(
                          msg: "This discount value is not allowed.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                        );
                      }
                    } else {
                      double finalPrice = double.parse(
                          (model!.calculation.grandTotal! -
                                  double.parse(data["discount"]))
                              .toStringAsFixed(1));
                      if (finalPrice > 0.0) {
                        selectedDiscount = data["type"];
                        disCount = data["discount"];
                        model!.calculation.grandTotal = double.parse(
                            (model!.calculation.grandTotal! -
                                    double.parse(disCount))
                                .toStringAsFixed(1));
                        model!.calculation.discountAmount =
                            double.parse(disCount);
                        model!.cartListModel.discountAmount =
                            double.parse(disCount);
                      } else {
                        Fluttertoast.showToast(
                          msg: "This discount value is not allowed.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                        );
                      }
                    }
                  });
                  sendMsgToSubScreen(
                      method: "list", data: model!.cartListModel.toJson());
                  sendMsgToSubScreen(method: "pay", data: {
                    "payment": paymentMethod.toList(),
                    "discount_type": selectedDiscount
                  });
                },
                discountType: selectedDiscount));
      },
    );
  }

  void getKgBox({required Function() onKg}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          content: KilogramReadingWidget(
            onDone: (Map<String, dynamic> data) {
              Navigator.of(context).pop();
              setState(() {
                kiloUnit = double.tryParse(data['kg'] ?? 1.00) ?? 1.00;
              });
              onKg();
              sendMsgToSubScreen(
                  method: "list", data: model!.cartListModel.toJson());
              sendMsgToSubScreen(method: "pay", data: {
                "payment": paymentMethod.toList(),
                "discount_type": selectedDiscount
              });
            },
          ),
        );
      },
    );
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
                onDone: (Map<String, dynamic> postData) =>
                    onCashClose(postData)),
          ),
        );
      },
    );
  }

  void getPaymentDialogue() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            contentPadding: EdgeInsets.zero,
            content: PaymentWidget(
                disCount: selectedDiscount ?? "",
                cartItem: model!.cartListModel.productList!.length,
                total: model!.calculation.grandTotal ?? 0.00,
                cashOpen: () async {
                  try {
                    await model!.openCashBox();
                  } on PlatformException catch (e) {
                    Fluttertoast.showToast(msg: e.toString());
                  } catch (e) {
                    Fluttertoast.showToast(msg: e.toString());
                  }
                },
                onPayDone: (payMethod, change) {
                  Navigator.of(context).pop();
                  addCustomer(changeReturn: change, payMethod: payMethod);
                }
                // paymentUpdate(changeReturn: change, payMethod: payMethod),
                // newPaymentUpdate(changeReturn: change, payMethod: payMethod),
                ),
          ),
        );
      },
    );
  }

  void addCustomer(
      {required List<Map<String, String>> payMethod,
      required double changeReturn}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 250, // Limit dialog height (adjust as needed)
                ),
                child: AddCustomerScreen(
                    onDone: (int customerId) => newPaymentUpdate(
                        changeReturn: changeReturn,
                        payMethod: payMethod,
                        customerId: customerId)),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> onCashClose(Map<String, dynamic> postData) async {
    prefs = spEngine!.prefs;
    int? cashId = prefs!.getInt(AppStrings.cashId) ?? 0;
    bool result = await model!.cashCloseApi(
        postBody: postData,
        context: context,
        key: keyLoader,
        cashId: cashId.toString());
    if (result) {
      if (result) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          "/",
          (route) => false,
        );
        setState(() {
          model!.cartListModel.productList!.clear();
          typeValue = "";
          model!.cartListModel.billNo = "";
          model!.cartListModel.cashPaid = "0.0";
          model!.cartListModel.balance = "0.0";
          model!.calculation.grandTotal = 0.0;
          model!.calculation.discountAmount = 0.0;
          model!.cartListModel.discountAmount = 0.0;
          selectedDiscount = "";
          paymentMethod = [];
          isHold = false;
        });
        sendMsgToSubScreen(method: "list", data: model!.cartListModel.toJson());
        sendMsgToSubScreen(
            method: "pay",
            data: {"payment": [], "discount_type": selectedDiscount});
      }
    }
  }

  void getDoublePrice(
      {List<VariationDouble>? variationDouble,
      String? productName,
      String? unit}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 250, // Limit dialog height (adjust as needed)
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName ?? "",
                    style: TextStyle(
                        color: AppColor.blackColor,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Expanded(
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      // Prevent nested scrolling
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        // 🔧 Adjust based on how many items per row
                        crossAxisSpacing: 5.0,
                        mainAxisSpacing: 5.0,
                        mainAxisExtent:
                            90.0, // 🔧 Optional fixed height for each card
                      ),
                      itemCount: variationDouble!.length,
                      itemBuilder: (context, index) {
                        final e = variationDouble[index];
                        return InkResponse(
                          onTap: () async {
                            Navigator.of(context).pop();
                            if (e.defaultSellPrice == "0" ||
                                e.defaultSellPrice == "0.0000" ||
                                e.defaultSellPrice == "0.00" ||
                                e.defaultSellPrice!.isEmpty) {
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0)),
                                    content: SellingPriceWidget(
                                      onDone: (data) {
                                        if (typeValue != null &&
                                            typeValue!.isEmpty) {
                                          sellingProductUpdate(
                                            name:
                                                "$productName ${e.id == null || e.id == 0 ? "" : e.name ?? ""}",
                                            quantity: 1.0,
                                            isEdit: "0",
                                            unitPrice: double.parse(
                                                data['selling_price'] ?? "0.0"),
                                            id: e.productId.toString(),
                                            variantId: e.variationId.toString(),
                                            unit: e.unit ?? "",
                                            variationDoubleId: e.id ?? null,
                                            totalPrice: 1.0 *
                                                (double.parse(
                                                    data['selling_price'] ??
                                                        "0.0")),
                                          );
                                        } else {
                                          if (typeValue!.length <= 2) {
                                            productUpdate(
                                              name:
                                                  "$productName ${e.id == null || e.id == 0 ? "" : e.name ?? ""}",
                                              quantity: double.parse(
                                                  typeValue ?? "0"),
                                              unitPrice: double.parse(
                                                  data['selling_price'] ??
                                                      "0.0"),
                                              isEdit: "0",
                                              id: e.productId.toString(),
                                              unit: e.unit ?? "",
                                              variationDoubleId: e.id,
                                              variantId:
                                                  e.variationId.toString(),
                                              totalPrice: int.parse(
                                                      typeValue ?? "0") *
                                                  (double.parse(
                                                      data['selling_price'] ??
                                                          "0.0")),
                                            );
                                          } else {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "You are not allow to purchase the product by this quantity.",
                                                backgroundColor: Colors.red);
                                          }
                                        }
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  );
                                },
                              );
                            } else {
                              if (typeValue != null && typeValue!.isEmpty) {
                                productUpdate(
                                  name:
                                      "$productName ${e.id == null || e.id == 0 ? "" : e.name ?? ""}",
                                  quantity: 1.0,
                                  unitPrice:
                                      double.parse(e.defaultSellPrice ?? "0.0"),
                                  id: e.productId.toString(),
                                  variantId: e.variationId.toString(),
                                  unit: e.unit ?? "",
                                  variationDoubleId: e.id,
                                  isEdit: "0",
                                  totalPrice: 1.0 *
                                      (double.parse(
                                          e.defaultSellPrice ?? "0.0")),
                                );
                              } else {
                                if (typeValue!.length <= 2) {
                                  productUpdate(
                                    name:
                                        "$productName ${e.id == null || e.id == 0 ? "" : e.name ?? ""}",
                                    quantity: double.parse(typeValue ?? "0"),
                                    unitPrice: double.parse(
                                        e.defaultSellPrice ?? "0.0"),
                                    id: e.productId.toString(),
                                    unit: e.unit ?? "",
                                    isEdit: "0",
                                    variationDoubleId: e.id,
                                    variantId: e.variationId.toString(),
                                    totalPrice: int.parse(typeValue ?? "0") *
                                        (double.parse(
                                            e.defaultSellPrice ?? "0.0")),
                                  );
                                } else {
                                  Fluttertoast.showToast(
                                      msg:
                                          "You are not allow to purchase the product by this quantity.",
                                      backgroundColor: Colors.red);
                                }
                              }
                            }
                          },
                          child: /*Container(
                            padding: const EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                              color: Colors.purple.shade600,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  e.name.toString(),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 15.0),
                                ),
                                const SizedBox(height: 10.0),
                                Text(
                                  "U.Price : ${e.defaultSellPrice.toString()}",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 15.0),
                                ),
                              ],
                            ),
                          )*/
                              Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25.0, vertical: 10.0),
                            decoration: BoxDecoration(
                              color: Colors.purple.shade600,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${e.name.toString()} ${e.unit!.isNotEmpty ? "(${e.unit ?? ""})" : ""}",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 15.0),
                                ),
                                const SizedBox(height: 5.0),
                                Text(
                                  "U.Price : ${double.parse(e.defaultSellPrice ?? "0.00").toStringAsFixed(2)}",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14.0),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> sendMsgToSubScreen({String? method, data}) async {
    final isMultipleScreen =
        await imInViceScreenPlugin.isSupportMultipleScreen();
    if (isMultipleScreen != null && isMultipleScreen) {
      imInViceScreenPlugin
          .sendMsgToViceScreen(method!, params: {"data": data!});
    }
  }

  Future<void> initPrinter() async {
    await imInPrinter.initPrinter();
    await imInPrinter.exitPrinterBuffer(false);
  }

  List<ProductList> mapSeller(List<SellDetails> sellerOrder) {
    List<ProductList> list = [];
    for (var item in sellerOrder) {
      list.add(
        ProductList(
          id: item.productId.toString(),
          name: item.productName,
          unit: item.unit,
          isEdit: item.posSellQuantityEdit,
          productVariantId: item.variationId.toString(),
          quantity: double.parse(item.quantityOrdered ?? "0"),
          unitPrice: double.parse(item.defaultSellPrice ?? '0.0'),
          totalPrice: double.parse(item.quantityOrdered ?? "0").toInt() *
              double.parse(item.defaultSellPrice ?? '0.0'),
        ),
      );
    }
    return list;
  }

  Future<Uint8List> getImage() async {
    ByteData byteData = await rootBundle.load("assets/images/logo-remove.png");
    return byteData.buffer.asUint8List();
  }

  void initScreen() {
    imInViceScreenPlugin.mainStream.listen((event) {
      updateEvent(event);
    });
  }

  void updateEvent(MethodCall event) {
    model!.updateData(event).then(
      (value) {
        setState(() {});
        updateData(method: "paynow");
      },
    );
  }

  void updateData({required String method}) {
    debugPrint((typeValue == null || typeValue!.isEmpty)
        ? (model!.cartListModel.cashPaid == null ||
                model!.cartListModel.cashPaid == "0.0")
            ? model!.calculation.grandTotal!.toStringAsFixed(2)
            : model!.cartListModel.balance
        : double.parse(typeValue ?? "").toString());
    setState(() {
      paymentMethod.add({
        "method": method,
        "amount": (typeValue == null || typeValue!.isEmpty)
            ? (model!.cartListModel.cashPaid == null ||
                    model!.cartListModel.cashPaid == "0.0")
                ? model!.calculation.grandTotal!.toStringAsFixed(2)
                : model!.cartListModel.balance
            : double.parse(typeValue ?? "")
      });
      String amount = (typeValue == null || typeValue!.isEmpty)
          ? model!.calculation.grandTotal!.toStringAsFixed(2)
          : double.parse(typeValue ?? "").toStringAsFixed(2);
      model!.cartListModel.cashPaid = model!.cartListModel.cashPaid != null &&
              model!.cartListModel.cashPaid!.isNotEmpty
          ? (double.parse(model!.cartListModel.cashPaid ?? "0.0") +
                  double.parse(amount))
              .toStringAsFixed(2)
          : double.parse(amount).toStringAsFixed(2);
      model!.cartListModel.balance = ((model!.calculation.grandTotal! -
              double.parse(model!.cartListModel.cashPaid!)))
          .abs()
          .toStringAsFixed(2);
      typeValue = "";
    });
    sendMsgToSubScreen(method: "list", data: model!.cartListModel.toJson());
    sendMsgToSubScreen(method: "pay", data: {
      "payment": paymentMethod.toList(),
      "discount_type": selectedDiscount
    });
    if (model!.calculation.grandTotal! <=
        double.parse(model!.cartListModel.cashPaid ?? "0.0")) {
      // paymentUpdate();
    }
  }

  void paymentUpdate(
      {required List<Map<String, String>> payMethod,
      required double changeReturn}) async {
    await Future.delayed(const Duration(seconds: 8));
    Navigator.of(context).pop();
    if (model!.cartListModel.billNo!.isEmpty) {
      if (model!.cartListModel.productList!.isNotEmpty) {
        setState(() {
          model!.cartListModel.cashPaid =
              (model!.calculation.grandTotal ?? 0.0).toStringAsFixed(1);
        });
        Map<String, dynamic> postData = {
          "is_enabled_stock": 1, // default
          "location_id": prefs!.getInt(AppStrings.businessLocations), // default
          "contact_id": 1, // default
          "price_group": 0, // default
          "sell_price_tax": "includes", // default
          "products": getProductList(),
          "advance_balance": 0.0000, // default
          "payment": payMethod, // paymentMethod
          "change_return": changeReturn.toStringAsFixed(2), // default
          "is_suspend": 0, // default
          "recur_interval_type": "days", // default
          "final_total": double.parse(model!.calculation.grandTotal.toString()),
          "is_credit_sale": 0, // default
          "discount_type": selectedDiscount != null && selectedDiscount != ""
              ? selectedDiscount == "% Discount"
                  ? "Discount"
                  : selectedDiscount == "Voucher"
                      ? "voucher"
                      : "Percentage"
              : "",
          "discount_amount": selectedDiscount != null && selectedDiscount != ""
              ? model!.calculation.discountAmount ?? 0.0
              : 0.0,
          "rp_redeemed": 0, // default
          "rp_redeemed_amount": 0, // default
          "tax_rate_id": 1, // default
          "tax_calculation_amount": 5.000,
          "shipping_charges": 0.000, // default
          "discount_type_modal":
              selectedDiscount != null && selectedDiscount != ""
                  ? selectedDiscount == "% Discount"
                      ? "Discount"
                      : selectedDiscount == "Voucher"
                          ? "voucher"
                          : "Percentage"
                  : "",
          "discount_amount_modal":
              selectedDiscount != null && selectedDiscount != ""
                  ? model!.calculation.discountAmount ?? 0.0
                  : 0.0,
          "order_tax_modal": 1, // default
          "shipping_charges_modal": 0, // default
          "status": "final" // default
        };
        // debugPrint(postData.toString());
        await model!
            .placeOrder(postData,
                context: context,
                keyLoader: keyLoader,
                url: isHold
                    ? AppStrings.recallOrderUpdateUrl + holdId.toString()
                    : AppStrings.placeOrderUrl)
            .then((value) async {
          if (value) {
            await Future.delayed(const Duration(seconds: 2));
            setState(() {
              model!.cartListModel.productList!.clear();
              typeValue = "";
              model!.cartListModel.billNo = "";
              model!.cartListModel.cashPaid = "0.0";
              model!.cartListModel.balance = "0.0";
              model!.calculation.grandTotal = 0.0;
              model!.calculation.discountAmount = 0.0;
              model!.cartListModel.discountAmount = 0.0;
              selectedDiscount = "";
              paymentMethod = [];
              isHold = false;
            });
            sendMsgToSubScreen(
                method: "list", data: model!.cartListModel.toJson());
            sendMsgToSubScreen(
                method: "pay",
                data: {"payment": [], "discount_type": selectedDiscount});
            /* if (printers.isNotEmpty) {
              usbPrint(
                  deviceId: printers[0]['deviceId'].toString(),
                  gTotal: model!.calculation.grandTotal!.toStringAsFixed(2),
                  products: model!.cartListModel.productList ?? []);
            } else {
              await printReceipt(
                  products: model!.cartListModel.productList ?? [],
                  total: model!.calculation.grandTotal!.toStringAsFixed(2));
            }*/
          } else {
            setState(() {
              paymentMethod = [];
              model!.cartListModel.billNo = "";
              model!.cartListModel.cashPaid = "0.0";
              model!.cartListModel.balance = "0.0";
            });
            sendMsgToSubScreen(
                method: "list", data: model!.cartListModel.toJson());
            sendMsgToSubScreen(method: "pay", data: {
              "payment": paymentMethod.toList(),
              "discount_type": selectedDiscount
            });
          }
        });
      }
    }
  }

  void paymentFinishDialog(
      List<Map<String, String>> payMethod, double changeReturn) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            content: PaymentFinishWidget(
                payMethod: payMethod,
                printers: printers,
                changeReturn: changeReturn,
                total: model!.calculation.grandTotal,
                productList: model!.cartListModel.productList!,
                onDone: () {
                  setState(() {
                    model!.cartListModel.productList!.clear();
                    typeValue = "";
                    model!.cartListModel.billNo = "";
                    model!.cartListModel.cashPaid = "0.0";
                    model!.cartListModel.balance = "0.0";
                    model!.calculation.grandTotal = 0.0;
                    model!.calculation.discountAmount = 0.0;
                    model!.cartListModel.discountAmount = 0.0;
                    selectedDiscount = "";
                    paymentMethod = [];
                    isHold = false;
                  });
                  sendMsgToSubScreen(
                      method: "list", data: model!.cartListModel.toJson());
                  sendMsgToSubScreen(
                      method: "pay",
                      data: {"payment": [], "discount_type": selectedDiscount});
                },
                postData: {
                  "is_enabled_stock": 1,
                  // default
                  "location_id": prefs!.getInt(AppStrings.businessLocations),
                  // default
                  "contact_id": 1,
                  // default
                  "price_group": 0,
                  // default
                  "sell_price_tax": "includes",
                  // default
                  "products": getProductList(),
                  "advance_balance": 0.0000,
                  // default
                  "payment": payMethod,
                  // paymentMethod
                  "change_return": changeReturn.toStringAsFixed(2),
                  // default
                  "is_suspend": 0,
                  // default
                  "recur_interval_type": "days",
                  // default
                  "final_total":
                      double.parse(model!.calculation.grandTotal.toString()),
                  "is_credit_sale": 0,
                  // default
                  "discount_type":
                      selectedDiscount != null && selectedDiscount != ""
                          ? selectedDiscount == "% Discount"
                              ? "Discount"
                              : selectedDiscount == "Voucher"
                                  ? "voucher"
                                  : "Percentage"
                          : "",
                  "discount_amount":
                      selectedDiscount != null && selectedDiscount != ""
                          ? model!.calculation.discountAmount ?? 0.0
                          : 0.0,
                  "rp_redeemed": 0,
                  // default
                  "rp_redeemed_amount": 0,
                  // default
                  "tax_rate_id": 1,
                  // default
                  "tax_calculation_amount": 5.000,
                  "shipping_charges": 0.000,
                  // default
                  "discount_type_modal":
                      selectedDiscount != null && selectedDiscount != ""
                          ? selectedDiscount == "% Discount"
                              ? "Discount"
                              : selectedDiscount == "Voucher"
                                  ? "voucher"
                                  : "Percentage"
                          : "",
                  "discount_amount_modal":
                      selectedDiscount != null && selectedDiscount != ""
                          ? model!.calculation.discountAmount ?? 0.0
                          : 0.0,
                  "order_tax_modal": 1,
                  // default
                  "shipping_charges_modal": 0,
                  // default
                  "status": "final"
                  // default
                },
                url: isHold
                    ? AppStrings.recallOrderUpdateUrl + holdId.toString()
                    : AppStrings.placeOrderUrl),
          ),
        );
      },
    );
  }

  void newPaymentUpdate(
      {required List<Map<String, String>> payMethod,
      required double changeReturn,
      required int customerId}) async {
    Navigator.of(context).pop();
    Map<String, dynamic> postData = {
      "is_enabled_stock": 1,
      // default
      "location_id": prefs!.getInt(AppStrings.businessLocations),
      // default
      "contact_id": customerId,
      // default
      "price_group": 0,
      // default
      "sell_price_tax": "includes",
      // default
      "products": getProductList(),
      "advance_balance": 0.0000,
      // default
      "payment": payMethod,
      // paymentMethod
      "change_return": changeReturn.toStringAsFixed(2),
      // default
      "is_suspend": 0,
      // default
      "recur_interval_type": "days",
      // default
      "final_total": double.parse(model!.calculation.grandTotal.toString()),
      "is_credit_sale": 0,
      // default
      "discount_type": selectedDiscount != null && selectedDiscount != ""
          ? selectedDiscount == "% Discount"
              ? "Discount"
              : selectedDiscount == "Voucher"
                  ? "voucher"
                  : "Percentage"
          : "",
      "discount_amount": selectedDiscount != null && selectedDiscount != ""
          ? model!.calculation.discountAmount ?? 0.0
          : 0.0,
      "rp_redeemed": 0,
      // default
      "rp_redeemed_amount": 0,
      // default
      "tax_rate_id": 1,
      // default
      "tax_calculation_amount": 5.000,
      "shipping_charges": 0.000,
      // default
      "discount_type_modal": selectedDiscount != null && selectedDiscount != ""
          ? selectedDiscount == "% Discount"
              ? "Discount"
              : selectedDiscount == "Voucher"
                  ? "voucher"
                  : "Percentage"
          : "",
      "discount_amount_modal":
          selectedDiscount != null && selectedDiscount != ""
              ? model!.calculation.discountAmount ?? 0.0
              : 0.0,
      "order_tax_modal": 1,
      // default
      "shipping_charges_modal": 0,
      // default
      "status": "final"
      // default
    };
    String url = isHold
        ? AppStrings.recallOrderUpdateUrl + holdId.toString()
        : AppStrings.placeOrderUrl;
    setState(() {
      lastItems = model!.cartListModel.productList!;
      cusName = model!.customerMobile;
      mobile = model!.customerName;
    });
    await model!
        .orderUpdate(
            url: url,
            postData: postData,
            context: context,
            keyLoader: keyLoader,
            isLoad: true)
        .then(
      (value) {
        if (value) {
          setState(() {
            lastItems = model!.lastPurchaseList;
            lastBillNo = model!.cartListModel.billNo ?? "";
            lastTransaction = model!.lastPurchase ?? "";
            lastTotal = model!.calculation.grandTotal ?? 0.00;
            cusName = model!.customerMobile;
            mobile = model!.customerName;
            lastPayments = payMethod;
            lastDiscount = selectedDiscount != null && selectedDiscount != ""
                ? model!.calculation.discountAmount ?? 0.00
                : 0.00;
            returnChange = changeReturn;
            model!.cartListModel.productList = [];
            typeValue = "";
            model!.cartListModel.billNo = "";
            model!.cartListModel.cashPaid = "0.0";
            model!.cartListModel.balance = "0.0";
            model!.calculation.grandTotal = 0.0;
            model!.calculation.discountAmount = 0.0;
            model!.cartListModel.discountAmount = 0.0;
            selectedDiscount = "";
            paymentMethod = [];
            isHold = false;
            isOrder = false;
            isVisible = true;
            time = 120;
          });
          // startTimer();
          sendMsgToSubScreen(
              method: "list", data: model!.cartListModel.toJson());
          sendMsgToSubScreen(
              method: "pay",
              data: {"payment": [], "discount_type": selectedDiscount});
        }
      },
    );
    // setState(() {
    //   isOrder = true;
    //   paymentMethod = payMethod;
    //   returnChange = changeReturn;
    // });
    // paymentFinishDialog(payMethod, changeReturn);
  }

  Future<void> loadPrinters() async {
    try {
      final devices = await model!.getConnectedPrinters();
      setState(() {
        printers = devices;
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  /*Future<void> usbPrint({
    required String deviceId,
    required String gTotal,
    required List<ProductList> products,
  }) async {
    List<int> bytes =
        await printReceiptAsBytes(total: gTotal, productList: products);
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
  }*/
  void loadCart(Transactions receipt) {
    setState(() {
      isRecall = true;
      holdId = receipt.id ?? 0;
      model!.cartListModel.productList = mapSeller(receipt.sellDetails ?? []);
      model!.calculation.grandTotal =
          double.parse(receipt.finalTotal ?? "0.00");
      model!.calculation.discountAmount =
          double.parse(receipt.discountAmount ?? "0.00");
      model!.cartListModel.discountAmount =
          double.parse(receipt.discountAmount ?? "0.00");
      selectedDiscount = receipt.discountType ?? "";
      model!.cartListModel.billNo = "";
      model!.cartListModel.billNo = "";
      paymentMethod = receipt.paymentLines!
          .map(
            (e) => e.toJson(),
          )
          .toList();
      disCount = "";
    });
  }

  Future<void> usbPrint(
      {required String deviceId,
      required String gTotal,
      required String receipt,
      required String date,
      required String time,
      required List<Map<String, double>> payHistory,
      required String discount,
      required List<ProductList> products}) async {
    List<int> bytes = await printReceiptAsBytes(
        total: gTotal,
        cashier: prefs!.getString(AppStrings.userName) ?? "",
        date: date,
        receiptNo: receipt,
        time: time,
        productList: products,
        history: payHistory,
        discount: discount,
        customerName: cusName,
        mobile: mobile);
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

  /*Future<List<int>> printReceiptAsBytes(
      {required String total, required List<ProductList> productList}) async
  {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    final List<int> bytes = [];

    // Optional: Reset printer
    bytes.addAll(generator.reset());
    // 2. Print Address
    bytes.addAll(generator.text(
      'Address',
      styles: const PosStyles(align: PosAlign.center),
    ));
    bytes.addAll(generator.text(
      // 'Yishun, 269A Yishun Street 22 - 761269, Singapore',
      prefs!.getString(AppStrings.selectedAddress) ?? "",
      styles: const PosStyles(align: PosAlign.center),
    ));

    // 3. Divider line
    bytes.addAll(generator.hr());

    // 4. Table Header
    bytes.addAll(generator.row([
      PosColumn(text: 'Product', width: 6),
      PosColumn(
          text: 'Qty',
          width: 2,
          styles: const PosStyles(align: PosAlign.center)),
      PosColumn(
          text: 'Unit',
          width: 2,
          styles: const PosStyles(align: PosAlign.right)),
      PosColumn(
          text: 'Total',
          width: 2,
          styles: const PosStyles(align: PosAlign.right)),
    ]));

    bytes.addAll(generator.hr());

    // 5. Product rows
    for (final item in productList) {
      bytes.addAll(generator.row([
        PosColumn(text: item.name ?? '', width: 6),
        PosColumn(
          text: item.quantity.toString(),
          width: 2,
          styles: const PosStyles(align: PosAlign.center),
        ),
        PosColumn(
          text: item.unitPrice!.toStringAsFixed(2),
          width: 2,
          styles: const PosStyles(align: PosAlign.right),
        ),
        PosColumn(
          text: item.totalPrice!.toStringAsFixed(2),
          width: 2,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]));
    }

    // 6. Final Divider
    bytes.addAll(generator.hr());

    // 7. Total row
    bytes.addAll(generator.row([
      PosColumn(text: '', width: 8),
      PosColumn(
          text: 'Total',
          width: 2,
          styles: const PosStyles(align: PosAlign.right, bold: true)),
      PosColumn(
        text: '\$ $total',
        width: 2,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
    ]));

    // 8. Feed and Cut
    bytes.addAll(generator.feed(2));
    bytes.addAll(generator.cut());

    return bytes;
  }*/
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

  img.Image removeTransparency(img.Image src) {
    // Create a white background image (same dimensions)
    final whiteBg = img.Image(width: src.width, height: src.height);
    whiteBg.clear(img.ColorRgb8(255, 255, 255)); // Fill with white color

    // Draw the original image on top (this keeps non-transparent parts)
    img.compositeImage(whiteBg, src);

    return whiteBg;
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

  Future<List<int>> printReceiptAsBytes({
    required String total,
    required String time,
    required String cashier,
    required String date,
    required String receiptNo,
    required List<ProductList> productList,
    required List<Map<String, double>> history,
    required String discount,
    required String customerName,
    required String mobile,
  }) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    final List<int> bytes = [];
    //  bytes.addAll(generator.feed(1));
    bytes.addAll(generator.reset());
    bytes.addAll(generator.text(
      // "GMART",
      prefs!.getString(AppStrings.appName) ?? "",
      styles: const PosStyles(
        width: PosTextSize.size3,
        bold: true,
        align: PosAlign.center,
      ),
    ));
    bytes.addAll(generator.feed(2));
    bytes.addAll(generator.text(
      prefs!.getString(AppStrings.selectedAddress) ?? "",
      styles: const PosStyles(align: PosAlign.center),
    ));
    bytes.addAll(generator.row([
      PosColumn(text: "Receipt No : $receiptNo", width: 6),
      PosColumn(
          text: "Date : $date",
          width: 6,
          styles: const PosStyles(align: PosAlign.right)),
    ]));
    bytes.addAll(generator.row([
      PosColumn(text: "Cashier : $cashier", width: 6),
      PosColumn(
          text: "Time : $time",
          width: 6,
          styles: const PosStyles(align: PosAlign.right)),
    ]));
    bytes.addAll(generator.row([
      PosColumn(text: "Cus Name : $customerName", width: 6),
      PosColumn(
          text: "Mobile : $mobile",
          width: 6,
          styles: const PosStyles(align: PosAlign.right)),
    ]));
    bytes.addAll(generator.hr());
    bytes.addAll(generator.row([
      PosColumn(
        text: "S.No",
        width: 2,
        styles: const PosStyles(bold: true, align: PosAlign.left),
      ),
      PosColumn(
        text: "Items",
        width: 4,
        styles: const PosStyles(bold: true, align: PosAlign.center),
      ),
      PosColumn(
        text: "Qty",
        width: 2,
        styles: const PosStyles(bold: true, align: PosAlign.center),
      ),
      PosColumn(
        // text: "Unit",
        text: "Price",
        width: 2,
        styles: const PosStyles(bold: true, align: PosAlign.right),
      ),
      PosColumn(
        text: "Total",
        width: 2,
        styles: const PosStyles(bold: true, align: PosAlign.right),
      ),
    ]));
    bytes.addAll(generator.hr());
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
          text: item.name ?? '',
          width: 5,
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text: item.quantity.toString(),
          width: 2,
          styles: const PosStyles(align: PosAlign.center),
        ),
        PosColumn(
          text: item.unitPrice!.toStringAsFixed(2),
          width: 2,
          styles: const PosStyles(align: PosAlign.right),
        ),
        PosColumn(
          text: item.totalPrice!.toStringAsFixed(2),
          width: 2,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]));
    }
    bytes.addAll(generator.hr());
    bytes.addAll(generator.row([
      PosColumn(text: '', width: 3),
      PosColumn(
          text: 'SubTotal',
          width: 5,
          styles: const PosStyles(align: PosAlign.right, bold: true)),
      PosColumn(
        text: '\$ $total',
        width: 4,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
    ]));
    if (discount != "0.00") {
      bytes.addAll(generator.row([
        PosColumn(text: '', width: 3),
        PosColumn(
            text: 'Discount',
            width: 5,
            styles: const PosStyles(align: PosAlign.right, bold: true)),
        PosColumn(
          text: '\$ $discount',
          width: 4,
          styles: const PosStyles(align: PosAlign.right, bold: true),
        ),
      ]));
    }
    bytes.addAll(generator.hr());
    /*for (final item in history) {
      String key = item.keys.toString().replaceAll('(', '').replaceAll(')', '');
      final match = paymentList.where((element) => element.key == key).toList();
      final displayKey =
          match.isNotEmpty ? match[0].type.toString() : key.toString();
      String value =
          item.values.toString().replaceAll('(', '').replaceAll(')', '');
      bytes.addAll(
        generator.row(
          [
            PosColumn(text: '', width: 3),
            PosColumn(
                // text: item.keys.toString(),
                text: displayKey,
                width: 5,
                styles: const PosStyles(align: PosAlign.right, bold: true)),
            PosColumn(
              // text: '\$ ${item.values.toString()}',
              text: '\$ ${double.parse(value).toStringAsFixed(2)}',
              width: 4,
              styles: const PosStyles(align: PosAlign.right, bold: true),
            ),
          ],
        ),
      );
    }*/
    for (final item in history) {
      String key = item.keys.toString().replaceAll('(', '').replaceAll(')', '');
      final match = paymentList.where((element) => element.key == key).toList();
      final displayKey =
          match.isNotEmpty ? match[0].type.toString() : key.toString();
      String value =
          item.values.toString().replaceAll('(', '').replaceAll(')', '');
      bytes.addAll(
        generator.row(
          [
            PosColumn(text: '', width: 3),
            PosColumn(
                // text: item.keys.toString(),
                text: displayKey,
                width: 5,
                styles: const PosStyles(align: PosAlign.right, bold: true)),
            PosColumn(
              // text: '\$ ${item.values.toString()}',
              text: '\$ ${double.parse(value).toStringAsFixed(2)}',
              width: 4,
              styles: const PosStyles(align: PosAlign.right, bold: true),
            ),
          ],
        ),
      );
    }
    bytes.addAll(generator.feed(2));
    bytes.addAll(generator.cut());

    return bytes;
  }

  Future<img.Image> loadLogoAsImage() async {
    final ByteData data = await rootBundle.load('assets/images/trans_logo.png');
    final Uint8List bytes = data.buffer.asUint8List();
    return img.decodeImage(bytes)!; // convert Uint8List -> image.Image
  }

  Future<List<int>> generateDailyClosingReport(
    Map<String, dynamic> json,
    String fromDate,
    String toDate,
  ) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    final List<int> bytes = [];

    final now = DateTime.now();
    final dateStr = DateFormat('dd/MM/yyyy').format(now);
    final timeStr = DateFormat('hh:mm a').format(now);

    bytes.addAll(generator.text(
      'DAILY CLOSING REPORT',
      styles: const PosStyles(
          align: PosAlign.center, bold: true, height: PosTextSize.size2),
      linesAfter: 1,
    ));

    bytes
        .addAll(generator.text('From Date  : $fromDate     To Date : $toDate'));
    bytes.addAll(
        generator.text('Printed on : $dateStr $timeStr', linesAfter: 1));

    bytes.addAll(generator.text('Start Bill : ${json['start_bill'] ?? "-"}'));
    bytes.addAll(generator.text('End Bill   : ${json['end_bill'] ?? "-"}'));
    bytes.addAll(generator.text('Total Bill : ${json['total_bill'] ?? "-"}',
        linesAfter: 1));
    bytes.addAll(generator.text('Total Sale : ${json['total_sale'] ?? "-"}'));
    bytes.addAll(generator.text('Net Sale   : ${json['net_sale'] ?? "-"}',
        linesAfter: 1));
    bytes.addAll(generator.text('---------- CATEGORY SUMMARY ----------',
        styles: const PosStyles(bold: true)));
    bytes.addAll(generator.text('Category         Qty Sold      Subtotal'));

    final List<dynamic> summary = json['summery'] ?? [];

    for (final item in summary) {
      final category = (item['category_name'] ?? '')
          .toString()
          .padRight(16)
          .substring(0, 16);
      final qty = (item['total_qty_sold'] ?? '').toString().padLeft(6);
      final subtotal = (item['subtotal'] ?? '').toString().padLeft(12);
      bytes.addAll(generator.text('$category$qty$subtotal'));
    }

    bytes.addAll(generator.text('-' * 40));
    bytes.addAll(generator.feed(2));
    bytes.addAll(generator.cut());

    return bytes;
  }

  Future<void> printDailyClosingReport(CustomReportModel finalReport) async {
    final now = DateTime.now();
    final dateStr = DateFormat('dd/MM/yyyy').format(now);
    final timeStr = DateFormat('hh:mm a').format(now);
    await imInPrinter.resetDevice();
    await imInPrinter.exitPrinterBuffer(false);
    await imInPrinter.setPrinterSpeed(10000);
    await imInPrinter.printAndLineFeed().then(
      (value) async {
        await imInPrinter.printColumnsText(
            cols: List.generate(
          350,
          (index) {
            return ColumnMaker(text: "-");
          },
        ));
        await imInPrinter.printText(
            "DAILY CLOSING REPORT\nFrom Date: $dateStr To Date: $dateStr\nPrinting Date: $dateStr $timeStr",
            style: IminTextStyle(fontSize: 28, align: IminPrintAlign.center));
        await imInPrinter.printText(
          "Start Bill : ${finalReport.startBill ?? '-'}\nEnd Bill : ${finalReport.endBill ?? '-'}\nTotal Bill : ${finalReport.totalBill ?? '-'}\n\nTransaction Summary",
          // style: IminTextStyle(align: IminPrintAlign.center),
        );
        await imInPrinter.printText(
          "Total Sale : ${finalReport.totalSale ?? '-'}\nNet Sale : ${finalReport.netSale ?? '-'}",
          // style: IminTextStyle(align: IminPrintAlign.center),
        );
        await imInPrinter.printText(
          "Payment Summary",
          // style: IminTextStyle(align: IminPrintAlign.center),
        );
        for (PSummery item in finalReport.pSummery ?? []) {
          await imInPrinter.printColumnsText(cols: [
            ColumnMaker(
              text: item.method ?? '',
              width: 250,
              fontSize: 23,
            ),
            ColumnMaker(
              text: item.amount ?? '',
              width: 110,
              fontSize: 23,
              align: IminPrintAlign.right,
            ),
          ]);
        }
        await imInPrinter.printText(
          "\nDepartment Summary",
          // style: IminTextStyle(align: IminPrintAlign.center),
        );
        await imInPrinter.printColumnsText(cols: [
          ColumnMaker(
            text: 'Category',
            width: 250,
            fontSize: 26,
            align: IminPrintAlign.center,
          ),
          ColumnMaker(
            text: 'Qty',
            width: 110,
            fontSize: 26,
            align: IminPrintAlign.center,
          ),
          ColumnMaker(
            text: 'Sub Total',
            width: 180,
            fontSize: 26,
            align: IminPrintAlign.center,
          )
        ]);
        await imInPrinter.printColumnsText(
            cols: List.generate(
          350,
          (index) {
            return ColumnMaker(text: "-");
          },
        ));
        for (DSummery item in finalReport.summery ?? []) {
          await imInPrinter.printColumnsText(cols: [
            ColumnMaker(
              text: item.categoryName ?? '',
              width: 250,
              fontSize: 23,
            ),
            ColumnMaker(
              text: item.totalQtySold ?? '',
              width: 110,
              fontSize: 23,
              align: IminPrintAlign.center,
            ),
            ColumnMaker(
              text: item.subtotal ?? '',
              width: 180,
              fontSize: 23,
              align: IminPrintAlign.center,
            ),
          ]);
        }
        await imInPrinter.printColumnsText(
            cols: List.generate(
          350,
          (index) {
            return ColumnMaker(text: "-");
          },
        ));
      },
    );
    await imInPrinter.commitPrinterBuffer().then(
      (value) async {
        await imInPrinter.partialCut();
      },
    ).whenComplete(
      () async {
        await imInPrinter.resetDevice();
      },
    );
  }

  Future<void> voidCartProduct() async {
    String? id;
    if (selectedCart == null) {
      id = model!.cartListModel.productList!.isNotEmpty
          ? model!.cartListModel.productList!.last.id ?? "0"
          : "0";
    } else {
      id = model!.cartListModel.productList!.length >= 8
          ? model!.cartListModel.productList!.reversed
                  .toList()[selectedCart!]
                  .id ??
              "0"
          : model!.cartListModel.productList![selectedCart!].id ?? "0";
    }
    await model!.deleteProduct(index: id).then(
      (value) {
        setState(() {
          selectedCart = null;
        });
        setState(() {
          if (model!.cartListModel.productList!.isEmpty) {
            selectedDiscount = "";
            paymentMethod = [];
            isHold = false;
          }
        });
      },
    );
  }

  Future<void> onVoidCartReturn(List<Map<String, dynamic>> returnPay) async {
    Navigator.of(context).pop();
    Map<String, dynamic> postData = {
      "is_enabled_stock": 1, // default
      "location_id": 1, // default
      "contact_id": 1, // default
      "price_group": 0, // default
      "sell_price_tax": "includes", // default
      "products": getProductList(),
      "advance_balance": 0.0000, // default
      "payment": paymentMethod,
      "change_return": 0.000, // default
      'return_payment': returnPay,
      "is_suspend": 1,
      "recur_interval_type": "days", // default
      "final_total": model!.calculation.grandTotal!.toStringAsFixed(2),
      "is_credit_sale": 0, // default
      "discount_type": selectedDiscount != null && selectedDiscount != ""
          ? selectedDiscount == "% Discount"
              ? "Discount"
              : "Percentage"
          : "",
      "discount_amount": selectedDiscount != null && selectedDiscount != ""
          ? model!.calculation.discountAmount ?? 0.0
          : 0.0,
      "rp_redeemed": 0, // default
      "rp_redeemed_amount": 0, // default
      "tax_rate_id": 1, // default
      "tax_calculation_amount": 5.000,
      "shipping_charges": 0.000, // default
      "discount_type_modal": selectedDiscount != null && selectedDiscount != ""
          ? selectedDiscount
          : "",
      "discount_amount_modal": 0.000,
      "order_tax_modal": 1, // default
      "shipping_charges_modal": 0, // default
      "status": "final" // default
    };
    await model!
        .voidOrder(postData,
            context: context, keyLoader: keyLoader, id: holdId.toString())
        .then((value) {
      if (value) {
        afterUpdate();
      }
    });
    sendMsgToSubScreen(method: "list", data: model!.cartListModel.toJson());
    sendMsgToSubScreen(
        method: "pay",
        data: {"payment": [], "discount_type": selectedDiscount});
  }

  afterUpdate() {
    CustomDialogBox().getCustomBox(
        context: context,
        message: "Are you want to load in cart ?",
        onDone: () async {
          setState(() {
            isRecall = false;
            typeValue = "";
            model!.cartListModel.billNo = "";
            model!.cartListModel.cashPaid = "0.0";
            model!.cartListModel.balance = "0.0";
            model!.calculation.grandTotal = 0.0;
            model!.calculation.discountAmount = 0.0;
            selectedDiscount = "";
            paymentMethod = [];
            disCount = model!.calculation.discountAmount.toString();
          });
          Navigator.of(context).pop();
        },
        onCancel: () {
          Navigator.of(context).pop();
          setState(() {
            isRecall = false;
            typeValue = "";
            model!.cartListModel.productList!.clear();
            isHold = false;
            model!.cartListModel.billNo = "";
            model!.cartListModel.cashPaid = "0.0";
            model!.cartListModel.balance = "0.0";
            model!.calculation.grandTotal = 0.0;
            model!.calculation.discountAmount = 0.0;
            selectedDiscount = "";
            paymentMethod = [];
            disCount = "";
          });
        });
  }

  Future<void> clearPrefsExcept(String keyToKeep) async {
    final prefs = spEngine!.prefs; // or however you get SharedPreferences
    final keys = prefs!.getKeys().toList(); // get all keys

    for (var key in keys) {
      if (key != keyToKeep) {
        await prefs.remove(key); // remove everything except keyToKeep
      }
    }
  }
}
