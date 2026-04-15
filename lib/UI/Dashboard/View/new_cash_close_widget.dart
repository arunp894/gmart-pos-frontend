import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:gmart/Constant/app_color.dart';
import 'package:gmart/Constant/app_strings.dart';
import 'package:gmart/Core/application_base.dart';
import 'package:gmart/UI/Dashboard/ViewModel/dashboard_view_model.dart';
import 'package:gmart/Utils/text_decorator.dart';

class NewCashCloseWidget extends StatefulWidget {
  final Future<void> Function(Map<String, dynamic> postData) onDone;

  const NewCashCloseWidget({super.key, required this.onDone});

  @override
  State<NewCashCloseWidget> createState() => _NewCashCloseWidgetState();
}

class _NewCashCloseWidgetState extends State<NewCashCloseWidget> {
  TextEditingController cashCtrl = TextEditingController();
  TextEditingController cardCtrl = TextEditingController();
  TextEditingController fiveCtrl = TextEditingController();
  TextEditingController tenCtrl = TextEditingController();
  TextEditingController fifCtrl = TextEditingController();
  TextEditingController hunCtrl = TextEditingController();
  TextEditingController notesCtrl = TextEditingController();
  TextEditingController selectedCtrl = TextEditingController();
  final cashForm = GlobalKey<FormState>();
  int length = 5;
  SharedPreferences? prefs;
  List<String> denominationList = [];
  final Map<String, TextEditingController> controllers = {};
  DashboardViewModel? model;

  @override
  void initState() {
    prefs = spEngine!.prefs;
    loadDenominations();
    super.initState();
  }

