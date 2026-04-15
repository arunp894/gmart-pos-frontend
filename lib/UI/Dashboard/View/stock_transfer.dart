import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gmart/Constant/app_color.dart';
import 'package:gmart/Constant/app_strings.dart';
import 'package:gmart/Core/application_base.dart';
import 'package:gmart/UI/Dashboard/Model/product_list_reponse_model.dart';
import 'package:gmart/UI/Dashboard/Model/scanned_product_response_model.dart';
import 'package:gmart/UI/Dashboard/Model/transfer_product_model.dart';
import 'package:gmart/UI/Dashboard/View/selling_price_widget.dart';
import 'package:gmart/UI/Login/Model/login_response_model.dart';
import 'package:gmart/Utils/loading_dialog_box.dart';
import 'package:gmart/Utils/text_decorator.dart';
import 'package:intl/intl.dart';

class StockTransfer extends StatefulWidget {
  const StockTransfer({super.key});

  @override
  State<StockTransfer> createState() => _StockTransferState();
}

class _StockTransferState extends State<StockTransfer> {
  List<Locations> localLocation = [];
  SharedPreferences? pref;
  bool isKeyShow = true;
  TransferProductModel transferProductModel = TransferProductModel();
  int? selectedCart;
  final FocusNode _focusNode = FocusNode();
  final keyLoader = GlobalKey<State>();
  final scanKeyLoader = GlobalKey<State>();
  final formKey = GlobalKey<FormState>();
  String? typeValue = "";
  String scanValue = "";
  String finalScanned = "";
  bool isComplete = false;
  List<ScanProduct> scannedProduct = [];
  String selectedName = "";
  TextEditingController transferTo = TextEditingController();
  TextEditingController referNo = TextEditingController();
  int transferId = 0;

  @override
  void initState() {
    pref = spEngine!.prefs;
    isLoad();
    super.initState();
  }

