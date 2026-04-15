import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gmart/Constant/app_color.dart';
import 'package:gmart/Constant/app_strings.dart';
import 'package:gmart/Core/application_base.dart';
import 'package:gmart/UI/Login/Model/login_response_model.dart';
import 'package:gmart/UI/Login/ViewModel/login_view_model.dart';
import 'package:gmart/Utils/loading_dialog_box.dart';
import 'package:gmart/Utils/text_decorator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginViewModel? model;
  bool isPass = true;
  final keyLoader = GlobalKey<State>();
  final formKey = GlobalKey<FormState>();
  final cashFormKey = GlobalKey<FormState>();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController cashCtrl = TextEditingController();
  TextEditingController locationCtrl = TextEditingController();
  TextEditingController pwdCtrl = TextEditingController();
  DateTime? currentBackPressTime;
  int locationId = 0;
  bool isCashEnable = false, isLocation = false;
  SharedPreferences? pref;
  List<Locations> localLocation = [];

  @override
  void initState() {
    isLoad();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginViewModel>(
      prepareModel: (model) {
        this.model = model;
      },
      builder: (context, model, child) {
        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            if (!didPop) {
              DateTime now = DateTime.now();
              if (currentBackPressTime == null ||
                  now.difference(currentBackPressTime!) >
                      const Duration(seconds: 2)) {
                currentBackPressTime = DateTime.now();
                Fluttertoast.showToast(
                  msg: "Press again to exit",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: AppColor.primaryColor,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              } else {
                Navigator.of(context).pop();
              }
            }
          },
          child: Scaffold(
            body: isCashEnable ? cashSection() : loginSection(),
          ),
        );
      },
    );
  }

  Widget loginSection() {
    return Form(
      key: formKey,
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20), // smooth corners
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                offset: const Offset(0, 4),
                blurRadius: 25,
              ),
            ],
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset("assets/images/logo.png"),
                const SizedBox(
                  height: 15.0,
                ),
                const Text(
                  "Welcome Back",
                  style: TextStyle(
                    fontSize: 23.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                // Text(
                //   "Sign in wth an email and password to continue.",
                //   style: TextStyle(color: AppColor.primaryColor),
                // ),
                const Text(
                  "Sign in to your account",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.person_outline, size: 18),
                      SizedBox(width: 6),
                      Text("Username", style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
                const SizedBox(height: 6.0),
                TextFormField(
                  controller: emailCtrl,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Username is required.";
                    } else {
                      return null;
                    }
                  },
                  decoration: textDecorator(label: "Enter your username"),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                const Row(
                  children: [
                    Icon(Icons.lock_outline, size: 18),
                    SizedBox(width: 6),
                    Text("Password", style: TextStyle(fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 6.0),
                TextFormField(
                  controller: pwdCtrl,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Password is required.";
                    } else {
                      return null;
                    }
                  },
                  obscureText: isPass,
                  decoration: textDecorator(
                      label: "Enter your Password",
                      suffixIcon: InkResponse(
                        onTap: () {
                          setState(() {
                            isPass = !isPass;
                          });
                        },
                        child: Icon(
                          isPass
                              ? Icons.visibility_off_sharp
                              : Icons.visibility,
                          size: 20.0,
                        ),
                      )),
                ),
                const SizedBox(
                  height: 35.0,
                ),
                InkResponse(
                  radius: 5.0,
                  onTap: () {
                    validateInput(context);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    decoration: BoxDecoration(
                      color: AppColor.blackColor,
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                    child: Text(
                      "Sign In",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: AppColor.whiteColor, fontSize: 18.0),
                    ),
                  ),
                ),
                /*ElevatedButton(
                    onPressed: () async {
                      validateInput(context);
                    },
                    child: const Text("Login"))*/
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget cashSection() {
    return Form(
      key: formKey,
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20), // smooth corners
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                offset: const Offset(0, 4),
                blurRadius: 25,
              ),
            ],
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset("assets/images/logo.png"),
                const SizedBox(
                  height: 15.0,
                ),
                const Text(
                  "Setup Your Terminal",
                  style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 25.0),
                const Row(
                  children: [
                    Icon(Icons.location_on_outlined,
                        size: 18, color: Colors.grey),
                    SizedBox(width: 6),
                    Text("Select Location", style: TextStyle(fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 8),
                Visibility(
                  visible: !isLocation,
                  child: DropdownButtonFormField<String>(
                    // value: locationCtrl.text,
                    decoration: textDecorator(),
                    hint: const Text("Choose location..."),
                    // alignment: Alignment.center,
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColor.blackColor,
                      size: 28,
                    ),
                    items: localLocation.asMap().entries.map(
                      (e) {
                        return DropdownMenuItem<String>(
                            value: e.value.name,
                            child: Text(e.value.name ?? ""));
                      },
                    ).toList(),
                    onChanged: (value) async {
                      // bool isDone = pref!.getBool(AppStrings.isUpdate) ?? false;
                      List<Locations> selected = localLocation
                          .where((element) => element.name == value)
                          .toList();
                      if (selected.isNotEmpty) {
                        if (selected[0].cashRegister != null) {
                          await pref!.setInt(AppStrings.cashId,
                              selected[0].cashRegister!.id ?? 0);
                          await pref!.setInt(AppStrings.isCash, 1);
                          await pref!.setString(AppStrings.paymentList,
                              jsonEncode(selected[0].payment ?? []));
                          await pref!.setString(AppStrings.qrCodeImage,
                              selected[0].media!.displayUrl ?? "");
                          await pref!
                              .setString(AppStrings.taxType, selected[0].taxType ?? "");
                          await pref!.setBool(
                              AppStrings.isTax,
                              selected[0].isTaxEnable == null
                                  ? false
                                  : selected[0].isTaxEnable == 0
                                  ? false
                                  : true);
                          await pref!
                              .setString(AppStrings.taxRate, selected[0].taxRate ?? "0");
                          await pref!.setString(
                              AppStrings.selectedHub, selected[0].name ?? "");
                          await pref!.setString(AppStrings.selectedAddress,
                              "${selected[0].city ?? ""},${selected[0].country ?? ""} - ${selected[0].zipCode ?? ""}");
                          await pref!.setInt(
                              AppStrings.businessLocations,
                              int.parse(selected[0]
                                  .cashRegister!
                                  .locationId
                                  .toString()));
                          bool isDone = pref!.getBool(AppStrings.isUpdate) ?? false;
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            isDone ? "/Dashboard" : "/Excel",
                                (route) => false,
                          );
                          // Navigator.of(context).pushNamedAndRemoveUntil(
                          //  "/Dashboard" ,
                          //   (route) => false,
                          // );
                        } else {
                          List<Payment> payment = selected[0].payment ?? [];
                          await pref!.setString(
                              AppStrings.paymentList, jsonEncode(payment));
                          await pref!.setString(
                              AppStrings.selectedHub, selected[0].name ?? "");
                          await pref!.setString(AppStrings.selectedAddress,
                              "${selected[0].city ?? ""},${selected[0].country ?? ""} - ${selected[0].zipCode ?? ""}");
                          await pref!.setString(AppStrings.qrCodeImage,
                              selected[0].media!.displayUrl ?? "");
                          setState(() {
                            locationCtrl.text = selected[0].name ?? "";
                            locationId = selected[0].id ?? 0;
                          });
                        }
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                const Row(
                  children: [
                    Icon(Icons.attach_money, size: 18.0, color: Colors.grey),
                    SizedBox(width: 6.0),
                    Text(
                      "Opening Cash Register Amount",
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: cashCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    // FilteringTextInputFormatter.digitsOnly,
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Cash is required.";
                    } else {
                      return null;
                    }
                  },
                  decoration: textDecorator(label: " \$  0.0"),
                ),
                const SizedBox(
                  height: 13.0,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Enter the starting cash amount in your register",
                    style: TextStyle(fontSize: 12.0, color: Colors.grey),
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                /*Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(

                    onPressed: () async {
                        validateCashInput(context);
                      },
                      child: const Text("Register Cash"),
                    ),
                    const SizedBox(
                      width: 15.0,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          await pref!.clear();
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            "/",
                            (route) => false,
                          );
                        },
                        child: const Text("Logout")),
                  ],
                )*/
                const SizedBox(
                  height: 15.0,
                ),
                InkResponse(
                  radius: 5.0,
                  onTap: () {
                    validateCashInput(context);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    decoration: BoxDecoration(
                      color: AppColor.blackColor,
                      borderRadius: BorderRadius.circular(13.0),
                    ),
                    child: Text(
                      "Start POS Terminal",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: AppColor.whiteColor, fontSize: 16.0),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _handleLocationSelection(Locations location) async {
    try {
      if (location.cashRegister == null) {
        return false;
      }

      final isOk = await startImportAndNavigate();
      if (!isOk) return false;

      await pref!.setInt(AppStrings.cashId, location.cashRegister!.id ?? 0);
      await pref!.setInt(AppStrings.isCash, 1);
      await pref!.setString(
          AppStrings.paymentList, jsonEncode(location.payment ?? []));
      await pref!
          .setString(AppStrings.qrCodeImage, location.media?.displayUrl ?? "");
      await pref!.setString(AppStrings.selectedHub, location.name ?? "");
      await pref!.setString(
        AppStrings.selectedAddress,
        "${location.city ?? ""},${location.country ?? ""} - ${location.zipCode ?? ""}",
      );
      await pref!.setInt(
        AppStrings.businessLocations,
        int.parse(location.cashRegister!.locationId.toString()),
      );

      return true;
    } catch (e) {
      debugPrint("❌ Location selection error: $e");
      return false;
      // throw Exception(e.toString());
    }
  }

  void validateInput([BuildContext? context]) async {
    if (formKey.currentState!.validate()) {
      await model!
          .userAuth(
              email: emailCtrl.text,
              password: pwdCtrl.text,
              context: context!,
              key: keyLoader)
          .then(
        (value) async {
          if (value) {
            await model!.getExcel(context: context, key: keyLoader).then((value) async {
              if(value){
                if (model!.locations.length == 1) {
                  await Future.delayed(const Duration(seconds: 1));
                  if (model!.locations[0].cashRegister != null) {
                    await pref!.setBool(AppStrings.isLogIn, true);
                    await pref!.setInt(AppStrings.cashId,
                        model!.locations[0].cashRegister!.id ?? 0);
                    await pref!.setInt(
                        AppStrings.businessLocations,
                        int.parse(model!.locations[0].cashRegister!.locationId
                            .toString()));
                    await pref!.setString(AppStrings.qrCodeImage,
                        model!.locations[0].media!.displayUrl ?? "");
                    List<Payment> payment = model!.locations[0].payment ?? [];
                    await pref!
                        .setString(AppStrings.paymentList, jsonEncode(payment));
                    await pref!.setString(
                        AppStrings.selectedHub, model!.locations[0].name ?? "");
                    await pref!.setString(
                        AppStrings.selectedAddress,
                        // "${},"
                        "${model!.locations[0].city ?? ""},${model!.locations[0].country ?? ""} - ${model!.locations[0].zipCode ?? ""}");
                    // await Navigator.of(context).pushNamedAndRemoveUntil(
                    //   "/Dashboard" ,
                    //       (route) => false,
                    // );
                    bool isDone = pref!.getBool(AppStrings.isUpdate) ?? false;
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      isDone ? "/Dashboard" : "/Excel",
                          (route) => false,
                    );
                  } else {
                    await pref!.setBool(AppStrings.isLogIn, true);
                    await pref!.setString(AppStrings.paymentList,
                        model!.locations[0].media!.displayUrl ?? "");
                    List<Payment> payment = model!.locations[0].payment ?? [];
                    await pref!
                        .setString(AppStrings.paymentList, jsonEncode(payment));
                    await pref!.setString(
                        AppStrings.selectedHub, model!.locations[0].name ?? "");
                    await pref!.setString(
                        AppStrings.selectedAddress,
                        // "${},"
                        "${model!.locations[0].city ?? ""},${model!.locations[0].country ?? ""} - ${model!.locations[0].zipCode ?? ""}");
                    setState(() {
                      locationId = model!.locations[0].id ?? 0;
                      isCashEnable = true;
                      isLocation = true;
                    });
                  }
                } else {
                  await pref!.setBool(AppStrings.isLogIn, true);
                  setState(() {
                    isCashEnable = true;
                    localLocation = model!.locations;
                  });
                }
              }
            },);
          }
        },
      );
    }
  }

  Future<bool> startImportAndNavigate() async {
    bool result = false;
    pref = spEngine!.prefs;
    try {
      bool isUpdate = pref!.getBool(AppStrings.isUpdate) ?? false;
      if (!isUpdate) {
        bool success = await model!.initLocalData();
        if (!context.mounted) return result;

        if (success) {
          pref!.setBool(AppStrings.isUpdate, true);
          result = true;
        }
      }
    } catch (e) {
      throw Exception(e.toString());
    }
    return result;
  }

  void validateCashInput([BuildContext? context]) async {
    if (formKey.currentState!.validate()) {
      await model!
          .cashRegisterApi(
              amt: cashCtrl.text,
              locationId: locationId,
              context: context!,
              key: keyLoader)
          .then(
        (value) {
          if (value) {
            if (value) {
              bool isDone = pref!.getBool(AppStrings.isUpdate) ?? false;
              // Navigator.of(context).pushNamedAndRemoveUntil(
              //   "/Dashboard",
              //   (route) => false,
              // );
              Navigator.of(context).pushNamedAndRemoveUntil(
                isDone ? "/Dashboard" : "/Excel",
                (route) => false,
              );
            }
          }
        },
      );
    }
  }

  void isLoad() {
    pref = spEngine!.prefs;
    String? permittedList = pref?.getString(AppStrings.locationsList);
    if (permittedList != null) {
      List<dynamic> decodedList = jsonDecode(permittedList);
      List<Locations> mainList =
          decodedList.map((e) => Locations.fromJson(e)).toList();
      if (mainList.length == 1) {
        setState(() {
          locationId = mainList[0].id ?? 0;
          isLocation = true;
        });
      } else {
        setState(() {
          localLocation = mainList;
        });
      }
    }
    bool isLog =
        pref == null ? false : pref!.getBool(AppStrings.isLogIn) ?? false;
    setState(() {
      isCashEnable = isLog;
    });
  }
}
