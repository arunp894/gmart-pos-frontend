import 'package:dio/dio.dart';
import 'package:gmart/Constant/app_strings.dart';
import 'package:gmart/Core/application_base.dart';
import 'package:gmart/UI/Dashboard/Model/purchase_sale_report_response.dart';
import 'package:gmart/Utils/loading_dialog_box.dart';
import 'package:intl/intl.dart';

class ReportViewModel extends BaseModel {
  Map<String, dynamic>? purchaseResponse;

  Future<bool> purchaseReport(
      {required BuildContext context, required GlobalKey keyLoader}) async {
    bool result = false;
    try {
      LoadingDialogBox().loading(context, keyLoader);
      String dateTime = DateFormat('yyyy-MM-dd').format(DateTime.now());
      await httpEngine!
          .get(
              url:
                  "${applicationCore!.appProfile.baseUrl!}${AppStrings.purchaseSellReportUrl}?start_date=$dateTime&end_date=$dateTime")
          .then(
        (value) {
          PurchaseSaleReportResponse entity =
              PurchaseSaleReportResponse.fromJson(value.data);
          Navigator.of(keyLoader.currentContext!, rootNavigator: true).pop();
          purchaseResponse = entity.toJson();
          result = true;
        },
      );
    } on DioException catch (e) {
      Navigator.of(keyLoader.currentContext!, rootNavigator: true).pop();
      dialogueEngine!.showDialogueBox(
          msg: e.response == null ? e.message : e.response!.data['message']);
    } catch (e) {
      Navigator.of(keyLoader.currentContext!, rootNavigator: true).pop();
      debugPrint(e.toString());
    }
    return result;
  }
}