  void isLoad() {
    pref = spEngine!.prefs;
    String? permittedList = pref?.getString(AppStrings.locationsList);
    if (permittedList != null) {
      List<dynamic> decodedList = jsonDecode(permittedList);
      List<Locations> mainList =
          decodedList.map((e) => Locations.fromJson(e)).toList();
      setState(() {
        localLocation = mainList
            .where((element) =>
                element.name != pref!.getString(AppStrings.selectedHub))
            .toList();
        transferProductModel.transfer = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: (value) {
        handleKeyEvent(
            value: value,
            typeValue: typeValue ?? "",
            context: context,
            keyLoader: keyLoader,
            onDone: () {
              setState(() {
                typeValue = "";
              });
            });
        _focusNode.requestFocus();
        setState(() {});
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Stock Transfer"),
        ),
        body: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Transfer To",
                        style: TextStyle(
                            color: AppColor.blackColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 18.0),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      DropdownButtonFormField<String>(
                        // value: null,
                        decoration: textDecorator(),
                        hint: const Text("Choose location..."),
                        // alignment: Alignment.center,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Transfer Location is required.";
                          } else {
                            return null;
                          }
                        },
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColor.blackColor,
                          size: 28,
                        ),
                        items: localLocation.isEmpty
                            ? []
                            : localLocation.asMap().entries.map(
                                (e) {
                                  return DropdownMenuItem<String>(
                                      value: e.value.name,
                                      child: Text(e.value.name ?? ""));
                                },
                              ).toList(),
                        // items: [],
                        onChanged: (value) async {
                          List<Locations> selected = localLocation
                              .where((element) => element.name == value)
                              .toList();
                          if (selected.isNotEmpty) {
                            setState(() {
                              transferId = selected[0].id ?? 0;
                            });
                          }
                        },
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      Text(
                        "Refer No",
                        style: TextStyle(
                            color: AppColor.blackColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 18.0),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      TextFormField(
                        onTap: () {
                          setState(() {
                            isKeyShow = false;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Refer no is required.";
                          } else {
                            return null;
                          }
                        },
                        onFieldSubmitted: (value) {
                          setState(() {
                            isKeyShow = true;
                          });
                        },
                        decoration: textDecorator(label: "Enter refer number"),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      InkResponse(
                        radius: 5.0,
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            bool result = await stockTransfer(
                                context: context, keyLoader: keyLoader);
                            if (result) {
                              Navigator.of(context).pop();
                            }
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          decoration:
                              BoxDecoration(color: AppColor.primaryColor),
                          child: Text(
                            "Transfer Stock",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: AppColor.whiteColor,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    border: Border(
                      bottom:
                          BorderSide(color: AppColor.blackColor, width: 2.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 50.0,
                        child: Text(
                          "S.NO",
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(
                        width: 18.0,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: const Text("PRODUCTS",
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis),
                      ),
                      const SizedBox(
                        width: 15.0,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.09,
                        child:
                            const Text("QTY", overflow: TextOverflow.ellipsis),
                      ),
                      const SizedBox(
                        width: 15.0,
                      ),
                      // const Spacer(),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.06,
                        child: const Text(
                          "U.PRICE",
                          textAlign: TextAlign.end,
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          "T.PRICE",
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: transferProductModel.transfer != null,
                  child: Expanded(
                    child: cartListWidget(),
                  ),
                ),
                Visibility(
                  visible: isKeyShow,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        typeValue!,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                      inputWidget(),
                    ],
                  ),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }

  Widget cartListWidget() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      reverse: transferProductModel.transfer!.length >= 8 ? true : false,
      itemCount: transferProductModel.transfer!.length,
      itemBuilder: (context, index) {
        return cartWidget(
            transferProductModel.transfer!.length >= 8
                ? transferProductModel.transfer!.reversed.toList()
                : transferProductModel.transfer!,
            index);
      },
    );
  }

  Widget cartWidget(
    List<Transfer> reversedItems,
    int index,
  ) {
    // bool isSelected = index == selectedCart;
    return InkResponse(
      radius: 5.0,
      onTap: () {
        setState(() {
          selectedCart = index;
          selectedName = reversedItems[index].name!;
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
                "${transferProductModel.transfer!.length >= 8 ? (transferProductModel.transfer!.length - 1 - index) + 1 : index + 1}",
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
                    child: InkResponse(
                      radius: 5.0,
                      onTap: () async {
                        if (reversedItems[index].quantity! != 1) {
                          await sellingUpdateProduct(
                              name: reversedItems[index].name!,
                              tag: "remove",
                              uPrice: double.parse(
                                  reversedItems[index].sellingPrice ?? "0"));
                          setState(() {});
                        } else {
                          Fluttertoast.showToast(
                              msg: "Minimum cart quantity is 1");
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
                    child: InkResponse(
                      radius: 5.0,
                      onTap: () async {
                        await sellingUpdateProduct(
                            name: reversedItems[index].name!,
                            tag: "add",
                            uPrice: double.parse(
                                reversedItems[index].sellingPrice ?? "0"));
                        setState(() {});
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
                reversedItems[index].sellingPrice!,
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

  Widget inputWidget() {
    return Column(
      children: [
        Row(
          children: [
            buttonWidget(
              title: "7",
              isNum: true,
              onTap: () {
                setState(() {
                  typeValue = "${typeValue}7";
                });
              },
            ),
            buttonWidget(
              title: "8",
              isNum: true,
              onTap: () {
                setState(() {
                  typeValue = "${typeValue}8";
                });
              },
            ),
            buttonWidget(
              title: "9",
              isNum: true,
              onTap: () {
                setState(() {
                  typeValue = "${typeValue}9";
                });
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
                setState(() {
                  typeValue = "${typeValue}4";
                });
              },
            ),
            buttonWidget(
              title: "5",
              isNum: true,
              onTap: () {
                setState(() {
                  typeValue = "${typeValue}5";
                });
              },
            ),
            buttonWidget(
              title: "6",
              isNum: true,
              onTap: () {
                setState(() {
                  typeValue = "${typeValue}6";
                });
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
                setState(() {
                  typeValue = "${typeValue}1";
                });
              },
            ),
            buttonWidget(
              title: "2",
              isNum: true,
              onTap: () {
                setState(() {
                  typeValue = "${typeValue}2";
                });
              },
            ),
            buttonWidget(
              title: "3",
              isNum: true,
              onTap: () {
                setState(() {
                  typeValue = "${typeValue}3";
                });
              },
            ),
          ],
        ),
        Row(
          children: [
            buttonWidget(
              title: "Clear",
              isNum: true,
              onTap: () {
                setState(() {
                  typeValue = "";
                });
              },
            ),
            buttonWidget(
              title: "0",
              isNum: true,
              onTap: () {
                setState(() {
                  typeValue = "${typeValue}0";
                });
              },
            ),
            buttonWidget(
              title: "X",
              isNum: true,
              onTap: () async {
                if (transferProductModel.transfer!.isNotEmpty) {
                  await updateXAction(
                      selectedName: selectedName,
                      index: selectedCart!,
                      quantity: int.parse(typeValue!));
                  setState(() {
                    typeValue = "";
                  });
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget buttonWidget(
      {required String title,
      Color? btnColor,
      Color? textColor,
      bool? isNum = false,
      Function()? onTap}) {
    return InkResponse(
      onTap: onTap,
      splashColor: Colors.grey,
      containedInkWell: true,
      hoverColor: Colors.grey,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          width: 100.0,
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
    );
  }

  updateXAction(
      {required int index, required int quantity, String? selectedName}) async {
    var dummy = transferProductModel.transfer!
        .where(
          (element) => element.name == selectedName,
        )
        .toList();
    if (dummy.isNotEmpty) {
      dummy[0].quantity = quantity;
      dummy[0].totalPrice = double.parse(
          (quantity * double.parse(dummy[0].sellingPrice ?? "0"))
              .toStringAsFixed(2));
    }
  }

  sellingUpdateProduct({
    required String name,
    required String? tag,
    required double uPrice,
  }) {
    List<Transfer> selectedList = transferProductModel.transfer!
        .where((element) => element.name == name)
        .toList();
    int index = transferProductModel.transfer!
        .indexWhere((product) => product.name == selectedList[0].name);
    if (selectedList.isNotEmpty) {
      if (tag! == "add") {
        transferProductModel.transfer![index].quantity =
            transferProductModel.transfer![index].quantity! + 1;
        transferProductModel.transfer![index].totalPrice = (double.parse(
                        (transferProductModel.transfer![index].quantity! *
                                double.parse(transferProductModel
                                        .transfer![index].sellingPrice ??
                                    "0"))
                            .toStringAsFixed(2)) *
                    20)
                .ceil() /
            20;
      } else {
        transferProductModel.transfer![index].quantity =
            transferProductModel.transfer![index].quantity! - 1;
        transferProductModel.transfer![index].totalPrice = (double.parse(
                        (transferProductModel.transfer![index].quantity! *
                                double.parse(transferProductModel
                                        .transfer![index].sellingPrice ??
                                    "0"))
                            .toStringAsFixed(2)) *
                    20)
                .ceil() /
            20;
      }
    }
  }

  void handleKeyEvent(
      {required KeyEvent value,
      required String typeValue,
      required BuildContext context,
      required GlobalKey keyLoader,
      required Function() onDone}) async {
    if (value is KeyDownEvent) {
      final key = value.logicalKey;

      if (key == LogicalKeyboardKey.enter) {
        debugPrint("✅ Final Barcode: $scanValue");
        finalScanned = scanValue;
        scanValue = ''; // Clear buffer

        final value = await getProductByScan(
          scannedCode: finalScanned,
          context: context,
          keyLoader: keyLoader,
        );

        if (value) {
          if (isComplete) {
            Navigator.of(context).pop();
          }
          if (scannedProduct.isNotEmpty) {
            if (scannedProduct.length > 1) {
              getScannedDialog(context, typeValue, onDone);
            } else {
              final scanned = scannedProduct[0];
              if (scanned.isTimeLimit != null) {
                dialogueEngine!.showDialogueBox(
                    msg: scanned.isTimeLimit!.timeDescription ?? "");
              } else {
                if (scanned.variationDouble != null &&
                    scanned.variationDouble!.isNotEmpty) {
                  List<VariationDouble> filter = scanned.variationDouble!
                      .where((element) => (element.barcode?.split('|') ?? [])
                          .contains(finalScanned))
                      .toList();
                  if (filter.isEmpty) {
                    getDoublePrice(
                        typeValue: typeValue,
                        onDone: onDone,
                        context: context,
                        unit: scanned.unit,
                        productName: scanned.name,
                        variationDouble: scanned.variationDouble);
                  } else {
                    if (filter.length != 1) {
                      getDoublePrice(
                          typeValue: typeValue,
                          onDone: onDone,
                          context: context,
                          unit: scanned.unit,
                          productName: scanned.name,
                          variationDouble: filter);
                    } else {
                      if (filter[0].defaultSellPrice == "0" ||
                          filter[0].defaultSellPrice == "0.00" ||
                          filter[0].defaultSellPrice == "0.0000" ||
                          filter[0].defaultSellPrice == "") {
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0)),
                              content: SellingPriceWidget(
                                onDone: (data) {
                                  if (typeValue.length <= 2) {
                                    final quantity = (typeValue.isNotEmpty)
                                        ? double.tryParse(typeValue) ?? 1
                                        : 1.00;
                                    final unitPrice = double.tryParse(
                                            data['selling_price'] ?? "0.0") ??
                                        0.0;
                                    updateList(
                                      name:
                                          "${scanned.name ?? ""} ${filter[0].name ?? ""}",
                                      quantity: quantity,
                                      sellingPrice:
                                          unitPrice.toStringAsFixed(2),
                                      productId:
                                          int.parse(filter[0].productId ?? "0"),
                                      variantId: int.parse(
                                          filter[0].variationId ?? "0"),
                                      unit: scanned.unit.toString(),
                                    );
                                  } else {
                                    Fluttertoast.showToast(
                                        msg:
                                            "You are not allow to purchase the product by this quantity.",
                                        backgroundColor: Colors.red);
                                  }
                                  Navigator.of(context).pop();
                                  scannedProduct = [];
                                  onDone();
                                },
                              ),
                            );
                          },
                        );
                      } else {
                        if (typeValue.length <= 2) {
                          final quantity = (typeValue.isNotEmpty)
                              ? double.tryParse(typeValue) ?? 1
                              : 1.00;
                          final unitPrice = double.tryParse(
                                  filter[0].defaultSellPrice ?? "0.0") ??
                              0.0;
                          updateList(
                            name: scanned.name ?? "",
                            quantity: quantity,
                            sellingPrice: unitPrice.toStringAsFixed(2),
                            productId: int.parse(scanned.productId.toString()),
                            variantId:
                                int.parse(scanned.variationId.toString()),
                            unit: scanned.unit.toString(),
                          );
                        } else {
                          Fluttertoast.showToast(
                              msg:
                                  "You are not allow to purchase the product by this quantity.",
                              backgroundColor: Colors.red);
                        }
                      }
                      scannedProduct = [];
                      onDone();
                    }
                  }
                } else {
                  if (scanned.sellingPrice == "0" ||
                      scanned.sellingPrice == "0.00" ||
                      scanned.sellingPrice == "0.0000" ||
                      scanned.sellingPrice == "") {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          content: SellingPriceWidget(
                            onDone: (data) {
                              if (typeValue.length <= 2) {
                                final quantity = (typeValue.isNotEmpty)
                                    ? double.tryParse(typeValue) ?? 1
                                    : 1.00;
                                final unitPrice = double.tryParse(
                                        data['selling_price'] ?? "0.0") ??
                                    0.0;
                                updateList(
                                  name: scanned.name ?? "",
                                  quantity: quantity,
                                  sellingPrice: unitPrice.toStringAsFixed(2),
                                  productId:
                                      int.parse(scanned.productId.toString()),
                                  variantId:
                                      int.parse(scanned.variationId.toString()),
                                  unit: scanned.unit.toString(),
                                );
                              } else {
                                Fluttertoast.showToast(
                                    msg:
                                        "You are not allow to purchase the product by this quantity.",
                                    backgroundColor: Colors.red);
                              }
                              Navigator.of(context).pop();
                              scannedProduct = [];
                              onDone();
                            },
                          ),
                        );
                      },
                    );
                  } else {
                    if (typeValue.length <= 2) {
                      final quantity = (typeValue.isNotEmpty)
                          ? double.tryParse(typeValue) ?? 1
                          : 1.00;
                      final unitPrice =
                          double.tryParse(scanned.sellingPrice.toString()) ??
                              0.0;
                      updateList(
                        name: scanned.name ?? "",
                        quantity: quantity,
                        sellingPrice: unitPrice.toStringAsFixed(2),
                        productId: int.parse(scanned.productId.toString()),
                        variantId: int.parse(scanned.variationId.toString()),
                        unit: scanned.unit.toString(),
                      );
                    } else {
                      Fluttertoast.showToast(
                          msg:
                              "You are not allow to purchase the product by this quantity.",
                          backgroundColor: Colors.red);
                    }
                  }
                  scannedProduct = [];
                  onDone();
                }
              }
            }
          } else {
            Fluttertoast.showToast(msg: "No products are available");
          }
        }
      } else {
        final char = value.character;
        if (char != null && char.isNotEmpty && char.codeUnitAt(0) >= 32) {
          scanValue += char;
        }
      }
    }
  }

  Future<bool> updateList({
    required String name,
    required double quantity,
    required String sellingPrice,
    required int productId,
    required int variantId,
    required String unit,
  }) async {
    bool result = false;
    List<Transfer> selectedList = transferProductModel.transfer!
        .where((element) => element.name == name)
        .toList();

    if (selectedList.isEmpty) {
      transferProductModel.transfer!.addAll([
        Transfer(
            productId: productId,
            variantId: variantId,
            name: name,
            quantity: int.parse(quantity.toStringAsFixed(2)),
            // totalPrice: (totalPrice * 20).ceil() / 20,
            unit: unit,
            sellingPrice: sellingPrice,
            enableStock: 1)
      ]);
      result = true;
    } else {
      int index = transferProductModel.transfer!
          .indexWhere((product) => product.name == selectedList[0].name);
      transferProductModel.transfer![index].quantity =
          transferProductModel.transfer![index].quantity! +
              int.parse(quantity.toStringAsFixed(2));
      transferProductModel.transfer![index].sellingPrice = sellingPrice;
      transferProductModel.transfer![index].unit = unit;
      transferProductModel.transfer![index].enableStock = 1;
      transferProductModel
          .transfer![index].totalPrice = double.parse((double.parse(
                  transferProductModel.transfer![index].sellingPrice ?? "0") *
              transferProductModel.transfer![index].quantity!)
          .toStringAsFixed(2));
      result = true;
    }
    return result;
  }

  void getScannedDialog(context, typeValue, Function() onDone) {
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
              Text(AppStrings.appName),
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
                  const SizedBox(height: 10),
                  const Text("Product Variants"),
                  const SizedBox(height: 10),
                  Expanded(
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 2.0,
                        mainAxisSpacing: 2.0,
                        mainAxisExtent: 50, // 👈 fixed height for each item
                      ),
                      itemCount: scannedProduct.length,
                      itemBuilder: (context, index) {
                        final product = scannedProduct[index];
                        final quantity =
                            double.tryParse(typeValue ?? "") ?? 1.00;
                        final price =
                            double.tryParse(product.sellingPrice ?? "0") ?? 0.0;

                        return InkWell(
                          onTap: () {
                            if (product.variationDouble != null &&
                                product.variationDouble!.isNotEmpty) {
                              Navigator.of(context).pop();
                              getDoublePrice(
                                  unit: product.unit.toString(),
                                  productName: product.name ?? "",
                                  variationDouble:
                                      product.variationDouble ?? [],
                                  typeValue: typeValue,
                                  onDone: onDone,
                                  context: context);
                            } else {
                              Navigator.of(context).pop();
                              if (product.sellingPrice == "0" ||
                                  product.sellingPrice == "0.00" ||
                                  product.sellingPrice == "0.0000" ||
                                  product.sellingPrice == "") {
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
                                          if (typeValue!.length <= 2) {
                                            updateList(
                                              name: product.name ?? "",
                                              quantity: quantity,
                                              sellingPrice: double.parse(
                                                      data['selling_price'] ??
                                                          "0.0")
                                                  .toStringAsFixed(2),
                                              productId: product.productId!,
                                              variantId: product.variationId!,
                                              unit: product.unit.toString(),
                                            );
                                          } else {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "You are not allow to purchase the product by this quantity.",
                                                backgroundColor: Colors.red);
                                          }
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    );
                                  },
                                );
                              } else {
                                if (typeValue!.length <= 2) {
                                  updateList(
                                    name: product.name ?? "",
                                    quantity: quantity,
                                    sellingPrice: price.toStringAsFixed(2),
                                    productId: product.productId!,
                                    variantId: product.variationId!,
                                    unit: product.unit.toString(),
                                  );
                                } else {
                                  Fluttertoast.showToast(
                                      msg:
                                          "You are not allow to purchase the product by this quantity.",
                                      backgroundColor: Colors.red);
                                }
                              }
                              scannedProduct = [];
                              onDone();
                            }
                          },
                          child: Container(
                            // Optional: not required when using mainAxisExtent
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            decoration: BoxDecoration(
                              color: Colors.purple.shade600,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Center(
                              child: Text(
                                "${product.name ?? ""}${product.variation != null && product.variation!.isNotEmpty ? " (${product.variation})" : ""}",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12.0),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
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

  Future<bool> getProductByScan(
      {required String scannedCode,
      required BuildContext context,
      required GlobalKey keyLoader}) async {
    bool result = false;
    pref = spEngine!.prefs;
    try {
      LoadingDialogBox().loading(context, keyLoader);
      await httpEngine!
          .get(
        url:
            "${applicationCore!.appProfile.baseUrl!}${AppStrings.getScannedProductUrl}?location_id=${pref!.getInt(AppStrings.businessLocations)}&term=$scannedCode&search_fields[0]=sku",
      )
          .then(
        (value) {
          ScannedProductResponseModel entity =
              ScannedProductResponseModel.fromJson(value.data);
          Navigator.of(keyLoader.currentContext!, rootNavigator: true).pop();
          scannedProduct = entity.product ?? [];
          result = true;
        },
      );
    } on DioException catch (e) {
      Navigator.of(keyLoader.currentContext!, rootNavigator: true).pop();
      dialogueEngine!.showDialogueBox(
          msg: e.response == null ? e.message : e.response!.data['message']);
    } catch (e) {
      Navigator.of(keyLoader.currentContext!, rootNavigator: true).pop();
      debugPrint(e.toString());
    }
    return result;
  }

  Future<bool> stockTransfer(
      {required BuildContext context, required GlobalKey keyLoader}) async {
    bool result = false;
    pref = spEngine!.prefs;
    try {
      LoadingDialogBox().loading(context, keyLoader);
      int fromId = localLocation
              .where(
                (element) =>
                    element.name == pref!.getString(AppStrings.selectedHub),
              )
              .toList()[0]
              .id ??
          0;
      double grandTotal = transferProductModel.transfer!.fold<double>(
        0.0,
        (sum, e) =>
            sum + (double.tryParse(e.totalPrice!.toStringAsFixed(2)) ?? 0.0),
      );
      Map<String, dynamic> postData = {
        "transaction_date": "2026-06-03 03:23 PM",
        "ref_no": referNo.text,
        "location_id": fromId,
        "status": "pending",
        "transfer_location_id": transferId,
        "final_total": grandTotal,
        "additional_notes": "",
        "products": transferProductModel.transfer ?? []
      };
      await httpEngine!
          .post(
        postData: postData,
        url:
            "${applicationCore!.appProfile.baseUrl!}${AppStrings.stockTransferUrl}",
      )
          .then(
        (value) {
          Navigator.of(keyLoader.currentContext!, rootNavigator: true).pop();
          result = true;
        },
      );
    } on DioException catch (e) {
      Navigator.of(keyLoader.currentContext!, rootNavigator: true).pop();
      dialogueEngine!.showDialogueBox(
          msg: e.response == null ? e.message : e.response!.data['message']);
    } catch (e) {
      Navigator.of(keyLoader.currentContext!, rootNavigator: true).pop();
      debugPrint(e.toString());
    }
    return result;
  }

  void getDoublePrice(
      {List<VariationDouble>? variationDouble,
      String? productName,
      String? unit,
      required String typeValue,
      required Function() onDone,
      required BuildContext context}) {
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
                        fontWeight: FontWeight.w600,
                        fontSize: 18.0),
                  ),
                  const SizedBox(
                    height: 15.0,
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
                            80.0, // 🔧 Optional fixed height for each card
                      ),
                      itemCount: variationDouble!.length,
                      itemBuilder: (context, index) {
                        final e = variationDouble[index];
                        return InkResponse(
                          onTap: () async {
                            Navigator.of(context).pop();
                            if (e.defaultSellPrice == "0" ||
                                e.defaultSellPrice == "0.00" ||
                                e.defaultSellPrice == "0.0000" ||
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
                                        if (typeValue.isNotEmpty) {
                                          if (typeValue.length <= 2) {
                                            final quantity =
                                                double.tryParse(typeValue) ??
                                                    1.0;
                                            updateList(
                                              name:
                                                  "$productName ${variationDouble[index].id == null || variationDouble[index].id == 0 ? "" : variationDouble[index].name ?? ""}",
                                              quantity: quantity,
                                              sellingPrice: double.parse(
                                                      data['selling_price'] ??
                                                          "0.0")
                                                  .toStringAsFixed(2),
                                              productId: int.parse(
                                                  variationDouble[index]
                                                          .productId ??
                                                      "0"),
                                              variantId: int.parse(
                                                  variationDouble[index]
                                                          .variationId ??
                                                      "0"),
                                              unit:
                                                  variationDouble[index].unit ??
                                                      "",
                                            );
                                          } else {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "You are not allow to purchase the product by this quantity.",
                                                backgroundColor: Colors.red);
                                          }
                                          scannedProduct = [];
                                          onDone();
                                        } else {
                                          updateList(
                                            name:
                                                "$productName ${variationDouble[index].id == null || variationDouble[index].id == 0 ? "" : variationDouble[index].name ?? ""}",
                                            quantity: 1,
                                            sellingPrice: double.parse(
                                                    data['selling_price'] ??
                                                        "0.0")
                                                .toStringAsFixed(2),
                                            productId: int.parse(
                                                variationDouble[index]
                                                        .productId ??
                                                    "0"),
                                            variantId: int.parse(
                                                variationDouble[index]
                                                        .variationId ??
                                                    "0"),
                                            unit: variationDouble[index].unit ??
                                                "",
                                          );
                                          scannedProduct = [];
                                          onDone();
                                        }
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  );
                                },
                              );
                            } else {
                              if (typeValue.isNotEmpty) {
                                if (typeValue.length <= 2) {
                                  final quantity =
                                      double.tryParse(typeValue) ?? 1.00;
                                  updateList(
                                    name:
                                        "$productName ${variationDouble[index].id == null || variationDouble[index].id == 0 ? "" : variationDouble[index].name ?? ""}",
                                    quantity: quantity,
                                    sellingPrice: double.parse(
                                            variationDouble[index]
                                                    .defaultSellPrice ??
                                                "0.00")
                                        .toStringAsFixed(2),
                                    productId: int.parse(
                                        variationDouble[index].productId ??
                                            "0"),
                                    variantId: int.parse(
                                        variationDouble[index].variationId ??
                                            "0"),
                                    unit: variationDouble[index].unit ?? "",
                                  );
                                } else {
                                  Fluttertoast.showToast(
                                      msg:
                                          "You are not allow to purchase the product by this quantity.",
                                      backgroundColor: Colors.red);
                                }
                                scannedProduct = [];
                                onDone();
                              } else {
                                updateList(
                                  name:
                                      "$productName ${variationDouble[index].id == null || variationDouble[index].id == 0 ? "" : variationDouble[index].name ?? ""}",
                                  quantity: 1,
                                  sellingPrice: double.parse(
                                          variationDouble[index]
                                                  .defaultSellPrice ??
                                              "0.00")
                                      .toStringAsFixed(2),
                                  productId: int.parse(
                                    variationDouble[index].productId ?? "0",
                                  ),
                                  variantId: int.parse(
                                      variationDouble[index].variationId ??
                                          "0"),
                                  unit: variationDouble[index].unit ?? "",
                                );
                                scannedProduct = [];
                                onDone();
                              }
                            }
                          },
                          child: Container(
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
}
