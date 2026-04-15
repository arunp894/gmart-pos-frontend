import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:gmart/Constant/app_color.dart';
import 'package:gmart/Constant/app_strings.dart';
import 'package:gmart/Core/application_base.dart';
import 'package:gmart/Utils/text_decorator.dart';

class CashCloseWidget extends StatefulWidget {
  final void Function(Map<String, dynamic> postData) onDone;

  const CashCloseWidget({super.key, required this.onDone});

  @override
  State<CashCloseWidget> createState() => _CashCloseWidgetState();
}

class _CashCloseWidgetState extends State<CashCloseWidget> {
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: AppColor.primaryColor,
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarColor: AppColor.primaryColor),
        title: const Text("Cash Close"),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
        child: Form(
          key: cashForm,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Cash Amount",
                        style: TextStyle(
                            color: AppColor.blackColor,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      SizedBox(
                        width: 250.0,
                        child: TextFormField(
                          readOnly: true,
                          controller: cashCtrl,
                          onTap: () {
                            setState(() {
                              selectedCtrl = cashCtrl;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Cash amount is required.";
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
                              label: "Enter the cash amount",
                              borderColor: Colors.orange,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 10.0)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 25.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Card Slips",
                        style: TextStyle(
                            color: AppColor.blackColor,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      SizedBox(
                        width: 250.0,
                        child: TextFormField(
                          controller: cardCtrl,
                          readOnly: true,
                          onTap: () {
                            setState(() {
                              selectedCtrl = cardCtrl;
                            });
                          },
                          maxLength: 3,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: textDecorator(
                              label: "No.of.card slips",
                              borderColor: Colors.orange,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 10.0)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 15.0,
              ),
              Text(
                "Denominations",
                style: TextStyle(
                    color: AppColor.blackColor,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600),
              ),
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 0.0,
                    mainAxisSpacing: 0.0,
                    crossAxisCount: 5,
                    mainAxisExtent: 65.0),
                itemCount: denominationList.length,
                itemBuilder: (context, index) {
                  String denomination = denominationList[index];
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "X $denomination",
                        style: TextStyle(
                            color: AppColor.blackColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 18.0),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      Container(
                        width: 150.0,
                        margin: const EdgeInsets.only(top: 5.0),
                        child: TextFormField(
                          maxLength: 3,
                          readOnly: true,
                          controller: controllers[denomination],
                          onTap: () {
                            setState(() {
                              selectedCtrl = controllers[denomination]!;
                            });
                          },
                          // validator: (value) {
                          //   if(value == null || value.isEmpty){
                          //     return "\$5 is required.";
                          //   }else{
                          //     return null;
                          //   }
                          // },
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: textDecorator(
                              label: "${denominationList[index]} X",
                              borderColor: Colors.orange,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 10.0)),
                        ),
                      ),
                    ],
                  );
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          "Payments Notes",
                          style: TextStyle(
                              color: AppColor.blackColor,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        TextFormField(
                          controller: notesCtrl,
                          maxLines: 6,
                          decoration: textDecorator(label: "Payments noes"),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 15.0,
                  ),
                  Flexible(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buttonWidget(
                              title: "7",
                              onTap: () {
                                if (selectedCtrl.text.length < length) {
                                  selectedCtrl.text = "${selectedCtrl.text}7";
                                }
                              },
                            ),
                            buttonWidget(
                              title: "8",
                              onTap: () {
                                if (selectedCtrl.text.length < length) {
                                  selectedCtrl.text = "${selectedCtrl.text}8";
                                }
                              },
                            ),
                            buttonWidget(
                              title: "9",
                              onTap: () {
                                selectedCtrl.text = "${selectedCtrl.text}9";
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
                                selectedCtrl.text = "${selectedCtrl.text}4";
                              },
                            ),
                            buttonWidget(
                              title: "5",
                              onTap: () {
                                selectedCtrl.text = "${selectedCtrl.text}5";
                              },
                            ),
                            buttonWidget(
                              title: "6",
                              onTap: () {
                                selectedCtrl.text = "${selectedCtrl.text}6";
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
                                selectedCtrl.text = "${selectedCtrl.text}1";
                              },
                            ),
                            buttonWidget(
                              title: "2",
                              onTap: () {
                                selectedCtrl.text = "${selectedCtrl.text}2";
                              },
                            ),
                            buttonWidget(
                              title: "3",
                              onTap: () {
                                selectedCtrl.text = "${selectedCtrl.text}3";
                              },
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buttonWidget(
                              title: "0",
                              onTap: () {
                                selectedCtrl.text = "${selectedCtrl.text}0";
                              },
                            ),
                            buttonWidget(
                              title: ".",
                              onTap: () {
                                if (selectedCtrl.text.isNotEmpty) {
                                  selectedCtrl.text = "${selectedCtrl.text}.";
                                } else {
                                  selectedCtrl.text = "0.";
                                }
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buttonWidget(
                              title: "Clear",
                              onTap: () {
                                selectedCtrl.text = "";
                              },
                            ),
                            buttonWidget(
                              title: "Del",
                              onTap: () {
                                if (selectedCtrl.text.isNotEmpty) {
                                  selectedCtrl.text = selectedCtrl.text
                                      .substring(
                                          0, selectedCtrl.text.length - 1);
                                }
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            Expanded(
              child: InkResponse(
                radius: 5.0,
                onTap: () {
                  if (cashForm.currentState!.validate()) {
                    final Map<String, dynamic> payload =
                        {}; // use dynamic so we can store null
                    controllers.forEach((denomination, controller) {
                      String value = controller.text.trim();
                      payload[denomination] = value.isEmpty ? null : value;
                    });
                    Map<String, dynamic> postData = {
                      "closing_amount":
                          cashCtrl.text.isEmpty ? 0 : num.parse(cashCtrl.text),
                      "total_card_slips":
                          cardCtrl.text.isEmpty ? 0 : int.parse(cardCtrl.text),
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
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    "Cash Close",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppColor.whiteColor,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 15.0,
            ),
            Expanded(
              child: InkResponse(
                radius: 5.0,
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    "Back",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppColor.whiteColor,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buttonWidget(
      {required String title,
      Color? btnColor,
      Color? textColor,
      Function()? onTap}) {
    return Expanded(
      child: InkResponse(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Container(
            // width: MediaQuery.of(context).size.width / ,
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: btnColor ?? Colors.black12,
                borderRadius: BorderRadius.circular(8.0)),
            child: Text(
              title.toUpperCase(),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style:
                  TextStyle(color: textColor ?? Colors.black, fontSize: 12.0),
            ),
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
}