  @override
  void dispose() {
    controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<DashboardViewModel>(
      prepareModel: (model) {
        this.model = model;
        model.getCashDetails().then(
          (value) {
            // setState(() {
            //   cashCtrl.text = model.cashRegDetails!.totalCash ?? "";
            // });
          },
        );
      },
      builder: (context, model, child) {
        return Form(
          key: cashForm,
          child: Column(
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
                      "Cash Close",
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          // margin: const EdgeInsets.all(15.0),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 15.0),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15.0),
                                decoration: BoxDecoration(
                                  color: Colors.yellow.shade700,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: const Text(
                                  'Denominations',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: denominationList.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2.5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 100.0,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 13.0),
                                            decoration: BoxDecoration(
                                                color: AppColor.whiteColor,
                                                border: Border.all(
                                                    color:
                                                        Colors.grey.shade400)),
                                            child: Text(
                                              "\$${denominationList[index]}",
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10.0,
                                          ),
                                          Expanded(
                                            child: TextFormField(
                                                maxLength: 3,
                                                readOnly: true,
                                                onChanged: (value) {
                                                  setState(() {});
                                                },
                                                controller: controllers[
                                                    denominationList[index]],
                                                onTap: () {
                                                  setState(() {
                                                    selectedCtrl = controllers[
                                                        denominationList[
                                                            index]]!;
                                                  });
                                                },
                                                // validator: (value) {
                                                //   if(value == null || value.isEmpty){
                                                //     return "\$5 is required.";
                                                //   }else{
                                                //     return null;
                                                //   }
                                                // },
                                                textAlign: TextAlign.center,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ],
                                                decoration: InputDecoration(
                                                  counterText: "",
                                                  fillColor:
                                                      AppColor.whiteColor,
                                                  filled: true,
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 15.0),
                                                  // contentPadding: contentPadding,
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0.0),
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .grey.shade400)),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      0.0),
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .red)),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      0.0),
                                                          borderSide: BorderSide(
                                                              color: Colors.grey
                                                                  .shade400)),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      0.0),
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .orange)),
                                                )),
                                          ),
                                          const SizedBox(
                                            width: 8.0,
                                          ),
                                          Container(
                                            width: 100.0,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 13.0),
                                            decoration: BoxDecoration(
                                                color: Colors.grey.shade200,
                                                border: Border.all(
                                                    color:
                                                        Colors.grey.shade400)),
                                            child: Text(
                                              "\$${(double.parse(denominationList[index]) * double.parse(controllers[denominationList[index]]!.text == "" ? "0.00" : controllers[denominationList[index]]!.text)).toStringAsFixed(2)}",
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Text(
                                    "Total Amount",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    width: 15.0,
                                  ),
                                  Container(
                                    width: 100.0,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 13.0),
                                    decoration: BoxDecoration(
                                      color: Colors.yellow.shade500,
                                      borderRadius: BorderRadius.circular(5.0),
                                      border: Border.all(
                                          color: Colors.yellow.shade700),
                                    ),
                                    child: Text(
                                      // "\$ ${controllers.values.map((e) => double.parse(e.text.isEmpty ? "0.00" : e.text)).reduce((a, b) => a + b).toStringAsFixed(2)}",
                                      "\$ ${getTotalAmount().toStringAsFixed(2)}",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15.0,
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              buttonWidget(
                                title: "7",
                                onTap: () {
                                  if (selectedCtrl.text.length < length) {
                                    setState(() {
                                      selectedCtrl.text =
                                          "${selectedCtrl.text}7";
                                    });
                                  }
                                },
                              ),
                              buttonWidget(
                                title: "8",
                                onTap: () {
                                  if (selectedCtrl.text.length < length) {
                                    setState(() {
                                      selectedCtrl.text =
                                          "${selectedCtrl.text}8";
                                    });
                                  }
                                },
                              ),
                              buttonWidget(
                                title: "9",
                                onTap: () {
                                  if (selectedCtrl.text.length < length) {
                                    setState(() {
                                      selectedCtrl.text =
                                          "${selectedCtrl.text}9";
                                    });
                                  }
                                },
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              buttonWidget(
                                title: "4",
                                onTap: () {
                                  if (selectedCtrl.text.length < length) {
                                    setState(() {
                                      selectedCtrl.text =
                                          "${selectedCtrl.text}4";
                                    });
                                  }
                                },
                              ),
                              buttonWidget(
                                title: "5",
                                onTap: () {
                                  if (selectedCtrl.text.length < length) {
                                    setState(() {
                                      selectedCtrl.text =
                                          "${selectedCtrl.text}5";
                                    });
                                  }
                                },
                              ),
                              buttonWidget(
                                title: "6",
                                onTap: () {
                                  if (selectedCtrl.text.length < length) {
                                    setState(() {
                                      selectedCtrl.text =
                                          "${selectedCtrl.text}6";
                                    });
                                  }
                                },
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              buttonWidget(
                                title: "1",
                                onTap: () {
                                  if (selectedCtrl.text.length < length) {
                                    setState(() {
                                      selectedCtrl.text =
                                          "${selectedCtrl.text}1";
                                    });
                                  }
                                },
                              ),
                              buttonWidget(
                                title: "2",
                                onTap: () {
                                  if (selectedCtrl.text.length < length) {
                                    setState(() {
                                      selectedCtrl.text =
                                          "${selectedCtrl.text}2";
                                    });
                                  }
                                },
                              ),
                              buttonWidget(
                                title: "3",
                                onTap: () {
                                  if (selectedCtrl.text.length < length) {
                                    setState(() {
                                      selectedCtrl.text =
                                          "${selectedCtrl.text}3";
                                    });
                                  }
                                },
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              buttonWidget(
                                title: "Clear",
                                btnColor: Colors.orangeAccent,
                                onTap: () {
                                  setState(() {
                                    selectedCtrl.text = "";
                                  });
                                },
                              ),
                              buttonWidget(
                                title: "0",
                                onTap: () {
                                  if (selectedCtrl.text.length < length) {
                                    setState(() {
                                      selectedCtrl.text =
                                          "${selectedCtrl.text}0";
                                    });
                                  }
                                },
                              ),
                              buttonWidget(
                                title: "Del",
                                btnColor: Colors.red,
                                onTap: () {
                                  if (selectedCtrl.text.isNotEmpty) {
                                    setState(() {
                                      selectedCtrl.text = selectedCtrl.text
                                          .substring(
                                              0, selectedCtrl.text.length - 1);
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 15.0,
                      ),
                      Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.26,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25.0, vertical: 20.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  border: Border.all(
                                      color: AppColor.hintBlackColor),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Total Cash Amount"),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    TextFormField(
                                      readOnly: true,
                                      enabled: false,
                                      textAlign: TextAlign.center,
                                      controller: cashCtrl,
                                      // onTap: () {
                                      //   setState(() {
                                      //     selectedCtrl = cashCtrl;
                                      //   });
                                      // },
                                      onChanged: (value) {
                                        setState(() {});
                                      },
                                      // validator: (value) {
                                      //   if (value == null || value.isEmpty) {
                                      //     return "Cash amount is required.";
                                      //   } else {
                                      //     return null;
                                      //   }
                                      // },
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^\d*\.?\d{0,2}')),
                                      ],
                                      decoration: textDecorator(
                                        label:
                                            "\$ ${getTotalAmount().toStringAsFixed(2)}",
                                        borderColor: Colors.orange,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              /*const SizedBox(
                                height: 15.0,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.26,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25.0, vertical: 20.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  border: Border.all(
                                      color: AppColor.hintBlackColor),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Total Card Slips"),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    TextFormField(
                                      controller: cardCtrl,
                                      readOnly: true,
                                      onTap: () {
                                        setState(() {
                                          selectedCtrl = cardCtrl;
                                        });
                                      },
                                      maxLength: 3,
                                      onChanged: (value) {
                                        setState(() {});
                                      },
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      textAlign: TextAlign.center,
                                      decoration: textDecorator(
                                        label: "0",
                                        borderColor: Colors.orange,
                                      ),
                                    ),
                                  ],
                                ),
                              )*/
                            ],
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          Column(
                            children: [
                              InkResponse(
                                radius: 5.0,
                                onTap: () {
                                  // if (cashForm.currentState!.validate()) {
                                    final Map<String, dynamic> payload =
                                        {}; // use dynamic so we can store null
                                    controllers
                                        .forEach((denomination, controller) {
                                      String value = controller.text.trim();
                                      payload[denomination] =
                                          value.isEmpty ? null : value;
                                    });
                                    Map<String, dynamic> postData = {
                                      // "closing_amount": cashCtrl.text.isEmpty
                                      //     ? 0
                                      //     : num.parse(cashCtrl.text),
                                      "closing_amount": getTotalAmount(),
                                      "total_card_slips": cardCtrl.text.isEmpty
                                          ? 0
                                          : int.parse(cardCtrl.text),
                                      "total_cheques": 0,
                                      "closing_note": notesCtrl.text,
                                      /* "denominations": {
                          "5": int.parse(
                              fiveCtrl.text.isEmpty ? "0" : fiveCtrl.text),
                          "10": int.parse(
                              tenCtrl.text.isEmpty ? "0" : tenCtrl.text),
                          "50": int.parse(
                              fifCtrl.text.isEmpty ? "0" : fifCtrl.text),
                          "100":
                              int.parse(hunCtrl.text.isEmpty ? "0" : hunCtrl.text)
                        }*/
                                      "denominations": payload
                                    };
                                    widget.onDone(postData);
                                  // }
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.26,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 25.0),
                                  decoration: BoxDecoration(
                                    color: AppColor.primaryColor,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Text(
                                    "Submit Cash Close",
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(color: AppColor.whiteColor),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              InkResponse(
                                radius: 5.0,
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.26,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 25.0),
                                  decoration: BoxDecoration(
                                    color: AppColor.hintBlackColor,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Text(
                                    "Cancel",
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(color: AppColor.whiteColor),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
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

  Widget buttonWidget(
      {required String title,
      Color? btnColor,
      Color? textColor,
      Function()? onTap}) {
    return InkResponse(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
          width: 90.0,
          // width: MediaQuery.of(context).size.width * 0.07,
          padding: const EdgeInsets.symmetric(vertical: 25.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: btnColor ?? Colors.blueAccent,
              // color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(8.0)),
          child: Text(
            title.toUpperCase(),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: textColor ?? AppColor.whiteColor,
                // fontSize: 20.0,
                fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }

  void loadDenominations() {
    String? permittedList = prefs!.getString(AppStrings.denominationList);
    if (permittedList != null) {
      List<dynamic> decodedList = jsonDecode(permittedList);
      List<String> mainList = decodedList.map((e) => e.toString()).toList();
      setState(() {
        denominationList = mainList;
      });
    }
    for (var denomination in denominationList) {
      controllers[denomination] = TextEditingController();
    }
  }

  double getTotalAmount() {
    double total = 0.0;

    for (final denom in denominationList) {
      final denomValue = double.tryParse(denom) ?? 0.0;

      final qtyText = controllers[denom]?.text ?? "0";
      final qty = double.tryParse(qtyText.isEmpty ? "0" : qtyText) ?? 0.0;

      total += denomValue * qty;
    }

    return total;
  }
}
