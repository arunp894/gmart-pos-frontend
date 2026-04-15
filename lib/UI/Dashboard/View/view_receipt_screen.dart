import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gmart/UI/Dashboard/ViewModel/local_dashboard_view_model.dart';
import 'package:image/image.dart' as img;
import 'package:gmart/Constant/app_color.dart';
import 'package:gmart/Constant/app_strings.dart';
import 'package:gmart/Core/application_base.dart';
import 'package:gmart/UI/Dashboard/Model/cart_list_model.dart';
import 'package:gmart/UI/Dashboard/Model/recall_hold_order_details_response_model.dart';
import 'package:gmart/UI/Dashboard/Model/recall_hold_order_response_model.dart';
import 'package:gmart/UI/Dashboard/ViewModel/dashboard_view_model.dart';
import 'package:gmart/UI/Login/Model/login_response_model.dart';
import 'package:imin_printer/column_maker.dart';
import 'package:imin_printer/enums.dart';
import 'package:imin_printer/imin_printer.dart';
import 'package:imin_printer/imin_style.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data';

class ViewReceiptScreen extends StatefulWidget {
  final List<Transactions> receipts;
  final List printers;
  final LocalDashboardViewModel? model;
  final Function(Transactions receipt) loadCart;

  const ViewReceiptScreen(
      {super.key,
      required this.receipts,
      required this.printers,
      this.model,
      required this.loadCart});

  @override
  State<ViewReceiptScreen> createState() => _ViewReceiptScreenState();
}

class _ViewReceiptScreenState extends State<ViewReceiptScreen> {
  IminPrinter imInPrinter = IminPrinter();
  int? selectedItem;
  List<ProductList> receiptProduct = [];
  String total = "0.00";
  int selectedIndex = 0;
  SharedPreferences? prefs;
  List<Payment> paymentList = [];

  @override
  void initState() {
    initPrinter();
    addInit();
    super.initState();
  }

