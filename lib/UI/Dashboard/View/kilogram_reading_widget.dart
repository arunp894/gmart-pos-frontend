import 'package:flutter/services.dart';
import 'package:gmart/Core/application_base.dart';
import 'package:gmart/Utils/text_decorator.dart';

class KilogramReadingWidget extends StatefulWidget {
  final Function(Map<String, dynamic> data) onDone;

  const KilogramReadingWidget({super.key, required this.onDone});

  @override
  State<KilogramReadingWidget> createState() => _KilogramReadingWidgetState();
}

class _KilogramReadingWidgetState extends State<KilogramReadingWidget> {
  TextEditingController amtCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();

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
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Kilogram is required.";
                  } else {
                    return null;
                  }
                },
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                decoration: textDecorator(label: "Enter kg"),
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
                    if (amtCtrl.text.length <= 5) {
                      amtCtrl.text = "${amtCtrl.text}7";
                    }
                  },
                ),
                buttonWidget(
                  title: "8",
                  onTap: () {
                    if (amtCtrl.text.length <= 5) {
                      amtCtrl.text = "${amtCtrl.text}8";
                    }
                  },
                ),
                buttonWidget(
                  title: "9",
                  onTap: () {
                    if (amtCtrl.text.length <= 5) {
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
                    if (amtCtrl.text.length <= 5) {
                      amtCtrl.text = "${amtCtrl.text}4";
                    }
                  },
                ),
                buttonWidget(
                  title: "5",
                  onTap: () {
                    if (amtCtrl.text.length <= 5) {
                      amtCtrl.text = "${amtCtrl.text}5";
                    }
                  },
                ),
                buttonWidget(
                  title: "6",
                  onTap: () {
                    if (amtCtrl.text.length <= 5) {
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
                    if (amtCtrl.text.length <= 5) {
                      amtCtrl.text = "${amtCtrl.text}1";
                    }
                  },
                ),
                buttonWidget(
                  title: "2",
                  onTap: () {
                    if (amtCtrl.text.length <= 5) {
                      amtCtrl.text = "${amtCtrl.text}2";
                    }
                  },
                ),
                buttonWidget(
                  title: "3",
                  onTap: () {
                    if (amtCtrl.text.length <= 5) {
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
                    if (amtCtrl.text.length <= 5) {
                      amtCtrl.text = "${amtCtrl.text}0";
                    }
                  },
                ),
                buttonWidget(
                  title: ".",
                  onTap: () {
                    if (amtCtrl.text.length <= 5) {
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
                      widget.onDone({
                        "kg": double.parse(amtCtrl.text).toStringAsFixed(2)
                      });
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
