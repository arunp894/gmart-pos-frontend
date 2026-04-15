import 'package:dio/dio.dart';
import 'package:gmart/Constant/app_strings.dart';
import 'package:gmart/Core/application_base.dart';
import 'package:gmart/UI/Dashboard/Model/all_category_product_response_model.dart'
    as ac;

class StockViewModel extends BaseModel {
  int categoryId = 0;
  List<ac.Category>? categoryProduct = [];

  Future<bool> getInitial() async {
    bool result = false;
    try {
      await httpEngine!
          .get(
              url: applicationCore!.appProfile.baseUrl! +
                  AppStrings.getAllCategoryProductUrl)
          .then(
        (value) {
          ac.AllCategoryProductResponseModel entity =
              ac.AllCategoryProductResponseModel.fromJson(value.data);
          categoryProduct = entity.category;
          categoryId = entity.category![0].id ?? 0;
          result = true;
        },
      );
    } on DioException catch (e) {
      dialogueEngine!.showDialogueBox(
          msg: e.response == null ? e.message : e.response!.data['message']);
    } catch (e) {
      debugPrint(e.toString());
    }
    return result;
  }
}
