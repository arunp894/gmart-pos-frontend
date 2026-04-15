import 'package:flutter/services.dart';
import 'package:gmart/Core/application_base.dart';
import 'package:gmart/Utils/text_decorator.dart';

class SellingPriceWidget extends StatefulWidget {
  final Function(Map<String, dynamic> data) onDone;
  final String? discountType;

  const SellingPriceWidget(
      {super.key, this.discountType, required this.onDone});

  @override
  State<SellingPriceWidget> createState() => _SellingPriceWidgetState();
}

class _SellingPriceWidgetState extends State<SellingPriceWidget> {
  TextEditingController amtCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();
  int length = 5;

  @override
  void initState() {
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
        Column(
          children: [
            Form(
              key: formKey,
              child: TextFormField(
                readOnly: true,
                controller: amtCtrl,
                maxLength: length,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Amount is required.";
                  }
                  double? amount = double.tryParse(value);
                  if (amount == null) {
                    return "Invalid number.";
                  }
                  if (amount <= 0) {
                    return "Invalid price.";
                  }
                  return null;
                },
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                decoration: textDecorator(label: "Enter Selling Amount"),
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
                    if (amtCtrl.text.length < length) {
                      amtCtrl.text = "${amtCtrl.text}7";
                    }
                  },
                ),
                buttonWidget(
                  title: "8",
                  onTap: () {
                    if (amtCtrl.text.length < length) {
                      amtCtrl.text = "${amtCtrl.text}8";
                    }
                  },
                ),
                buttonWidget(
                  title: "9",
                  onTap: () {
                    if (amtCtrl.text.length < length) {
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
                    if (amtCtrl.text.length < length) {
                      amtCtrl.text = "${amtCtrl.text}4";
                    }
                  },
                ),
                buttonWidget(
                  title: "5",
                  onTap: () {
                    if (amtCtrl.text.length < length) {
                      amtCtrl.text = "${amtCtrl.text}5";
                    }
                  },
                ),
                buttonWidget(
                  title: "6",
                  onTap: () {
                    if (amtCtrl.text.length < 3) {
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
                    if (amtCtrl.text.length < length) {
                      amtCtrl.text = "${amtCtrl.text}1";
                    }
                  },
                ),
                buttonWidget(
                  title: "2",
                  onTap: () {
                    if (amtCtrl.text.length < length) {
                      amtCtrl.text = "${amtCtrl.text}2";
                    }
                  },
                ),
                buttonWidget(
                  title: "3",
                  onTap: () {
                    if (amtCtrl.text.length < length) {
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
                    if (amtCtrl.text.length < length) {
                      amtCtrl.text = "${amtCtrl.text}0";
                    }
                  },
                ),
                buttonWidget(
                  title: ".",
                  onTap: () {
                    if (amtCtrl.text.length < length) {
                      if (amtCtrl.text.isNotEmpty) {
                        amtCtrl.text = "${amtCtrl.text}.";
                      } else {
                        amtCtrl.text = "0.";
                      }
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
                      widget.onDone({"selling_price": amtCtrl.text});
                    }
                  },
                )
              ],
            )
          ],
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
