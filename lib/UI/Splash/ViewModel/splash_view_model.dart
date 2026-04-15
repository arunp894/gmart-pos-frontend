import 'dart:convert';
import 'package:gmart/Constant/app_strings.dart';
import 'package:gmart/Core/application_base.dart';
import 'package:gmart/UI/Login/Model/login_response_model.dart';

class SplashViewModel extends BaseModel {
  SharedPreferences? pref;

  Future<void> getInit() async {
    pref = spEngine?.prefs;
    bool isLogged =
        pref == null ? false : pref!.getBool(AppStrings.isLogIn) ?? false;
    // int isCash = pref == null ? 0 : pref!.getInt(AppStrings.isCash) ?? 0;
    if (isLogged) {
      try {
        await httpEngine!
            .get(
                url: applicationCore!.appProfile.baseUrl! +
                    AppStrings.initialDataUrl)
            .then(
          (value) async {
            LoginResponseModel entity = LoginResponseModel.fromJson(value.data);
            int cashId = pref!.getInt(AppStrings.cashId) ?? 0;
            pref!.setString(
                AppStrings.locationsList, jsonEncode(entity.allLocation ?? []));
            var filterList = entity.locations
                ?.where((element) => element.cashRegister?.id == cashId)
                .toList();
            if (filterList!.isNotEmpty) {
              await pref!.setInt(AppStrings.isCash, 1);
              await pref!.setString(AppStrings.paymentList,
                  jsonEncode(filterList[0].payment ?? []));
              await pref!.setString(AppStrings.qrCodeImage,
                  filterList[0].media!.displayUrl ?? "");
              await pref!
                  .setString(AppStrings.taxType, filterList[0].taxType ?? "");
              await pref!.setBool(
                  AppStrings.isTax,
                  filterList[0].isTaxEnable == null
                      ? false
                      : filterList[0].isTaxEnable == 0
                          ? false
                          : true);
              await pref!
                  .setString(AppStrings.taxRate, filterList[0].taxRate ?? "0");
              await pref!
                  .setString(AppStrings.selectedHub, filterList[0].name ?? "");
              await pref!.setString(
                  AppStrings.selectedAddress,
                  // "${},"
                  "${filterList[0].city ?? ""},${filterList[0].country ?? ""} - ${filterList[0].zipCode ?? ""}");
              Navigator.of(applicationCore!.navigatorKey.currentContext!)
                  .pushNamedAndRemoveUntil(
                "/Dashboard",
                (route) => false,
              );
            } else {
              Navigator.of(applicationCore!.navigatorKey.currentContext!)
                  .pushNamedAndRemoveUntil(
                "/LoginScreen",
                (route) => false,
              );
            }
          },
        );
      } catch (e) {
        await clearPrefsExcept(AppStrings.isUpdate);
        Navigator.of(applicationCore!.navigatorKey.currentContext!)
            .pushNamedAndRemoveUntil(
          "/",
          (route) => false,
        );
      }
    } else {
      navigatePage();
    }
  }

  Future<void> clearPrefsExcept(String keyToKeep) async {
    final prefs = spEngine!.prefs; // or however you get SharedPreferences
    final keys = prefs!.getKeys().toList(); // get all keys

    for (var key in keys) {
      if (key != keyToKeep) {
        await prefs.remove(key); // remove everything except keyToKeep
      }
    }
  }

  startNavigate() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, getInit);
  }

  navigatePage() async {
    pref = spEngine?.prefs;
    bool isLogged =
        pref == null ? false : pref!.getBool(AppStrings.isLogIn) ?? false;
    Navigator.of(applicationCore!.navigatorKey.currentContext!)
        .pushNamedAndRemoveUntil(
      isLogged ? "/Dashboard" : "/LoginScreen",
      // "/Dashboard",
      (route) => false,
    );
  }
}
