import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gmart/Constant/app_color.dart';
import 'package:gmart/Constant/app_strings.dart';
import 'package:gmart/Core/application_base.dart';
import 'package:gmart/UI/Splash/Model/cash_checking_response_model.dart';

class VoidBillScreen extends StatefulWidget {
  final List<Map<String, dynamic>> payments;
  final Function(List<Map<String, dynamic>> returnPay) onVoid;

  const VoidBillScreen(
      {super.key, required this.payments, required this.onVoid});

  @override
  State<VoidBillScreen> createState() => _VoidBillScreenState();
}

class _VoidBillScreenState extends State<VoidBillScreen> {
  SharedPreferences? preferences;
  List<Payment> paymentList = [];
  ScrollController categoryScroll = ScrollController();
  List<Pay> finalPayment = [];
  String returnMethod = "";
  int? returnIndex;

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
    loadPayment(widget.payments);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Void Bill",
              style: TextStyle(
                  color: AppColor.blackColor,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w700),
            ),
            InkResponse(
              radius: 5.0,
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                padding: const EdgeInsets.all(3.0),
                decoration: const BoxDecoration(
                    color: Colors.red, shape: BoxShape.circle),
                child: Icon(
                  Icons.clear,
                  size: 18.0,
                  color: AppColor.whiteColor,
                ),
              ),
            )
          ],
        ),
        Column(
          children: [
            const SizedBox(
              height: 25.0,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.5,
                        // height: MediaQuery.of(context).size.height / 5,
                        height: 150.0,
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 5,
                                  mainAxisExtent: 80.0,
                                  crossAxisSpacing: 5.0,
                                  mainAxisSpacing: 5.0),
                          itemCount: finalPayment.length,
                          itemBuilder: (context, index) {
                            return InkResponse(
                              radius: 5.0,
                              onTap: () {
                                if (returnIndex != null &&
                                    finalPayment[returnIndex!].isEdit!) {
                                  setState(() {
                                    finalPayment[returnIndex!].isEdit = null;
                                    returnIndex = index;
                                    finalPayment[index].isEdit = true;
                                    returnMethod =
                                        finalPayment[index].method ?? "";
                                  });
                                } else {
                                  if (finalPayment[index].isEdit == null ||
                                      finalPayment[index].isEdit!) {
                                    setState(() {
                                      returnIndex = index;
                                      finalPayment[index].isEdit = true;
                                      returnMethod =
                                          finalPayment[index].method ?? "";
                                    });
                                  }
                                }
                              },
                              child: Container(
                                // width: 85.0,
                                margin: const EdgeInsets.only(right: 5.0),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 10.0),
                                decoration: BoxDecoration(
                                    color: finalPayment[index].isEdit == null
                                        ? Colors.blueAccent
                                        : finalPayment[index].isEdit!
                                            ? Colors.grey
                                            : Colors.red),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      finalPayment[index].method ?? "",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 13.0,
                                          color: AppColor.whiteColor,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      "S\$ ${finalPayment[index].amount ?? ""}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 13.0,
                                          color: AppColor.whiteColor,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      returnMethod.isNotEmpty
                          ? returnMethod.toLowerCase() == "cash"
                              ? InkResponse(
                                  radius: 5.0,
                                  onTap: () {
                                    setState(() {
                                      finalPayment[returnIndex!].isEdit = false;
                                      finalPayment[returnIndex!].returnBy =
                                          "Cash";
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 15.0),
                                    decoration: const BoxDecoration(
                                        color: Colors.orange),
                                    child: Text(
                                      "Return By Cash",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: AppColor.whiteColor,
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                )
                              : Row(
                                  children: [
                                    InkResponse(
                                      radius: 5.0,
                                      onTap: () {
                                        setState(() {
                                          finalPayment[returnIndex!].isEdit =
                                              false;
                                          finalPayment[returnIndex!].returnBy =
                                              "Cash";
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 15.0),
                                        decoration: const BoxDecoration(
                                            color: Colors.orange),
                                        child: Text(
                                          "Return By Cash",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: AppColor.whiteColor,
                                              fontSize: 17.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5.0,
                                    ),
                                    InkResponse(
                                      radius: 5.0,
                                      onTap: () {
                                        setState(() {
                                          finalPayment[returnIndex!].isEdit =
                                              false;
                                          finalPayment[returnIndex!].returnBy =
                                              returnMethod;
                                        });
                                      },
                                      child: Container(
                                        // width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 15.0),
                                        decoration: const BoxDecoration(
                                            color: Colors.orange),
                                        child: Text(
                                          "Return By $returnMethod",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: AppColor.whiteColor,
                                              fontSize: 17.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                          : const SizedBox.shrink(),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: finalPayment.asMap().entries.map(
                          (e) {
                            return Column(
                              children: [
                                e.value.returnBy == null ||
                                        e.value.returnBy!.isEmpty
                                    ? const SizedBox.shrink()
                                    : Text(
                                        "${e.value.method ?? " "} :  S\$${e.value.amount} (${e.value.returnBy})",
                                        style: TextStyle(
                                            color: e.value.returnBy == null ||
                                                    e.value.returnBy!.isEmpty
                                                ? Colors.purpleAccent
                                                : Colors.red,
                                            fontWeight: FontWeight.w800),
                                      ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                              ],
                            );
                          },
                        ).toList(),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkResponse(
                          radius: 5.0,
                          onTap: () {
                            final hasDisabled = finalPayment.any(
                                (e) => e.isEdit == null || e.isEdit == true);
                            if (hasDisabled) {
                              Fluttertoast.showToast(
                                  msg: "Please return all the payments");
                            } else {
                              List<Map<String, dynamic>> returnPay = [];
                              for (Pay items in finalPayment) {
                                returnPay.add({
                                  "amount": items.amount,
                                  "method": items.method
                                });
                              }
                              widget.onVoid(returnPay);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 15.0),
                            decoration: BoxDecoration(
                              color: AppColor.primaryColor,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              "Void",
                              style: TextStyle(
                                  color: AppColor.whiteColor,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  void loadPayment(List<Map<String, dynamic>> payments) {
    Map<String, double> grouped = {};
    for (var item in payments) {
      if (item["is_return"] == "1") continue; // Skip returns

      String key = item["method"];
      double amount = double.tryParse(item["amount"].toString()) ?? 0.0;

      grouped[key] = (grouped[key] ?? 0) + amount;
    }
    List<Map<String, dynamic>> cList = grouped.entries.map(
      (e) {
        return {"method": e.key, "amount": e.value.toStringAsFixed(2)};
      },
    ).toList();
    for (var item in cList) {
      final label = paymentList
          .where(
            (element) => element.key == item['method'],
          )
          .toList();
      if (label.isNotEmpty) {
        setState(() {
          finalPayment.add(Pay(
              method: label[0].type,
              isReturn: item['is_return'] ?? "0",
              amount: item['amount'] ?? "0.00",
              label: label[0].key));
        });
      }
    }
  }
}

class Pay {
  String? method;
  String? amount;
  String? label;
  String? isReturn;
  bool? isEdit;
  String? returnBy;

  Pay(
      {this.amount,
      this.method,
      this.label,
      this.isReturn,
      this.isEdit,
      this.returnBy});

  Pay.fromJson(Map<String, dynamic> json) {
    method = json['method'];
    amount = json['amount'];
    label = json['label'];
    isReturn = json['isReturn'];
    isEdit = json['isEdit'];
    returnBy = json['returnBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['method'] = this.method;
    data['amount'] = this.amount;
    data['label'] = this.label;
    data['isReturn'] = this.isReturn;
    data['isEdit'] = this.isEdit;
    data['returnBy'] = this.returnBy;
    return data;
  }
}
