import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:gmart/Constant/app_color.dart';
import 'package:gmart/Constant/app_strings.dart';
import 'package:gmart/Core/application_base.dart';
import 'package:gmart/UI/Splash/Model/cash_checking_response_model.dart';
import 'package:gmart/Utils/text_decorator.dart';
import 'package:imin_vice_screen/imin_vice_screen.dart';

class PaymentWidget extends StatefulWidget {
  final int cartItem;
  final double total;
  final void Function(dynamic payMethod, dynamic change) onPayDone;
  final String disCount;
  final Future<void> Function() cashOpen;

  const PaymentWidget(
      {super.key,
      required this.cartItem,
      required this.total,
      required this.onPayDone,
      required this.disCount,
      required this.cashOpen});

  @override
  State<PaymentWidget> createState() => _PaymentWidgetState();
}

class _PaymentWidgetState extends State<PaymentWidget> {
  SharedPreferences? preferences;
  List<Payment> paymentList = [];
  TextEditingController amtCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<Map<String, String>> payType = [];
  double totalPaid = 0.00;
  IminViceScreen imInViceScreenPlugin = IminViceScreen();
  ScrollController categoryScroll = ScrollController();
  bool isFinish = false;

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            ),
          ),
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Payment",
                style: TextStyle(
                    color: AppColor.whiteColor,
                    fontSize: 22.0,
                    fontWeight: FontWeight.w700),
              ),
              InkResponse(
                radius: 5.0,
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                      color: Colors.red, shape: BoxShape.circle),
                  child: Icon(
                    Icons.clear,
                    size: 22.0,
                    color: AppColor.whiteColor,
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
          child: Column(
            children: [
              /*Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Form(
                          // key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 150.0,
                                child: TextFormField(
                                  readOnly: true,
                                  controller: amtCtrl,
                                  maxLength: 3,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Amount is required.";
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d*\.?\d{0,2}')),
                                  ],
                                  decoration: textDecorator(
                                    label: "Enter Amount",
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              Row(
                                children: [
                                  buttonWidget(
                                    width: 117.0,
                                    title: "\$ 5",
                                    onTap: () {
                                      cashUpdate(amt: "5");
                                    },
                                  ),
                                  buttonWidget(
                                    width: 95.0,
                                    title: "\$ 10",
                                    onTap: () {
                                      cashUpdate(amt: "10");
                                    },
                                  ),
                                  buttonWidget(
                                    width: 95.0,
                                    title: "\$ 50",
                                    onTap: () {
                                      cashUpdate(amt: "50");
                                    },
                                  ),
                                  buttonWidget(
                                    width: 95.0,
                                    title: "\$ 100",
                                    onTap: () {
                                      cashUpdate(amt: "100");
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                buttonWidget(
                                  title: "7",
                                  onTap: () {
                                    if (amtCtrl.text.length < 5) {
                                      amtCtrl.text = "${amtCtrl.text}7";
                                    }
                                  },
                                ),
                                buttonWidget(
                                  title: "8",
                                  onTap: () {
                                    if (amtCtrl.text.length < 5) {
                                      amtCtrl.text = "${amtCtrl.text}8";
                                    }
                                  },
                                ),
                                buttonWidget(
                                  title: "9",
                                  onTap: () {
                                    if (amtCtrl.text.length < 5) {
                                      amtCtrl.text = "${amtCtrl.text}9";
                                    }
                                  },
                                )
                              ],
                            ),
                            Row(
                              children: [
                                buttonWidget(
                                  title: "4",
                                  onTap: () {
                                    if (amtCtrl.text.length < 5) {
                                      amtCtrl.text = "${amtCtrl.text}4";
                                    }
                                  },
                                ),
                                buttonWidget(
                                  title: "5",
                                  onTap: () {
                                    if (amtCtrl.text.length < 5) {
                                      amtCtrl.text = "${amtCtrl.text}5";
                                    }
                                  },
                                ),
                                buttonWidget(
                                  title: "6",
                                  onTap: () {
                                    if (amtCtrl.text.length < 5) {
                                      amtCtrl.text = "${amtCtrl.text}6";
                                    }
                                  },
                                )
                              ],
                            ),
                            Row(
                              children: [
                                buttonWidget(
                                  title: "1",
                                  onTap: () {
                                    if (amtCtrl.text.length < 5) {
                                      amtCtrl.text = "${amtCtrl.text}1";
                                    }
                                  },
                                ),
                                buttonWidget(
                                  title: "2",
                                  onTap: () {
                                    if (amtCtrl.text.length < 5) {
                                      amtCtrl.text = "${amtCtrl.text}2";
                                    }
                                  },
                                ),
                                buttonWidget(
                                  title: "3",
                                  onTap: () {
                                    if (amtCtrl.text.length < 5) {
                                      amtCtrl.text = "${amtCtrl.text}3";
                                    }
                                  },
                                )
                              ],
                            ),
                            Row(
                              children: [
                                buttonWidget(
                                  title: "0",
                                  onTap: () {
                                    if (amtCtrl.text.length < 5) {
                                      amtCtrl.text = "${amtCtrl.text}0";
                                    }
                                  },
                                ),
                                buttonWidget(
                                  title: ".",
                                  onTap: () {
                                    if (amtCtrl.text.length < 5) {
                                      if (amtCtrl.text.isNotEmpty) {
                                        amtCtrl.text = "${amtCtrl.text}.";
                                      } else {
                                        amtCtrl.text = "0.";
                                      }
                                    }
                                  },
                                ),
                                */
              /*buttonWidget(
                                  title: "Del",
                                  onTap: () {
                                    if (amtCtrl.text.isNotEmpty) {
                                      amtCtrl.text =
                                          amtCtrl.text.substring(0, amtCtrl.text.length - 1);
                                    }
                                  },
                                )*/
              /*
                                buttonWidget(
                                  title: "Clear",
                                  onTap: () {
                                    amtCtrl.text = "";
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Text(
                          "Payment Types",
                          style: TextStyle(
                              color: AppColor.blackColor,
                              fontWeight: FontWeight.w900,
                              fontSize: 18.0),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        */
              /*SizedBox(
                          width: MediaQuery.of(context).size.width / 4,
                          child: Scrollbar(
                            controller: categoryScroll,
                            thickness: 5.0,
                            interactive: true,
                            thumbVisibility: true,
                            radius: const Radius.circular(8.0),
                            child: SingleChildScrollView(
                              controller: categoryScroll,
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: paymentList.asMap().entries.map(
                                    (e) {
                                      return InkResponse(
                                        radius: 5.0,
                                        onTap: () {
                                          if (!isFinish) {
                                            if ((e.value.key ?? "")
                                                    .toLowerCase() ==
                                                "cash") {
                                              widget.cashOpen();
                                            }
                                            if (amtCtrl.text.isEmpty) {
                                              setState(() {
                                                payType.add({
                                                  "method": e.value.key ?? "",
                                                  "amount": totalPaid != 0.00
                                                      ? ((double.parse(widget
                                                                  .total
                                                                  .toStringAsFixed(
                                                                      2)) -
                                                              totalPaid)
                                                          .toStringAsFixed(2))
                                                      : widget.total
                                                          .toStringAsFixed(2)
                                                });
                                              });
                                              getTotalPay();
                                              finalDone();
                                              sendMsgToSubScreen(
                                                  method: "pay",
                                                  data: {
                                                    "payment": payType,
                                                    "discount_type":
                                                        widget.disCount
                                                  });
                                            } else {
                                              paymentUpdate(
                                                  type: e.value.key ?? "",
                                                  amount: amtCtrl.text);
                                            }
                                          }
                                        },
                                        child: Container(
                                          width: 95.0,
                                          margin:
                                              const EdgeInsets.only(right: 5.0),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 25.0),
                                          decoration: const BoxDecoration(
                                              color: Colors.blueAccent),
                                          child: Text(
                                            e.value.type ?? "",
                                            maxLines: 1,
                                            // e.value.type ?? "",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: AppColor.whiteColor,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      );
                                    },
                                  ).toList()),
                            ),
                          ),
                        )*/
              /*
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 4,
                          child: Wrap(
                            runSpacing: 5.0,
                            children: paymentList.asMap().entries.map(
                              (e) {
                                return InkResponse(
                                  radius: 5.0,
                                  onTap: () {
                                    if (!isFinish) {
                                      if ((e.value.key ?? "").toLowerCase() ==
                                          "cash") {
                                        widget.cashOpen();
                                      }
                                      if (amtCtrl.text.isEmpty) {
                                        setState(() {
                                          payType.add({
                                            "method": e.value.key ?? "",
                                            "amount": totalPaid != 0.00
                                                ? ((double.parse(widget.total
                                                            .toStringAsFixed(2)) -
                                                        totalPaid)
                                                    .toStringAsFixed(2))
                                                : widget.total.toStringAsFixed(2)
                                          });
                                        });
                                        getTotalPay();
                                        finalDone();
                                        sendMsgToSubScreen(method: "pay", data: {
                                          "payment": payType,
                                          "discount_type": widget.disCount
                                        });
                                      } else {
                                        paymentUpdate(
                                            type: e.value.key ?? "",
                                            amount: amtCtrl.text);
                                      }
                                    }
                                  },
                                  child: Container(
                                    // width: 115.0,
                                    margin: const EdgeInsets.only(right: 5.0),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15.0, horizontal: 25.0),
                                    decoration: const BoxDecoration(
                                        color: Colors.blueAccent),
                                    child: Text(
                                      e.value.type ?? "",
                                      maxLines: 1,
                                      // e.value.type ?? "",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: AppColor.whiteColor,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                );
                              },
                            ).toList(),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 25.0,
                  ),
                  SizedBox(
                    width: 180.0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          headValueWidget(
                              title: "Total Items",
                              value: widget.cartItem.toString()),
                          const Divider(),
                          headValueWidget(
                              title: "Total Payable",
                              value: "\$ ${widget.total.toStringAsFixed(2)}"),
                          const Divider(),
                          headValueWidget(
                              title: "Total Paying",
                              value: payType.isEmpty ? "\$ 0.00" : getAmt()),
                          const Divider(),
                          headValueWidget(
                              title: "Change Return",
                              value:
                                  "S\$ ${totalPaid != 0.00 ? totalPaid < widget.total ? 0.00 : (totalPaid - double.parse(widget.total.toStringAsFixed(2))).toStringAsFixed(2) : 0.00}"),
                          const Divider(),
                          headValueWidget(
                              title: "Balance",
                              value:
                                  "S\$ ${totalPaid != 0.00 ? totalPaid < widget.total ? (double.parse(widget.total.toStringAsFixed(2)) - totalPaid).toStringAsFixed(2) : 0.00 : 0.00}"),
                        ],
                      ),
                    ),
                  )
                ],
              ),*/
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Enter Amount"),
                      SizedBox(
                        width: 150.0,
                        child: TextFormField(
                          readOnly: true,
                          controller: amtCtrl,
                          maxLength: 3,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Amount is required.";
                            } else {
                              return null;
                            }
                          },
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d{0,2}')),
                          ],
                          decoration: textDecorator(
                            label: "\$ 0.00",
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          buttonWidget(
                            width: 110.0,
                            height: 50.0,
                            title: "\$ 5",
                            onTap: () {
                              cashUpdate(amt: "5");
                            },
                          ),
                          const SizedBox(
                            width: 3.0,
                          ),
                          buttonWidget(
                            width: 110.0,
                            height: 50.0,
                            title: "\$ 10",
                            onTap: () {
                              cashUpdate(amt: "10");
                            },
                          ),
                          const SizedBox(
                            width: 3.0,
                          ),
                          buttonWidget(
                            width: 110.0,
                            height: 50.0,
                            title: "\$ 50",
                            onTap: () {
                              cashUpdate(amt: "50");
                            },
                          ),
                          const SizedBox(
                            width: 3.0,
                          ),
                          buttonWidget(
                            width: 110.0,
                            height: 50.0,
                            title: "\$ 100",
                            onTap: () {
                              cashUpdate(amt: "100");
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          buttonWidget(
                            title: "7",
                            textColor: AppColor.blackColor,
                            btnColor: Colors.transparent,
                            onTap: () {
                              if (amtCtrl.text.length < 5) {
                                amtCtrl.text = "${amtCtrl.text}7";
                              }
                            },
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          buttonWidget(
                            title: "8",
                            textColor: AppColor.blackColor,
                            btnColor: Colors.transparent,
                            onTap: () {
                              if (amtCtrl.text.length < 5) {
                                amtCtrl.text = "${amtCtrl.text}8";
                              }
                            },
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          buttonWidget(
                            title: "9",
                            textColor: AppColor.blackColor,
                            btnColor: Colors.transparent,
                            onTap: () {
                              if (amtCtrl.text.length < 5) {
                                amtCtrl.text = "${amtCtrl.text}9";
                              }
                            },
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        children: [
                          buttonWidget(
                            title: "4",
                            textColor: AppColor.blackColor,
                            btnColor: Colors.transparent,
                            onTap: () {
                              if (amtCtrl.text.length < 5) {
                                amtCtrl.text = "${amtCtrl.text}4";
                              }
                            },
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          buttonWidget(
                            title: "5",
                            textColor: AppColor.blackColor,
                            btnColor: Colors.transparent,
                            onTap: () {
                              if (amtCtrl.text.length < 5) {
                                amtCtrl.text = "${amtCtrl.text}5";
                              }
                            },
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          buttonWidget(
                            title: "6",
                            textColor: AppColor.blackColor,
                            btnColor: Colors.transparent,
                            onTap: () {
                              if (amtCtrl.text.length < 5) {
                                amtCtrl.text = "${amtCtrl.text}6";
                              }
                            },
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        children: [
                          buttonWidget(
                            title: "1",
                            textColor: AppColor.blackColor,
                            btnColor: Colors.transparent,
                            onTap: () {
                              if (amtCtrl.text.length < 5) {
                                amtCtrl.text = "${amtCtrl.text}1";
                              }
                            },
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          buttonWidget(
                            title: "2",
                            textColor: AppColor.blackColor,
                            btnColor: Colors.transparent,
                            onTap: () {
                              if (amtCtrl.text.length < 5) {
                                amtCtrl.text = "${amtCtrl.text}2";
                              }
                            },
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          buttonWidget(
                            title: "3",
                            textColor: AppColor.blackColor,
                            btnColor: Colors.transparent,
                            onTap: () {
                              if (amtCtrl.text.length < 5) {
                                amtCtrl.text = "${amtCtrl.text}3";
                              }
                            },
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        children: [
                          buttonWidget(
                            title: "0",
                            textColor: AppColor.blackColor,
                            btnColor: Colors.transparent,
                            onTap: () {
                              if (amtCtrl.text.length < 5) {
                                amtCtrl.text = "${amtCtrl.text}0";
                              }
                            },
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          buttonWidget(
                            title: ".",
                            textColor: AppColor.blackColor,
                            btnColor: Colors.transparent,
                            onTap: () {
                              if (amtCtrl.text.length < 5) {
                                if (amtCtrl.text.isNotEmpty) {
                                  amtCtrl.text = "${amtCtrl.text}.";
                                } else {
                                  amtCtrl.text = "0.";
                                }
                              }
                            },
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          buttonWidget(
                            title: "Clear".toUpperCase(),
                            // textColor: AppColor.blackColor,
                            btnColor: Colors.red,
                            onTap: () {
                              if (amtCtrl.text.isNotEmpty) {
                                amtCtrl.text = amtCtrl.text
                                    .substring(0, amtCtrl.text.length - 1);
                              }
                            },
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        "Payment Types",
                        style: TextStyle(
                            color: AppColor.blackColor,
                            // fontWeight: FontWeight.w900,
                            fontSize: 18.0),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Wrap(
                        // runSpacing: 5.0,
                        children: paymentList.asMap().entries.map(
                          (e) {
                            return InkResponse(
                              radius: 5.0,
                              onTap: () {
                                if (!isFinish) {
                                  if ((e.value.key ?? "").toLowerCase() ==
                                      "cash") {
                                    widget.cashOpen();
                                  }
                                  if (amtCtrl.text.isEmpty) {
                                    setState(() {
                                      payType.add({
                                        "method": e.value.key ?? "",
                                        "amount": totalPaid != 0.00
                                            ? ((double.parse(widget.total
                                                        .toStringAsFixed(2)) -
                                                    totalPaid)
                                                .toStringAsFixed(2))
                                            : widget.total.toStringAsFixed(2)
                                      });
                                    });
                                    getTotalPay();
                                    finalDone();
                                    sendMsgToSubScreen(method: "pay", data: {
                                      "payment": payType,
                                      "discount_type": widget.disCount
                                    });
                                  } else {
                                    paymentUpdate(
                                        type: e.value.key ?? "",
                                        amount: amtCtrl.text);
                                  }
                                }
                              },
                              child: Container(
                                width: 140.0,
                                margin:
                                    const EdgeInsets.only(right: 8.0, top: 8.0),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15.0),
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Text(
                                  e.value.type ?? "",
                                  // "Bank Transfer",
                                  maxLines: 1,
                                  // e.value.type ?? "",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColor.whiteColor,
                                  ),
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 15.0,
                  ),
                  SizedBox(
                    width: 180.0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          headValueWidget(
                              title: "Total Items",
                              value: widget.cartItem.toString()),
                          const Divider(),
                          headValueWidget(
                              title: "Total Payable",
                              value: "\$ ${widget.total.toStringAsFixed(2)}"),
                          const Divider(),
                          headValueWidget(
                              title: "Total Paying",
                              value: payType.isEmpty ? "\$ 0.00" : getAmt()),
                          const Divider(),
                          headValueWidget(
                              title: "Change Return",
                              value:
                                  "S\$ ${totalPaid != 0.00 ? totalPaid < widget.total ? 0.00 : (totalPaid - double.parse(widget.total.toStringAsFixed(2))).toStringAsFixed(2) : 0.00}"),
                          const Divider(),
                          headValueWidget(
                              title: "Balance",
                              value:
                                  "S\$ ${totalPaid != 0.00 ? totalPaid < widget.total ? (double.parse(widget.total.toStringAsFixed(2)) - totalPaid).toStringAsFixed(2) : 0.00 : 0.00}"),
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  cashUpdate({required String amt}) {
    if (!isFinish) {
      widget.cashOpen();
      setState(() {
        payType.add({
          "method": paymentList
                  .where((element) => element.key!.toLowerCase() == "cash")
                  .toList()[0]
                  .key ??
              "",
          "amount": double.parse(amt).toStringAsFixed(2)
        });
      });
      getTotalPay();
      finalDone();
      sendMsgToSubScreen(
          method: "pay",
          data: {"payment": payType, "discount_type": widget.disCount});
    }
  }

  getAmt() {
    Map<String, double> grouped = {};
    for (var payment in payType) {
      String method = payment['method'] ?? "";
      String amount = payment["amount"] ?? "0.00";
      grouped[method] = (grouped[method] ?? 0) + double.parse(amount);
    }
    return grouped.entries.map((e) {
      final match =
          paymentList.where((element) => element.key == e.key).toList();
      final displayKey = match.isNotEmpty ? match[0].type : e.key;
      return "$displayKey : \$ ${e.value.toStringAsFixed(2)}";
    }).join("\n");
  }

  getTotalPay() {
    Map<String, double> grouped = {};
    for (var payment in payType) {
      String method = payment['method'] ?? "";
      String amount = payment["amount"] ?? "0.00";
      grouped[method] = (grouped[method] ?? 0.0) + double.parse(amount);
    }
    setState(() {
      totalPaid = grouped.entries.fold(
        0.0,
        (previousValue, element) {
          return previousValue + element.value;
        },
      );
    });
  }

  paymentUpdate({required String amount, required String type}) {
    setState(() {
      payType.add({"method": type, "amount": amount});
      amtCtrl.text = "";
    });
    getTotalPay();
    finalDone();
    sendMsgToSubScreen(
        method: "pay",
        data: {"payment": payType, "discount_type": widget.disCount});
  }

  Widget headValueWidget({required String title, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              color: AppColor.whiteColor, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 5.0,
        ),
        Text(
          value,
          style: TextStyle(
              color: AppColor.whiteColor,
              fontWeight: FontWeight.w600,
              fontSize: 18.0),
        ),
      ],
    );
  }

  Widget buttonWidget(
      {required String title,
      Color? btnColor,
      Color? textColor,
      double? width,
      double? height,
      Function()? onTap}) {
    return InkResponse(
      onTap: onTap,
      child: Container(
        width: width ?? 145.0,
        height: height ?? 53.0,
        margin: const EdgeInsets.all(0.9),
        padding: const EdgeInsets.symmetric(vertical: 17.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: btnColor ?? Colors.blueAccent,
          border: Border.all(
              color: btnColor != null ? Colors.grey : Colors.transparent,
              width: 0.9),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          title.toUpperCase(),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: textColor ?? Colors.white,
              fontSize: 13.0,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void finalDone() {
    if (double.parse(totalPaid.toStringAsFixed(2)) >=
        double.parse(widget.total.toStringAsFixed(2))) {
      setState(() {
        isFinish = true;
      });
      widget.onPayDone(
          payType,
          totalPaid != 0.00
              ? totalPaid < widget.total
                  ? 0.00
                  : (totalPaid - double.parse(widget.total.toStringAsFixed(2)))
              : 0.00);
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
