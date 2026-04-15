import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gmart/Constant/app_color.dart';
import 'package:gmart/Constant/app_strings.dart';
import 'package:gmart/Core/application_base.dart';
import 'package:gmart/UI/Dashboard/Model/customer_response_model.dart';
import 'package:gmart/Utils/loading_dialog_box.dart';
import 'package:gmart/Utils/text_decorator.dart';

class AddCustomerScreen extends StatefulWidget {
  final void Function(int customerId) onDone;
  const AddCustomerScreen({super.key, required this.onDone});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  bool isKey = true, isSearch = false, isPay = false, isCheck = true;
  final formKey = GlobalKey<FormState>();
  final keyLoader = GlobalKey<State>();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController mobileCtrl = TextEditingController();
  TextEditingController searchCtrl = TextEditingController();
  int customerId = 0;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /*SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Search Customer",
                  style: TextStyle(color: AppColor.blackColor, fontSize: 16.0),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: TextFormField(
                    decoration: textDecorator(),
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 150.0,
                        color: Colors.red,
                      );
                    },
                  ),
                )
              ],
            ),
          ),*/
        SizedBox(
          width: MediaQuery.of(context).size.width / 3,
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Customer Name"),
                      const SizedBox(
                        height: 5.0,
                      ),
                      TextFormField(
                        controller: nameCtrl,
                        enabled: !isPay,
                        validator: (value) {
                          if (!isCheck) {
                            if (value == null || value.isEmpty) {
                              return "Name is required.";
                            } else {
                              return null;
                            }
                          } else {
                            return null;
                          }
                        },
                        onTap: () {
                          setState(() {
                            isKey = false;
                          });
                        },
                        onFieldSubmitted: (value) {
                          setState(() {
                            isKey = true;
                          });
                        },
                        decoration: textDecorator(),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Customer Mobile"),
                      const SizedBox(
                        height: 5.0,
                      ),
                      TextFormField(
                        controller: mobileCtrl,
                        enabled: !isPay,
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Mobile is required.";
                          } else {
                            return null;
                          }
                        },
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          setState(() {
                            isKey = true;
                          });
                        },
                        decoration:
                        textDecorator(borderColor: AppColor.secondaryColor),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  !isCheck
                      ? InkResponse(
                    radius: 5.0,
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      if (formKey.currentState!.validate()) {
                        Map<String, dynamic> postData = {
                          "type": "customer",
                          "prefix": "",
                          "first_name": nameCtrl.text,
                          "middle_name": "",
                          "last_name": "",
                          "mobile": mobileCtrl.text,
                          "email": "",
                          "dob": "",
                          "address_line_1": "",
                          "address_line_2": "",
                          "city": "",
                          "state": "",
                          "country": "",
                          "zip_code": "",
                          "land_mark": "",
                          "street_name": "",
                          "building_number": "",
                          "additional_number": ""
                        };
                        await addCustomer(postBody: postData).then(
                              (value) {
                            // setState(() {
                            //   nameCtrl.text = "";
                            //   mobileCtrl.text = "";
                            // });
                          },
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14.0, horizontal: 20.0),
                      // margin:
                      // const EdgeInsets.symmetric(horizontal: 15.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          color: AppColor.primaryColor),
                      child: Text(
                        "Add Customer",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColor.whiteColor, fontSize: 15.0),
                      ),
                    ),
                  )
                      : Visibility(
                    visible: !isPay,
                        child: InkResponse(
                                            onTap: () async {
                        if (formKey.currentState!.validate()) {
                          await checkCustomer(phone: mobileCtrl.text).then(
                                (value) {},
                          );
                        }
                                            },
                                            child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 14.0, horizontal: 20.0),
                        // margin:
                        // const EdgeInsets.symmetric(horizontal: 15.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            color: AppColor.primaryColor),
                        child: Text(
                          "Check Customer",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppColor.whiteColor, fontSize: 15.0),
                        ),
                                            ),
                                          ),
                      ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Visibility(
                    visible: isPay,
                    child: InkResponse(
                      onTap: () async {
                        widget.onDone(customerId);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 14.0, horizontal: 20.0),
                        // margin:
                        // const EdgeInsets.symmetric(horizontal: 15.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            color: AppColor.primaryColor),
                        child: Text(
                          "Complete Payment",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppColor.whiteColor, fontSize: 15.0),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 15.0,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 15.0,
                ),
                Row(
                  children: [
                    Visibility(visible: isKey, child: inputWidget()),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget inputWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            buttonWidget(
              title: "7",
              isNum: true,
              onTap: () {
                if (isSearch) {
                  setState(() {
                    searchCtrl.text = "${searchCtrl.text}7";
                  });
                } else {
                  setState(() {
                    mobileCtrl.text = "${mobileCtrl.text}7";
                  });
                }
              },
            ),
            buttonWidget(
              title: "8",
              isNum: true,
              onTap: () {
                if (isSearch) {
                  setState(() {
                    searchCtrl.text = "${searchCtrl.text}8";
                  });
                } else {
                  setState(() {
                    mobileCtrl.text = "${mobileCtrl.text}8";
                  });
                }
              },
            ),
            buttonWidget(
              title: "9",
              isNum: true,
              onTap: () {
                if (isSearch) {
                  setState(() {
                    searchCtrl.text = "${searchCtrl.text}9";
                  });
                } else {
                  setState(() {
                    mobileCtrl.text = "${mobileCtrl.text}9";
                  });
                }
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
                if (isSearch) {
                  setState(() {
                    searchCtrl.text = "${searchCtrl.text}4";
                  });
                } else {
                  setState(() {
                    mobileCtrl.text = "${mobileCtrl.text}4";
                  });
                }
              },
            ),
            buttonWidget(
              title: "5",
              isNum: true,
              onTap: () {
                if (isSearch) {
                  setState(() {
                    searchCtrl.text = "${searchCtrl.text}5";
                  });
                } else {
                  setState(() {
                    mobileCtrl.text = "${mobileCtrl.text}5";
                  });
                }
              },
            ),
            buttonWidget(
              title: "6",
              isNum: true,
              onTap: () {
                if (isSearch) {
                  setState(() {
                    searchCtrl.text = "${searchCtrl.text}6";
                  });
                } else {
                  setState(() {
                    mobileCtrl.text = "${mobileCtrl.text}6";
                  });
                }
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
                if (isSearch) {
                  setState(() {
                    searchCtrl.text = "${searchCtrl.text}1";
                  });
                } else {
                  setState(() {
                    mobileCtrl.text = "${mobileCtrl.text}1";
                  });
                }
              },
            ),
            buttonWidget(
              title: "2",
              isNum: true,
              onTap: () {
                if (isSearch) {
                  setState(() {
                    searchCtrl.text = "${searchCtrl.text}2";
                  });
                } else {
                  setState(() {
                    mobileCtrl.text = "${mobileCtrl.text}2";
                  });
                }
              },
            ),
            buttonWidget(
              title: "3",
              isNum: true,
              onTap: () {
                if (isSearch) {
                  setState(() {
                    searchCtrl.text = "${searchCtrl.text}3";
                  });
                } else {
                  setState(() {
                    mobileCtrl.text = "${mobileCtrl.text}3";
                  });
                }
              },
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buttonWidget(
              title: "Clear",
              isNum: true,
              onTap: () {
                if (isSearch) {
                  setState(() {
                    searchCtrl.text = "";
                  });
                } else {
                  setState(() {
                    mobileCtrl.text = "";
                  });
                }
              },
            ),
            buttonWidget(
              title: "0",
              isNum: true,
              onTap: () {
                if (isSearch) {
                  setState(() {
                    searchCtrl.text = "${searchCtrl.text}0";
                  });
                } else {
                  setState(() {
                    mobileCtrl.text = "${mobileCtrl.text}0";
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

  Future<bool> addCustomer({required Map<String, dynamic> postBody}) async {
    bool result = false;
    LoadingDialogBox().loading(context, keyLoader);
    try {
      await httpEngine!
          .post(
              url:
                  "${applicationCore!.appProfile.baseUrl!}${AppStrings.contactUrl}",
              postData: postBody)
          .then(
        (value) {
          CustomerResponseModel entity = CustomerResponseModel.fromJson({
            "customer": [value.data]
          });
          Navigator.of(keyLoader.currentContext!, rootNavigator: true).pop();
          setState(() {
            customerId = entity.customer![0].id ?? 0;
            isPay = true;
          });
          Fluttertoast.showToast(msg: "Customer added successfully...!");
          result = true;
        },
      );
    } on DioException catch (e) {
      Navigator.of(keyLoader.currentContext!, rootNavigator: true).pop();
      dialogueEngine!.showDialogueBox(msg: e.response!.data['message'] ?? "");
    } catch (e) {
      Navigator.of(keyLoader.currentContext!, rootNavigator: true).pop();
      debugPrint(e.toString());
      result = false;
    }
    return result;
  }

  Future<bool> checkCustomer({required String phone}) async {
    bool result = false;
    LoadingDialogBox().loading(context, keyLoader);
    try {
      await httpEngine!
          .get(
              url:
                  "${applicationCore!.appProfile.baseUrl!}${AppStrings.contactSearchUrl}$phone")
          .then(
        (value) {
          CustomerResponseModel entity =
              CustomerResponseModel.fromJson({"customer": value.data ?? []});
          Navigator.of(keyLoader.currentContext!, rootNavigator: true).pop();
          if (entity.customer!.isNotEmpty) {
            setState(() {
              nameCtrl.text = entity.customer![0].text ?? "";
              customerId = entity.customer![0].id ?? 0;
              isPay = true;
            });
          } else {
            setState(() {
              isCheck = false;
            });
          }
          result = true;
        },
      );
    } on DioException catch (e) {
      Navigator.of(keyLoader.currentContext!, rootNavigator: true).pop();
      dialogueEngine!.showDialogueBox(msg: e.response!.data['message'] ?? "");
    } catch (e) {
      Navigator.of(keyLoader.currentContext!, rootNavigator: true).pop();
      debugPrint(e.toString());
      result = false;
    }
    return result;
  }
}
