import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gmart/Constant/app_color.dart';
import 'package:gmart/Constant/app_strings.dart';
import 'package:gmart/Core/application_base.dart';
import 'package:gmart/UI/Dashboard/Model/cart_list_model.dart';
import 'package:gmart/UI/Dashboard/ViewModel/dashboard_view_model.dart';
import 'package:gmart/UI/Splash/Model/cash_checking_response_model.dart';
import 'package:imin_printer/imin_printer.dart';
import 'package:imin_vice_screen/imin_vice_screen.dart';
import 'package:intl/intl.dart';
import 'package:image/image.dart' as img;

class PaymentFinishWidget extends StatefulWidget {
  final String url;
  final Map<String, dynamic> postData;
  final double changeReturn;
  final List<Map<String, dynamic>> payMethod;
  final Function() onDone;
  final List printers;
  final double? total;
  final List<ProductList>? productList;

  const PaymentFinishWidget(
      {super.key,
      required this.url,
      required this.postData,
      required this.changeReturn,
      required this.payMethod,
      required this.onDone,
      required this.printers,
      required this.total,
      required this.productList});

  @override
  State<PaymentFinishWidget> createState() => _PaymentFinishWidgetState();
}

class _PaymentFinishWidgetState extends State<PaymentFinishWidget> {
  IminPrinter imInPrinter = IminPrinter();
  DashboardViewModel? model;
  List<Map<String, String>> payType = [];
  SharedPreferences? preferences;
  List<Payment> paymentList = [];
  IminViceScreen imInViceScreenPlugin = IminViceScreen();

  @override
  void initState() {
    preferences = spEngine!.prefs;
    String? permittedList = preferences!.getString(AppStrings.paymentList);
    if (permittedList != null) {
      List<dynamic> decodedList = jsonDecode(permittedList);
      List<Payment> mainList =
          decodedList.map((e) => Payment.fromJson(e)).toList();
      setState(() {
        paymentList = mainList;
      });
    }
    initPrinter();
    super.initState();
  }

