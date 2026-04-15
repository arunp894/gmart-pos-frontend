import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:excel/excel.dart';
import 'package:gmart/Constant/app_strings.dart';
import 'package:gmart/Core/Engine/database_engine.dart';
import 'package:gmart/Core/application_base.dart';
import 'package:gmart/UI/Login/Model/login_response_model.dart';
import 'package:gmart/UI/Splash/Model/cash_checking_response_model.dart';
import 'package:gmart/Utils/loading_dialog_box.dart';
import 'package:path_provider/path_provider.dart';

class LoginViewModel extends BaseModel {
  SharedPreferences? prefs;
  int? cashRegister;
  List<Locations> locations = [];
  List<int> permittedLocation = [];
  List<String> cashDenomination = [];

  Future<void> loadList() async {
    super.setState(ViewState.inActive);
    prefs = spEngine!.prefs;
    String? locationList = prefs!.getString(AppStrings.locationsList);
    String? permittedList = prefs!.getString(AppStrings.permittedList);
    if (locationList != null) {
      List<dynamic> decodedList = jsonDecode(locationList);
      List<Locations> mainList =
          decodedList.map((e) => Locations.fromJson(e)).toList();
      locations = mainList;
    }
    if (permittedList != null) {
      List<dynamic> decodedList = jsonDecode(permittedList);
      List<int> maList = decodedList.cast<int>();
      permittedLocation = maList;
    }
    super.setState(ViewState.active);
  }

  Future<bool> userAuth(
      {required String email,
      required String password,
      required BuildContext context,
      required GlobalKey key}) async {
    bool result = false;
    LoadingDialogBox().loading(context, key);
    prefs = spEngine!.prefs;
    try {
      await httpEngine!
          .post(
              url: applicationCore!.appProfile.baseUrl! +
                  AppStrings.userLoginUrl,
              postData: {"username": email, "password": password},
              isProtected: true)
          .then(
        (value) async {
          Navigator.of(key.currentContext!, rootNavigator: true).pop();
          LoginResponseModel entity = LoginResponseModel.fromJson(value.data);
          prefs!.setString(AppStrings.accessToken, entity.accessToken ?? "");
          locations = entity.locations ?? [];
          cashDenomination = entity.posSettings?.cashDenominations ?? [];
          prefs!.setString(AppStrings.locationsList, jsonEncode(locations));
          prefs!.setString(AppStrings.userName, entity.user!.username ?? "");
          prefs!.setString(
              AppStrings.denominationList, jsonEncode(cashDenomination));
          result = true;
        },
      );
    } on DioException catch (e) {
      Navigator.of(key.currentContext!, rootNavigator: true).pop();
      dialogueEngine!.showDialogueBox(msg: e.response!.data['message'] ?? "");
    } catch (e) {
      debugPrint(e.toString());
      result = false;
    }
    return result;
  }

  Future<bool> getExcel({
    required BuildContext context,
    required GlobalKey key,
  }) async {
    bool result = false;
    bool isUpdate = prefs!.getBool(AppStrings.isUpdate) ?? false;
    if (isUpdate){
      result = true;
      return result;
    }
    await Future.delayed(const Duration(seconds: 1));
    LoadingDialogBox().loading(context, key);

    try {
      // Call API
      Response response = await httpEngine!.downloadFile(
        url: applicationCore!.appProfile.baseUrl! + AppStrings.excelDataUrl,
      );
      // Get downloads directory (Desktop / Windows / Mac)
      final Directory path = await getApplicationSupportDirectory();
      // File path
      String filePath = "${path.path}/report.xlsx";

      // Save file
      File file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        print("Old Excel deleted");
      }
      await file.writeAsBytes(response.data);

      // Close loading
      Navigator.of(key.currentContext!, rootNavigator: true).pop();
      prefs!.setString(AppStrings.excelPath, filePath);
      result = true;
    } on DioException catch (e) {
      Navigator.of(key.currentContext!, rootNavigator: true).pop();
      dialogueEngine!.showDialogueBox(
        msg: e.response?.data['message'] ?? "Excel download failed",
      );
    } catch (e) {
      Navigator.of(key.currentContext!, rootNavigator: true).pop();
      debugPrint(e.toString());
      dialogueEngine!.showDialogueBox(msg: "Excel download failed");
    }

    return result;
  }

  Future<bool> initLocalData() async {
    try {
      final prefs = spEngine!.prefs;
      final filePath = prefs!.getString(AppStrings.excelPath);

      if (filePath == null || filePath.isEmpty) {
        return false;
      }

      // 🔥 Run heavy work in background isolate
      bool result = await loadData(filePath);
      // Navigator.of(keyLoader.currentContext!, rootNavigator: true).pop();
      return result;
    } catch (e) {
      // Navigator.of(keyLoader.currentContext!, rootNavigator: true).pop();
      // debugPrint("❌ initLocalData error: $e");
      throw Exception(e.toString());
    }
  }

  Future<bool> loadData(String filePath) async {
    bool result = false;
    try {
      final Uint8List bytes = await File(filePath).readAsBytes();
      final excel = Excel.decodeBytes(bytes);
      final categorySheet = excel.sheets["Worksheet"];
      final variantSheet = excel.sheets["Worksheet 2"];
      final productSheet = excel.sheets["Worksheet 1"];
      DatabaseEngine db = DatabaseEngine();
      // if (await db.categoryDataImport(sheetData: categorySheet) &&
      //     await db.variantDataImport(sheetData: variantSheet) &&
      //     await db.productDataImport(sheetData: productSheet)) {
      //   result = true;
      // }
    } catch (e) {
      debugPrint(e.toString());
      throw e.toString();
    }
    return result;
  }

  Future<bool> cashRegisterApi(
      {required String amt,
      required int locationId,
      required BuildContext context,
      required GlobalKey key}) async {
    bool result = false;
    LoadingDialogBox().loading(context, key);
    prefs = spEngine!.prefs;
    try {
      await httpEngine!
          .post(
              url: applicationCore!.appProfile.baseUrl! +
                  AppStrings.cashDrawerRegisterUrl,
              postData: {"amount": amt, "location_id": locationId},
              isProtected: true)
          .then(
        (value) async {
          Navigator.of(key.currentContext!, rootNavigator: true).pop();
          prefs!.setInt(AppStrings.businessLocations, locationId);
          prefs!.setInt(AppStrings.isCash, 1);
          // await cashCheck();
          prefs!.setInt(AppStrings.cashId, value.data['data']['id']);
          prefs!.setBool(AppStrings.isLogIn, true);
          result = true;
        },
      );
    } on DioException catch (e) {
      Navigator.of(key.currentContext!, rootNavigator: true).pop();
      dialogueEngine!.showDialogueBox(msg: e.response!.data['message'] ?? "");
    } catch (e) {
      debugPrint(e.toString());
      result = false;
    }
    return result;
  }

  Future<bool> cashCheck() async {
    bool result = false;
    prefs = spEngine!.prefs;
    try {
      await httpEngine!
          .get(
              url: applicationCore!.appProfile.baseUrl! +
                  AppStrings.cashDrawerStatusUrl)
          .then(
        (value) {
          CashCheckingResponseModel entity =
              CashCheckingResponseModel.fromJson(value.data);
          // List<Payment> payment = entity.payment ?? [];
          // prefs!.setString(AppStrings.paymentList, jsonEncode(payment));
        },
      );
    } on DioException catch (e) {
      dialogueEngine!.showDialogueBox(msg: e.response!.data['message'] ?? "");
    } catch (e) {
      debugPrint(e.toString());
      result = false;
    }
    return result;
  }
}