  void addInit() {
    prefs = spEngine!.prefs;
    setState(() {
      receiptProduct = mapSeller(widget.receipts[0].sellDetails);
      total = double.parse(receiptProduct
              .map((item) => item.totalPrice as double)
              .reduce((a, b) => a + b)
              .toStringAsFixed(2))
          .toString();
    });
    // debugPrint(widget.receipts[0].transactionDate ?? "");
    if (!mounted) return;
    prefs = spEngine!.prefs;
    String? permittedList = prefs?.getString(AppStrings.paymentList);
    if (permittedList != null) {
      List<dynamic> decodedList = jsonDecode(permittedList);
      List<Payment> mainList =
          decodedList.map((e) => Payment.fromJson(e)).toList();
      setState(() {
        paymentList = mainList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text("View Receipts"),
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.green),
      ),
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  decoration: const BoxDecoration(color: Colors.yellow),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("S.No"),
                      const Expanded(
                          child: Text(
                        "Bill Date",
                        textAlign: TextAlign.center,
                      )),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1,
                        child: const Text(
                          "Receipt No",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1,
                        child: const Text(
                          "Qty",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1,
                        child: const Text(
                          "T.Price",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      // const Text("T.Price"),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: widget.receipts.length,
                    itemBuilder: (context, index) {
                      return InkResponse(
                        radius: 5.0,
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                            receiptProduct =
                                mapSeller(widget.receipts[index].sellDetails);
                            total = double.parse(receiptProduct
                                    .map((item) => item.totalPrice as double)
                                    .reduce((a, b) => a + b)
                                    .toStringAsFixed(2))
                                .toString();
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2.0, horizontal: 0.0),
                          child: Container(
                            color: selectedIndex == index
                                ? Colors.blueAccent
                                : widget.receipts[index].isSuspend == "1"
                                    ? Colors.red
                                    : Colors.transparent,
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 15.0),
                            child: Row(
                              children: [
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.05,
                                    child: Text("${index + 1}")),
                                Expanded(
                                  child: Text(
                                    widget.receipts[index].transactionDate ??
                                        "",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                  child: Text(
                                    "${widget.receipts[index].invoiceNo ?? ""} ${widget.receipts[index].isSuspend == "1" ? "(Void)" : ""}",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                  child: Text(
                                    widget.receipts[index].sellDetails!.length
                                        .toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                  child: Text(
                                    double.parse(
                                            widget.receipts[index].finalTotal ??
                                                "")
                                        .toStringAsFixed(2),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
          Expanded(
              child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/logo-remove.png",
                        scale: 1.3,
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        prefs!.getString(AppStrings.selectedAddress) ?? "",
                        style: TextStyle(
                            color: AppColor.blackColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 15.0),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Receipt No: ${widget.receipts[selectedIndex].invoiceNo ?? ""}",
                            style: TextStyle(
                                color: AppColor.blackColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 15.0),
                          ),
                          Text(
                            "Date : ${getDataFormat(date: widget.receipts[selectedIndex].transactionDate ?? "")}",
                            style: TextStyle(
                                color: AppColor.blackColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 15.0),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Cashier : ${prefs!.getString(AppStrings.userName) ?? ""}",
                            style: TextStyle(
                                color: AppColor.blackColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 15.0),
                          ),
                          Text(
                            "Time : ${getDataFormat(date: widget.receipts[selectedIndex].transactionDate ?? "", type: "time")}",
                            style: TextStyle(
                                color: AppColor.blackColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 15.0),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Customer Name : ${widget.receipts[selectedIndex].contact!.name ?? ""}",
                            style: TextStyle(
                                color: AppColor.blackColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 15.0),
                          ),
                          Text(
                            "Phone : ${widget.receipts[selectedIndex].contact!.mobile ?? ""}",
                            style: TextStyle(
                                color: AppColor.blackColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 15.0),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Divider(
                        color: AppColor.blackColor,
                        thickness: 1.5,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.05,
                            child: Text(
                              "S.No",
                              // textAlign: TextAlign.center,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: AppColor.blackColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18.0),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "products".toUpperCase(),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: AppColor.blackColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18.0),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.08,
                            child: Text(
                              "U.Price (\$)",
                              // textAlign: TextAlign.center,
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  color: AppColor.blackColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18.0),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.05,
                            child: Text(
                              "Qty",
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  color: AppColor.blackColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18.0),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.08,
                            child: Text(
                              "T.Price (\$)",
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  color: AppColor.blackColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18.0),
                            ),
                          ),
                          // const Text("T.Price"),
                        ],
                      ),
                      Divider(
                        color: AppColor.blackColor,
                        // thickness: 1.5,
                      ),
                      Expanded(
                        child: (receiptProduct.isNotEmpty)
                            ? cartListWidget(receiptProduct)
                            : const Center(
                                child: Text("Receipt is not selected"),
                              ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.08,
                                  child: Text(
                                    "Sub total",
                                    style: TextStyle(
                                        color: AppColor.blackColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 22.0),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  ":",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      color: AppColor.blackColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 22.0),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.08,
                                  child: Text(
                                    "S\$ ${double.parse(total).toStringAsFixed(2)}",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        color: AppColor.blackColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18.0),
                                  ),
                                ),
                              ],
                            ),
                            Visibility(
                              visible: double.parse(widget
                                              .receipts[selectedIndex]
                                              .discountAmount ??
                                          "")
                                      .toStringAsFixed(2) !=
                                  "0.00",
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.08,
                                    child: Text(
                                      "Discount",
                                      style: TextStyle(
                                          color: AppColor.blackColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 22.0),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    ":",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        color: AppColor.blackColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 22.0),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.08,
                                    child: Text(
                                      "S\$ ${double.parse(widget.receipts[selectedIndex].discountAmount ?? "").toStringAsFixed(2)}",
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          color: AppColor.blackColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(),
                            getAmtWidget()
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Divider(
                        color: AppColor.blackColor,
                        // thickness: 1.5,
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Text(
                        "Thank you".toUpperCase(),
                        style: TextStyle(
                            color: AppColor.blackColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 22.0),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.03,
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: receiptProduct.isNotEmpty,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Visibility(
                      visible: widget.receipts[selectedIndex].isSuspend != "1",
                      child: InkResponse(
                        radius: 5.0,
                        onTap: () {
                          widget.loadCart(widget.receipts[selectedIndex]);
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          margin: const EdgeInsets.all(15.0),
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              color: AppColor.primaryColor,
                              shape: BoxShape.circle),
                          child: Icon(
                            Icons.file_download,
                            size: 30.0,
                            color: AppColor.whiteColor,
                          ),
                        ),
                      ),
                    ),
                    InkResponse(
                      radius: 5.0,
                      onTap: () {
                        Map<String, double> grouped = {};
                        for (var payment
                            in widget.receipts[selectedIndex].paymentLines ??
                                []) {
                          String method = payment.isReturn.toLowerCase() == "1"
                              ? "Balance"
                              : payment.method ?? "";
                          String amount = payment.amount ?? "0.00";
                          grouped[method] =
                              (grouped[method] ?? 0) + double.parse(amount);
                        }
                        if (widget.printers.isNotEmpty) {
                          usbPrint(
                            deviceId: widget.printers[0]['deviceId'].toString(),
                            gTotal: double.parse(total ?? "0.00")
                                .toStringAsFixed(2),
                            products: receiptProduct,
                            receipt:
                                widget.receipts[selectedIndex].invoiceNo ?? "",
                            time: getDataFormat(
                                date: widget.receipts[selectedIndex]
                                        .transactionDate ??
                                    "",
                                type: "time"),
                            date: getDataFormat(
                                date: widget.receipts[selectedIndex]
                                        .transactionDate ??
                                    ""),
                            discount: double.parse(widget
                                        .receipts[selectedIndex]
                                        .discountAmount ??
                                    "0.00")
                                .toStringAsFixed(2),
                            payHistory: grouped.entries
                                .map((e) => {e.key: e.value})
                                .toList(),
                            customerName:
                                widget.receipts[selectedIndex].contact!.name ??
                                    "",
                            customerPhone: widget
                                    .receipts[selectedIndex].contact!.mobile ??
                                "",
                          );
                        } else {
                          printReceipt(total: total, products: receiptProduct);
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.all(15.0),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            color: AppColor.primaryColor,
                            shape: BoxShape.circle),
                        child: Icon(
                          Icons.print_outlined,
                          size: 30.0,
                          color: AppColor.whiteColor,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ))
        ],
      ),
    );
  }

  Widget getAmtWidget() {
    Map<String, double> grouped = {};
    for (var payment in widget.receipts[selectedIndex].paymentLines ?? []) {
      String method = payment.isReturn.toLowerCase() == "1"
          ? "Balance"
          : payment.method ?? "";
      String amount = payment.amount ?? "0.00";
      grouped[method] = (grouped[method] ?? 0) + double.parse(amount);
    }

    return Column(
      children: grouped.entries.map((e) {
        final match =
            paymentList.where((element) => element.key == e.key).toList();
        final displayKey = match.isNotEmpty ? match[0].type : e.key;
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.08,
              child: Text(
                formatKey(displayKey ?? ""),
                textAlign: TextAlign.start,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: AppColor.blackColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 22.0),
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Text(
              ":",
              textAlign: TextAlign.end,
              style: TextStyle(
                  color: AppColor.blackColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 22.0),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.08,
              child: Text(
                "S\$ ${e.value.toStringAsFixed(2)}",
                // "1000.00",
                textAlign: TextAlign.end,
                style: TextStyle(
                    color: AppColor.blackColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 18.0),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  List<ProductList> mapSeller(List<SellDetails>? sellerOrder) {
    List<ProductList> list = [];
    for (var item in sellerOrder ?? []) {
      list.add(
        ProductList(
          id: item.productId.toString(),
          name: item.productName,
          unit: item.unit,
          productVariantId: item.variationId.toString(),
          quantity: double.parse(item.quantityOrdered ?? "0.00"),
          // quantity: NumberFormat("#.##").format(double.parse(item.quantityOrdered ?? "0.0")),
          unitPrice: double.parse(item.defaultSellPrice ?? '0.0'),
          totalPrice: double.parse(item.quantityOrdered ?? "0").toInt() *
              double.parse(item.defaultSellPrice ?? '0.0'),
        ),
      );
    }
    return list;
  }

  Future<void> usbPrint(
      {required String deviceId,
      required String gTotal,
      required String receipt,
      required String date,
      required String time,
      required List<ProductList> products,
      required List<Map<String, double>> payHistory,
      required String discount,
      required String customerName,
      required String customerPhone}) async {
    List<int> bytes = await printReceiptAsBytes(
        total: gTotal,
        cashier: prefs!.getString(AppStrings.userName) ?? "",
        date: date,
        receiptNo: receipt,
        time: time,
        productList: products,
        history: payHistory,
        discount: discount,
        customerName: customerName,
        mobile: customerPhone);
    if (bytes.isNotEmpty) {
      try {
        await widget.model!.requestUsbPermission(deviceId);
        final ok = await widget.model!.printData(deviceId, bytes);
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

  Widget cartListWidget(List<ProductList> receiptProduct) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: receiptProduct.length,
      itemBuilder: (context, index) {
        return cartWidget(receiptProduct[index], index);
      },
    );
  }

  Widget cartWidget(ProductList receiptProduct, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 0.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
        child: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.05,
              child: Text("${index + 1}",
                  // textAlign: TextAlign.center,
                  textAlign: TextAlign.start),
            ),
            Expanded(
              child: Text(
                receiptProduct.name ?? "",
                // "sjxhdsahldjkhb lkjasgb jkgfl jksdfgkj ;bf;k bhn;kalefnhlewafknkegjljnal1",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.08,
              child: Text(
                "${receiptProduct.unitPrice}",
                textAlign: TextAlign.end,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.05,
              child: Text(
                receiptProduct.quantity.toString(),
                textAlign: TextAlign.end,
              ),
            ),
            /* Padding(
              padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.07),
              child:
                  Text("${receiptProduct.unitPrice} (${receiptProduct.unit})",textAlign: TextAlign.center,),
            ),*/
            /* Padding(
              padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.08),
              child: Text(receiptProduct.quantity.toString()),
            ),*/
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.08,
              child: Text(
                receiptProduct.totalPrice!.toStringAsFixed(2),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ),
    );
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

  Future<List<int>> printReceiptAsBytes(
      {required String total,
      required String time,
      required String cashier,
      required String date,
      required String receiptNo,
      required List<ProductList> productList,
      required List<Map<String, double>> history,
      required String discount,
      required String customerName,
      required String mobile}) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    final List<int> bytes = [];
    bytes.addAll(generator.reset());
    bytes.addAll(generator.text(
      // "GMART",
      prefs!.getString(AppStrings.appName) ?? "",
      styles: const PosStyles(
        width: PosTextSize.size2,
        height: PosTextSize.size2,
        bold: true,
        align: PosAlign.center,
      ),
    ));
    bytes.addAll(generator.feed(2));
    bytes.addAll(generator.text(
      "${prefs!.getString(AppStrings.selectedAddress) ?? " "}",
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
    for (final item in history) {
      String key = item.keys.first;
      String value = item.values.toString();
      // Remove parentheses if present
      String keys = key.replaceAll('(', '').replaceAll(')', '');
      String values = value.replaceAll('(', '').replaceAll(')', '');
      final match =
          paymentList.where((element) => element.key == keys).toList();
      final displayKey =
          match.isNotEmpty ? match[0].type.toString() : key.toString();
      bytes.addAll(
        generator.row(
          [
            PosColumn(text: '', width: 3),
            PosColumn(
                text: displayKey,
                width: 5,
                styles: const PosStyles(align: PosAlign.right, bold: true)),
            PosColumn(
              // text: '\$ $value',
              text: '\$ ${double.parse(values).toStringAsFixed(2)}',
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

  Future<void> initPrinter() async {
    await imInPrinter.initPrinter();
    await imInPrinter.exitPrinterBuffer(false);
  }

  Future<img.Image> loadLogoAsImage() async {
    final ByteData data = await rootBundle.load('assets/images/trans_logo.png');
    final Uint8List bytes = data.buffer.asUint8List();
    return img.decodeImage(bytes)!; // convert Uint8List -> image.Image
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
          // await imInPrinter.printText("");
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

  Future<Uint8List> getImage() async {
    ByteData byteData = await rootBundle.load("assets/images/logo-remove.png");
    return byteData.buffer.asUint8List();
  }

  String formatKey(String key) {
    return key
        .split('_') // split by underscore
        .map((word) =>
            word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : "")
        .join(' ');
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
}