  Future<void> sendMsgToSubScreen({String? method, data}) async {
    final isMultipleScreen =
        await imInViceScreenPlugin.isSupportMultipleScreen();
    if (isMultipleScreen != null && isMultipleScreen) {
      imInViceScreenPlugin
          .sendMsgToViceScreen(method!, params: {"data": data!});
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<DashboardViewModel>(
      prepareModel: (model) {
        this.model = model;
        model.orderUpdate(url: widget.url, postData: widget.postData).then(
          (value) {
            // widget.onDone();
            sendMsgToSubScreen(method: "list", data: []);
            sendMsgToSubScreen(
                method: "pay", data: {"payment": [], "discount_type": 0.00});
          },
        );
      },
      builder: (context, model, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/images/logo-remove.png",
                scale: 1.5,
              ),
              const SizedBox(
                height: 15.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    model.state == ViewState.innerActive
                        ? "assets/images/order_compeleted.png"
                        : "assets/images/order_processing.png",
                    height: 50.0,
                    width: 50.0,
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Text(model.textUpdate ?? ""),
                ],
              ),
              const SizedBox(
                height: 15.0,
              ),
              Visibility(
                visible: model.state == ViewState.innerActive,
                child: Column(
                  children: [
                    Text(
                      "Payment Details",
                      style: TextStyle(
                          color: AppColor.blackColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 20.0),
                    ),
                    const SizedBox(
                      height: 3.0,
                    ),
                    completedDetails(
                        title: "Bill No",
                        value: model.cartListModel.billNo ?? ""),
                    const SizedBox(
                      height: 3.0,
                    ),
                    completedDetails(
                        title: "Date",
                        value: getDataFormat(
                            date: model.lastPurchase ?? "", type: "date")),
                    const SizedBox(
                      height: 3.0,
                    ),
                    completedDetails(
                      title: "Time",
                      value: getDataFormat(
                          date: model.lastPurchase ?? "", type: "time"),
                    ),
                    const SizedBox(
                      height: 3.0,
                    ),
                    const Divider(),
                    Column(children: getAmt()),
                    const SizedBox(
                      height: 3.0,
                    ),
                    Visibility(
                      visible: widget.changeReturn.toStringAsFixed(2) != "0.00",
                      child: completedDetails(
                          title: "Change Return",
                          value:
                              "S\$ ${widget.changeReturn.toStringAsFixed(2)}"),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Total Amount"),
                        Text(
                          "S \$ ${widget.total!.toStringAsFixed(2)}",
                          style: TextStyle(
                              color: AppColor.blackColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 22.0),
                        ),
                      ],
                    ),
                    /*Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkResponse(
                          radius: 5.0,
                          onTap: () {
                            */
                    /* Map<String, double> grouped = {};
                            for (var payment in widget.payMethod) {
                              String method = payment['method'] ?? "";
                              String amount = payment["amount"] ?? "0.00";
                              grouped[method] =
                                  (grouped[method] ?? 0) + double.parse(amount);
                            }
                            // Add change return if available
                            double changeReturn = widget.changeReturn ??
                                0.00; // assuming it's a string
                            double changeAmount =
                                double.tryParse(changeReturn.toString()) ?? 0.00;
                            if (changeAmount > 0) {
                              grouped["Balance"] =
                                  (grouped["Balance"] ?? 0) + changeAmount;
                            }
                            usbPrint(
                                deviceId: "1",
                                gTotal: widget.total!.toStringAsFixed(2),
                                products: widget.productList ?? [],
                                receipt: model.cartListModel.billNo ?? "",
                                time: getDataFormat(
                                    date: model.lastPurchase ?? "", type: "time"),
                                date:
                                    getDataFormat(date: model.lastPurchase ?? ""),
                                discount: widget.postData["discount_amount"]
                                    .toStringAsFixed(2),
                                payHistory: grouped.entries
                                    .map((e) => {e.key: e.value})
                                    .toList());*/
                    /*
                            if (widget.printers.isNotEmpty) {
                              Map<String, double> grouped = {};
                              for (var payment in widget.payMethod) {
                                String method = payment['method'] ?? "";
                                String amount = payment["amount"] ?? "0.00";
                                grouped[method] =
                                    (grouped[method] ?? 0) + double.parse(amount);
                              }
                              // Add change return if available
                              double changeReturn = widget.changeReturn ??
                                  0.00; // assuming it's a string
                              double changeAmount =
                                  double.tryParse(changeReturn.toString()) ??
                                      0.00;
                              if (changeAmount > 0) {
                                grouped["Balance"] =
                                    (grouped["Balance"] ?? 0) + changeAmount;
                              }
                              usbPrint(
                                  deviceId:
                                      widget.printers[0]['deviceId'].toString(),
                                  gTotal: widget.total!.toStringAsFixed(2),
                                  products: widget.productList ?? [],
                                  receipt: model.cartListModel.billNo ?? "",
                                  time: getDataFormat(
                                      date: model.lastPurchase ?? "",
                                      type: "time"),
                                  date: getDataFormat(
                                      date: model.lastPurchase ?? ""),
                                  discount: widget.postData["discount_amount"]
                                      .toStringAsFixed(2),
                                  payHistory: grouped.entries
                                      .map((e) => {e.key: e.value})
                                      .toList());
                            } else {
                              // i(total: model.calculation.grandTotal.toString(), products: model.productList);
                            }
                          },
                          child: Container(
                            width: 120.0,
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            decoration: BoxDecoration(
                              // color: Colors.redAccent,
                              border: Border.all(color: AppColor.primaryColor),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.local_print_shop_outlined,
                                  color: AppColor.primaryColor,
                                ),
                                const SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  "Print",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.0,
                                      color: AppColor.primaryColor),
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
                            widget.onDone();
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            width: 120.0,
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              // border: Border.all(color: AppColor.primaryColor),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.close,
                                  color: AppColor.whiteColor,
                                ),
                                const SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  "Close",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.0,
                                      color: AppColor.whiteColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )*/
                    const SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkResponse(
                          radius: 5.0,
                          onTap: () {
                            /* Map<String, double> grouped = {};
                                for (var payment in widget.payMethod) {
                                  String method = payment['method'] ?? "";
                                  String amount = payment["amount"] ?? "0.00";
                                  grouped[method] =
                                      (grouped[method] ?? 0) + double.parse(amount);
                                }
                                // Add change return if available
                                double changeReturn = widget.changeReturn ??
                                    0.00; // assuming it's a string
                                double changeAmount =
                                    double.tryParse(changeReturn.toString()) ?? 0.00;
                                if (changeAmount > 0) {
                                  grouped["Balance"] =
                                      (grouped["Balance"] ?? 0) + changeAmount;
                                }
                                usbPrint(
                                    deviceId: "1",
                                    gTotal: widget.total!.toStringAsFixed(2),
                                    products: widget.productList ?? [],
                                    receipt: model.cartListModel.billNo ?? "",
                                    time: getDataFormat(
                                        date: model.lastPurchase ?? "", type: "time"),
                                    date:
                                        getDataFormat(date: model.lastPurchase ?? ""),
                                    discount: widget.postData["discount_amount"]
                                        .toStringAsFixed(2),
                                    payHistory: grouped.entries
                                        .map((e) => {e.key: e.value})
                                        .toList());*/
                            if (widget.printers.isNotEmpty) {
                              Map<String, double> grouped = {};
                              for (var payment in widget.payMethod) {
                                String method = payment['method'] ?? "";
                                String amount = payment["amount"].toString();
                                grouped[method] = (grouped[method] ?? 0) +
                                    double.parse(amount);
                              }
                              // Add change return if available
                              double changeReturn = widget.changeReturn ??
                                  0.00; // assuming it's a string
                              double changeAmount =
                                  double.tryParse(changeReturn.toString()) ??
                                      0.00;
                              if (changeAmount > 0) {
                                grouped["Balance"] =
                                    (grouped["Balance"] ?? 0) + changeAmount;
                              }
                              usbPrint(
                                  deviceId:
                                      widget.printers[0]['deviceId'].toString(),
                                  gTotal: widget.total!.toStringAsFixed(2),
                                  products: widget.productList ?? [],
                                  receipt: model.cartListModel.billNo ?? "",
                                  time: getDataFormat(
                                      date: model.lastPurchase ?? "",
                                      type: "time"),
                                  date: getDataFormat(
                                      date: model.lastPurchase ?? ""),
                                  discount: widget.postData["discount_amount"]
                                      .toStringAsFixed(2),
                                  payHistory: grouped.entries
                                      .map((e) => {e.key: e.value})
                                      .toList());
                            } else {
                              // i(total: model.calculation.grandTotal.toString(), products: model.productList);
                            }
                          },
                          child: Container(
                            width: 120.0,
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            decoration: BoxDecoration(
                              // color: Colors.redAccent,
                              border: Border.all(color: AppColor.primaryColor),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.local_print_shop_outlined,
                                  color: AppColor.primaryColor,
                                ),
                                const SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  "Print",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.0,
                                      color: AppColor.primaryColor),
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
                            widget.onDone();
                            // Navigator.of(context).pop();
                          },
                          child: Container(
                            width: 120.0,
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              // border: Border.all(color: AppColor.primaryColor),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.close,
                                  color: AppColor.whiteColor,
                                ),
                                const SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  "Close",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.0,
                                      color: AppColor.whiteColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: model.state == ViewState.innerInActive,
                // visible: false,
                child: const SizedBox(
                  height: 30.0,
                  width: 30.0,
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          ),
        );
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

  List<Widget> getAmt() {
    Map<String, double> grouped = {};

    for (var payment in widget.payMethod) {
      String method = payment['method'] ?? "";
      String amount = payment["amount"] ?? "0.00";
      grouped[method] = (grouped[method] ?? 0) + double.parse(amount);
    }

    return grouped.entries.map((e) {
      final match =
          paymentList.where((element) => element.key == e.key).toList();
      final displayKey = match.isNotEmpty ? match[0].type : e.key;

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            displayKey.toString(),
            style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
          ),
          Text(
            "S\$ ${e.value.toStringAsFixed(2)}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColor.blackColor,
              fontWeight: FontWeight.w600,
              fontSize: 18.0,
            ),
          ),
        ],
      );
    }).toList(); // important to convert Iterable to List
  }

  Widget completedDetails({required String title, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
        ),
        const SizedBox(
          width: 15.0,
        ),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: AppColor.blackColor,
              fontWeight: FontWeight.w600,
              fontSize: 18.0),
        )
      ],
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
        cashier: preferences!.getString(AppStrings.userName) ?? "",
        date: date,
        receiptNo: receipt,
        time: time,
        productList: products,
        history: payHistory,
        discount: discount);
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

  Future<List<int>> printReceiptAsBytes(
      {required String total,
      required String time,
      required String cashier,
      required String date,
      required String receiptNo,
      required List<ProductList> productList,
      required List<Map<String, double>> history,
      required String discount}) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    final List<int> bytes = [];
    bytes.addAll(generator.reset());
    final img.Image logo = await loadLogoAsImage();
    final img.Image resized =
        img.copyResize(logo, width: 560); // slightly under 576
    final img.Image dithered = threshold(resized, 128);
    bytes.addAll(generator.image(dithered, align: PosAlign.center));
    bytes.addAll(generator.text(
      preferences!.getString(AppStrings.selectedAddress) ?? "",
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
    bytes.addAll(generator.hr());
    bytes.addAll(generator.row([
      PosColumn(
        text: "S.No",
        width: 2,
        styles: const PosStyles(bold: true, align: PosAlign.center),
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
        text: "Unit",
        width: 2,
        styles: const PosStyles(bold: true, align: PosAlign.center),
      ),
      PosColumn(
        text: "Total",
        width: 2,
        styles: const PosStyles(bold: true, align: PosAlign.center),
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
    if (discount == "0.00") {
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

  Future<void> initPrinter() async {
    await imInPrinter.initPrinter();
    await imInPrinter.exitPrinterBuffer(false);
  }

  Future<img.Image> loadLogoAsImage() async {
    final ByteData data = await rootBundle.load('assets/images/trans_logo.png');
    final Uint8List bytes = data.buffer.asUint8List();
    return img.decodeImage(bytes)!; // convert Uint8List -> image.Image
  }

  /*printReceipt(
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
            "\nAddress\n${preferences!.getString(AppStrings.selectedAddress) ?? ""}",
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
  }*/

  Future<Uint8List> getImage() async {
    ByteData byteData = await rootBundle.load("assets/images/logo-remove.png");
    return byteData.buffer.asUint8List();
  }
}
