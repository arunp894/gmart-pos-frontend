import 'package:flutter/services.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gmart/Constant/app_color.dart';
import 'package:gmart/Constant/app_strings.dart';
import 'package:gmart/Core/application_base.dart';
import 'package:gmart/UI/Dashboard/ViewModel/dashboard_view_model.dart';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'dart:typed_data';

class XyReportScreen extends StatefulWidget {
  final List printers;

  const XyReportScreen({super.key, required this.printers});

  @override
  State<XyReportScreen> createState() => _XyReportScreenState();
}

class _XyReportScreenState extends State<XyReportScreen> {
  DashboardViewModel? model;
  SharedPreferences? prefs;

  @override
  void initState() {
    prefs = spEngine!.prefs;
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
        if (model.state == ViewState.innerInActive) {
          return Scaffold(
            backgroundColor: AppColor.whiteColor,
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: Colors.grey.shade200,
            appBar: AppBar(
              elevation: 0.0,
              titleSpacing: 0.0,
              // toolbarHeight: 0.0,
              title: const Text(
                "Cashier Reports",
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700),
              ),
              systemOverlayStyle:
                  SystemUiOverlayStyle(statusBarColor: AppColor.primaryColor),
            ),
            body: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: Card(
                    margin:
                        const EdgeInsets.only(top: 15.0, left: 5.0, right: 5.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
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
                            "Daily Closing Report",
                            // textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18.0,
                                color: AppColor.blackColor,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Start Bill No"),
                                  Text(
                                    model.cashDetails!.firstBillNo ?? "",
                                    style: TextStyle(
                                        color: AppColor.blackColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18.0),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 3.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("End Bill No"),
                                  Text(
                                    model.cashDetails!.lastBillNo ?? "",
                                    style: TextStyle(
                                        color: AppColor.blackColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18.0),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 3.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Total Bills"),
                                  Text(
                                    "${model.cashDetails!.totalBills ?? 0}",
                                    style: TextStyle(
                                        color: AppColor.blackColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18.0),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              InkResponse(
                                radius: 5.0,
                                onTap: () {
                                  usbPrint(deviceId: "1".toString());
                                  if (widget.printers.isNotEmpty) {
                                    usbPrint(
                                        deviceId: widget.printers[0]['deviceId']
                                            .toString());
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 13.0, horizontal: 15.0),
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.print_outlined,
                                        color: AppColor.whiteColor,
                                      ),
                                      const SizedBox(
                                        width: 5.0,
                                      ),
                                      Text(
                                        "Print",
                                        style: TextStyle(
                                            color: AppColor.whiteColor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                            ],
                          ),
                        ),
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
                      mainAxisSize: MainAxisSize.min,
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
                            "Department Summary",
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
                                      fontSize: 18.0),
                                ),
                              ),
                              const SizedBox(
                                width: 15.0,
                              ),
                              Expanded(
                                child: Text(
                                  "Category",
                                  // textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: AppColor.blackColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18.0),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.04,
                                child: Text(
                                  "QTY",
                                  style: TextStyle(
                                      color: AppColor.blackColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18.0),
                                ),
                              ),
                              Text(
                                "Total amount",
                                style: TextStyle(
                                    color: AppColor.blackColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18.0),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: model
                                .cashDetails!.productDetailsByCategory!.length,
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
                                        // "125",
                                        model
                                                .cashDetails!
                                                .productDetailsByCategory![
                                                    index]
                                                .categoryName ??
                                            "",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15.0,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.06,
                                      // child: Text("1000000000.00",
                                      child: Text(
                                          double.parse(model
                                                      .cashDetails!
                                                      .productDetailsByCategory![
                                                          index]
                                                      .totalQuantity ??
                                                  "0.00")
                                              .toStringAsFixed(2),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.06,
                                      child: Text(
                                        "S\$ ${double.parse(model.cashDetails!.productDetailsByCategory![index].totalAmount ?? "0.00").toStringAsFixed(2)}",
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
                              // "Total Amount: S\$ ${model.cashDetails!.productDetailsByCategory!.map((e) => double.parse(e.totalAmount ?? "0.00")).reduce((a, b) => a + b).toStringAsFixed(2)}",
                              "Total Amount: S\$ ${model.cashDetails?.productDetailsByCategory?.fold<double>(
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
                            "Hourly Sales Summary",
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Hours",
                                style: TextStyle(
                                    color: AppColor.blackColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18.0),
                              ),
                              Text(
                                "Orders",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: AppColor.blackColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18.0),
                              ),
                              Text(
                                "Items",
                                style: TextStyle(
                                    color: AppColor.blackColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18.0),
                              ),
                              Text(
                                "Gross",
                                style: TextStyle(
                                    color: AppColor.blackColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18.0),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: model.cashDetails!.hourelySales!.length,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      // "125",
                                      model.cashDetails!.hourelySales![index]
                                              .range ??
                                          "",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.06,
                                      child: Text(
                                        // "100 PLUS",
                                        model.cashDetails!.hourelySales![index]
                                                .ordersCount ??
                                            "",
                                        maxLines: 1,
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(
                                      // width: MediaQuery.of(context).size.width*0.09,
                                      child: Text(
                                          double.parse(model
                                                      .cashDetails!
                                                      .hourelySales![index]
                                                      .itemsCount ??
                                                  "0.00")
                                              .toStringAsFixed(2),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.06,
                                      child: Text(
                                        "S\$ ${double.parse(model.cashDetails!.hourelySales![index].totalAmount ?? "0.00").toStringAsFixed(2)}",
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
                              // "Total Amount: S\$ ${model.cashDetails!.hourelySales!.map((e) => double.parse(e.totalAmount ?? "0.00")).reduce((a, b) => a + b).toStringAsFixed(2)}",
                            "Total Amount: S\$ ${model.cashDetails?.hourelySales?.fold<double>(
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
        }
      },
    );
  }

  Future<void> usbPrint({required String deviceId}) async {
    List<int> bytes = await printDetailsReceiptAsBytes();
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

  Future<List<int>> printDetailsReceiptAsBytes() async {
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
    bytes.addAll(generator.text(
      "\n${prefs!.getString(AppStrings.selectedAddress) ?? " "}",
      styles: const PosStyles(align: PosAlign.center),
    ));
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
    bytes.addAll(generator.feed(2));
    bytes.addAll(generator.cut());
    return bytes;
  }
}
