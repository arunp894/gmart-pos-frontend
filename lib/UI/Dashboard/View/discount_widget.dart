import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gmart/Constant/app_color.dart';
import 'package:gmart/Utils/text_decorator.dart';

class DiscountWidget extends StatefulWidget {
  final Function(Map<String, dynamic> data) onDone;
  final String? discountType;

  const DiscountWidget({super.key, this.discountType, required this.onDone});

  @override
  State<DiscountWidget> createState() => _DiscountWidgetState();
}

class _DiscountWidgetState extends State<DiscountWidget> {
  String? selectedDiscount = "";
  TextEditingController amtCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    setState(() {
      selectedDiscount = "Voucher";
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 15.0,
        ),
        Row(
          children: ["Voucher", "\$ Discount", "% Discount"]
              .map((e) => InkResponse(
                    onTap: () {
                      setState(() {
                        selectedDiscount = e;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 25.0),
                        decoration: BoxDecoration(
                            color: selectedDiscount! == e
                                ? Colors.purple
                                : Colors.black12,
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Text(
                          e,
                          style: TextStyle(
                              color: selectedDiscount! == e
                                  ? AppColor.whiteColor
                                  : Colors.black38),
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(
          height: 15.0,
        ),
        Visibility(
          visible: selectedDiscount!.isNotEmpty,
          child: Column(
            children: [
              Form(
                key: formKey,
                child: TextFormField(
                  readOnly: true,
                  controller: amtCtrl,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Amount is required.";
                    } else {
                      return null;
                    }
                  },
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,2}')),
                  ],
                  decoration: textDecorator(label: "Enter Amount"),
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              Row(
                children: [
                  buttonWidget(
                    title: "7",
                    onTap: () {
                      amtCtrl.text = "${amtCtrl.text}7";
                    },
                  ),
                  buttonWidget(
                    title: "8",
                    onTap: () {
                      amtCtrl.text = "${amtCtrl.text}8";
                    },
                  ),
                  buttonWidget(
                    title: "9",
                    onTap: () {
                      amtCtrl.text = "${amtCtrl.text}9";
                    },
                  )
                ],
              ),
              Row(
                children: [
                  buttonWidget(
                    title: "4",
                    onTap: () {
                      amtCtrl.text = "${amtCtrl.text}4";
                    },
                  ),
                  buttonWidget(
                    title: "5",
                    onTap: () {
                      amtCtrl.text = "${amtCtrl.text}5";
                    },
                  ),
                  buttonWidget(
                    title: "6",
                    onTap: () {
                      amtCtrl.text = "${amtCtrl.text}6";
                    },
                  )
                ],
              ),
              Row(
                children: [
                  buttonWidget(
                    title: "1",
                    onTap: () {
                      amtCtrl.text = "${amtCtrl.text}1";
                    },
                  ),
                  buttonWidget(
                    title: "2",
                    onTap: () {
                      amtCtrl.text = "${amtCtrl.text}2";
                    },
                  ),
                  buttonWidget(
                    title: "3",
                    onTap: () {
                      amtCtrl.text = "${amtCtrl.text}3";
                    },
                  )
                ],
              ),
              Row(
                children: [
                  buttonWidget(
                    title: "0",
                    onTap: () {
                      amtCtrl.text = "${amtCtrl.text}0";
                    },
                  ),
                  buttonWidget(
                    title: ".",
                    onTap: () {
                      if (amtCtrl.text.isNotEmpty) {
                        amtCtrl.text = "${amtCtrl.text}.";
                      } else {
                        amtCtrl.text = "0.";
                      }
                    },
                  ),
                  buttonWidget(
                    title: "Del",
                    onTap: () {
                      if (amtCtrl.text.isNotEmpty) {
                        amtCtrl.text =
                            amtCtrl.text.substring(0, amtCtrl.text.length - 1);
                      }
                    },
                  )
                ],
              ),
              Row(
                children: [
                  buttonWidget(
                    title: "Clear",
                    onTap: () {
                      amtCtrl.text = "";
                    },
                  ),
                  buttonWidget(
                    title: "Ok",
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        widget.onDone({
                          "type": selectedDiscount,
                          "discount":
                              double.parse(amtCtrl.text).toStringAsFixed(1)
                        });
                      }
                    },
                  )
                ],
              )
            ],
          ),
        )
      ],
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
}
